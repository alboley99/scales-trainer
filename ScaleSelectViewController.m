//
//  ScaleSelectViewController.m
//  Scales Trainer
//
//  Created by Alec Hoffman on 27/02/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import "ScaleSelectViewController.h"

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
    
    NSString *myListPath = [[NSBundle mainBundle] pathForResource:@"ScalesGroup" ofType:@"plist"];
    groups = [[NSArray alloc]initWithContentsOfFile:myListPath];
    
    myListPath = [[NSBundle mainBundle] pathForResource:@"ScalesList" ofType:@"plist"];
    scales = [[NSArray alloc]initWithContentsOfFile:myListPath];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView.tag == 0)
    {
        return [groups count];
    }
    else
    {
        NSString *scaleSection = @"Major Scales";
        return [[scales valueForKey:scaleSection] count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    
     if (tableView.tag == 0)
     {
        return [groups count];
     }
     else
     {
         NSString *scaleSection = @"Major Scales";
         return [[scales valueForKey:scaleSection] count];
     }
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section


{
//    return [[groups objectAtIndex:section]objectForKey:@"scalegroup"];
    
        return @"";
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScaleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int section = indexPath.section;
    int row = indexPath.row;
    

    
    

    
    if (tableView.tag == 0)
    {
        NSString *group = [groups objectAtIndex:row];
        cell.textLabel.text = group;
    }
    else
    {
        NSString *scale = [[[scales objectAtIndex:section]objectForKey:@"scales"]objectAtIndex:row];
        cell.textLabel.text = scale;
    }
    
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
    
    self.selectedScale  = [groups objectAtIndex:row];
    
    
    [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
    
    
}

@end
