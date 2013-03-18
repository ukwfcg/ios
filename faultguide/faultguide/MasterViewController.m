//
//  MasterViewController.m
//  faultguide
//
//  Created by Sudeep Talati on 19/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "ReceiptCheck.h"
#import "CrossCheckReceipt.h"
#import "DbHelper.h"
// 1
#import "FaultGuideIAPHelper.h"
#import <StoreKit/StoreKit.h>


@interface MasterViewController () {
    NSMutableArray *_objects;
      NSArray *_products;
}
@end

NSNumberFormatter * _priceFormatter;


@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    /*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
     */
    self.title = @"Full Versions";
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
   
//    [self.refreshControl beginRefreshing];
     self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
 

    

    
    /*RESTIORE BUTTON IS DISABLED BECAUSE THE SUBCRIPTIONS BUY BUTTON IS SOLVING THE PURPOSE*/
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore " style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
    
    
    
    
}



- (void)reload {
    _products = nil;
    [self.tableView reloadData];
    [[FaultGuideIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
    }];
    
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}








#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return _products.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    if ([DbHelper database].getFullVersionStatus==1) {
        
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.accessoryView = nil;

        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        buyButton.frame = CGRectMake(0, 0, 16, 16);
        //[buyButton setTitle:@"Info " forState:UIControlStateNormal];
        [buyButton setBackgroundColor:[UIColor clearColor]];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
        
    } else {
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 51, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
        
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"createAccount"]) {
        
       
    
    }
}


- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[FaultGuideIAPHelper sharedInstance] buyProduct:product];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
          [self reload];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}



 



 





- (void)restoreTapped:(id)sender {
    
 
    
    [self performSegueWithIdentifier:@"createAccount" sender:self];
    
    
    
    
    /* SINCE RESTORE COMPLETED TRABSACTIONS DOES NOT WORK WITH NON RENEWAL SUSBCRIPTIONS THEREFORE NEW LOGIC WROTE UP
    
    [[FaultGuideIAPHelper sharedInstance] restoreCompletedTransactions];

    
    NSLog(@"I m press");
    
    
    NSArray *receipts = [[NSArray alloc] initWithContentsOfFile:[DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"]];
    if(!receipts || [receipts count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No receipts" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    int totalRecipts=[receipts count];
    
    NSLog(@"Total recipets are %d",totalRecipts);
    
    NSData *r = receipts[0];
    [CrossCheckReceipt validateReceiptWithData:r completionHandler:^(BOOL success, NSString *message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Latest Reciept"
                                                        message:[NSString stringWithFormat:@"Success:%d - Message:%@",success,message]
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
         
        NSString *expiryDateString = [message stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
        
        
        NSLog(@"CURRENT Expiry Date %@",[DbHelper database].getFullVersionExpiryDate);

        NSLog(@" NEW time is %@",expiryDateString);
        
        if (expiryDateString!=NULL)
        {
            if([[DbHelper database]setFullVersionExpiryDate:expiryDateString])
            {
                NSLog(@"New Expiry Date Set Successfully");
            }
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"MasterViewController: Latest reciept shows that your subscription is expired, please subscibe again"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
        
        }
        
     
        NSLog(@"UPDATED  Expiry Date %@",[DbHelper database].getFullVersionExpiryDate);
        
        
        
    }
     ];
    
    */
    
   
     
    
    /*
    int a=1;
    for(NSData *aReceipt in receipts) {
        
        NSLog(@" Total recipets  count %d",a);
        a++;
        
        [CrossCheckReceipt validateReceiptWithData:aReceipt completionHandler:^(BOOL success, NSString *message) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receipt validation"
                                                            message:[NSString stringWithFormat:@"Success:%d - Message:%@",success,message]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            
            NSLog(@"Success:%d - Message:%@",success,message);
            //[alert show];
            
        }
         ];
    }///end of for
    */
   
}




// Add new method


//- (IBAction)checkreciepts:(id)sender {
    

- (void)infoButtonTapped:(id)sender {

    //[[FaultGuideIAPHelper sharedInstance] restoreCompletedTransactions];
    
    NSLog(@"CURRENT Expiry Date %@",[DbHelper database].getFullVersionExpiryDate);
  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:[NSString stringWithFormat:@"This Full version will be active until %@",[DbHelper database].getFullVersionExpiryDate]
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}
@end
