//
//  ScaleSelectViewController.h
//  Scales Trainer
//
//  Created by Alec Hoffman on 27/02/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesTrainerCommon.h"

@interface ScaleSelectViewController : UIViewController
<UITableViewDataSource , UITableViewDelegate, UIAlertViewDelegate>

{
    
NSMutableArray *scales;
    
ScalesTrainerCommon *myScalesTrainerCommon;
    

    
}

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) NSString *selectedScale;


@property (strong, nonatomic) NSString *selectedGroup;

@property (weak, nonatomic) IBOutlet UITableView *groupScaleTableView;

@end
