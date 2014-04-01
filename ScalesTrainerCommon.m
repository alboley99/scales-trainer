//
//  ScalesTrainerCommon.m
//  Scales Trainer
//
//  Created by Alec Hoffman on 04/03/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import "ScalesTrainerCommon.h"

@implementation ScalesTrainerCommon

@synthesize someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static ScalesTrainerCommon *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (NSString *)getScaleName:(NSString *)scaleMnemonic
{
    
    // Create Scale Name from Mnemonic
    
    //           NSString *scaleType = [scaleMnemonic substringToIndex:3];
    
    NSString *scaleName = @"";
    NSString *scaleType = [scaleMnemonic substringWithRange:NSMakeRange(0, 3)];
    NSString *scaleTonic = [scaleMnemonic substringWithRange:NSMakeRange(3, 1)];
    NSString *scaleTonicAccidental = [scaleMnemonic substringWithRange:NSMakeRange(4, 1)];
    NSString *scaleTonicOctave = [scaleMnemonic substringWithRange:NSMakeRange(5, 2)];
    NSString *scaleNoOfOctaves = [scaleMnemonic substringWithRange:NSMakeRange(7, 1)];
    
    
    // Scale Type
    
    if ([scaleType  isEqual: @"MAJ"] || [scaleType  isEqual: @"MIH"] || [scaleType  isEqual: @"MIM"])
    {
        scaleName = @"Scale -";
    }
    else if ([scaleType  isEqual: @"AMA"])
    {
        scaleName = @"Arpeggio -";
    }
    else if ([scaleType  isEqual: @"DO7"])
    {
        scaleName = @"Dominant 7th -";
    }
    else if ([scaleType  isEqual: @"DI7"])
    {
        scaleName = @"Diminished 7th -";
    }
    
    
    // Tonic
    
    if ([scaleType  isEqual: @"MAJ"] || [scaleType  isEqual: @"MIH"] || [scaleType  isEqual: @"MIM"] || [scaleType  isEqual: @"AMA"])
    {
        scaleName =  [scaleName stringByAppendingString:@" "];
        scaleName =  [scaleName stringByAppendingString:scaleTonic];
    }
    else if ([scaleType  isEqual: @"DO7"])
    {
        scaleName =  [scaleName stringByAppendingString:@" In the key of "];
        scaleName =  [scaleName stringByAppendingString:scaleTonic];
    }
    else if ([scaleType  isEqual: @"DI7"])
    {
        scaleName =  [scaleName stringByAppendingString:@" Starting on "];
        scaleName =  [scaleName stringByAppendingString:scaleTonic];
    }
    
    
    // Tonic Accidental
    if ([scaleTonicAccidental isEqual: @"F"])
    {
        scaleName =  [scaleName stringByAppendingString:@"♭"];
    }
    else if ([scaleTonicAccidental isEqual: @"F"])
    {
        scaleName =  [scaleName stringByAppendingString:@"#"];
    }
    
    // Major or Minor
    if ([scaleType  isEqual: @"MAJ"] || [scaleType  isEqual: @"AMA"])
    {
        scaleName =  [scaleName stringByAppendingString:@" Major"];
        
    }
    else if ([scaleType  isEqual: @"MIH"] )
    {
        scaleName =  [scaleName stringByAppendingString:@" Minor Harmonic"];
        
    }
    else if ([scaleType  isEqual: @"MIM"] )
    {
        scaleName =  [scaleName stringByAppendingString:@" Minor Melodic"];
        
    }
    
    // Octaves
    
    scaleName =  [scaleName stringByAppendingString:@" - "];
    scaleName =  [scaleName stringByAppendingString:scaleNoOfOctaves];
    scaleName =  [scaleName stringByAppendingString:@" Octaves"];
    
    // Starting Octave
    
    scaleName =  [scaleName stringByAppendingString:@" ("];
    scaleName =  [scaleName stringByAppendingString:scaleTonicOctave];
    scaleName =  [scaleName stringByAppendingString:@")"];
    
    
    return scaleName;
    
}


@end
