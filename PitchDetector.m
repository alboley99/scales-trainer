/*
 Copyright (c) Kevin P Murphy June 2012
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "PitchDetector.h"
#import <Accelerate/Accelerate.h>


@implementation PitchDetector
@synthesize lowBoundFrequency, hiBoundFrequency, sampleRate, delegate, running;

#pragma mark Initialize Methods


-(id) initWithSampleRate: (float) rate andDelegate: (id<PitchDetectorDelegate>) initDelegate {
    return [self initWithSampleRate:rate lowBoundFreq:40 hiBoundFreq:4500 andDelegate:initDelegate];
}

-(id) initWithSampleRate: (float) rate lowBoundFreq: (int) low hiBoundFreq: (int) hi andDelegate: (id<PitchDetectorDelegate>) initDelegate {
    self.lowBoundFrequency = low;
    self.hiBoundFrequency = hi;
    self.sampleRate = rate;
    self.delegate = initDelegate;
    
    bufferLength = self.sampleRate/self.lowBoundFrequency;    
    
    
 //   hann = (float*) malloc(sizeof(float)*bufferLength);
    
// **AJH defined bigger than the buffer length - causes memory problems if not
    
    hann = (float*) malloc(sizeof(float)*5000);
    
    vDSP_hann_window(hann, bufferLength, vDSP_HANN_NORM);
    
    sampleBuffer = (SInt16*) malloc(512);
    samplesInSampleBuffer = 0;
    
 //   result = (float*) malloc(sizeof(float)*bufferLength);
    
    // **AJH defined bigger than the buffer length - causes memory problems if not
    
    result = (float*) malloc(sizeof(float)*5000);
    
    return self;
}

#pragma  mark Insert Samples

- (void) addSamples:(SInt16 *)samples inNumberFrames:(int)frames {
    int newLength = frames;
    if(samplesInSampleBuffer>0) {
        newLength += samplesInSampleBuffer;
    }
    
    // AJH - Creates and allocates newBuffer and then copies sampleBuffer to newBuffer
    
    SInt16 *newBuffer = (SInt16*) malloc(sizeof(SInt16)*newLength);
    memcpy(newBuffer, sampleBuffer, samplesInSampleBuffer*sizeof(SInt16));
    
    // AJH - Now append the latest samples to the buffer starting from the end of the previous samples
    
    memcpy(&newBuffer[samplesInSampleBuffer], samples, frames*sizeof(SInt16));
    
    // Free up the memory from the old sample buffer
    
    free(sampleBuffer);
        
    sampleBuffer = newBuffer;
    samplesInSampleBuffer = newLength;
    
    if(samplesInSampleBuffer>(self.sampleRate/self.lowBoundFrequency)) {
        
//        [self performWithNumFrames:[NSNumber numberWithInt:newLength]];
        
        if(!self.running) {
            
 //           samplesToPass = sampleBuffer;
            [self performSelectorInBackground:@selector(performWithNumFrames:) withObject:[NSNumber numberWithInt:newLength]];
    //        printf("Correlating");
            self.running = YES;
        }
        samplesInSampleBuffer = 0;
    } else {
        //printf("NOT ENOUGH SAMPLES: %d\n", newLength);
    }
}


#pragma mark Perform Auto Correlation

-(void) performWithNumFrames: (NSNumber*)numFrames   {
    int n = numFrames.intValue;
    float freq = 0;
    
    // ** AJH - May be a problem here - this is running in background - what happens if sampleBuffer is freed up in the meantime?

// ** AJH Now Stored as a class variable - REINSTATED
    
    SInt16 *samples = sampleBuffer;
    
//    SInt16 *samples = samplesToPass;
    
    int returnIndex = 0;
    float sum;
    bool goingUp = false;
    float normalize = 0;
    
    
//    NSLog(@"%.2d", n);
     
    for(int i = 0; i<n; i++) {    // n is the number frames
        sum = 0;
        for(int j = 0; j<n; j++) {
            
            sum += (samples[j]*samples[j+i])*hann[j];
  //          NSLog(@"%.2hd", samples[i]);
   //         NSLog(@"%.2f", hann[i]);
            
        }
        if(i ==0 ) normalize = sum;
        result[i] = sum/normalize;
        
    }
    
    
    for(int i = 0; i<n-8; i++) {
//        NSLog(@"%.2f", result[i]);
        
        if(result[i]<0) {
            i+=2; // no peaks below 0, skip forward at a faster rate
        } else {
            if(result[i]>result[i-1] && goingUp == false && i >1) {
        
                //local min at i-1
            
                goingUp = true;
            
            } else if(goingUp == true && result[i]<result[i-1]) {
                
                //local max at i-1
            
                if(returnIndex==0 && result[i-1]>result[0]*0.95) {
                    returnIndex = i-1;
                    break; 
                    //############### NOTE ##################################
                    // My implemenation breaks out of this loop when it finds the first peak.
                    // This is (probably) the greatest source of error, so if you would like to
                    // improve this algorithm, start here. the next else if() will trigger on 
                    // future local maxima (if you first take out the break; above this paragraph)
                    //#######################################################
                } else if(result[i-1]>result[0]*0.85) {
                }
                goingUp = false;
            }       
        }
    }
 // AJH** Getting stuck here - freq = 0
    freq =self.sampleRate/interp(result[returnIndex-1], result[returnIndex], result[returnIndex+1], returnIndex);
    if(freq >= 27.5 && freq <= 4500.0) {
        
 //AJH       dispatch_async(dispatch_get_main_queue(), ^{
            [delegate updatedPitch:freq];
 //AJH      });
    }
    self.running = NO;
}


float interp(float y1, float y2, float y3, int k);
float interp(float y1, float y2, float y3, int k) {
    
    float d, kp;
    d = (y3 - y1) / (2 * (2 * y2 - y1 - y3));
//    printf("%f = %d + %f\n", k+d, k, d);
    kp  =  k + d;
    return kp;
}
@end

