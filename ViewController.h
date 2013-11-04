/*
 Copyright (c) Kevin P Murphy June 2012
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "AudioController.h"
#import "PitchDetector.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class ScaleSelectorViewController;

@interface ViewController : UIViewController <PitchDetectorDelegate, AudioControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    
        NSArray *scaleData;
        NSMutableArray *scaleNotes; // Holds the MIDI note number for each note in the current scale
        NSString *selectedScale;
    
    int numberOfPositions;   // The number of positions to show on one string
    
    
    IBOutlet UILabel *freqLabel;
    __weak IBOutlet UILabel *noteLabel;
    __weak IBOutlet UILabel *octaveLabel;
    __weak IBOutlet UILabel *frequencyIndexLabel;
    __weak IBOutlet UILabel *accuracyLabel;
    __weak IBOutlet UILabel *variationLabel;
    
    __weak IBOutlet UIPickerView *scalePicker;
    
    __weak IBOutlet UISwitch *stopStartPitchSwitch;
    __weak IBOutlet UILabel *instrument;
    __weak IBOutlet UIImageView *pitchIndicatorLabel;
    
    NSArray *scaleList;
    NSMutableArray *fingerLabels; // Used to hold the UI labels for fingerings
    NSMutableArray *noteImages; // Used to hold the UI labels for note images
    
    AVAudioRecorder *recorder;
    float decibels;
    
    __weak IBOutlet UIButton *soundButton;
    
    __weak IBOutlet UILabel *decibelsLabel;
    __weak IBOutlet UILabel *currentScale;
    
    // Fingers
    
    AudioController *audioManager;
    PitchDetector *autoCorrelator;
    
    NSMutableArray *medianPitchFollow;
    
    
    // Pitches array
    
    NSArray *frequencies;
    NSArray *octaves;
    NSArray *notes;
    
    // Stores the last note that has been lit up
    
    int lastNoteIndex;
    
    BOOL pitchDetectionStarted;
    
    UILabel *currentPitchIndicatorLabel;
    

}


@end
