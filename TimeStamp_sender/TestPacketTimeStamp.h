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
 */ 

#ifndef _TESTPACKETTIMESTAMP_H
#define _TESTPACKETTIMESTAMP_H

enum
{
    AM_TIMESTAMPPOLL = 0xBA,
    AM_TIMESTAMPPOLLREPORT = 0xBB
};

typedef nx_struct TimeStampPoll
{
    nx_uint16_t senderAddr;
    nx_uint16_t msgID;
    nx_uint32_t previousSendTime;
}TimeStampPoll;

typedef nx_struct TimeStampPollReport
{
    nx_uint16_t localAddr;
    nx_uint16_t senderAddr;
    nx_uint16_t msgID;
    nx_uint32_t previousSendTime;
    nx_uint32_t previousReceiveTime;
    nx_uint32_t currentSendTime;
    
}TimeStampPollReport;

#endif