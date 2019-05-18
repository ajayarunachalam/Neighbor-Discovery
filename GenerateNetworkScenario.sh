############################################################################################################################################
# GenerateNetworkScenario.sh
# A Script for creating the random movement senarios
#
############################################################################################################################################


clear
ns2version="2.35"
ns2InstallationRoot="/home/ajay";
# ~ means home directory -  if the installation is under /root  then "/root" if the installation is under /usr/user1   then this will be  "/usr/user1" instead of ""


source P2PParameters.sh


for Rep in  $SimulationRepetitions
do
	for Mobility in $Mobilities
	do
		for Nodes in $NumberOfNodes
		do
		   #clear
			for PauseTime in $PauseTimes
			do
			  echo	"File Senario Program is Runing ...................... ok"
			  P2PNetScenarioFileName='P2PNet-N'$Nodes'-Scen'$Rep'-P'$PauseTime'-M'$Mobility'-t'$Time'-X'$X'-Y'$Y'.Scen'
			  echo	"The File Senario  $P2PNetScenarioFileName	Under Creation "
			  echo	"Please Wait ............................. "
				$ns2InstallationRoot/ns-allinone-$ns2version/ns-$ns2version/indep-utils/cmu-scen-gen/setdest/setdest -v 1 -n $Nodes -p $PauseTime -M $Mobility -t $Time -x $X -y $Y > $P2PNetScenarioFileName
			  echo	"The File Senario  $P2PNetScenarioFileName   .... Created"
			  echo " "
			  echo " "
			  echo " "
			done
		done
	done
done
