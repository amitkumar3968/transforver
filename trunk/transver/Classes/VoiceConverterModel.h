//
//  VoiceConverterModel.h
//  NavTab
//
//  Created by CHA-MBP on 12/9/17.
//
//

#import <Foundation/Foundation.h>
#import "Util.h"

#define VOCODER_SAMPLE_RATE 22050.0

@interface VoiceConverterModel : NSObject

+ (BOOL) convertAifFile:(NSString *) sourceFileName
              toM4aFile:(NSString *) destinationFileName;

@end
