//
//  ScalesTrainerCommon.h
//  Scales Trainer
//
//  Created by Alec Hoffman on 04/03/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScalesTrainerCommon : NSObject {

NSString *someProperty;
}

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;
- (NSString *)getScaleName:(NSString *)scaleMnemonic;


@end
