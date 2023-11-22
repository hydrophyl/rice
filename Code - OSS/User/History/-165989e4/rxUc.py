from flask import render_template, request, redirect, url_for
from app.song import bp
from app import socketio
from app.global_vars import *
from app.extensions import db, Timer
from app.midi import mido, socket, init_udp_socket, create_midi_file, save_processed_data, process_track, load_processed_data
from app.models.song import Song
from time import time, sleep
import os


# Main site for /song
@bp.route('/', methods=['GET'])
def index():
    songs = Song.query.all()
    return render_template('song/index.html', songs=songs)


# Initialize start timer for recording
record_timer = Timer()
start_sequence_time = time() 

# /song/record : UI for recording
@bp.route('/record', methods=['GET'])
def record():
    songs = Song.query.all()
    placeholder = "A_1"
    songs_list = []
    last_song_id = 0 
    for song in songs:
        songs_list.append(song.title)
        if "A_" in song.title:
            try:
                song_number = int(song.title[2:])
                placeholder = "A_" + str(song_number+1)
            except ValueError:
                pass
    if len(songs) > 0:
        last_song_id = int(songs[-1].id)
    return render_template('song/record.html', songs_list=songs_list, placeholder=placeholder, last_song_id=last_song_id)

# Function to update the variable and emit changes to connected clients
@socketio.on('update_first_signal')
def update_first_signal(value):
    global record_timer, start_sequence_time  
    socketio.emit('firstSignal_updated', {'value': value})
    if value == True:
        if not record_timer.get_status():
            record_timer.start_timer()
            start_sequence_time = time() 

# /song/startrecord
@bp.route('/startrecord/')
def start_record():
    global running, chosen_song_title, first_signal, start_sequence_time

    running = True
    bpm = 120
    ppqn = 48
    song_title = request.args.get('song_title') # Get the 'title' query parameter
    chosen_song_title = song_title

    sock = init_udp_socket()
    note_track, midi_file = create_midi_file(bpm=bpm, ppqn=ppqn)

    try:
        while running:
            try:
                received_data = b""
                data, addr = sock.recvfrom(512)  # Buffer size is 512 bytes for incoming data
                update_first_signal(True)
                # Append the received data to the existing data
                received_data += data
                print(data)

                # Process complete MIDI messages
                while len(received_data) >= 1:
                    # Check if the first byte is a valid MIDI status byte
                    if received_data[0] >= 0x80:
                        # Find the length of the MIDI message based on the status byte
                        msg_length = 3 if received_data[0] < 0xC0 or received_data[0] >= 0xE0 else (
                            2 if received_data[0] < 0xE0 else 1)

                        # Check if the received data contains a complete MIDI message
                        if len(received_data) >= msg_length:
                            # Extract the MIDI message from the received data
                            midi_data = received_data[:msg_length]
                            received_data = received_data[msg_length:]

                            try:
                                # Convert the MIDI data to a MIDI message
                                midi_msg = mido.Message.from_bytes(midi_data)

                                # Calculate the delta time since the last message
                                delta_time = time() - start_sequence_time
                                start_sequence_time = time()

                                midi_msg.time = round(
                                    mido.second2tick(delta_time, ticks_per_beat=ppqn, tempo=mido.bpm2tempo(bpm)))

                                print(str(midi_msg))

                                # Add the MIDI message to the MIDI file
                                note_track.append(midi_msg)

                            except ValueError:
                                print("Invalid MIDI data:", midi_data)
                        else:
                            # Break the loop if there is not enough data for a complete MIDI message
                            break
                    else:
                        # Remove the invalid byte and continue searching for a valid MIDI status byte
                        received_data = received_data[1:]

            except socket.error as e:
                if e.errno == socket.errno.EWOULDBLOCK:
                    # No data available yet, continue with other tasks
                    pass
                else:
                    # Handle other socket errors
                    print("An error occurred:", e)

    except Exception as e:
        print("An error occurred:", e)

    finally:
        # Close the socket
        sock.close()

        # Save the MIDI file
        print(f"Notenanzahl: {len(midi_file.tracks[1])}") 
        if len(midi_file.tracks[1]) > 1:
            midi_file_path = "midi_files/" + str(song_title) + ".mid" 
            if os.path.exists("midi_files/"):
                pass
            else:
                os.makedirs('midi_files/')

            midi_file.save(midi_file_path)
            midi_file = mido.MidiFile(midi_file_path)
            processed_data_filename = midi_file_path[:-4] + '.pkl'
            binary_messages = process_track(midi_file.tracks[1], ppqn=ppqn, bpm=bpm)
            save_processed_data(binary_messages, processed_data_filename)
            song_length = midi_file.length
            new_song = Song(title=chosen_song_title, length=song_length, default_speed=1.0, default_transposition=0)
            db.session.add(new_song) 
            db.session.commit() 
        
    return f'Loop stopped with title: {song_title}'

@bp.route('/stoprecord/', methods=['GET'])
def stoprecord():
    global running, chosen_song_title, record_timer
    record_timer.stop_timer()
    if record_timer.get_recorded_time() > 0: 
        print(f"Totalzeit: {record_timer.get_recorded_time()}s") 
        running = False
        return redirect(url_for('song.record'))
    else:
        running = False
        return redirect(url_for('song.record'))

# Play subapplication to playback the recorded song
@bp.route('/play', methods=['GET'])
def play():
    songs = Song.query.all()
    return render_template('song/play.html', songs=songs)

@socketio.on('update_playback_speed')
def update_playback_speed(data):
    global playbackspeed
    playbackspeed = data['value']

@socketio.on('update_isPlaying')
def update_isPlaying(data):
    global isPlaying
    isPlaying = data['value']

@socketio.on('update_percentage')
def update_percentage(value):
    socketio.emit('updatePercentage', {'value': value})

@socketio.on('update_playstatus')
def update_playstatus(value):
    socketio.emit('updatePlaystatus', {'value': value})

@bp.route('/playrecord', methods=['GET'])
def playrecord():
    songs = Song.query.all()
    songId = request.args.get('song_id') 
    global playbackspeed
    global isPlaying 
    for song in songs:
        if str(song.id) == songId:
            bpm=120
            ppqn=48
            time_delay_n = 0
            playbackspeed = song.default_speed if playbackspeed == song.default_speed else playbackspeed
            # Define the UDP settings
            UDP_IP = "192.168.1.4"
            UDP_PORT = 21929
            # Create a UDP socket
            udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

            # Load the MIDI file
            midi_file_path = "midi_files/" + song.title + ".mid"
            midi_file = mido.MidiFile(midi_file_path)
            processed_data_filename = midi_file_path[:-4] + '.pkl' 
 
            # Try to find saved data
            try:
                binary_messages = load_processed_data(processed_data_filename)
                
            except FileNotFoundError:
                midi_file = mido.MidiFile(midi_file_path)
                binary_messages = process_track(midi_file.tracks[1], ppqn=ppqn, bpm=bpm)
                save_processed_data(binary_messages, processed_data_filename)

            update_playstatus("song play")
            isPlaying = True
            if len(binary_messages) != 0:
                for binary, time_delay in binary_messages:
                    if not isPlaying:
                        break 
                    hex_string = "".join(f"\\x{byte:02x}" for byte in binary)
                    sleep(time_delay/float(playbackspeed)) 
                    time_delay_n = time_delay_n + time_delay
                    print(f"{hex_string} {time_delay:.2f} | {float(playbackspeed):.2f} speed | {time_delay_n*100/midi_file.length}% ")
                    #print(f"{time_delay_n:.2f} | {time_delay_n*100/midi_file.length}%")
                    update_percentage(time_delay_n*100/midi_file.length) 
                    udp_socket.sendto(binary, (UDP_IP, UDP_PORT))
                        
            # Reseting UI playback progress bar
            update_percentage(100) 
            sleep(0.4)
            update_percentage(0) 
            update_playstatus("song stop")
            # Close the UDP socket
            udp_socket.close()    

    return redirect(url_for('song.play'))

@bp.route('/admin', methods=['GET'])
def admin():
    songs = Song.query.all()
    return render_template('song/admin.html', songs=songs)

@bp.route('/docs', methods=['GET'])
def docs():
    return render_template('song/docs.html')
    
# Edit song details (title, default_speed, default_transposition)
@bp.route('/edit/<int:song_id>', methods=['GET', 'POST'])
def edit_song(song_id):
    song = Song.query.get(song_id) 
    if not song:
        return "Song not found", 404
    else:
        print(song.title, song.default_speed, song.default_transposition)
        
    if request.method == 'POST':
        new_title = request.form.get('title')
        midi_file_path = "midi_files/" + song.title + ".mid"
        processed_data_filename = midi_file_path[:-4] + '.pkl' 
        os.rename(midi_file_path, 'midi_files/' + new_title + '.mid')
        os.rename(processed_data_filename, 'midi_files/' + new_title + '.pkl')
        song.title = new_title
        song.default_speed = request.form.get('speed')
        song.default_transposition = request.form.get('transposition')
        db.session.commit()
        return redirect(url_for('song.admin'))

    return render_template('song/edit.html', song=song)

@bp.route('/delete/<int:song_id>', methods=['GET', 'POST'])
def delete_song(song_id):
    song = Song.query.get(song_id)
    if not song:
        return "Song not found", 404

    if request.method == 'POST':
        db.session.delete(song)
        db.session.commit()
        return redirect(url_for('song.admin'))

    return render_template('song/delete.html', song=song)

@bp.route('/loading')
def loading():
    return render_template('song/loading.html')
