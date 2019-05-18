############################################################################################################################################
# PrepareMasterTable.sh
#     A Script for Preparing a Master Table from all the tbl files
############################################################################################################################################
source P2PParameters.sh
>MasterTable.tbl
>MasterTableI.tbl
for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
do

	 echo  " Performance of $P2PResourceDiscoveryProtocol" >> MasterTable.tbl
	 
	 
	 echo -e "Nodes\tPDF\tNRL\tEED\tOverhd\tDropped\tThroughput\tMACLoad\tConsumedPower" >> MasterTable.tbl
     cat  P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl >> MasterTable.tbl
     echo >> MasterTable.tbl
     
     echo  " Performance of $P2PResourceDiscoveryProtocol" >> MasterTableI.tbl
     
     echo -e "Nodes\tSent%\tReceived%\tRDTime" >> MasterTableI.tbl
     cat  P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl >> MasterTableI.tbl
     echo >> MasterTableI.tbl

done


