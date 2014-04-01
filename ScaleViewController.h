//
//  ScaleViewController.h
//  Scales Trainer
//
//  Created by Alec Hoffman on 03/03/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesTrainerCommon.h"

@interface ScaleViewController : UIViewController
<UITableViewDataSource , UITableViewDelegate>

{
    
    NSArray *scales;
    ScalesTrainerCommon *myScalesTrainerCommon;

    
}

@property (weak, nonatomic) IBOutlet UITableView *scalesTableView;

@property (strong, nonatomic) NSMutableArray *selectedScales;




@end
