############################################################################################################################################
# P2PParameters.sh
#     Some of the common parameters of the simulation
#
#
############################################################################################################################################
clear

#Parameters
X=1000
Y=1000
Time=100						 # this value will be used to select the scenario file
Mobilities="20" 				#May give a list of Different Mobilities
PauseTimes="20" 			#May give a list of Different Pause Times
NumberOfResourceQueries="10"
QueryInterval=5.0

#Variable Parameters
SimulationRepetitions="1 2 3"				#  2 3 how many SimulationRepetitions you want to run the simulation with different network - finding average performance
NumberOfNodes="30 40 50 60"	#  60 80 100 May give a list of Different number of Nodes

RoutingProtocols="AODV"

#we may order the algorithms as per your wish
P2PResourceDiscoveryProtocols="StdFlooding StdRandomWalk StdGossip iRandomWalk iGossip" # StdFlooding iFlooding StdRandomWalk iRandomWalk StdGossip  iGossip TwoWayGossip
Legends="-0 StdFlooding -1 StdRandomWalk -2 StdGossip -3 iRandomWalk -4 iGossip"

PDFFileNames=""
NRLFileNames=""
EEDFileNames=""
OverheadFileNames=""
DroppedFileNames=""
ThroughputFileNames=""
MACLoadFileNames=""
PowerConsumptionFileNames=""
