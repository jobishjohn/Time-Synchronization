/*
* Copyright (c) 2006 Stanford University.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 * - radio message timestamping test application
 * - tests both message reception and transmission timestamps
 * - each node periodically broadcasts TimeStampPoll messages which are
 *   timestamped at both sender and receiver. TimeStampPoll message includes
 *   previous timestamp of the sender. receiver reports both reception timestamp
 *   and the previous sender timestamp.
 * - BusyTimer fires periodically to simulate CPU load
 */

#include "TestPacketTimeStamp.h"
#include "Timer.h"

module TestPacketTimeStampP
{
    uses 
    {
        interface Boot;
        interface Leds;

        interface SplitControl as RadioControl;
        interface AMSend as ReportSend;

        interface Receive as PollReceive;
        interface PacketTimeStamp<T32khz, uint32_t>;
        
        interface AMPacket as RadioAMPacket;
    }
}

implementation
{
    #ifndef TIMESYNC_POLLER_RATE
    #define TIMESYNC_POLLER_RATE 1000
    #endif

	/*------variadle declarations--------*/
    message_t msg, msgReport;
	am_addr_t addr;
	/*-------------------------------------------*/
    event void Boot.booted()
    {
      	call RadioControl.start();
    }

    /* -----receives the message and puts the received time stamp (t2) and sends back to the 
     * same address. The packet is also time stamped while sending(t3). If the time stamp is invalid
     * the times stamp will be zero.......  */
   
    event message_t* PollReceive.receive(message_t* p, void* payload, uint8_t len)
    {
        atomic
        {
	        TimeStampPoll *tsp = (TimeStampPoll *)payload;
	        TimeStampPollReport *tspr = call ReportSend.getPayload(&msgReport, sizeof(TimeStampPollReport));
	           
	        addr = call RadioAMPacket.source(p);
	        
	        call Leds.led1Toggle();
	        
	        tspr ->localAddr = TOS_NODE_ID;
	        tspr->senderAddr = tsp->senderAddr;
	        tspr->msgID = tsp->msgID;
	        tspr->previousSendTime = tsp->previousSendTime;
	
	        if (tsp->previousSendTime!=0 && call PacketTimeStamp.isValid(p))
	        	tspr->previousReceiveTime = call PacketTimeStamp.timestamp(p);
	        else
	         	tspr->previousReceiveTime = 0;

	        call ReportSend.send(addr, &msgReport, sizeof(TimeStampPollReport));
	        
	        return p;
	    }
    }

/*-----------------------------------------------------------------*/
 	event void RadioControl.startDone(error_t error){};
    event void RadioControl.stopDone(error_t error){};
/*-------------------------------------------------------------------*/
 /* -----This portion puts the timestamp  while sending(t3). If the time stamp is invalid
 * 		the times stamp will be zero.......  */

    event void ReportSend.sendDone(message_t* p, error_t success)
    {
	   	TimeStampPollReport *tspr = call ReportSend.getPayload(&msgReport, sizeof(TimeStampPollReport));
        if (call PacketTimeStamp.isValid(p))
            tspr->currentSendTime = call PacketTimeStamp.timestamp(p);
        else
            tspr->currentSendTime = 0;
    }
/*-----------------------------------------------------------------*/
}