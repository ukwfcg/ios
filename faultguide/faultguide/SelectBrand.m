//
//  SelectBrand.m
//  faultguide
//
//  Created by Sudeep Talati on 20/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "SelectBrand.h"
#import "DbHelper.h"
#import "SelectSeries.h"


@interface SelectBrand ()

@end

@implementation SelectBrand
@synthesize isFullDatabase=_isFullDatabase;
@synthesize brandList=_brandList;

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
}


-(void) viewWillAppear : (BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings " style:UIBarButtonItemStyleBordered target:self action:@selector(settingsTapped:)];
    
    
    
    self.brandList=[DbHelper database].brandList;
    
    self.title = @"Brand";
    
    self.isFullDatabase=[DbHelper database].getFullVersionStatus;
    
    if (self.isFullDatabase==0)
    {
        for(int i=0;i<[self.brandList count];i++)
        {
            // NSLog(@"BRAND NAME IS : %@", [self.brandList objectAtIndex:i]);
            
            NSDictionary *cellData = [self.brandList objectAtIndex:i];
            NSArray *allValuesArray=[cellData allValues];
            NSString *brandId =[allValuesArray objectAtIndex:0];
            
            NSArray *allKeysArray=[cellData allKeys];
            NSString *brandName =[allKeysArray objectAtIndex:0];
            
            if ([brandName isEqualToString:@"ISE"])
            {
                NSMutableArray *demoBrandList = [[NSMutableArray alloc] init]  ;
                
                [demoBrandList addObject:cellData];
                NSLog (@"Selected Brand in Segued is: %@ and brand Id is %@",brandName,brandId);
                //self.brandList = nil;
                self.brandList=demoBrandList;
                break;
            }
        }
    }
    
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
    // Return the number of rows in the section.
   // return 0;
    
     //return [self.brandList count];
    return [self.brandList count];
    
     
    
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
//    NSString *cellData = [self.brandList objectAtIndex:indexPath.row];
//    cell.textLabel.text =cellData;
    
    NSDictionary *cellData = [self.brandList objectAtIndex:indexPath.row];
    
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
    [self performSegueWithIdentifier:@"showSeries" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier  );
    if ([segue.identifier isEqualToString:@"showSeries"])
    {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      
        NSDictionary *cellData = [self.brandList objectAtIndex:indexPath.row];
        
        NSArray *allValuesArray=[cellData allValues];
        NSString *brandId =[allValuesArray objectAtIndex:0];
        
        NSArray *allKeysArray=[cellData allKeys];
        NSString *brandName =[allKeysArray objectAtIndex:0];
        NSLog (@"Selected Brand in Segued is: %@ and brand Id is %@",brandName,brandId);

        [[segue destinationViewController] setBrandId:brandId];
        [[segue destinationViewController] setBrandName:brandName];
 
    }
}


- (void)settingsTapped:(id)sender {
 
    [self performSegueWithIdentifier:@"settings" sender:self];
}
@end