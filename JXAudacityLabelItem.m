//
//  JXAudacityLabelItem.m
//  Transcriptions
//
//  Created by Jan on 24.08.17.
//
//

#import "JXAudacityLabelItem.h"


@implementation JXAudacityLabelItem

- (instancetype)initWithLabelString:(NSString *)labelString
						  startTime:(CMTime)startTime
							endTime:(CMTime)endTime;
{
	self = [self init];
	
	if (self != nil) {
		self.text = labelString;
		_startTime = startTime;
		_endTime = endTime;
	}
	
	return self;
}

- (instancetype)initWithLabelString:(NSString *)labelString
					 startInSeconds:(double)startInSeconds
					   endInSeconds:(double)endInSeconds
						  timescale:(CMTimeScale)timescale;
{
	CMTime startTime = CMTimeMakeWithSeconds(startInSeconds, timescale);
	CMTime endTime = CMTimeMakeWithSeconds(endInSeconds, timescale);
	
	return [self initWithLabelString:labelString
						   startTime:startTime
							 endTime:endTime];
}

@end

/*
 Copyright 2016-17 Jan Weiß
 
 Some rights reserved: https://opensource.org/licenses/BSD-3-Clause
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.
 
 3. Neither the name of the copyright holder nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
