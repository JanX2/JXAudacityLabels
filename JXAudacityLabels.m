//
//  JXAudacityLabels.m
//  Transcriptions
//
//  Created by Jan on 24.08.17.
//
//

#import "JXAudacityLabels.h"



NSString * const    JXAudacityLabelsErrorDomain		= @"de.geheimwerk.Error.AudacityLabels";


@implementation JXAudacityLabels

NS_INLINE BOOL scanLinebreak(NSScanner *scanner, NSString *linebreakString, size_t *lineNumber) {
	BOOL success = ([scanner scanString:linebreakString intoString:NULL] && ((*lineNumber) += 1));
	return success;
}

NS_INLINE BOOL scanString(NSScanner *scanner, NSString *str) {
	BOOL success = [scanner scanString:str intoString:NULL];
	return success;
}

static const CMTimeScale MicrosecondTimescaleJX = 1000000;

+ (NSMutableArray *)parseAudacityTextLabelsInString:(NSString *)string
										  timescale:(CMTimeScale)timescale
										   outError:(NSError **)outError;
{
	NSScanner *scanner = [NSScanner scannerWithString:string];
	[scanner setCharactersToBeSkipped:nil];
	
	// Auto-detect linebreakString
	NSString *linebreakString = nil;
	{
		NSCharacterSet *newlineCharacterSet = [NSCharacterSet newlineCharacterSet];
		BOOL ok = ([scanner scanUpToCharactersFromSet:newlineCharacterSet intoString:NULL] &&
				   [scanner scanCharactersFromSet:newlineCharacterSet intoString:&linebreakString]);
		if (ok == NO) {
			NSLog(@"Parser warning in Audacity text labels: no line break found!");
			linebreakString = @"\n";
		}
		scanner.scanLocation = 0;
	}
	
	NSString *separator = @"\t";
	
	NSMutableArray *labelItems = [NSMutableArray array];
	
#   define SCAN_LINEBREAK() scanLinebreak(scanner, linebreakString, &lineNumber)
#   define SCAN_STRING(str) scanString(scanner, (str))
	
	size_t lineNumber = 1;
	
	while (!scanner.atEnd) {
		NSString *labelString;
		
		double startInSeconds;
		double endInSeconds;
		
		BOOL ok = ([scanner scanDouble:&startInSeconds] &&
				   SCAN_STRING(separator) &&
				   [scanner scanDouble:&endInSeconds] &&
				   SCAN_STRING(separator) &&
				   // Label text
				   (
					[scanner scanUpToString:linebreakString
								 intoString:&labelString] || // We either find a string…
					(labelString = @"") // … or we assume an empty label.
					)
				   &&
				   
				   // End of label
				   (SCAN_LINEBREAK() || scanner.atEnd)
				   );
		
		if (ok) {
			JXAudacityLabelItem *labelItem =
			[[JXAudacityLabelItem alloc] initWithLabelString:labelString
											  startInSeconds:startInSeconds
												endInSeconds:endInSeconds
												   timescale:timescale ?: MicrosecondTimescaleJX];
			
			[labelItems addObject:labelItem];
		}
		else {
			if (outError != NULL) {
				const NSUInteger contextLength = 20;
				NSUInteger strLength = string.length;
				NSUInteger errorLocation = scanner.scanLocation;
				
				NSRange beforeRange, afterRange;
				
				beforeRange.length = MIN(contextLength, errorLocation);
				beforeRange.location = errorLocation - beforeRange.length;
				NSString *beforeError = [string substringWithRange:beforeRange];
				
				afterRange.length = MIN(contextLength, (strLength - errorLocation));
				afterRange.location = errorLocation;
				NSString *afterError = [string substringWithRange:afterRange];
				
				NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"The Audacity text labels could not be parsed: error in line %d:\n%@<HERE>%@", @"Cannot parse Audacity text labels file"),
											  lineNumber, beforeError, afterError];
				NSDictionary *errorDetail = @{NSLocalizedDescriptionKey: errorDescription};
				*outError = [NSError errorWithDomain:JXAudacityLabelsErrorDomain
												code:JXAudacityLabelsCouldNotParseError
											userInfo:errorDetail];
			}
			
			return nil;
		}
		
	}
	
	return labelItems;
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
