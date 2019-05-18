############################################################################################################################################
#	myP2PNetworkResourceDiscoverySimulation.tcl
#
#   P2P Network Resource Discovery Simulation
#
#  For understanding, use this Script to Simulate The following Protocols
#   1. Simple Flooding Based Resource Discovery in P2P Network
#   2. Controlled Flooding Based Resource Discovery in P2P Network
#   3. Random Walk Based Resource Discovery in P2P Network

#	Technically, the method (3) will require my modified version of AODV - So, you have to patch the modified AODV before running that method
#   From the interface provided by the modified AODV, we resolve the Neighbor count and Neighbor list of a node
#
#   While Running the scripts, you will give some input parameters like
#   Parameter  P2PResourceDiscoveryProtocol will make this script to behave as that selected protocol
#   ns myP2PNetworkResourceDiscoverySimulation.tcl	P2PNetScenarioFileName P2PNetTraceFileName 40  AODV StdFlooding 10 RDMessageTTL 1
############################################################################################################################################


 if { $argc != 8 } {
	puts "The script requires Eight inputs "
	puts "ns myP2PNetworkResourceDiscoverySimulation.tcl P2PNetScenarioFileName P2PNetTraceFileName Nodes  RoutingProtocol P2PResourceDiscoveryProtocol NumberOfResourceQueries NamLog"
	puts "Example : # ns myP2PNetworkResourceDiscoverySimulation.tcl	P2PNetScenarioFileName P2PNetTraceFileName 40  AODV StdFlooding 10 RDMessageTTL 1"
	puts "Please try again. $argc "
	exit 0
    }

set P2PNetScenarioFileName			[lindex $argv 0]   ;# name of movment file / network scenario file
set P2PNetTraceFileName 			[lindex $argv 1]   ;# The output trace file name
set TotalNodes						[lindex $argv 2]   ;# number of Nodes (N)
set RoutingProtocol					[lindex $argv 3]   ;# Routing Layer Protocol
set P2PResourceDiscoveryProtocol	[lindex $argv 4]   ;# P2P Application Layer Protocol
set NumberOfResourceQueries			[lindex $argv 5]   ;# Total Number of REsource Queries to be Generated
set RDMessageTTL					[lindex $argv 6]   ;# TTL of RD messages
set NamLog							[lindex $argv 7]   ;# Record Nam Events

#####################################################################################################
#Somep of the P2P Allication Related Parameters
#####################################################################################################
set P2PApplicationPort							  6346	  ;# 6346,6347- TCP	UDP	gnutella
set OneHopBroadcastAddress						  -1
set P2PResourceRequestMessageSize		  100	  ;# in bytes Max 1500
set P2PResourceReplyMessageSize 		  100	  ;# in bytes Max 1500


set BroadcastDelay		0.01	    ;
set TransmissionPropability	100
set GossipInterval			1		; #If a node receives a  Gossip, after sharring it immediately with a node after GossipDelay seconds, then how much time it should wait for sharring it with another node
set NoGossipsPerRequestPerNode	2
set GossipDelay 			0.01	    ; #If a node receives a  Gossip, then how much time it should wait for sharring it with first random node
set RememberGossippedNeighbor	false

#The following parameters may be used latter to reduce overhead
set RDMessageTimeout			1



#####################################################################################################
#If needed to Modify Protocol Specific Variables with respect to the selected Protocol in the following section
#####################################################################################################
	switch $P2PResourceDiscoveryProtocol {
		"StdFlooding"  {
			#Set Protocol Specific Variables if any
			 set BroadcastDelay		 0.01	     ;
			 set TransmissionPropability	 100
			 }

		"iFlooding"  {
			#Set Protocol Specific Variables if any
			set TransmissionPropability	50
			set BroadcastDelay		0.01	    ;
		}
 
		"StdRandomWalk"  {
			#Set Protocol Specific Variables if any
			set TransmissionPropability	50
		}	

} ;# end of switch   $P2PResourceDiscoveryProtocol {

#####################################################################################################
# Parameters Related to node and Network configuration
#####################################################################################################

set val(chan)		Channel/WirelessChannel    ;#Channel Type
set val(prop)		Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)		Phy/WirelessPhy 	   ;# network interface type
set val(ifq)		Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)		LL			   ;# link layer type
set val(ant)		Antenna/OmniAntenna	   ;# antenna model
set val(ifqlen) 	50			   ;# max packet in ifq
# size of the topography
set val(x)		1000
set val(y)		1000


set val(mac)		Mac/802_11		   ;# MAC type
#set val(mac)		 Mac		     ;# MAC type

#set val(mac)		Mac/Simple
#Mac/Simple set bandwidth_ 1Mb

# DumbAgent, AODV, and DSDV work.  DSR is broken
set val(rp)		$RoutingProtocol

set NodeVeocity 		20	 ; # meters per second
set NamAnimationSpeed		250u	;#in Micro Seconds

set val(engmodel)	EnergyModel	;
set val(initeng)	500.0		;# Initial energy in Joules

#####################################################################################################
# Create Simulator instant and define name file and trace file Descriptors
#####################################################################################################
set ns_ [new Simulator]

set P2PNetTraceFileDescriptor [open $P2PNetTraceFileName w]
$ns_ trace-all $P2PNetTraceFileDescriptor

if {$NamLog == 1} {
set P2PNetNAMFileDescriptor [open "P2PNetworkResourceDiscoverySimulation.nam" w]
$ns_ namtrace-all-wireless $P2PNetNAMFileDescriptor $val(x) $val(y)
}

# To reduce the trace file size and for the simplicity of the analysis we use old trace format only
# set ns2 trace file format
#$ns_ use-newtrace

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

#
# Create God
#
set god_  [create-god $TotalNodes]

$ns_ color 0 blue
$ns_ color 1 red
$ns_ color 2 chocolate
$ns_ color 3 red
$ns_ color 4 brown
$ns_ color 5 tan
$ns_ color 6 gold
$ns_ color 7 black

#####################################################################################################
#configure Nodes with given parameters
#####################################################################################################
set chan_1_ [new $val(chan)]

$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace OFF \
		-channel $chan_1_  \
		-energyModel $val(engmodel) \
		-initialEnergy $val(initeng)

#####################################################################################################
# Create a  P2PApplication by inheriting the agent  Agent/MessagePassing
#####################################################################################################
Class P2PApplicationClass -superclass Agent/MessagePassing

# the recv will be called whenever a P2PApplicationClass Agent recieves a message

P2PApplicationClass instproc recv {source sport size data} {
    $self instvar ResourceRequestIDSeen ResourceList node_  GossippedNeighbors ImmunityLevel  
    global ns_ P2PResourceDiscoveryProtocol OneHopBroadcastAddress TransmissionPropability  BroadcastDelay P2PResourceReplyMessageSize P2PApplicationPort
    global GossipDelay GossipInterval NoGossipsPerRequestPerNode RDMessageTTL

	set rng [new RNG]
	$rng seed 0


    ;# extract message ID from message
    set PacketType			[lindex [split $data ":"] 0]


    switch $PacketType {
		"Req"  {

			set ResourceRequestID	[lindex [split $data ":"] 1]
			set RequestingNodeID    [lindex [split $data ":"] 2]
			set RequestedResourceID [lindex [split $data ":"] 3]
			set TTL [lindex [split $data ":"] 4]
			

			switch $P2PResourceDiscoveryProtocol {

			   "StdFlooding"  {
					if {[lsearch $ResourceRequestIDSeen $ResourceRequestID] == -1} {
						puts "Node [$node_ node-addr] Received a $P2PResourceDiscoveryProtocol Msg :  ResourceRequestID:$ResourceRequestID OriginatedfromNode :$RequestingNodeID With RequestedResourceID:$RequestedResourceID"

						;#Mark that we have processed that Request
						lappend ResourceRequestIDSeen $ResourceRequestID

						;#check Whether we have that resource
						if {[lsearch $ResourceList $RequestedResourceID] != -1} {
							 puts "Node [$node_ node-addr] has the resource  RequestedResourceID:$RequestedResourceID"

							 set Payload  "Rep:$ResourceRequestID:[$node_ node-addr]:$RequestedResourceID"
							 puts "Node [$node_ node-addr] is sending Resource Reply : $Payload"
							 set	Jitter [expr ([$rng integer 10]+1.0 )/100.0]
							 $ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter ]	  "$self  SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"
							 #$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter + 0.5]	"$self	SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"

							return
						}

						$ns_ trace-annotate "[$node_ node-addr] received {$data} from $source"
						set TransmitFlag [expr [$rng integer 100] ]

							$ns_ trace-annotate "[$node_ node-addr] sending message $ResourceRequestID"
							set ReBroadcastJitter [expr ([$rng integer 10]+1.0 )/100.0]
							$ns_ at [expr [$ns_ now]+ $ReBroadcastJitter] "$node_  color red"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter]       "$self Broadcast_Message $size $data $OneHopBroadcastAddress $sport"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 0.1] "$node_  color brown"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 1.1] "$node_  color black"
					} else {
						$ns_ trace-annotate "[$node_ node-addr] received redundant message $ResourceRequestID from $source"
					}

			   } ; #end of "StdFlooding"

				"iFlooding"  {
						if {[lsearch $ResourceRequestIDSeen $ResourceRequestID] == -1} {
							puts "Node [$node_ node-addr] Received a $P2PResourceDiscoveryProtocol Msg :  ResourceRequestID:$ResourceRequestID OriginatedfromNode :$RequestingNodeID With RequestedResourceID:$RequestedResourceID"

							;#Mark that we have processed that Request
							lappend ResourceRequestIDSeen $ResourceRequestID

							;#check Whether we have that resource
							if {[lsearch $ResourceList $RequestedResourceID] != -1} {
								 puts "Node [$node_ node-addr] has the resource  RequestedResourceID:$RequestedResourceID"

								 set Payload  "Rep:$ResourceRequestID:[$node_ node-addr]:$RequestedResourceID"
								 puts "Node [$node_ node-addr] is sending Resource Reply : $Payload"
								 set	Jitter [expr ([$rng integer 10]+1.0 )/100.0]
								 $ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter ]	  "$self  SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"
								 #$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter + 0.5]	"$self	SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"
								return
							}

						$ns_ trace-annotate "[$node_ node-addr] received {$data} from $source"
						set TransmitFlag [expr [$rng integer 100] ]

						if {$TransmitFlag < $TransmissionPropability} {
							$ns_ trace-annotate "[$node_ node-addr] sending message $ResourceRequestID"
							set ReBroadcastJitter [expr ([$rng integer 10]+1.0 )/100.0]
							$ns_ at [expr [$ns_ now]+ $ReBroadcastJitter] "$node_  color red"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter]       "$self Broadcast_Message $size $data $OneHopBroadcastAddress $sport"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 0.1] "$node_  color brown"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 1.1] "$node_  color black"
						}


						} else {
								$ns_ trace-annotate "[$node_ node-addr] received redundant message $ResourceRequestID from $source"
						}

					} ; #end of "iFlooding"
                                        
                                      
				"StdRandomWalk"  {

							puts "Node [$node_ node-addr] Received a $P2PResourceDiscoveryProtocol Msg :  ResourceRequestID:$ResourceRequestID OriginatedfromNode :$RequestingNodeID With RequestedResourceID:$RequestedResourceID"


							;#check Whether we have that resource
							if {[lsearch $ResourceList $RequestedResourceID] != -1} {
								 puts "Node [$node_ node-addr] has the resource  RequestedResourceID:$RequestedResourceID"

								 set Payload  "Rep:$ResourceRequestID:[$node_ node-addr]:$RequestedResourceID"
								 puts "Node [$node_ node-addr] is sending Resource Reply : $Payload"
								 set	Jitter [expr ([$rng integer 10]+1.0 )/100.0]
								 $ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter ]		"$self	SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"
								 #$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $Jitter + 0.5]	"$self	SendResourceReply  $P2PResourceReplyMessageSize $Payload  $RequestingNodeID $P2PApplicationPort"

								return
							}

						$ns_ trace-annotate "[$node_ node-addr] received {$data} from $source"


						# The following line will get  neighbor_count from the AODV routing agent of the node
						;# I have implemented the function  neighbor_list in aodv.cc
					    ;# this interface is the complex and important part of this simulation code.

						set NighborCount  [[$node_  set ragent_]  neighbor_count ]


						if {$NighborCount == 0 } {
							puts "The Random Walk failded at node $node_ due to the NighborCount=0"
							return
						} else {
							;# I have implemented the function  neighbor_list in aodv.cc
							;# this interface is the complex and important part of this simulation code.
							;# in fact, this will return the neighbor list of nodes seperates by ":", like	"3:2:33:24:56:"
							;# refer the modified part of c++ code (aodv.cc) for understanding it

							set NighborList   [[$node_  set ragent_]  neighbor_list ]

							set RandomNeighborIdx [$rng integer $NighborCount]

							set RandomNeighbor   [lindex [split $NighborList ":"] $RandomNeighborIdx]

							$ns_ trace-annotate "[$node_ node-addr] Randomly Passing message $ResourceRequestID to $RandomNeighbor"
							set ReBroadcastJitter [expr ([$rng integer 10]+1.0 )/100.0]

							$ns_ at [expr [$ns_ now]+ $ReBroadcastJitter] "$node_  color red"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter]       "$self SendMessage  $size $data $RandomNeighbor $sport"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 0.1] "$node_  color brown"
							$ns_ at [expr [$ns_ now]+ $BroadcastDelay + $ReBroadcastJitter + 1.1] "$node_  color black"

						}
				} ; #end of "RandomWalk"

				default {
				  puts "Error: Unknown P2P Resource Discovery Protocol $P2PResourceDiscoveryProtocol"
				  exit
				}
			} ;# end of switch $P2PResourceDiscoveryProtocol


		} ;# end of Req

		"Rep"  {
			set ResourceRequestID		  [lindex [split $data ":"] 1]
	        set ResourceProvidingNodeID   [lindex [split $data ":"] 2]
			set RequestedResourceID 	  [lindex [split $data ":"] 3]
			puts "#Reply# At [$ns_ now]  Node [$node_ node-addr] ReceivedAreplyFrom  $ResourceProvidingNodeID  ResourceRequestID $ResourceRequestID  RequestedResourceID $RequestedResourceID"
		} ;# end of Rep

		default {
				  puts "Error: Unknown P2P Application Packet Type $PacketType"
				  exit
				}
   }	;# end of switch $PacketType

}

P2PApplicationClass instproc Broadcast_Message {size data addrs port} {
$self instvar ResourceRequestIDSeen node_
    $self sendto $size $data $addrs $port
}

P2PApplicationClass instproc SendResourceRequest {size Playload port} {
    $self instvar ResourceRequestIDSeen node_
    global ns_ P2PApplicationPort OneHopBroadcastAddress
	set ResourceRequestID	[lindex [split $Playload ":"] 1]

	if {[lsearch $ResourceRequestIDSeen $ResourceRequestID] == -1} {
		lappend ResourceRequestIDSeen $ResourceRequestID
	}
    $ns_ trace-annotate "[$node_ node-addr] Sending Resource Request $Playload"
    $self sendto $size "$Playload" $OneHopBroadcastAddress $port
}

P2PApplicationClass instproc SendResourceReply {size Playload Address port} {
    $self instvar  node_
    global ns_ P2PApplicationPort OneHopBroadcastAddress
    $ns_ trace-annotate "[$node_ node-addr] Sending Resource Reply $Playload"
    $self sendto $size "$Playload" $Address $port
}

P2PApplicationClass instproc SendMessage {size Playload Address port} {
    $self instvar  node_
    global ns_ P2PApplicationPort OneHopBroadcastAddress
    $ns_ trace-annotate "[$node_ node-addr] Sending Message to	$Address"
    $self sendto $size "$Playload" $Address $port
}


P2PApplicationClass instproc StartRandomWalk {size Playload port} {
	
	$self instvar  node_
    global ns_ P2PApplicationPort OneHopBroadcastAddress
    set rng [new RNG]
	$rng seed 0

    set NighborCount  [[$node_	set ragent_]  neighbor_count ]
    
    set ResourceRequestID	[lindex [split $Playload ":"] 1]
    set RequestingNodeID    [lindex [split $Playload ":"] 2]
	set RequestedResourceID [lindex [split $Playload ":"] 3]
    set TTL [lindex [split $Playload ":"] 4]

    if {$NighborCount == 0 } {
		puts "The Random Walk failed due to the NighborCount=0"
		return
    } else {
		set NighborList   [[$node_  set ragent_]  neighbor_list ]
		set RandomNeighborIdx [$rng integer $NighborCount]
		set RandomNeighbor   [lindex [split $NighborList ":"] $RandomNeighborIdx]
		$ns_ trace-annotate "[$node_ node-addr] Sending Message to  $RandomNeighbor"

		#the RandomNeighbor node ID is stored in the packet header for my proposed iRandomWalk Implementation.( It will not be used for normal RandomWalk)
		#Now change the packet header with next addressed neghbor information
		set Playload "Req:$ResourceRequestID:$RequestingNodeID:$RequestedResourceID:$TTL:$RandomNeighbor"


		$self sendto $size "$Playload" $RandomNeighbor $port
		}
		
}

set rng [new RNG]
$rng seed 0

# create  nodes
for {set i 0} {$i < $TotalNodes} {incr i} {
    set node_($i) [$ns_ node]

    $node_($i) color "black"
}

# Include Node movement Pattern File
 source $P2PNetScenarioFileName


# Setting the node size
for {set i 0} {$i < $TotalNodes} {incr i} {
   $ns_ at 0 "$ns_ initial_node_pos $node_($i) 30"
}

# attach a new P2PApplication to each node on port $P2PApplicationPort
for {set i 0} {$i < $TotalNodes} {incr i} {
    set P2PApplication($i) [new P2PApplicationClass]
    $node_($i) attach  $P2PApplication($i) $P2PApplicationPort
    $P2PApplication($i) set ResourceRequestIDSeen {}
    $P2PApplication($i) set ResourceList {}
	switch $P2PResourceDiscoveryProtocol {
		"StdFlooding"  {
			#Set Protocol Specific actions if any

		}

		"iFlooding"  {
			#Set Protocol Specific actions if any

		}
		
		"RandomWalk"  {
			#Set Protocol Specific actions if any


	}  ;# end of switch   $P2PResourceDiscoveryProtocol
}

set rng [new RNG]
$rng seed 0

#setup some nodes with resources
for {set i 0} {$i < $NumberOfResourceQueries} {incr i} {
	$P2PApplication($i) set ResourceList R$i
}

# now schedule some resource requests
##setup some nodes with resources
#$P2PApplication(5) set ResourceList {R5}
#$P2PApplication(6) set ResourceList {R6}
#$P2PApplication(7) set ResourceList {R7}


set ReqStartTime 30
set StartNodeID 20
set ReqInterval 5


for {set i 0} {$i < $NumberOfResourceQueries} {incr i} {
	set NodeID [expr $i + $StartNodeID ]
	switch $P2PResourceDiscoveryProtocol {
		"StdFlooding"  -
		"iFlooding"  {
			   $ns_ at [expr $ReqStartTime + $i * $ReqInterval] "$P2PApplication($NodeID) SendResourceRequest $P2PResourceRequestMessageSize {Req:s$i:$NodeID:R$i:$RDMessageTTL}	$P2PApplicationPort"


		}
		"StdRandomWalk"  {
							$ns_ at [expr $ReqStartTime + $i * $ReqInterval] "$P2PApplication($NodeID)  StartRandomWalk	$P2PResourceRequestMessageSize	{Req:s$i:$NodeID:R$i:$RDMessageTTL}  $P2PApplicationPort"

	} ;# end of switch   $P2PResourceDiscoveryProtocol

	puts "#Request# At [expr $ReqStartTime + $i * $ReqInterval]  Node $NodeID Requested   ResourceRequestID s$i  RequestedResourceID R$i with TTL:$RDMessageTTL"

	$ns_ at [expr $ReqStartTime + $i * $ReqInterval]  "$node_($NodeID)  color blue"
}


$ns_ at 100.0 "finish"

proc finish {} {
	global ns_ P2PNetTraceFileDescriptor  val  NamLog  P2PNetNAMFileDescriptor
	$ns_ flush-trace
	close $P2PNetTraceFileDescriptor
	close $P2PNetNAMFileDescriptor

		if {$NamLog == 1} {
			puts "running nam..."
			exec nam   P2PNetworkResourceDiscoverySimulation.nam &
		}

	exit 0
}

$ns_ run

