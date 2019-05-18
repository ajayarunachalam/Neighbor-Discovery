############################################################################################################################################
# P2PStatistics-II.awk
#     An Awk Script for doing trace analysis on the previously generated ns2 trace files
#
############################################################################################################################################

# Performance Analysis Program

BEGIN {
    sends=0.0;
    MACsends=0.0;
    recvs=0.0;
    routing_packets=0.0;
    droppedBytes=0;
    droppedPackets=0;
    highest_packet_id =0;
    sum=0.0;
    recvnum=0.0;

    beacon_no=0;		  #for control packet
    frip_no=0;			  #for control packet
    rsup_no=0;			  #for control packet
    rrep_no=0;			  #for control packet
    rreq_no=0;			  #for control packet
    Control_Total_pkt=0;	  #for control packet

    cbr_no=0;			  #for data packet
    tcp_no=0;			  #for data packet
    ack_no=0;			  #for data packet
    Data_Total_pkt=0 ;		  #for data packet

    recvdSize = 0.0;		  #for throughput
    startTime = 1e6;		  #for throughput
    stopTime = 0.0;		  #for throughput




    }
  {
#for  Consumed Power Calculation
if (firsttime==1)
{
	for (i=0; i<TotalNodes; i++) {
	 cpower[i]=500.0
	}
	firsttime=0
}

      # Trace line format: Old

	     event = $1;     # event is the contents of field #1 in the trace file which is s,r,f or d
	     time = $2;      # time = contents of 3rd field in the trace file

	     if (event=="N") {
		   # printf("%d, %f\n", $5, $7)
		    cpower[$5]=$7
	    }

if ($2 != "-t") {
	    # if (time>200)   time=200 ;
	     if (time<0)   time=0 ;
	     node_id = $3;
	     level = $4;
	     packet_id = $6;# packet_id = contents of field	#41 in the new trace  format
	     pkt_size = $8; # pkt_size is the contents of field #37 in the new trace  format
	     pkt_type= $7;  # pkt_type is the contents of field #35 in the new trace  format


     #rintf("\t %s %f %d %s %s \n", event, time,node_id,level,pkt_type);	# DroppedPackets  (Packet)
     #	      if( time>200)
      # 	 exit;
  #====== Start of Performance calculation

    #====== Start of  Consumed Power calculation

  #====== End of Consumed Power calculation
  # CALCULATE PACKET DELIVERY FRACTION (Data Packets)
  if (( event == "s") &&  ( (level=="AGT") )) {  sends++; }

  if (( event == "r") &&  ((level=="AGT") )) {	recvs++; }

   if (( event == "s") && (level=="MAC")) {  MACsends++; }


  # CALCULATE DELAY
  if ( start_time[packet_id] == 0 )  start_time[packet_id] = time;
  if (( event == "r") &&  ( pkt_type == "message"  ) && (level=="AGT")) {  end_time[packet_id] = time;	}
       else {  end_time[packet_id] = -1;  }


  # CALCULATE TOTAL OVERHEAD (Control Packets)
  if ((event == "s" || event == "f") && (level=="RTR") && (pkt_type == "message" || pkt_type == "DSDV" || pkt_type == "MDART" || pkt_type == "AOMDV" ||pkt_type =="REQUEST" || pkt_type =="REPLY"|| pkt_type == "AODV" ||
       pkt_type == "DSR" ||  pkt_type =="BEACON" || pkt_type =="FRIP" || pkt_type =="RSUP" || pkt_type =="ROUTE_REQ" || pkt_type =="ROUTE_REP"))
		routing_packets++;



  # DROPPED DSR PACKETS
  if (( event == "d" || event == "D")  && ( time  > 0 ))
       {
	     droppedPackets=droppedPackets+1;
       }

 #find the number of packets in the simulation
 if (packet_id > highest_packet_id)
    highest_packet_id = packet_id;



 #====== Start of Throughput calculation
 # Store start time
  if ((level == "AGT") && (event == "+" || event == "s") && pkt_size >= 100) {
    if (time < startTime && time>=0) {
	     startTime = time;
	     }
       }

  # Update total received packets' size and store packets arrival time
  if ((level == "AGT") && event == "r" && pkt_size >= 100) {
       if (time > stopTime) {
	     stopTime = time;
	     }
       # Rip off the header
       # Store received packet's size;
       recvdSize += pkt_size;
       }
  #====== End of Throughput calculation


}
  }

  END {

  #====== This part for Performance calculation
  for ( i in end_time )
  {
  start = start_time[i];
  end = end_time[i];
  packet_duration = end - start;
  if ( packet_duration > 0 )
  {    sum += packet_duration;
       recvnum++;
  }
  }
     if(recvnum==0)
	recvnum++; # set to 1
     if(sends==0)
      { printf("NOTE: No Data Sent ....... ");
	sends++;}  # set to 1
     if(recvs==0)
       {printf("No Data Received   ....... ");
	recvs++;}  # set to 1

     delay=sum/recvnum;
     NRL = routing_packets/recvs;  #normalized routing load
     PDF = (recvs/sends)*100;  #packet delivery ratio[fraction]
     Throughput=((recvdSize/(stopTime-startTime)) *8)/1000
     MACLoad=MACsends/recvs

     sum=0;
	for (i=0; i<TotalNodes; i++) {
	 sum=sum + cpower[i]
	}
     ConsumedPower = ((500.0*TotalNodes) - sum ) /TotalNodes ;
     printf("%.1f ",PDF);		# PDF
     printf("%.2f ",NRL);		# NRL
     printf("%.2f ",delay*1000);	# EED
     printf("%.0f ",routing_packets);	# Overhead
     printf("%.0f ",droppedPackets);	# DroppedPackets  (Packet)
     printf("%.2f ",Throughput);		# Throughput
     printf("%.2f ",MACLoad);		# MACLoad
     printf("%.2f",ConsumedPower);		# ConsumedPower
     printf("\n");
  }


