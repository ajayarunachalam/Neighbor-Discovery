############################################################################################################################################
# P2PAvgStatistics-II.awk
#     An Awk Script for doing trace analysis on the previously generated Custom trace files
#	
############################################################################################################################################

BEGIN {

}
{
    PDF+=$1;
    NRL+=$2;
    EED+=$3;
    Overhd+=$4;
    Dropped+=$5;
    Throughput=$6
    MACLoad=$7
    ConsumedPower=$8
}
END {
    printf("%3d\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%10d\t%5.2f\t%5.2f\t%5.2f\n",Variable,PDF/TotalRuns,NRL/TotalRuns,EED/TotalRuns,Overhd/TotalRuns,Dropped/TotalRuns,Throughput/TotalRuns,MACLoad/TotalRuns,ConsumedPower/TotalRuns);
}



