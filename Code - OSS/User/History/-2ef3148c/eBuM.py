import mido
import socket
from time import sleep

# UDP settings
udp_ip = '192.168.1.1'
udp_port = 21930

# Create UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

on_msg = mido.Message('note_on', channel=11, note=1, velocity=0, time=312)
off_msg = mido.Message('note_off', channel=10, note=1, velocity=0, time=312)
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
