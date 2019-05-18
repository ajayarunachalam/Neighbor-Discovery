############################################################################################################################################
# P2PAvgStatistics-I.awk
#     An Awk Script for doing trace analysis on the previously generated Custom trace files
#
#
############################################################################################################################################

BEGIN {
Rep=0.00000001	 ;# to avoid division by zero
}
{
    Req+=$1;
    Rep+=$2;
    Delay+=$3;

}
END {
    printf("%3d\t%5.2f\t%5.2f\t%5.2f\n",Variable,(Req/TotalRuns)*10,(Rep/TotalRuns)*10,Delay/TotalRuns);
}
