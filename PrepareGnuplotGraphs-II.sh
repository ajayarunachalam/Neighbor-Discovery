############################################################################################################################################
# PrepareGnuplotGraphs-II.sh
# A Script for	Preparing Graphs of different Analysis
# This is only for graph display purpose
# The stored PNG graphs created by this script 

############################################################################################################################################

source P2PParameters.sh

first="1"



for P2PResourceDiscoveryProtocol in $P2PResourceDiscoveryProtocols
do
	if [ $first = "1" ]
	then
	first="0"
	plotPDF="plot"
	plotNRL="plot"
	plotDelay="plot"
	plotOverhead="plot"
	plotDropped="plot"
	plotThroughput="plot"
	plotMACLoad="plot"
	plotPowerConsumption="plot"
	else
	  plotPDF="$plotPDF ,"
	  plotNRL="$plotNRL ,"
	  plotDelay="$plotDelay ,"
	  plotOverhead="$plotOverhead ,"
	  plotDropped="$plotDropped ,"
	  plotThroughput="$plotThroughput ,"
	  plotMACLoad="$plotMACLoad ,"
	  plotPowerConsumption="$plotPowerConsumption ,"

	fi

	plotPDF="$plotPDF 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:2 title '$P2PResourceDiscoveryProtocol'"
	plotNRL="$plotNRL 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:3 title '$P2PResourceDiscoveryProtocol'"
	plotDelay="$plotDelay 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:4 title '$P2PResourceDiscoveryProtocol'"
	plotOverhead="$plotOverhead 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:5 title '$P2PResourceDiscoveryProtocol'"
	plotDropped="$plotDropped 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:6 title '$P2PResourceDiscoveryProtocol'"
	plotThroughput="$plotThroughput 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:7 title '$P2PResourceDiscoveryProtocol'"
	plotMACLoad="$plotMACLoad 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:8 title '$P2PResourceDiscoveryProtocol'"
	plotPowerConsumption="$plotPowerConsumption 'P2P-$P2PResourceDiscoveryProtocol-Analysis-II.tbl'  using 1:9 title '$P2PResourceDiscoveryProtocol'"
done

echo  "load 'GnuplotParameters.plot'" >plotPDF.plot
echo  "set output 'P2PResourceDiscoveryProtocol-PDF.png'" >>plotPDF.plot
echo "set title 'P2P Agent Level Packet Delivery Ratio'"  >>plotPDF.plot
echo "set ylabel 'PDF'" >>plotPDF.plot
echo  "set yrange []" >>plotPDF.plot
echo  $plotPDF >> plotPDF.plot

echo  "load 'GnuplotParameters.plot'" >plotNRL.plot
echo  "set output 'P2PResourceDiscoveryProtocol-NRL.png'" >>plotNRL.plot
echo "set title 'P2P Network Routing Load'"  >>plotNRL.plot
echo "set ylabel 'Routing Load'" >>plotNRL.plot
echo  "set yrange []" >>plotNRL.plot
echo  $plotNRL >> plotNRL.plot

echo  "load 'GnuplotParameters.plot'" >plotDelay.plot
echo  "set output 'P2PResourceDiscoveryProtocol-Delay.png'" >>plotDelay.plot
echo "set title 'P2P Agent Level Hop to Hop Packet Delay'"  >>plotDelay.plot
echo "set ylabel 'Delay (ms)'" >>plotDelay.plot
echo  "set yrange []" >>plotDelay.plot
echo  $plotDelay >> plotDelay.plot

echo  "load 'GnuplotParameters.plot'" >plotOverhead.plot
echo  "set output 'P2PResourceDiscoveryProtocol-Overhead.png'" >>plotOverhead.plot
echo "set title 'P2P Network Overhead'"  >>plotOverhead.plot
echo "set ylabel 'Overhead'" >>plotOverhead.plot
echo  "set yrange []" >>plotOverhead.plot
echo  $plotOverhead >> plotOverhead.plot

echo  "load 'GnuplotParameters.plot'" >plotDropped.plot
echo  "set output 'P2PResourceDiscoveryProtocol-Dropped.png'" >>plotDropped.plot
echo "set title 'Overall Dropped Packets'"  >>plotDropped.plot
echo "set ylabel 'Dropped (no)'" >>plotDropped.plot
echo  "set yrange []" >>plotDropped.plot
echo  $plotDropped >> plotDropped.plot

echo  "load 'GnuplotParameters.plot'" >plotThroughput.plot
echo  "set output 'P2PResourceDiscoveryProtocol-Throughput.png'" >>plotThroughput.plot
echo "set title 'P2P Agent Level Throughput'"  >>plotThroughput.plot
echo "set ylabel 'Throughput/Bandwidth (kbps)'" >>plotThroughput.plot
echo  "set yrange []" >>plotThroughput.plot
echo  $plotThroughput >> plotThroughput.plot

echo  "load 'GnuplotParameters.plot'" >plotMACLoad.plot
echo  "set output 'P2PResourceDiscoveryProtocol-MACLoad.png'" >>plotMACLoad.plot
echo "set title 'P2P Network MAC Load'"  >>plotMACLoad.plot
echo "set ylabel 'MAC Load'" >>plotMACLoad.plot
echo  "set yrange []" >>plotMACLoad.plot
echo  $plotMACLoad >> plotMACLoad.plot

echo  "load 'GnuplotParameters.plot'" >plotPowerConsumption.plot
echo  "set output 'P2PResourceDiscoveryProtocol-PowerConsumption.png'" >>plotPowerConsumption.plot
echo "set title 'Avg. Consumed Energy of P2P Network'"	>>plotPowerConsumption.plot
echo "set ylabel 'Consumed Energy(Joules)'" >>plotPowerConsumption.plot
echo  "set yrange []" >>plotPowerConsumption.plot
echo  $plotPowerConsumption >> plotPowerConsumption.plot




gnuplot plotPDF.plot
gnuplot plotNRL.plot
gnuplot plotDelay.plot
gnuplot plotOverhead.plot
gnuplot plotDropped.plot
gnuplot plotThroughput.plot
gnuplot plotMACLoad.plot
gnuplot plotPowerConsumption.plot





