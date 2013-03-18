//
//  SelectBrand.h
//  faultguide
//
//  Created by Sudeep Talati on 20/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBrand : UITableViewController

@property (nonatomic, assign) int isFullDatabase;
@property (nonatomic, retain) NSArray *brandList;

@end
