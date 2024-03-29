# Excercise 2
# Author: Matthias Moulin, Ruben Pieters
# Course: Computer Networks

set ns [new Simulator]

# Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow
$ns color 5 Brown
$ns color 6 Magenta
$ns color 7 Pink
$ns color 8 Cyan

# Open the trace file
set tracefile1 [open /tmp/out_rm.tr w]
$ns trace-all $tracefile1
# Open the NAM trace file
set namfile [open /tmp/out_rm.nam w]
$ns namtrace-all $namfile

# Define a 'finish' procedure
proc finish {} {
	global ns tracefile1 namfile
	$ns flush-trace
	close $tracefile1
	close $namfile
	exec nam /tmp/out_rm.nam &
	exit 0
}

# Create three nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

# Create links between nodes
$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n6 10Mb 10ms DropTail
$ns duplex-link $n1 $n3 10Mb 10ms DropTail
$ns duplex-link $n1 $n5 10Mb 10ms DropTail
$ns duplex-link $n1 $n7 10Mb 10ms DropTail

# Set Queue Size of link 0 - 1
$ns queue-limit $n0 $n1 20

# Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n0 $n2 orient left-up
$ns duplex-link-op $n0 $n4 orient left
$ns duplex-link-op $n0 $n6 orient left-down
$ns duplex-link-op $n1 $n3 orient right-up
$ns duplex-link-op $n1 $n5 orient right
$ns duplex-link-op $n1 $n7 orient right-down
$ns duplex-link-op $n0 $n1 queuePos 0.5

# Setup a TCP connection
set tcp2_3 [new Agent/TCP/Vegas]
$ns attach-agent $n2 $tcp2_3
set sink2_3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2_3
$ns connect $tcp2_3 $sink2_3
$tcp2_3 set fid_ 1
$tcp2_3 set packetSize_ 552
$tcp2_3 set window_ 60

# Setup a FTP over TCP connection
set ftp2_3 [new Application/FTP]
$ftp2_3 attach-agent $tcp2_3

# Setup a TCP connection
set tcp4_5 [new Agent/TCP/Vegas]
$ns attach-agent $n4 $tcp4_5
set sink4_5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink4_5
$ns connect $tcp4_5 $sink4_5
$tcp4_5 set fid_ 2
$tcp4_5 set packetSize_ 552
$tcp4_5 set window_ 60

# Setup a FTP over TCP connection
set ftp4_5 [new Application/FTP]
$ftp4_5 attach-agent $tcp4_5

# Setup a TCP connection
set tcp6_7 [new Agent/TCP/Vegas]
$ns attach-agent $n6 $tcp6_7
set sink6_7 [new Agent/TCPSink]
$ns attach-agent $n7 $sink6_7
$ns connect $tcp6_7 $sink6_7
$tcp6_7 set fid_ 3
$tcp6_7 set packetSize_ 552
$tcp6_7 set window_ 60

# Setup a FTP over TCP connection
set ftp6_7 [new Application/FTP]
$ftp6_7 attach-agent $tcp6_7

$ns at 0.1 "$ftp2_3 start"
$ns at 0.4 "$ftp4_5 start"
$ns at 0.7 "$ftp6_7 start"
$ns at 19.1 "$ftp2_3 stop"
$ns at 19.5 "$ftp4_5 stop"
$ns at 19.7 "$ftp4_5 stop"

$ns at 20.0 "finish"
$ns run

