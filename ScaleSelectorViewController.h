//
//  ScaleSelectorViewController.h
//  Autocorrelation
//
//  Created by Alec Hoffman on 19/09/2013.
//  Copyright (c) 2013 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScaleSelectorViewController : UITableViewController
<UITableViewDataSource , UITableViewDelegate>

{

// NSDictionary *scales;
NSArray *scales;
    
}


@property (strong, nonatomic) NSString *selectedScale;


//

@end
