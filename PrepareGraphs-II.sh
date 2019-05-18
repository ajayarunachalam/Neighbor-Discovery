############################################################################################################################################
# PrepareGraphs-II.sh
#     A Script for Preparing Graphs from the tracefile outputs
############################################################################################################################################
source P2PParameters.sh

for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
do

    >$P2PResourceDiscoveryProtocol-PDF.dat
    >$P2PResourceDiscoveryProtocol-NRL.dat
    >$P2PResourceDiscoveryProtocol-EED.dat
    >$P2PResourceDiscoveryProtocol-Overhead.dat
    >$P2PResourceDiscoveryProtocol-Dropped.dat
    >$P2PResourceDiscoveryProtocol-Throughput.dat
    >$P2PResourceDiscoveryProtocol-MACLoad.dat
    >$P2PResourceDiscoveryProtocol-PowerConsumption.dat

    PDFFileNames="$PDFFileNames $P2PResourceDiscoveryProtocol-PDF.dat"
    NRLFileNames="$NRLFileNames $P2PResourceDiscoveryProtocol-NRL.dat"
    EEDFileNames="$EEDFileNames $P2PResourceDiscoveryProtocol-EED.dat"
    OverheadFileNames="$OverheadFileNames $P2PResourceDiscoveryProtocol-Overhead.dat"
    DroppedFileNames="$DroppedFileNames $P2PResourceDiscoveryProtocol-Dropped.dat"
    ThroughputFileNames="$ThroughputFileNames $P2PResourceDiscoveryProtocol-Throughput.dat"
    MACLoadFileNames="$MACLoadFileNames $P2PResourceDiscoveryProtocol-MACLoad.dat"
    PowerConsumptionFileNames="$PowerConsumptionFileNames $P2PResourceDiscoveryProtocol-PowerConsumption.dat"

     cut -f 1,2   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-PDF.dat
     cut -f 1,3   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-NRL.dat
     cut -f 1,4   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-EED.dat
     cut -f 1,5   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-Overhead.dat
     cut -f 1,6   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-Dropped.dat
     cut -f 1,7   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-Throughput.dat
     cut -f 1,8   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-MACLoad.dat
     cut -f 1,9   P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> $P2PResourceDiscoveryProtocol-PowerConsumption.dat

done


	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $PDFFileNames			-t "P2P Agent Level Packet Delivery Ratio"	    $Legends -x "Nodes" -y "PDF" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $NRLFileNames			-t "P2P Network Routing Load"		 $Legends -x "Nodes" -y "NRL" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $EEDFileNames			-t "P2P Agent Level Hop to Hop Delay"	     $Legends -x "Nodes" -y "Delay (ms)" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $OverheadFileNames			-t "P2P Network Overhead"   $Legends -x "Nodes" -y "Overhead" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $DroppedFileNames			-t "Overall Dropped Packets"	 $Legends -x "Nodes" -y "Dropped (no)" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $ThroughputFileNames		-t "P2P Agent Level Throughput"   $Legends -x "Nodes" -y "Throughput(kbps)" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $MACLoadFileNames			-t "P2P Network MAC Load"     $Legends -x "Nodes" -y "MAC Load" -geometry 640x340&
	exec xgraph  -nb -m -bd BLUE -bg WHITE	-lw 3 -fmtx %3d -fmty %3.2f $PowerConsumptionFileNames	-t "Avg Consumed Energy of P2P Network"     $Legends -x "Nodes" -y "Consumed Energy(Joules)" -geometry 640x340&

