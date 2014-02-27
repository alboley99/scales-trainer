/*
 Copyright (c) Kevin P Murphy June 2012
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ViewController.h"
#import "ScaleSelectorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SoundBankPlayer.h"


@interface ViewController ()

@end

@implementation ViewController

SoundBankPlayer *_soundBankPlayer;
NSTimer *_timer;
BOOL _playingArpeggio;
NSArray *_arpeggioNotes;
NSUInteger _arpeggioIndex;
CFTimeInterval _arpeggioStartTime;
CFTimeInterval _arpeggioDelay;


- (IBAction)playSound:(id)sender {
    
//  [_soundBankPlayer queueNote:48 gain:0.4f];
//	[_soundBankPlayer queueNote:55 gain:0.4f];
//	[_soundBankPlayer queueNote:64 gain:0.4f];
//	[_soundBankPlayer playQueuedNotes];
    
 //   [self playArpeggioWithNotes:@[@33, @45, @52, @60, @52, @45, @33] delay:0.5f];
    
  
    // Switch Off Pitch Detection

    [stopStartPitchSwitch setOn:NO animated:YES];
    [audioManager stopAudio];
    
    // Build scale
    
    int string;
    int position;
//    int positionIndex;
    int note;
    NSString *direction;
    NSMutableArray *scaleAllNotes;
    int j = 0;
    
    
    scaleAllNotes = [[NSMutableArray alloc] init];
    
    
    for(int i = 0; i<[scaleData count]; i++)
        
        // Go up the scale
    {
        
        direction = [[scaleData objectAtIndex:i]objectForKey:@"direction"];
        
        if (![direction isEqual:@"D"] )
        {
            
        string = [[[scaleData objectAtIndex:i]objectForKey:@"string"]intValue];
        position = [[[scaleData objectAtIndex:i]objectForKey:@"position"]intValue];
        
        
        // Calculate relative position
        
//AN        positionIndex = position + ((string - 1) * (numberOfPositions-1));
        
        // Calculate the note corresponding to the string and position
        
        if ([[currentScale.text substringToIndex:5] isEqual:@"Viola"])
        {
            note = 29 + position + ((string)*7);
        }
        else if ([[currentScale.text substringToIndex:11] isEqual:@"Double Bass"])
        {
            
            note = -1 + position + ((string)*5);
        }
            else   // cello
        {
                
                note = 17 + position + ((string)*7);
        }
    
        // Add the number to an Array - this enables the correct position to be lit up
            
        [scaleAllNotes insertObject:[NSNumber numberWithInteger: note] atIndex:j];
            j++;
            
        }
    }
    
        
        for(int i = [scaleData count]-2; i>-1; i--)
            
        {
        
        
        // Go down the scale
        {
            
            direction = [[scaleData objectAtIndex:i]objectForKey:@"direction"];
            
            if (![direction isEqual:@"U"] )
            {
                
                string = [[[scaleData objectAtIndex:i]objectForKey:@"string"]intValue];
                position = [[[scaleData objectAtIndex:i]objectForKey:@"position"]intValue];
                
                
                // Calculate relative position
                
  //AN              positionIndex = position + ((string - 1) * (numberOfPositions-1));
                
                // Calculate the note corresponding to the string and position
                
                if ([[currentScale.text substringToIndex:5] isEqual:@"Viola"])
                {
                    note = 29 + position + ((string)*7);
                }
                else if ([[currentScale.text substringToIndex:11] isEqual:@"Double Bass"])
                {
                    
                    note = -1 + position + ((string)*5);
                }
                else // cello
                {
                    
                    note = 17 + position + ((string)*7);
                }
                
                // Add the number to an Array - this enables the correct position to be lit up
                
                [scaleAllNotes insertObject:[NSNumber numberWithInteger: note] atIndex:j];
                j++;
                
            }
 
        }

    }
    
    
    [self playArpeggioWithNotes:scaleAllNotes delay:0.5f];
    

    
}


- (IBAction)stopSound:(id)sender {
    
    _playingArpeggio = NO;
    
    // Turn the last lit up finger red
    [self lightFinger:lastNoteIndex forColour:1 inPitchAccuracy:0];
    
    if (pitchDetectionStarted == true) {
        [stopStartPitchSwitch setOn:YES animated:YES];
        [audioManager startAudio];
    }
}

- (IBAction)unwindToViewController:(UIStoryboardSegue *)unwindSegue
{
    
    // This is called when a new scale has been selected
    
    ScaleSelectorViewController *scaleSelectionVC = unwindSegue.sourceViewController;

    [self loadScale:scaleSelectionVC.selectedScale];
    
    
}


- (BOOL) lightFinger:(int)noteIndex forColour:(int)colour inPitchAccuracy:(int)pitchAccuracy
{
  
    int currentNote;
    BOOL noteIsInScale = false;
    int string;
    int position;
    int positionIndex;
    
    // Lights up a finger with the desired colour
    
    
    UIImage *image;
    UIImageView *positionImage;
    
    switch (colour) {
        case 1:
            image = [UIImage imageNamed:@"note_red.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"note_amber.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"note_green.png"];
            break;
            
            
    }
    
    // Find out of the note is present in the current scale by looking up in the array
    
    for (int i=0; i<[scaleNotes count]; i++)
    {
        
        currentNote = [[scaleNotes objectAtIndex:i] intValue];
        
        
        if (currentNote == noteIndex)
        {
            
            noteIsInScale = true;
            
            // Look up string and position
            
            string = [[[scaleData objectAtIndex:i]objectForKey:@"string"]intValue];
            position = [[[scaleData objectAtIndex:i]objectForKey:@"position"]intValue];
            
            // Calculate relative position
            // There are 31 positions
            
            positionIndex = position + ((string - 1)*(numberOfPositions-1));
            
            // Light up the appropriate position
            
            positionImage = [noteImages objectAtIndex:positionIndex];
            positionImage.image = image;
            
            // Now get the coordinates on the screen
            
            CGPoint pos = positionImage.center;
            
            // Place a sharp or flat image above or below
            
            CGRect Rect;
            UIImageView *newImage;
            
         // Creates an indicator next to the finger position to indicate whether note is flat or sharp
            
            // Remove previous pitch indicator
            
            for (UIView *subview in [self.view subviews]) {
                if (subview.tag == 1) {
                    [subview removeFromSuperview];
                }
            }
            
            switch (pitchAccuracy)
            {
                case 1: // Sharp
                    Rect = CGRectMake(pos.x-15, pos.y-0, 30, 30);
                    newImage = [[UIImageView alloc] initWithFrame:Rect];
                    newImage.image = [UIImage imageNamed:@"note_clear.png"];
                    newImage.tag = 1;
                    [self.view addSubview:newImage];
                    break;

                
                case -1:   // Flat
                     // Arrow above the dot
                    Rect = CGRectMake(pos.x-15, pos.y-30, 30, 30);
                    newImage = [[UIImageView alloc] initWithFrame:Rect];
                    newImage.image = [UIImage imageNamed:@"note_clear.png"];
                    newImage.tag = 1;
                    [self.view addSubview:newImage];
                    break;
                    
                default:
                
                    // In tune - Get rid of images
                    break;
            }
            
            }
          
        }
        
    
    
    
    return noteIsInScale;

} //method

- (void)loadScale :(NSString*)scale
{
    
    
    // Clear the labels
    
    frequencyIndexLabel.text = nil;
    noteLabel.text = nil;
    octaveLabel.text = nil;
    freqLabel.text = nil;
    variationLabel.text = nil;
    accuracyLabel.text = nil;

    
    // Set up the UI objects (positions and fingerings)

 

    UILabel *currentFingerLabel;
    UIImageView *currentNoteImage;

    
    // Initialise the notes (positions) and fingerings
    
    for (int i=0; i<[fingerLabels count]; i++)
    {
        
        currentFingerLabel = [fingerLabels objectAtIndex:i];
        currentFingerLabel.text = @" ";
        currentFingerLabel.backgroundColor = [UIColor clearColor];
        
        currentNoteImage = [noteImages objectAtIndex:i];
       currentNoteImage.image = [UIImage imageNamed:@"note_clear.png"];
        
        
    }
    
    
// Load scale from Plist
    
    NSString *myListPath = [[NSBundle mainBundle] pathForResource:scale ofType:@"plist"];
    
  //  scaleData = Nil;
    
    scaleData = [[NSArray alloc]initWithContentsOfFile:myListPath];
    
    currentScale.text = scale;
    
    // Create fingering from scales array
    
    int finger;
    int string;
    int position;
    int note;
    NSString *direction;
    NSString *strFinger;
    UILabel *currentLabel;
    
    // Create the array that holds all of the note numbers for the scale
    
    scaleNotes = [[NSMutableArray alloc] init];
    int positionIndex;
    
    for(int i = 0; i<[scaleData count]; i++)
    {
        finger = [[[scaleData objectAtIndex:i]objectForKey:@"finger"]intValue];
        string = [[[scaleData objectAtIndex:i]objectForKey:@"string"]intValue];
        position = [[[scaleData objectAtIndex:i]objectForKey:@"position"]intValue];
        strFinger = [NSString stringWithFormat:@"%d", finger];
        direction = [[scaleData objectAtIndex:i]objectForKey:@"direction"];
        
        // Calculate relative position
        
        positionIndex = position + ((string - 1) * (numberOfPositions-1));
        
        // Calculate the note corresponding to the string and position
        
        if ([[currentScale.text substringToIndex:5] isEqual:@"Viola"])
            {
                note = 29 + position + ((string)*7);
                instrument.text = @"Viola";
            }
        else if ([[currentScale.text substringToIndex:11] isEqual:@"Double Bass"])
        {
        
            note = -1 + position + ((string)*5);
            instrument.text = @"Double Bass";
        }
        else
        {
            
            note = 17 + position + ((string)*7);
            instrument.text = @"Cello";
        }
        
 //      note = 17 + position + ((string)*7);
               
        

        // Add the number to an Array - this enables the correct position to be lit up
       
        [scaleNotes insertObject:[NSNumber numberWithInteger: note] atIndex:i];
        
        // Change label colour if up or down
        
        currentLabel = [fingerLabels objectAtIndex:positionIndex];
        currentLabel.text = strFinger;
        currentNoteImage = [noteImages objectAtIndex:positionIndex];
        currentNoteImage.image = [UIImage imageNamed:@"note_red.png"];
        
        if ([direction isEqual: @"U"]) {
            currentLabel.backgroundColor = [UIColor yellowColor];}
            else {
                if([direction isEqual: @"D"]){
                    currentLabel.backgroundColor = [UIColor greenColor];}
                else {
                    currentLabel.backgroundColor = [UIColor clearColor];}
                }
        
        
    } //loop
   
    
}



- (IBAction)stopStartPitch:(id)sender {
    
    // Stop or start the pitch recognition
    
    
    
    if (pitchDetectionStarted == true){
        
        [audioManager stopAudio];
        pitchDetectionStarted = false;
        
    }
    
    else
    {
        
        [audioManager startAudio];
        pitchDetectionStarted = true;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _playingArpeggio = NO;
    
    // Create the player and tell it which sound bank to use.
    _soundBankPlayer = [[SoundBankPlayer alloc] init];
    [_soundBankPlayer setSoundBank:@"Piano"];
    
    // We use a timer to play arpeggios.
    [self startTimer];

    
 //   mainViewController = self;
    
    // Load the screen
    
    numberOfPositions = 18;
    
    int wImage = 30, hImage = 30, wLabel= 11, hLabel= 21;
    int yStart = 34;
    int yOffset = 4; // Offset between label and image y coordinates
    int yGapStart = 70; // Gap between positions
    int yGap;
    int xGap = 26; // Gap between strings
    int xStart = 134;
    int xOffset = 10; // Offset between label and image x coordinates
    int xLabel,yLabel;
    int xImage,yImage;
    int positionIndex;
    
    
    
    xImage = xStart-xOffset;
    xLabel = xStart;
    
    CGRect Rect;
    UILabel *newLabel;
    UIImageView *newImage;
    
    fingerLabels = [[NSMutableArray alloc] init];
    noteImages = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<4; i++)
        
    {
        // Set the y offset to the start point
        yGap = yGapStart;
        yLabel = yStart;
        yImage = yStart-yOffset;
        
        for (int j=0; j<numberOfPositions; j++) {
            
            Rect = CGRectMake(xImage, yImage, wImage, hImage);
            newImage = [[UIImageView alloc] initWithFrame:Rect];
            newImage.image = [UIImage imageNamed:@"note_clear.png"];
            [self.view addSubview:newImage];
            
            Rect = CGRectMake(xLabel, yLabel, wLabel, hLabel);
            newLabel = [[UILabel alloc] initWithFrame:Rect];
            newLabel.text = @"X";
            [self.view addSubview:newLabel];
            
            positionIndex = (i*(numberOfPositions-1))+j;
            
            [fingerLabels insertObject:newLabel atIndex:positionIndex];
            [noteImages insertObject:newImage atIndex:positionIndex];
            
            yImage = yImage + yGap;
            yLabel = yLabel + yGap;
            
            yGap = yGap - (yGap*.02);
            
            // Splay out the positions further down the fingerboard
            
            switch (i) {
                case 0:
                    xLabel = xLabel - (xLabel*.005);
                    xImage = xLabel - xOffset;
                    break;
                case 1:
                    break;
                case 2:
                    xLabel = xLabel + (xLabel*.006);
                    xImage = xLabel - xOffset;
                    break;
                case 3:
                    xLabel = xLabel + (xLabel*.00925);
                    xImage = xLabel - xOffset;
                    break;
                default:
                    break;
            }
            
            
        }
        
        xImage = (xStart- xOffset) + (xGap * (i+1));
        xLabel = xStart  + (xGap * (i+1));
        
    }

   // Start the pitch recognition
    
    audioManager = [[AudioController alloc] init];
    audioManager.delegate = self;
    autoCorrelator = [[PitchDetector alloc] initWithSampleRate:audioManager.audioFormat.mSampleRate lowBoundFreq:30 hiBoundFreq:4500 andDelegate:self];
    
    medianPitchFollow = [[NSMutableArray alloc] initWithCapacity:22];
    
    [audioManager startAudio];
    
    pitchDetectionStarted = true;

    
    // Load up all the note frequencies (convert to Plist later)
    
    frequencies = [NSArray arrayWithObjects:
        @16.352 ,
        @17.324 ,
        @18.354 ,
        @19.445 ,
        @20.602 ,
        @21.827 ,
        @23.125 ,
        @24.500 ,
        @25.957 ,
        @27.500 ,
        @29.135 ,
        @30.868 ,
        @32.703 ,
        @34.648 ,
        @36.708 ,
        @38.891 ,
        @41.203 ,
        @43.654 ,
        @46.249 ,
        @48.999 ,
        @51.913 ,
        @55.000 ,
        @58.270 ,
        @61.735 ,
        @65.406 ,
        @69.296 ,
        @73.416 ,
        @77.782 ,
        @82.407 ,
        @87.307 ,
        @92.499 ,
        @97.999 ,
        @103.83 ,
        @110.00 ,
        @116.54 ,
        @123.47 ,
        @130.81 ,
        @138.59 ,
        @146.83 ,
        @155.56 ,
        @164.81 ,
        @174.61 ,
        @185.00 ,
        @196.00 ,
        @207.65 ,
        @220.00 ,
        @233.08 ,
        @246.94 ,
        @261.63 ,
        @277.18 ,
        @293.66 ,
        @311.13 ,
        @329.63 ,
        @349.23 ,
        @369.99 ,
        @392.00 ,
        @415.30 ,
        @440.00 ,
        @466.16 ,
        @493.88 ,
        @523.25 ,
        @554.37 ,
        @587.33 ,
        @622.25 ,
        @659.26 ,
        @698.46 ,
        @739.99 ,
        @783.99 ,
        @830.61 ,
        @880.00 ,
        @932.33 ,
        @987.77 ,
        @1046.5 ,
        @1108.7 ,
        @1174.7 ,
        @1244.5 ,
        @1318.5 ,
        @1396.9 ,
        @1480.0 ,
        @1568.0 ,
        @1661.2 ,
        @1760.0 ,
        @1864.7 ,
        @1975.5 ,
        @2093.0 ,
        @2217.5 ,
        @2349.3 ,
        @2489.0 ,
        @2637.0 ,
        @2793.8 ,
        @2960.0 ,
        @3136.0 ,
        @3322.4 ,
        @3520.0 ,
        @3729.3 ,
        @3951.1 ,
        @4186.0 ,
        @4434.9 ,
        @4698.6 ,
        @4978.0 ,
        @5274.0 ,
        @5587.7 ,
        @5919.9 ,
        @6271.9 ,
        @6644.9 ,
        @7040.0 ,
        @7458.6 ,
        @7902.1 ,
        @8372.0 ,
        @8869.8 ,
        @9397.3 ,
        @9956.1 ,
        @10548.1 ,
        @11175.3 ,
        @11839.8 ,
        @12543.9 ,
        @13289.8 ,
        @14080 ,
        @14917.2 ,
        @15804.3 ,
        @16744.0 ,
        @17739.7 ,
        @18794.5 ,
        @19912.1 ,
        @21096.2 ,
        @22350.6 ,
        @23679.6 ,
        @25087.7 ,
        @26579.5 ,
        @28160 ,
        @29834.5 ,
                   @31608.5, nil];
    
    
    // Load up all the octaves (convert to PLIST later)
    
    octaves = [NSArray arrayWithObjects:
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @0,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @1,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @2,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @3,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @4,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @5,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @6,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @7,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @8,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @9,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10,
    @10, nil];
    
    // Load up the note names
    
    notes = [NSArray arrayWithObjects:
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",
             @"C",
             @"C♯/D♭",
             @"D",
             @"E♭/D♯",
             @"E",
             @"F",
             @"F♯/G♭",
             @"G",
             @"A♭/G♯",
             @"A",
             @"B♭/A♯",
             @"B",nil];
    
    
    // Load the initial scale
   
    instrument.text = @"Cello";
    [self loadScale:@"Scale C Major - 3 Octaves"];
    
    // Set up to get Mic Volume
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
    
    NSError* error = nil;
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    recorder.meteringEnabled = YES;
    
    [recorder record];
   
}

- (void)viewDidUnload
{
    noteLabel = nil;
    frequencyIndexLabel = nil;
    octaveLabel = nil;
    accuracyLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) updatedPitch:(float)frequency {
    
    double value = frequency;
    

    
 /*
    //############ DATA SMOOTHING ###############
    //###     The following code averages previous values  ##
    //###  received by the pitch follower by using a             ##
    //###  median filter. Provides sub cent precision!          ##
    //#############################################

    NSNumber *nsnum = [NSNumber numberWithDouble:value];
    [medianPitchFollow insertObject:nsnum atIndex:0];

    if(medianPitchFollow.count>22) {
            [medianPitchFollow removeObjectAtIndex:medianPitchFollow.count-1];
        }
        double median = 0;
    
    
    
        if(medianPitchFollow.count>=2) {
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            NSMutableArray *tempSort = [NSMutableArray arrayWithArray:medianPitchFollow];
            [tempSort sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
            
            if(tempSort.count%2==0) {
                double first = 0, second = 0;
                first = [[tempSort objectAtIndex:tempSort.count/2-1] doubleValue];
                second = [[tempSort objectAtIndex:tempSort.count/2] doubleValue];
                median = (first+second)/2;
                value = median;
            } else {
                median = [[tempSort objectAtIndex:tempSort.count/2] doubleValue];
                value = median;
            }
            
            [tempSort removeAllObjects];
            tempSort = nil;
        }
    
        freqLabel.text = [NSString stringWithFormat:@"%3.1f Hz", value];
    */

    
    double currentFrequency = value;
    double pitchAbove=0;
    double pitchBelow=0;
    BOOL isNoteInScale = false;
    
    // Turn the last lit up finger red
    [self lightFinger:lastNoteIndex forColour:1 inPitchAccuracy:0];
    
    
// Get the volume and only update if over number of decibels
    
    // Record the mike volume
    
    [recorder updateMeters];
    decibels = [recorder averagePowerForChannel:0];
    decibelsLabel.text = [NSString stringWithFormat:@"%f", decibels];
    
    if (decibels > -30){
    
    
    
// Find the index of the note whose pitch is above the input pitch
    int noteAboveIndex = 0; 
    
    for (int i=0; i<[frequencies count]; i++)
         {

            pitchAbove = [[frequencies objectAtIndex:i] doubleValue];
            if (pitchAbove > currentFrequency)
            {
                
                noteAboveIndex = i;
                break;
            }
             
         }
    
    // Get the pitch below
    
    int noteBelowIndex = noteAboveIndex - 1;
 

    if (noteAboveIndex-1 >= 0) {
        pitchBelow = [[frequencies objectAtIndex:noteBelowIndex] doubleValue];
    } else {
        pitchBelow = 0;
    }
    
    
    double nearestPitch;
    int noteIndex;
    Boolean sharp = '\0';
  
    
    if ((pitchAbove - currentFrequency) > abs(pitchBelow - currentFrequency)) {
        nearestPitch = pitchBelow;
        noteIndex = noteBelowIndex;
        sharp = true;
    } else {
        nearestPitch = pitchAbove;
        noteIndex = noteAboveIndex;
        sharp = false;
    }
    

    
    double pitchDifference = abs(currentFrequency - nearestPitch);
    

        int pitchIndX = 297;
        int pitchIndY = 0;
        int pitchIndL =  // Pitch indicator bar length
        
        pitchIndL = @(pitchDifference).intValue * 10;
        if (pitchIndL > 50) {
            pitchIndL = 50;
        }
    
    if (pitchDifference < 1) {
        accuracyLabel.text = @"IN TUNE";
        accuracyLabel.textColor = [UIColor greenColor];
        pitchIndicatorLabel.image = [UIImage imageNamed:@"note_green.png"];
        // Finger is green if in tune
        isNoteInScale= [self lightFinger:noteIndex forColour:3 inPitchAccuracy:0];
        }
     else
        {
        if (sharp)
            {
            accuracyLabel.text = @"SHARP";
            accuracyLabel.textColor = [UIColor redColor];
            pitchIndicatorLabel.image = [UIImage imageNamed:@"note_amber.png"];
                // Finger is amber
            isNoteInScale= [self lightFinger:noteIndex forColour:2 inPitchAccuracy:1];
            pitchIndY = 395;
            pitchIndY = pitchIndY - pitchIndL;

            }
         else
            {
            accuracyLabel.text = @"FLAT";
            accuracyLabel.textColor = [UIColor redColor];
            pitchIndicatorLabel.image = [UIImage imageNamed:@"note_amber.png"];
                  // Finger is amber
            isNoteInScale= [self lightFinger:noteIndex forColour:2 inPitchAccuracy:-1];
            pitchIndY = 438;
            
    
        }

        }

    frequencyIndexLabel.text = [NSString stringWithFormat:@"%i", noteIndex];
    noteLabel.text = [notes objectAtIndex:noteIndex];
    octaveLabel.text = [NSString stringWithFormat:@"%i", [[octaves objectAtIndex:noteIndex] intValue]];
    freqLabel.text = [NSString stringWithFormat:@"%3.1f Hz", value];
    variationLabel.text = [NSString stringWithFormat:@"%3.1f Hz", pitchDifference];
        
        
    // Display the pitch indicator bars
        
        
        if (pitchIndL > 50) {
            pitchIndL = 50;
        }
        
    
        [currentPitchIndicatorLabel removeFromSuperview];
        currentPitchIndicatorLabel = nil;
        
        CGRect Rect = CGRectMake(pitchIndX, pitchIndY, 10, pitchIndL);
        currentPitchIndicatorLabel = [[UILabel alloc] initWithFrame:Rect];
        currentPitchIndicatorLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:currentPitchIndicatorLabel];
    
        
    
    // Note was in scale so store last note index
    
    if (isNoteInScale) {

        lastNoteIndex = noteIndex;
        
    }
    }
    
    else {
        
        frequencyIndexLabel.text = @" ";
        noteLabel.text = @" ";
        octaveLabel.text = @" ";
        freqLabel.text = @" ";
        variationLabel.text = @" ";
        accuracyLabel.text = @" ";
        pitchIndicatorLabel.image = [UIImage imageNamed:@"note_red.png"];
        [currentPitchIndicatorLabel removeFromSuperview];
        currentPitchIndicatorLabel = nil;
        
    }

    
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return scaleList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [scaleList objectAtIndex:row];
}

- (void) receivedAudioSamples:(SInt16 *)samples length:(int)len {
    [autoCorrelator addSamples:samples inNumberFrames:len];
   free(samples);
}

- (void)playArpeggioWithNotes:(NSArray *)arpNotes delay:(CFTimeInterval)delay
{
	if (!_playingArpeggio)
	{
		_playingArpeggio = YES;
		_arpeggioNotes = [arpNotes copy];
		_arpeggioIndex = 0;
		_arpeggioDelay = delay;
		_arpeggioStartTime = CACurrentMediaTime();
	}
}


- (void)startTimer
{
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.05f  // 50 ms
											  target:self
										    selector:@selector(handleTimer:)
										    userInfo:nil
											 repeats:YES];
}

- (void)stopTimer
{
	if (_timer != nil && [_timer isValid])
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)handleTimer:(NSTimer *)timer
{
	if (_playingArpeggio)
	{
		// Play each note of the arpeggio after "arpeggioDelay" seconds.
		CFTimeInterval now = CACurrentMediaTime();
		if (now - _arpeggioStartTime >= _arpeggioDelay)
		{
			NSNumber *number = _arpeggioNotes[_arpeggioIndex];
			[_soundBankPlayer noteOn:[number intValue] gain:1.0f];
            
            // Turn the last lit up finger red
            [self lightFinger:lastNoteIndex forColour:1 inPitchAccuracy:0];
            
            // Light up the note playing green
            [self lightFinger:[number intValue] forColour:3 inPitchAccuracy:0];
            lastNoteIndex = [number intValue];
            
			_arpeggioIndex += 1;
			if (_arpeggioIndex == [_arpeggioNotes count])
			{
				_playingArpeggio = NO;
				_arpeggioNotes = nil;
                
                
                // The scale has finished playing - swiwtch on pitch detection if set originally
                
                if (pitchDetectionStarted == true) {
                [stopStartPitchSwitch setOn:YES animated:YES];
                [audioManager startAudio];
                }
                
                
			}
			else  // schedule next note
			{
				_arpeggioStartTime = now;
			}
		}
	}
}

    

@end
