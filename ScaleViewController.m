//
//  ScaleViewController.m
//  Scales Trainer
//
//  Created by Alec Hoffman on 03/03/2014.
//  Copyright (c) 2014 Alec Hoffman. All rights reserved.
//

#import "ScaleViewController.h"
#import "ScalesTrainerCommon.h"


@interface ScaleViewController ()

@end

@implementation ScaleViewController

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
    
    NSString *myListPath = [[NSBundle mainBundle] pathForResource:@"Scale" ofType:@"plist"];
    scales = [[NSArray alloc]initWithContentsOfFile:myListPath];
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

        
    return 1;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return [scales count];
   
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section


{
  
        return @"Add Scales";

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScaleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    int section = indexPath.section;
    int row = indexPath.row;
    
    
    NSDictionary *scale = [scales objectAtIndex:row];
    
    ScalesTrainerCommon *MyScalesTrainerCommon = [ScalesTrainerCommon sharedManager];
    cell.textLabel.text = [MyScalesTrainerCommon getScaleName:scale[@"ScaleMnemonic"]];
    return cell;
    
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For now just send back the selected text
        
        
 //   UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//        self.selectedScale = selectedCell.textLabel.text;
    
    
 //       [self performSegueWithIdentifier:@"unwindToViewController" sender:self];
        
    }
    

- (IBAction)addScalesButtonPressed:(id)sender {
    
    NSArray *selectedScalesIndexes = [self.scalesTableView indexPathsForSelectedRows];
    
    self.selectedScales = [[NSMutableArray alloc] init];
    
    // Create an array of selected scale mnemonics
    
    for (int i =0 ;i <[selectedScalesIndexes count];i++)
    {
        NSIndexPath *currentIndex = [selectedScalesIndexes objectAtIndex:i];
        int row = currentIndex.row;
        NSDictionary *scale = [scales objectAtIndex:row];
        self.selectedScales[i] = scale[@"ScaleMnemonic"];
        
    }

     [self performSegueWithIdentifier:@"unwindToScaleSelect" sender:self];
}


@end
