import mido
import socket
from app.midi import create_midi_file
from time import sleep

# UDP settings
udp_ip = '192.168.1.1'
udp_port = 21930

# Create UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

note_track, midi_file = create_midi_file(bpm=bpm, ppqn=ppqn)
# Register MOD(1)
note_track.append(mido.Message('note_on', channel=10, note=1, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=10, note=2, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=11, note=2, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=11, note=3, velocity=0, time=312))

# Register MOD(1)
note_track.append(mido.Message('note_on', channel=1, note=12, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=1, note=21, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=2, note=20, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=1, note=3C, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=1, note=12, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=1, note=21, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=2, note=20, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=1, note=3C, velocity=0, time=312))

# Register MOD(2)
note_track.append(mido.Message('note_on', channel=10, note=1, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=10, note=2, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=11, note=2, velocity=0, time=312))
note_track.append(mido.Message('note_on', channel=11, note=3, velocity=0, time=312))
off = bytes(off_msg.bin())

# Convert MIDI message to bytes
data_on = bytes(on)
data_off = bytes(off)
i = 0 
while i < 30:
    i += 1
    # Send MIDI message over UDP
    sock.sendto(data_on, (udp_ip, udp_port))
    print(data_on)
    sleep(1)
    sock.sendto(data_off, (udp_ip, udp_port))
    print(data_off)
    sleep(1)

# Close the socket
sock.close()

# NOTE: tested on 13.06.2023: UDP signals sent but no response from PLC
