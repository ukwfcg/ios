//
//  FaultDatabase.h
//  Fault Guide
//
//  Created by Sudeep Talati on 24/10/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>



@interface FaultDatabase : NSObject{
    sqlite3 *_database;
}

+ (FaultDatabase *)database;

- (NSArray *)brandList;

- (NSString *)getFullVersionExpiryDate;
- (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date;



- (int) getFullVersionStatus;


-(void) updateDB;

@end

 
