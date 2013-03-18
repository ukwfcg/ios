//
//  SelectSeries.m
//  faultguide
//
//  Created by Sudeep Talati on 24/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "SelectSeries.h"
#import "DbHelper.h"
#import "SelectErrorCode.h"

@interface SelectSeries ()

@end

@implementation SelectSeries

@synthesize brandId=_brandId;
@synthesize brandName=_brandName;
@synthesize seriesList = _seriesList;



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
    
    NSLog (@"I reached in select Series brand is: %@ and brand Id is %@",self.brandName,self.brandId);
    self.title = self.brandName;
  
    self.seriesList=[[DbHelper database] seriesListOfBrandId:self.brandId];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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
    // Return the number of rows in the section.
    return  [self.seriesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    

    // Configure the cell...
    
    NSDictionary *cellData = [self.seriesList objectAtIndex:indexPath.row];
    
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
    [self performSegueWithIdentifier:@"showErrorcodes" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier  );
    if ([segue.identifier isEqualToString:@"showErrorcodes"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *cellData = [self.seriesList objectAtIndex:indexPath.row];

        NSArray *allValuesArray=[cellData allValues];
        NSString *seriesId =[allValuesArray objectAtIndex:0];
        
        NSArray *allKeysArray=[cellData allKeys];
        NSString *seriesName =[allKeysArray objectAtIndex:0];
        NSLog (@"Selected Brand in Segued is: %@ and brand Id is %@",seriesName,seriesId);
        
        [[segue destinationViewController] setBrandId:self.brandId];
        [[segue destinationViewController] setSeriesId:seriesId];
        [[segue destinationViewController] setSeriesName:seriesName];
        [[segue destinationViewController] setBrandName:self.brandName];
        
        
    }
}

@end
