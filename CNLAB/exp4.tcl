# New Simulation
set ns [new Simulator]

# Colors
$ns color 0 blue
$ns color 1 green

# Opening file in Write mode
set tr [open Droptail_queue_out.tr w]
$ns trace-all $tr

# Opening file in Write mode
set ftr [open Droptail_queue_out.nam w]
$ns namtrace-all $ftr

# Creating Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Connections between nodes (Duplex)
$ns duplex-link $n0 $n1 100Mb 2ms DropTail
$ns duplex-link $n1 $n2 60Mb 5ms DropTail
$ns duplex-link $n2 $n3 40Mb 3ms DropTail
$ns duplex-link $n3 $n4 20Mb 2ms DropTail
$ns duplex-link $n5 $n4 30Mb 2ms DropTail
$ns duplex-link $n5 $n0 30Mb 2ms DropTail
$ns duplex-link $n2 $n1 30Mb 2ms DropTail
# UDP
set udp [new Agent/UDP]

$udp set fid_ 1
set null [new Agent/Null]

$ns attach-agent $n0 $udp
$ns attach-agent $n4 $null
$ns connect $udp $null

# TCP
set tcp [new Agent/TCP]
$tcp set fid_ 0
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set interval 0.020

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ftp set interval 0.020
proc finish {} {

    # Global Variables
    global ns tr ftr

    # Flushing the Buffer and closing opened files
    $ns flush-trace
    close $tr
    close $ftr
    exec nam Droptail_queue_out.nam &
    exit
}

# Need to start at 0.1
$ns at 0.1 "$cbr start"
$ns at 2.0 "$cbr stop"
$ns at 0.1 "$ftp start"
$ns at 2.0 "$ftp stop"

# Finish execution at 2.1
$ns at 2.1 "finish"
$ns run



