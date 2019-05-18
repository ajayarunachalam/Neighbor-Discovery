############################################################################################################################################
# PrepareGnuplotGraphs-I.sh
# A Script for	Preparing Graphs of different Analysis
# This is only for graph display purpose
# The stored PNG graphs created by this script are only used in the paper and thesis
#     A Script for Preparing Graphs from the tracefile outputs
############################################################################################################################################

source P2PParameters.sh

first="1"

for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
do
if [ $first = "1" ]
then
first="0"
plotSuccessRate="plot"
plotResourceDiscoveryTime="plot"
else
  plotSuccessRate="$plotSuccessRate ,"
  plotResourceDiscoveryTime="$plotResourceDiscoveryTime ,"
fi
	plotSuccessRate="$plotSuccessRate 'P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl'  using 1:3 title '$P2PResourceDiscoveryProtocol' "
	plotResourceDiscoveryTime="$plotResourceDiscoveryTime 'P2P-$P2PResourceDiscoveryProtocol-Analysis-I.tbl'  using 1:4 title '$P2PResourceDiscoveryProtocol' "
done

echo  "load 'GnuplotParameters.plot'" >plotSuccessRate.plot
echo  "set output 'P2PResourceDiscoveryProtocol-SuccessRate.png'" >>plotSuccessRate.plot
echo "set title 'Success Rate of P2P Resource Discovery'"  >>plotSuccessRate.plot
echo "set ylabel 'Success Rate(%)'" >>plotSuccessRate.plot
echo  "set yrange [0:110]" >>plotSuccessRate.plot
echo  $plotSuccessRate >> plotSuccessRate.plot


echo  "load 'GnuplotParameters.plot'" >plotResourceDiscoveryTime.plot
echo  "set output 'P2PResourceDiscoveryProtocol-ResourceDiscoveryTime.png'" >>plotResourceDiscoveryTime.plot
echo "set title 'P2P Resource Discovery Time'"	>>plotResourceDiscoveryTime.plot
echo  "set ylabel 'Time Taken(ms)'" >>plotResourceDiscoveryTime.plot
echo  "set yrange []" >>plotSuccessRate.plot
echo  $plotResourceDiscoveryTime >> plotResourceDiscoveryTime.plot





gnuplot plotSuccessRate.plot
gnuplot plotResourceDiscoveryTime.plot




