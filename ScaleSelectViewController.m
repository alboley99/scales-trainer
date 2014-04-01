//
//  ScaleSelectViewController.m
//  Scales Trainer
//
//  Created by Alec Hoffman on 27/02/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import "ScaleSelectViewController.h"
#import "ScaleViewController.h"
#import "ScalesTrainerCommon.h"


@interface ScaleSelectViewController ()

@end

@implementation ScaleSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    myScalesTrainerCommon = [ScalesTrainerCommon sharedManager];
    
   
    // Get Group Scales from documents area
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myListPath = [documentsDirectory stringByAppendingPathComponent:@"GroupScale.plist"];
    scales = [[NSMutableArray alloc]initWithContentsOfFile:myListPath];
    
    // ********
    
    CGRect titleRect = CGRectMake(0, 0, 300, 70);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textAlignment = NSTextAlignmentCenter;
    tableTitle.textColor = [UIColor blackColor];
//*    tableTitle.backgroundColor = [self.tableView backgroundColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:24];
    tableTitle.text = @"Select the scale you want to practice";
//*    self.tableView.tableHeaderView = tableTitle;
//*    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.selectedGroup = @"Alec Current";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // NB No sections in this table
    
    if (tableView.tag == 0)
    {

        return 1;
    }
    else
    {

           return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     if (tableView.tag == 0)
     {
        return [scales count];
     }
     else
     {
         
         for(int i =0 ;i <[scales count];i++)
         {
             
          
             NSDictionary *group = [scales objectAtIndex:i];
             NSString *groupName = group[@"GroupName"];
       
             
             if ([groupName  isEqual: self.selectedGroup])
             {
                 NSArray *scalesInGroup = group[@"Scales"];
                 return [scalesInGroup count];
             }
            
     }
         
     }
    
    return 0;
}

    
    


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section


{
//    return [[groups objectAtIndex:section]objectForKey:@"scalegroup"];
    
    if (tableView.tag == 0)
    {
        return @"Groups";
    }
    else
    {
    return @"Scales";
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScaleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    int section = indexPath.section;
    int row = indexPath.row;
    

    
    if (tableView.tag == 0)
    {
        

            NSDictionary *group = [scales objectAtIndex:row];
            cell.textLabel.text = group[@"GroupName"];
                
                // Default the row - TEMP
                
                if ([group[@"GroupName"]  isEqual: @"Alec Current"])
                {
                    [tableView
                     selectRowAtIndexPath:indexPath
                     animated:TRUE
                     scrollPosition:UITableViewScrollPositionNone
                     ];
                    
                    [[tableView delegate]
                     tableView:tableView
                     didSelectRowAtIndexPath:indexPath
                     ];
                }

                
            
        
        
        
    
    }
    else
    {
        
        
        for(int i =0 ;i <[scales count];i++)
        {
            NSDictionary *group = [scales objectAtIndex:i];
            NSString *groupName = group[@"GroupName"];
            
            
            if ([groupName isEqualToString:self.selectedGroup])
            {
                
                
                NSArray *scalesInGroup = group[@"Scales"];
                NSString *scaleMnemonic1 = [scalesInGroup objectAtIndex:row];
                cell.textLabel.text = [myScalesTrainerCommon getScaleName:scaleMnemonic1];
                
                cell.showsReorderControl = true;
                
                break;
                
                
                
            }
            
        }
        

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // Update the PLIST to reorder scales
    
    // Create array with scales for the seelcted group
    
    for(int i =0 ;i <[scales count];i++)
    {
        
        
        NSDictionary *group = [scales objectAtIndex:i];
        NSString *groupName = group[@"GroupName"];
        
        
        if ([groupName isEqualToString:self.selectedGroup])
        {
            
            NSMutableArray *newScales =  [group[@"Scales"] mutableCopy];

            
            [newScales removeObjectAtIndex:sourceIndexPath.row];
            [newScales insertObject:group atIndex:destinationIndexPath.row];
            
            // Update the scales for the group
            [group setValue:newScales forKey:@"Scales"];
            
            // Update the scales PLIST
            [scales replaceObjectAtIndex:i withObject:group];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *myListPath = [documentsDirectory stringByAppendingPathComponent:@"GroupScale.plist"];
            [scales writeToFile:myListPath atomically:YES];
         
            break;
            
        }
        
    }
    
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    int section = indexPath.section;
    int row = indexPath.row;
    
    if (tableView.tag == 0)
    {
        
        NSDictionary *group = [scales objectAtIndex:row];
        self.selectedGroup = group[@"GroupName"];
        
        
        // Now reload the scales
                
        UITableView *tableViewScales = (UITableView *)[self.view viewWithTag:1];
        [tableViewScales reloadData];
        
    }
    else
    {
        
        
    // DO NOTHING
        
  //      for(int i =0 ;i <[scales count];i++)
  //      {
   //         NSArray *groupScales = [scales objectAtIndex:i];
            
            // Group name is in first array element
            
  //          NSString *groupName = [groupScales objectAtIndex:0];
            
   //
// if ([groupName isEqualToString:self.selectedGroup])
    //        {
                
   //             NSDictionary *scale = [groupScales objectAtIndex:row+1];
    //            NSString *scaleMnemonic = scale[@"ScaleMnemonic"];
               
                
  //          }
            
  //      }
        
        
        // For now just send back the selected text
        
        
  //      UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
  //      self.selectedScale = selectedCell.textLabel.text;
        
    //     [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // User has requested a delete
        
        for(int i =0 ;i <[scales count];i++)
        {
            
            
            
            NSDictionary *group = [scales objectAtIndex:i];
            NSString *groupName = group[@"GroupName"];
            
            
            if ([groupName isEqualToString:self.selectedGroup])
            {
                
                NSMutableArray *newScales =  [group[@"Scales"] mutableCopy];
                [newScales removeObjectAtIndex:indexPath.row];
                
                // Update the scales for the group
                [group setValue:newScales forKey:@"Scales"];
                
                // Update the scales PLIST
                [scales replaceObjectAtIndex:i withObject:group];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *myListPath = [documentsDirectory stringByAppendingPathComponent:@"GroupScale.plist"];
                [scales writeToFile:myListPath atomically:YES];
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                
                break;
                
            }
            
        }
        
    }
}


- (IBAction)editScalesClicked:(id)sender {
    
    // Get the Scales UITableView
    
    UITableView *scalesTableView = (UITableView *)[self.view viewWithTag:1];
    [scalesTableView setEditing:true animated:true];

    
}
- (IBAction)newGroup:(id)sender {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Group" message:@"Please enter the group name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Enter the group name";
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *newGroupName = [[alertView textFieldAtIndex:0] text];
    
    NSArray *newScales = [NSArray arrayWithObjects:nil];
    
    NSDictionary *group = [[NSDictionary alloc] initWithObjectsAndKeys:
                          newGroupName, @"GroupName", @"NEW", @"GroupAttribute1", newScales, @"Scales",nil];
    
    NSMutableArray *newGroups =  [scales mutableCopy];
    [newGroups insertObject:group atIndex:0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myListPath = [documentsDirectory stringByAppendingPathComponent:@"GroupScale.plist"];
    [newGroups writeToFile:myListPath atomically:YES];
    
    scales = newGroups;
    [self.groupsTableView reloadData];

}

- (IBAction)unwindToScaleSelect:(UIStoryboardSegue *)unwindSegue
{
    
    // This is called when one or more new scales have been selected
    
    ScaleViewController *scaleVC = unwindSegue.sourceViewController;
    
    // Now update the pList with the added scales
    NSArray *selectedScales = scaleVC.selectedScales;
    
    
    // Find the current selected group
    
    for(int i =0 ;i <[scales count];i++)
    {
        
        
        
        NSDictionary *group = [scales objectAtIndex:i];
        NSString *groupName = group[@"GroupName"];
        
        
        
        if ([groupName isEqualToString:self.selectedGroup])
        {
        
            
            // Now add the new scales at the top of the list
            
            NSMutableArray *newScales =  [group[@"Scales"] mutableCopy];

            for(int j =[selectedScales count]-1 ;j >=0;j--)
            {
                
                NSString *scaleMnemonic = [selectedScales objectAtIndex:j];
                [newScales insertObject:scaleMnemonic atIndex:0];
            }
            
            
            // Update the scales for the group
            [group setValue:newScales forKey:@"Scales"];
            
            
            // Update the scales PLIST
            [scales replaceObjectAtIndex:i withObject:group];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *myListPath = [documentsDirectory stringByAppendingPathComponent:@"GroupScale.plist"];
            [scales writeToFile:myListPath atomically:YES];
            
            // Reload data
            
            
            [self.groupScaleTableView reloadData];
            
            break;
            
        }
        

        
    }
    

    
    
    
}


@end
