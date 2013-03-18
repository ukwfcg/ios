//
//  SelectBrandForDP.m
//  faultguide
//
//  Created by Sudeep Talati on 23/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import "SelectBrandForDP.h"
#import "DbHelper.h"

#import "DiagnosticProcedure.h"


@interface SelectBrandForDP ()

@end

@implementation SelectBrandForDP

@synthesize isFullDatabase=_isFullDatabase;
@synthesize testList=_testList;
@synthesize series_id_for_dp=_series_id_for_dp;

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
    
    
    
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subscriptions" style:UIBarButtonSystemItemAction target:self action:@selector(setTapped:)];
    
    self.testList=[[DbHelper database] diagonosticProceduresTestListForSeriesId:self.series_id_for_dp];
    
    self.title = @"Diagnostic Procedures";
    
    
    
    NSLog(@"------------- Seies id is %@",self.series_id_for_dp);
    
    self.isFullDatabase=[DbHelper database].getFullVersionStatus;
    
    if (self.isFullDatabase==0)
    {
        for(int i=0;i<[self.testList count];i++)
        {
            // NSLog(@"BRAND NAME IS : %@", [self.brandList objectAtIndex:i]);
            
            NSDictionary *cellData = [self.testList objectAtIndex:i];
            NSArray *allValuesArray=[cellData allValues];
            NSString *testId =[allValuesArray objectAtIndex:0];
            
            NSArray *allKeysArray=[cellData allKeys];
            NSString *testName =[allKeysArray objectAtIndex:0];
            
            if ([testId isEqualToString:@"18"] || [testId isEqualToString:@"35"] )
            {
                NSMutableArray *demoTestList = [[NSMutableArray alloc] init]  ;
                
                [demoTestList addObject:cellData];
                NSLog (@"Selected  is: %@ and brand Id is %@",testName,testId);
                //self.brandList = nil;
                self.testList=demoTestList;
                
            }
        }
    }
    
    
    
    
    


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}///end of view did load


-(void) viewWillAppear : (BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the
    
    return [self.testList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    // Configure the cell...
    //    NSString *cellData = [self.brandList objectAtIndex:indexPath.row];
    //    cell.textLabel.text =cellData;
    
    NSDictionary *cellData = [self.testList objectAtIndex:indexPath.row];
    
    NSArray *allKeysArray=[cellData allKeys];
    cell.textLabel.text =[allKeysArray objectAtIndex:0];
    
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
    [self performSegueWithIdentifier:@"showDiagnosticProcedure" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier  );
    if ([segue.identifier isEqualToString:@"showDiagnosticProcedure"])
    {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *cellData = [self.testList objectAtIndex:indexPath.row];
        
        NSArray *allValuesArray=[cellData allValues];
        NSString *testId =[allValuesArray objectAtIndex:0];
        
        NSArray *allKeysArray=[cellData allKeys];
        NSString *testName =[allKeysArray objectAtIndex:0];
        
        
        
        
        [[segue destinationViewController] setTestId:testId];
        [[segue destinationViewController] setTestName:testName];
        
        NSLog (@"Selected TEST PRocedure in Segued is: %@ and TEST Id is %@",testName,testId);
        
 
        
    }
}


@end
