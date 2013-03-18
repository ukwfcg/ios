//
//  SelectErrorCode.h
//  faultguide
//
//  Created by Sudeep Talati on 24/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectErrorCode : UITableViewController

@property (nonatomic, retain) NSArray *errorCodeList;
@property (nonatomic, assign) NSString *brandId;
@property (nonatomic, assign) NSString *seriesId;
@property (nonatomic, assign) NSString *seriesName;
@property (nonatomic, retain) NSString *brandName;


@end
