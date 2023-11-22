import mido
import socket
from mido import MidiFile, MidiTrack, MetaMessage
from time import sleep
 pickle

def init_udp_socket():
    # IP address and port to listen on
    UDP_IP = "0.0.0.0"  # Listen on all available network interfaces
    UDP_PORT = 21930

    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Bind the socket to the IP address and port
    sock.bind((UDP_IP, UDP_PORT))
    # Receive and process incoming UDP packets
    sock.setblocking(False)
    return sock 

def create_midi_file(bpm, ppqn):
    # Create a MIDI file
    midi_file = MidiFile(ticks_per_beat=ppqn)

    # Create a track for meta messages
    meta_track = MidiTrack()
    midi_file.tracks.append(meta_track)

    # Add meta messages to the meta track
    meta_track.append(MetaMessage('track_name', name='Meta Track'))
    meta_track.append(MetaMessage('time_signature', numerator=4, denominator=4))
    meta_track.append(MetaMessage('key_signature', key='C'))
    meta_track.append(MetaMessage('set_tempo', tempo=mido.bpm2tempo(bpm)))

    # Create a track for note events
    note_track = MidiTrack()
    midi_file.tracks.append(note_track)
    return note_track, midi_file 


def messages_to_binary(messages):
    binary_data = bytearray()
    for msg in messages:
        binary_data.extend(msg.bytes())
    return binary_data

def process_track(track, ppqn, bpm):
    binary_messages = []
    current_time = 0
    grouped_messages = []
    for msg in track:
        #time_delay = mido.tick2second(msg.time, ticks_per_beat=ppqn, tempo=mido.bpm2tempo(bpm)) * 1000 if msg.time >= 0 else mido.tick2second(msg.time * (-1), ticks_per_beat=ppqn, tempo=mido.bpm2tempo(bpm)) * 1000
        time_delay = msg.time/100 if msg.time >= 0 else mido.tick2second(msg.time * (-1), ticks_per_beat=ppqn, tempo=mido.bpm2tempo(bpm)) * 1000
        if time_delay > 0:  # Only append if there's a time delay
            binary_messages.append((messages_to_binary(grouped_messages), current_time))
            grouped_messages = []
            current_time = time_delay 
        
        grouped_messages.append(msg)
    
    if grouped_messages:
        binary_messages.append((messages_to_binary(grouped_messages), current_time))
    
    return binary_messages

def save_processed_data(data, filename):
    with open(filename, 'wb') as f:
        pickle.dump(data, f)

def load_processed_data(filename):
    with open(filename, 'rb') as f:
        return pickle.load(f)
