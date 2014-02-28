//
//  ScaleSelectViewController.h
//  Scales Trainer
//
//  Created by Alec Hoffman on 27/02/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleSelectViewController : UIViewController
<UITableViewDataSource , UITableViewDelegate>

{
    
    // NSDictionary *scales;
    NSArray *scales;
    NSArray *groups;
    
}

@property (strong, nonatomic) NSString *selectedScale;


@end
