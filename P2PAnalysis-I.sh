############################################################################################################################################
# P2PAnalysis-I.sh
#     A Script for doing trace Analysis on the trace files of the simulation of the different network senarios
#
############################################################################################################################################


source P2PParameters.sh


echo "Storing the following values in DAT files"
echo "NumberOfNodes SentRequests ReceivedReplies E2EDealay"

echo "Please Wait"



	for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
		do
		>P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl
				for RoutingProtocol in $RoutingProtocols
					do
					for Nodes in  $NumberOfNodes   # Number of Nodes  20 40 60 80 100
						do

						>temp
						  for Rep in $SimulationRepetitions
							do
								echo  "Nodes: $Nodes Protocol: $P2PResourceDiscoveryProtocol"
								#P2PNetTraceFileName='P2PNetTrace-N'$Nodes'-Scen'$Rep'-Queries'$NumberOfResourceQueries'-'$RoutingProtocol'-'$P2PResourceDiscoveryProtocol.trace
								CustP2PNetTraceFileName='P2PNetTrace-N'$Nodes'-Scen'$Rep'-Queries'$NumberOfResourceQueries'-'$RoutingProtocol'-'$P2PResourceDiscoveryProtocol.cust
							    awk  -f P2PStatistics-I.awk  $CustP2PNetTraceFileName >> temp
							done
							awk -f P2PAvgStatistics-I.awk Variable=$Nodes  TotalRuns=$Rep pname=$Protocol  temp >> P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl
		       done
	      done
    done
