//
//  FaultDatabase.m
//  Fault Guide
//
//  Created by Sudeep Talati on 24/10/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "FaultDatabase.h"





@implementation FaultDatabase

static FaultDatabase *_database;

+ (FaultDatabase*)database {
    if (_database == nil) {
        _database = [[FaultDatabase alloc] init];
    }
    return _database;
}


- (id)init {
    if ((self = [super init])) {
       /* NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"FaultCodeGuide"
                                                             ofType:@"sqlite"];
        */
        }
    return self;
}
 


- (NSArray *)brandList {
    
    NSDictionary *brandDetails;

    
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
    NSString *query = @"SELECT _id, brand_name FROM brand ORDER BY brand_name ASC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int intBrandId = sqlite3_column_int(statement, 0);
            char *brandNameChars = (char *) sqlite3_column_text(statement, 1);
            NSString *brandName = [[NSString alloc] initWithUTF8String:brandNameChars];
            
            NSLog(@"Brand Name :%@",brandName);
            
            id brandId = [NSNumber numberWithInteger: intBrandId];
            [brandDetails setValue:brandId forKey:brandName];
            [retval addObject:brandDetails];
            
            
            /*
             Info *info = [[Info alloc] initWithBrandId:brandId brandName:brandName];
             
             [retval addObject:info];
             [brandName release];
             [info release];
             */
            
        }
        sqlite3_finalize(statement);
    }
    return retval;
}




- (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date {
    
    
    NSLog(@" EXPIRY DATE TO BE ENTERED %@",expiry_date);
    sqlite3 *fullVersionDb;
    NSString* fullDbName = [[NSBundle mainBundle] pathForResource:@"FaultCodeGuide" ofType:@"sqlite"];
    
    if (sqlite3_open([ fullDbName UTF8String], &fullVersionDb) != SQLITE_OK) {
        
        NSLog(@"Failed to open Failed to open DEMO Database Or Database not found");
        
    }
    
    /*
    
    NSString *query = [[NSString alloc]initWithFormat:@"UPDATE purchase_details SET expiry_date='%@' WHERE _id = '1'",expiry_date];
    NSLog(@"%@",query);
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(fullVersionDb, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSLog(@"Setting Expiry Date");
            
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Expiry Date NOT Set");
    }

    sqlite3_close(fullVersionDb);
    
    */
    
    
    
   // const char *sqlStatement = "UPDATE purchase_details SET expiry_date='NEVER DEAR' WHERE _id = '1'";
    //NSString *query = [[NSString alloc]initWithFormat:@"UPDATE purchase_details SET expiry_date='%@' WHERE _id = '1'",expiry_date];
    sqlite3_stmt *compiledStatement;
    
    
    const char *sqlStatement = "UPDATE purchase_details SET expiry_date=? WHERE _id = '1'";
    
    const char *variable="DEAR NAU";
    
    
    
    
    sqlite3_prepare_v2(fullVersionDb, sqlStatement, -1, &compiledStatement, NULL);
    
    sqlite3_bind_text(compiledStatement, 1, variable, -1, SQLITE_TRANSIENT);
    
   // int success = sqlite3_step(compiledStatement);
    
    sqlite3_reset(compiledStatement);
    
    
    return YES;
    
}





-(void) updateDB{
    NSLog(@"*************IN UPDATE DB");

    
    
        
    NSString *tt=@"2021-7-09";
    sqlite3 *db;
    //Get list of directories in Document path
   // NSArray * dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Define new path for database
    //NSString * documentPath = [[dirPath objectAtIndex:0] stringByAppendingPathComponent:@"FaultCodeGuide.sqlite"];
    NSString* documentPath = [[NSBundle mainBundle] pathForResource:@"FaultCodeGuide" ofType:@"sqlite"];
    
    
    
    
    
    
    /*WORKING IN SIMULATOR

     
    if(!(sqlite3_open([documentPath UTF8String], &db) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
        return;
    }else{
        const char *insertSQL = "UPDATE purchase_details SET expiry_date=? WHERE _id = '1';";
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare_v2(db, insertSQL, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
            return;
        }else{
            sqlite3_bind_text(sqlStatement, 1, [tt UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if(sqlite3_step(sqlStatement)==SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(db);
            }
            
        }
    }
     */
    
    
    sqlite3_stmt *updateStmt;
    
   if  (sqlite3_open([documentPath UTF8String], &db) == SQLITE_OK)
    {
      NSLog(@"PSUCCESS FULLY OPEN");
    }
   else{
       NSLog(@"PROBLEM TO OPEN DB");
       
   }
    
        const char *sql = "UPDATE purchase_details SET expiry_date=? WHERE _id = '1';";
        
 
       // const char *sql = "update Coffee Set CoffeeName = ?, Price = ? Where CoffeeID = ?";
        if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
            NSLog(@"Erroe iin ccreating update stateemet  %s",sqlite3_errmsg(db));
         
    //sqlite3_bind_text(updateStmt, 1, [coffeeName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStmt, 1, [tt UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
//        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
        NSLog(@"Erroe iin ccreating update stateemet %s",sqlite3_errmsg(db));

    sqlite3_reset(updateStmt);
    sqlite3_finalize(updateStmt);
    
    
    
    
}











- (NSString *)getFullVersionExpiryDate{
    
    NSString *expiry_date;
    NSString *query = @"SELECT expiry_date FROM purchase_details WHERE _id='1'";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSLog(@"Hurray I am fhee finally");
            char *expiry_dateChars = (char *) sqlite3_column_text(statement, 0);
            expiry_date = [[NSString alloc] initWithUTF8String:expiry_dateChars];
            
        }
        sqlite3_finalize(statement);
    }
    
    
    NSLog(@" Expiry DATE IN DATABASE %@",expiry_date);
    
    
    
    return expiry_date;
    
    
}


- (int) getFullVersionStatus
{
    
    NSString *expiryDateString= [self getFullVersionExpiryDate];
    NSLog(@"Expiry Date %@",expiryDateString);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSLocale *POSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [formatter setLocale:POSIXLocale];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *expiryDate = [formatter dateFromString:expiryDateString];
    NSDate *today = [NSDate date]; // it will give you current date
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:expiryDate]; // comparing two dates
    
    if(result==NSOrderedAscending)
    {
        NSLog(@"today is less, Not Expired, we will continue with FULL");
        return 1;
        
    }
    else if(result==NSOrderedDescending)
    {
        
        NSLog(@"Expiry  date is less, Expired, LITE VERSION IS ACTICVE");
        return 0;
        
        
    }
    else
    {
        NSLog(@"On Edge of Expiry Both dates are same SO DEMO VERSION");
        return 0;
    }
    
    
    
}


@end