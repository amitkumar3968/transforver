//
//  VoiceConverterModel.m
//  NavTab
//
//  Created by CHA-MBP on 12/9/17.
//
//

#import "VoiceConverterModel.h"

#include "CAXException.h"
#include "CAStreamBasicDescription.h"

extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@implementation VoiceConverterModel

+ (BOOL) convertAifFile:(NSString *) sourceFileName
              toM4aFile:(NSString *) destinationFileName {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString* sourceFilePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], sourceFileName];
    
    NSString* destinationFilePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], destinationFileName];
    
    CFURLRef sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)sourceFilePath, kCFURLPOSIXPathStyle, false);
    
    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    
    OSStatus error = DoConvertFile(sourceURL, destinationURL, kAudioFormatMPEG4AAC, VOCODER_SAMPLE_RATE);
    
    //    [self.activityIndicator stopAnimating];
    
    if (error) {
        // delete output file if it exists since an error was returned during the conversion process
        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
        }
        
        printf("DoConvertFile failed! %ld\n", error);
        [self performSelectorOnMainThread:(@selector(updateUI)) withObject:nil waitUntilDone:NO];
        return NO;
    } else {
        [self performSelectorOnMainThread:(@selector(playAudio)) withObject:nil waitUntilDone:NO];
        [[NSFileManager defaultManager] removeItemAtPath:sourceFilePath error:nil];
        return YES;
    }
    
    [pool release];
}

@end
