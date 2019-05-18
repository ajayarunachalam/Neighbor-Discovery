############################################################################################################################################
# RunP2PNetworkSimulations.sh
# A Script for running the simulation with different parameters and network senarios
#
############################################################################################################################################


clear

source P2PParameters.sh
PauseTime="20"
Mobility="20"

echo " " # print new line
echo " " # print new line
date | awk '{ print "Date: "$1" " $3 "-"$2"-"$6 }'
date | awk '{ print "Time: "$4" " $5 }'

for Rep in $SimulationRepetitions
do
	for Nodes in  $NumberOfNodes   # Number of Nodes  20 40 60 80 100
	do
	   #clear
				for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
				do
						for RoutingProtocol in $RoutingProtocols
						do
						  echo	"Nodes: $Nodes Protocol: $P2PResourceDiscoveryProtocol"
						  echo " "
						  P2PNetScenarioFileName='P2PNet-N'$Nodes'-Scen'$Rep'-P'$PauseTime'-M'$Mobility'-t'$Time'-X'$X'-Y'$Y'.Scen'
						  echo "Selected Network Scenario File :  $P2PNetScenarioFileName"

						  P2PNetTraceFileName='P2PNetTrace-N'$Nodes'-Scen'$Rep'-Queries'$NumberOfResourceQueries'-'$RoutingProtocol'-'$P2PResourceDiscoveryProtocol.trace
						  CustP2PNetTraceFileName='P2PNetTrace-N'$Nodes'-Scen'$Rep'-Queries'$NumberOfResourceQueries'-'$RoutingProtocol'-'$P2PResourceDiscoveryProtocol.cust
						  echo "The Output Trace File Name : $P2PNetTraceFileName"
						  echo "Running the simulation .... "
						  ns myP2PNetworkResourceDiscoverySimulation.tcl  $P2PNetScenarioFileName $P2PNetTraceFileName $Nodes  $RoutingProtocol $P2PResourceDiscoveryProtocol $NumberOfResourceQueries 0 > $CustP2PNetTraceFileName
						done
				done
	done
done
exit



