############################################################################################################################################
# Prepare.sh
#     A Script for Preparing Graphs from the tracefile outputs
#
############################################################################################################################################
source P2PParameters.sh

for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
do

    > $P2PResourceDiscoveryProtocol-SuccessRate.dat
    > $P2PResourceDiscoveryProtocol-Time.dat


    SuccessRateFileNames="$SuccessRateFileNames $P2PResourceDiscoveryProtocol-SuccessRate.dat"
    TimeFileNames="$TimeFileNames $P2PResourceDiscoveryProtocol-Time.dat"


     cut -f 1,3   P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl >> $P2PResourceDiscoveryProtocol-SuccessRate.dat
     cut -f 1,4   P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl >> $P2PResourceDiscoveryProtocol-Time.dat


done

	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f   $SuccessRateFileNames		-t "Resource Discovery Success Rate"	    $Legends -x "Nodes" -y "Success Rate(%)" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f   $TimeFileNames			-t "Resource Discovery Time"				$Legends -x "Nodes" -y "Time(sec)"	 -geometry 640x340&

