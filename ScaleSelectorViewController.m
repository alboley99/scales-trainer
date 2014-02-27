//
//  ScaleSelectorViewController.m
//  Autocorrelation
//
//  Created by Alec Hoffman on 19/09/2013.
//  Copyright (c) 2013 New York University. All rights reserved.
//

#import "ScaleSelectorViewController.h"

@interface ScaleSelectorViewController ()

@end

@implementation ScaleSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *myListPath = [[NSBundle mainBundle] pathForResource:@"ScalesList" ofType:@"plist"];
 //   scales = [[NSDictionary alloc]initWithContentsOfFile:myListPath];
    scales = [[NSArray alloc]initWithContentsOfFile:myListPath];
 //   NSLog(@" count = %d",[scales count]);
    
    CGRect titleRect = CGRectMake(0, 0, 300, 70);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textAlignment = NSTextAlignmentCenter;
    tableTitle.textColor = [UIColor blackColor];
    tableTitle.backgroundColor = [self.tableView backgroundColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:24];
    tableTitle.text = @"Select the scale you want to practice";
    self.tableView.tableHeaderView = tableTitle;
    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [scales count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
 // 	NSString *scaleSection = [self tableView:tableView titleForHeaderInSection:section];
	// return [[scales valueForKey:scaleSection] count];
    
    return [[[scales objectAtIndex:section]objectForKey:@"scales"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section


{

    
    return [[scales objectAtIndex:section]objectForKey:@"scalegroup"];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScaleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int section = indexPath.section;
    int row = indexPath.row;

//   NSString *scaleGroup = [self tableView:tableView titleForHeaderInSection:indexPath.section];
//	NSString *scale = [[scales valueForKey:scaleGroup] objectAtIndex:indexPath.row];
    
    
    NSString *scale = [[[scales objectAtIndex:section]objectForKey:@"scales"]objectAtIndex:row];
	
    cell.textLabel.text = scale;
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    self.selectedScale  = [[[scales objectAtIndex:section]objectForKey:@"scales"]objectAtIndex:row];
    
    
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
    
    
}

@end
