############################################################################################################################################
# P2PStatistics-I.awk
#     An Awk Script for doing trace analysis on the previously generated ns2 trace files
#
############################################################################################################################################

# Performance Analysis Program

BEGIN {
    Req=0.0
	Rep=0.0

    }

# Body
{

  if ($1== "#Request#") {
	Req=Req+1
	SentTime[$5]=$3

 }

  if ($1== "#Reply#") {
	Rep=Rep+1
	ReceivedTime[$5]=$3
  }
}

  END {
  sum=0
  tot=0.00000001 ; # to avoid division by zero error
	for ( i in ReceivedTime ) {
	 sum=sum + ( ReceivedTime[i]-SentTime[i] )
	 tot=tot+1
	}

	 AvgE2EDelay=sum/tot

     printf("%.2f\t",Req);	# Total Resource Discovery Requests
     printf("%.2f\t",Rep);	# Total Resource Discovery Replies
     printf("%.2f",AvgE2EDelay);	# Average Delay
     printf("\n");
  }


