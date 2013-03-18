//
//  SelectErrorCode.m
//  faultguide
//
//  Created by Sudeep Talati on 24/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "SelectErrorCode.h"
#import "DbHelper.h"

#import "DetailViewController.h"
#import "SelectBrandForDP.h"
#import "FaultDetails.h"

@interface SelectErrorCode ()

@end

@implementation SelectErrorCode

@synthesize errorCodeList=_errorCodeList;
@synthesize brandId=_brandId;
@synthesize seriesId=_seriesId;
@synthesize seriesName=_seriesName;
@synthesize brandName=_brandName;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog (@"I reached in select errorcode Series Name is: %@ and series Id is %@ and Brand id is %@",self.seriesName,self.seriesId,self.brandId);
    self.title = self.seriesName;
    
    
    self.errorCodeList=[[DbHelper database] faultListOfBrandId:self.brandId SeriesId:self.seriesId];
    
    
   
}///end of view did load

-(void) viewWillAppear : (BOOL)animated
{
    int diagnosticProcedureAvailable=[[DbHelper database] isDiagnosticProcedureAvailableForSeriesId:self.seriesId];
    if (diagnosticProcedureAvailable==1)
    {
        /*self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Diagonostic Procedures " style:UIBarButtonItemStyleBordered target:self action:@selector(topBarRightButtonTapped:)];
         */
        NSLog(@"########Diagonostic Procedures are availabe for this series");
        
        //self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController setToolbarHidden:NO];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *dpToolbarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Diagonostic Procedures are availabe for this series" style:UIBarButtonItemStyleBordered target:self action:@selector(dpBtnTapped)];
        [barItems addObject:dpToolbarBtn];
        
        
        [self setToolbarItems:barItems];
        
    }//    if (diagnosticProcedureAvailable==1)
    

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
    // Return the number of rows in the section.
    return [self.errorCodeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
/*    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  */  
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 

    
    // Configure the cell...
    FaultDetails *faultDetails=[self.errorCodeList objectAtIndex:indexPath.row];
    
    cell.textLabel.text=faultDetails.displayCode;
    cell.detailTextLabel.text = faultDetails.summary;
    
    
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
    [self performSegueWithIdentifier:@"showErrorcodeDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier  );
    if ([segue.identifier isEqualToString:@"showErrorcodeDetails"])
    {
        NSLog(@"prepareForSegue: %@", segue.identifier  );
        // Pass any objects to the view controller here, like...
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FaultDetails *faultDetails = [self.errorCodeList objectAtIndex:indexPath.row];
        
        //[[segue destinationViewController] setFaultDetails:faultDetails];
        [[segue destinationViewController] setBrandName:self.brandName];
        [[segue destinationViewController] setSeriesName:self.seriesName];
        
        
        DetailViewController *vc = [segue destinationViewController];
        [vc setFaultDetails:faultDetails];
        
    }
    
    if ([segue.identifier isEqualToString:@"showDiagnosticProcedure"])
    {
        NSLog(@"showDiagnosticProcedure prepareForSegue: %@", segue.identifier  );
        // Pass any objects to the view controller here, like...
        
        [[segue destinationViewController] setSeries_id_for_dp:self.seriesId];

        
    }
    
    
    
}



- (void)topBarRightButtonTapped:(id)sender {
   
    NSLog(@" Diagonstic Tapped");
    
     [self performSegueWithIdentifier:@"showDiagnosticProcedure" sender:self];
}

- (void) dpBtnTapped{

    NSLog(@" DP button Tapped");
    [self performSegueWithIdentifier:@"showDiagnosticProcedure" sender:self];

}

@end
