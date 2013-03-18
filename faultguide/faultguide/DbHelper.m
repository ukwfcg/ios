//
//  DbHelper.m
//  faultguide
//
//  Created by Sudeep Talati on 21/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "DbHelper.h"
#import <sqlite3.h>
#import "FaultDetails.h"

@implementation DbHelper

static DbHelper *_database;

@synthesize userDetais=_userDetais;
 

+ (DbHelper*)database {
    if (_database == nil) {
        _database = [[DbHelper alloc] init];
    }
    return _database;
}




#pragma mark- FIRST METHOD TO COPY DATABASE AT WRITABLE PLACE
-(BOOL) copyDatabase{
    
    //Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];

	if(!success) {
		

//        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FaultCodeGuide.sqlite"];//this is first database version
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FaultCodeGuide_v12.sqlite"];//this is databse version 12

		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
        {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            NSLog(@"Failed to create writable database file with message %@",[error localizedDescription]);
            return NO;
        }
        else
            return YES;
	}
    else
    {
        NSLog(@"DATABASE ALREADY EXISTING");
        return NO;//SINCE FILE ALREADY EXIST AT DATABASE PATH
    }
}//end of copyDatabase

- (NSString *) getDBPath {
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    
//    return [documentsDir stringByAppendingPathComponent:@"FaultCodeGuide.sqlite"]; //this is first database version
    return [documentsDir stringByAppendingPathComponent:@"FaultCodeGuide_v12.sqlite"];//this is databse version 12
    
	
}///end of getDBPath







#pragma mark- METHOD CALLED FROM OUTSIDE CLASSESS


- (NSArray *)brandList
{
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
    sqlite3_stmt *selectstmt = NULL;
    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = "SELECT _id, brand_name FROM brand ORDER BY brand_name ASC";
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
                char *brandIdChars = (char *) sqlite3_column_text(selectstmt, 0);
                NSString *brandIdString = [[NSString alloc] initWithUTF8String:brandIdChars];
                
                char *brandNameChars = (char *) sqlite3_column_text(selectstmt, 1);
                NSString *brandName = [[NSString alloc] initWithUTF8String:brandNameChars];
                
               // NSLog(@"Brand Name :%@",brandName);
                
                NSDictionary *brandDetails = [[NSDictionary alloc] initWithObjectsAndKeys:brandIdString, brandName, nil];
                [retval addObject:brandDetails];
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    return retval;
}///- end of  (NSArray *)brandList




- (NSArray *) seriesListOfBrandId: (NSString*) seriesbrandId
{
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
    sqlite3_stmt *selectstmt = NULL;

    NSString *query = [NSString stringWithFormat:@"SELECT _id, series_name FROM series WHERE brand_id = %@ ORDER BY series_name ASC",seriesbrandId];
    NSLog(@"QY+UERY IS : %@",query);
    
    
    if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		//const char *sql = "SELECT _id, brand_name FROM brand ORDER BY brand_name ASC";
		const char *sql = [query UTF8String];
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
                char *seriesIdChars = (char *) sqlite3_column_text(selectstmt, 0);
                NSString *seriesIdString = [[NSString alloc] initWithUTF8String:seriesIdChars];
                
                char *seriesNameChars = (char *) sqlite3_column_text(selectstmt, 1);
                NSString *seriesName = [[NSString alloc] initWithUTF8String:seriesNameChars];
                
                NSLog(@"Series Name :%@",seriesName);
                
                NSDictionary *seriesDetails = [[NSDictionary alloc] initWithObjectsAndKeys:seriesIdString, seriesName, nil];
                [retval addObject:seriesDetails];
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    return retval;
}///- end of  (NSArray *)brandList




- (NSArray *)faultListOfBrandId:(NSString*)faultbrandId SeriesId:(NSString*)faultSeriesId
{
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
        int brand_id=[faultbrandId intValue];
        NSString *tableName=[self getErrorCodeTableNameForBrandId:(int)brand_id];
        
        NSString *query = [NSString stringWithFormat:@"SELECT _id, series_id, display_panel_code, summary,number_of_leds, led_code, description, possible_cause, possible_solution, remarks FROM %@ WHERE series_id= %@ ORDER BY display_panel_code ASC ",tableName,faultSeriesId];

       
        
        
        retval=[self addFaultDetailsToReturningArray:retval forBrandId:brand_id fromSqlQuery:query];
        
        /*Logic to get the inherited fault codes*/
        NSLog(@"Series Id is %@",faultSeriesId);
        
        int series_id= [faultSeriesId intValue];
        ///Get the parent series id
        int parent_series_id= [self getParentSeriesId:series_id];
        
        NSLog(@"Series Id is %d",series_id);
        NSLog(@"Parent Series Id is %d",parent_series_id);
    
        while (series_id!=parent_series_id)
        {
            ////NOW PArent ID will become series id
            series_id=parent_series_id;

            /////GET brand id of parent series
            int parent_brand_id=[self getBrandIdOfSeries:series_id];
            
            tableName=[NSString stringWithFormat:@"brand_%d_errorcode",parent_brand_id];
            
            query = [NSString stringWithFormat:@"SELECT _id, series_id, display_panel_code, summary,number_of_leds, led_code, description, possible_cause, possible_solution, remarks FROM %@ WHERE series_id= %d ORDER BY display_panel_code ASC ",tableName,series_id];
            
            retval=[self addFaultDetailsToReturningArray:retval forBrandId:parent_brand_id fromSqlQuery:query];

            parent_series_id=[self getParentSeriesId:series_id];

        
        }///end of while (series_id!=parent_series_id)
        
    

        
    
    
        return retval;

}




#pragma mark- LOCAL Methods

- (NSMutableArray *) addFaultDetailsToReturningArray:(NSMutableArray*)retval forBrandId:(int)intBrandId fromSqlQuery:(NSString*)query
{
   
    
    if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
        const char *sql = [query UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
            //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
//            char *errorCodeIdChars = (char *) sqlite3_column_text(selectstmt, 0);
//            NSString *errorCodeIdString = [[NSString alloc] initWithUTF8String:errorCodeIdChars];
            NSInteger intFaultId = sqlite3_column_int(selectstmt, 0);
            
            
//            char *seriesIdChars = (char *) sqlite3_column_text(selectstmt, 1);
//            NSString *seriesIdString = [[NSString alloc] initWithUTF8String:seriesIdChars];
            NSInteger intSeriesId = sqlite3_column_int(selectstmt, 1);
            
            char *displayPanelCodeChars = (char *) sqlite3_column_text(selectstmt, 2);
            NSString *displayPanelCodeString = [[NSString alloc] initWithUTF8String:displayPanelCodeChars];
            displayPanelCodeString=[displayPanelCodeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                
                
            char *summaryChars = (char *) sqlite3_column_text(selectstmt, 3);
            NSString *summaryString = [[NSString alloc] initWithUTF8String:summaryChars];
            summaryString=[summaryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

//            char *number_of_ledsChars = (char *) sqlite3_column_text(selectstmt, 4);
//            NSString *number_of_ledsString = [[NSString alloc] initWithUTF8String:number_of_ledsChars];
            NSInteger int_num_of_leds = sqlite3_column_int(selectstmt, 4);
            
            
//            char *led_codeChars = (char *) sqlite3_column_text(selectstmt, 5);
//            NSString *led_codeString = [[NSString alloc] initWithUTF8String:led_codeChars];
            NSInteger int_led_code = sqlite3_column_int(selectstmt, 5);
            
            
            char *descriptionChars = (char *) sqlite3_column_text(selectstmt, 6);
            NSString *descriptionString = [[NSString alloc] initWithUTF8String:descriptionChars];
            descriptionString=[descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                
            char *possible_causeChars = (char *) sqlite3_column_text(selectstmt, 7);
            NSString *possible_causeString = [[NSString alloc] initWithUTF8String:possible_causeChars];
            possible_causeString=[possible_causeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                
            char *possible_solutionChars = (char *) sqlite3_column_text(selectstmt, 8);
            NSString *possible_solutionString = [[NSString alloc] initWithUTF8String:possible_solutionChars];
            possible_solutionString=[possible_solutionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
            char *remarksChars = (char *) sqlite3_column_text(selectstmt, 9);
            NSString *remarksString = [[NSString alloc] initWithUTF8String:remarksChars];
            remarksString=[remarksString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
            
            FaultDetails *faultDetails = [[FaultDetails alloc] initWithfaultId:intFaultId
                                                                      seriesId:intSeriesId
                                                                       brandId:intBrandId
                                                                  numberofLeds:int_num_of_leds
                                                                       ledCode:int_led_code
                                                                   displayCode:displayPanelCodeString
                                                                       summary:summaryString
                                                                   description:descriptionString
                                                                 possibleCause:possible_causeString
                                                              possibleSolution:possible_solutionString
                                                                       remarks:remarksString] ;
            
            
            [retval addObject:faultDetails];
             NSLog(@"Display Error Code :%@",displayPanelCodeString);
             NSLog(@"Summary:%@",summaryString);
                
            
            }//end of while
        /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
        
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement********  %s",sqlite3_errmsg(_database));}
    }
    
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
    

    
return retval;
}////end of  (NSMutableArray *) addFaultDetailsToReturningArray:(NSMutableArray*)retval forBrandId:(int)intBrandId fromSqlQuery:(NSString*)query





- (NSString *) getErrorCodeTableNameForBrandId:(int)brand_id {
    
     NSString *tableName = [NSString stringWithFormat:@"brand_%d_errorcode",brand_id];

    return tableName;
}




- (int) getParentSeriesId: (int) seriesId
{
    sqlite3_stmt *selectstmt = NULL;
    int parent_series_id=0;
    NSString *query = [NSString stringWithFormat:@"SELECT parent_series_id FROM series WHERE _id = %d ORDER BY series_name ASC",seriesId];
    
    if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		//const char *sql = "SELECT _id, brand_name FROM brand ORDER BY brand_name ASC";
		const char *sql = [query UTF8String];
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                parent_series_id = sqlite3_column_int(selectstmt, 0);
                                 
            }//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
    return parent_series_id;
}///- end of - (NSString *) getParentSeriesId: (NSString*) seriesId



- (int) getBrandIdOfSeries: (int) seriesId
{
    
    sqlite3_stmt *selectstmt = NULL;
    int brand_id=0;
    NSString *query = [NSString stringWithFormat:@"SELECT brand_id FROM series WHERE _id = %d ORDER BY series_name ASC",seriesId];
    
    if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = [query UTF8String];
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                brand_id = sqlite3_column_int(selectstmt, 0);
                NSLog(@"********Brand Id is %d",brand_id);
                
            }//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
    return brand_id;
}///- end of  - (NSString *) getBrandIdOfSeries: (NSString*) seriesId








#pragma mark- METHODs set and get the user details

- (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date
{
    self.userDetais =[NSUserDefaults standardUserDefaults];
    [self.userDetais setObject:expiry_date forKey:@"expiry_date"];
    return YES;
    
    
    ///// THE FOLOWING Method is depricarted from release 1.3 as NSUserDefaults methods retain the data even after update
     
    /*
    NSString *dbPath=[self getDBPath];
    
    sqlite3_stmt *sqliteStatement;
    
    
    if  (sqlite3_open([dbPath UTF8String], &_database) == SQLITE_OK)
    {
        NSLog(@"DATABASE SUCCESS FULLY OPEN");
    }
    else{
        NSLog(@"PROBLEM TO OPEN DB");
        return NO;
    }

    const char *sql = "UPDATE purchase_details SET expiry_date=? WHERE _id = '1';";
    
    
    if(sqlite3_prepare_v2(_database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error in Preparing SQL statement  %s",sqlite3_errmsg(_database));
        return NO;
    }
    
    sqlite3_bind_text(sqliteStatement, 1, [expiry_date UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(sqliteStatement))
    {
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(_database));
        NSLog(@"Error execution of update statement %s",sqlite3_errmsg(_database));
        return NO;
    }
    
    sqlite3_reset(sqliteStatement);
    sqlite3_finalize(sqliteStatement);
    
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
    return YES;
     */
    
    
    
}//end of - (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date;


- (BOOL) setRegistrationDetails: (NSString*)email password:(NSString*)pass
{
    
    self.userDetais =[NSUserDefaults standardUserDefaults];
    [self.userDetais setObject:email forKey:@"email"];
    [self.userDetais setObject:pass forKey:@"pass"];
    
    NSLog(@"******* Stored Email in NSUserDefaults is %@",email);
    
    
    return YES;
    
    
    
    
     /* THE FOLOWING Method is depricarted from release 1.3 as NSUserDefaults methods retain the data even after update
     
    NSString *dbPath=[self getDBPath];
    
    sqlite3_stmt *sqliteStatement;
    
    
    if  (sqlite3_open([dbPath UTF8String], &_database) == SQLITE_OK)
    {
        NSLog(@"DATABASE SUCCESS FULLY OPEN");
    }
    else{
        NSLog(@"PROBLEM TO OPEN DB");
        return NO;
    }
    
    const char *sql = "UPDATE purchase_details SET email=? , password=?  WHERE _id = '1';";
    
    
    if(sqlite3_prepare_v2(_database, sql, -1, &sqliteStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error in Preparing SQL statement  %s",sqlite3_errmsg(_database));
        return NO;
    }
    
    sqlite3_bind_text(sqliteStatement, 1, [email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sqliteStatement, 2, [pass UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(sqliteStatement))
    {
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(_database));
        NSLog(@"Error execution of update statement %s",sqlite3_errmsg(_database));
        return NO;
    }
    
    sqlite3_reset(sqliteStatement);
    sqlite3_finalize(sqliteStatement);
    
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    */
    
    
    
    

    
}//end of - (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date;

- (NSString *) getRegisteredEmailFromDb
{
    
    self.userDetais =[NSUserDefaults standardUserDefaults];
    NSString *email = [self.userDetais stringForKey:@"email"];
    if (email==NULL)
    {
        NSLog(@" *******In Database Helper Email is : %@",email);
        email=@"notset";
    }
    
    return email;
    
    /* THE FOLOWING Method is depricarted from release 1.3 as NSUserDefaults methods retain the data even after update
    sqlite3_stmt *selectstmt = NULL;
    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = "SELECT email FROM purchase_details WHERE _id='1'";
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
                email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
     if ([email length]==0)
     {
     email=@"notset";
     }
     return email;
     */
    
    
    ////The above method is replaced by NSUserdefaults from version 1.3
}/// END OF - (NSString *) getDatabaseExpiryDate





- (NSString *) getRegisteredPasswordFromDb
{
    self.userDetais =[NSUserDefaults standardUserDefaults];
    NSString *pass = [self.userDetais stringForKey:@"pass"];
    if (pass==NULL)
    {
        NSLog(@" *******In Database Helper Passwrd  is : %@",pass);
        pass=@"notset";
    }
    
    
    return pass;

    /*
    sqlite3_stmt *selectstmt = NULL;
    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = "SELECT password FROM purchase_details WHERE _id='1'";
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
                pass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    
     if ([pass length]==0)
    {
        pass=@"notset";
    }
      return pass;
     */
    

}/// END OF - (NSString *) getDatabaseExpiryDate



- (NSString *) getFullVersionExpiryDate
{
    self.userDetais =[NSUserDefaults standardUserDefaults];
    NSString *expiry_date = [self.userDetais stringForKey:@"expiry_date"];
    if (expiry_date==NULL)
    {
        NSLog(@" *******In Database Helper  Expiry Date is: %@",expiry_date);
        expiry_date=@"demo";
    }
    
    return expiry_date;
    
    /*sqlite3_stmt *selectstmt = NULL;
     
     if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
     
     const char *sql = "SELECT expiry_date FROM purchase_details WHERE _id='1'";
     
     if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
     
     
     ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
     while(sqlite3_step(selectstmt) == SQLITE_ROW) {
     
     expiryDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
     
     }//end of while
     /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
     
     }///enf of if sqlite3_prpare_v2
     else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
     }
     else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
     
     sqlite3_finalize(selectstmt);
     sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
     
     return expiryDate;
     
     */
    
    
}/// END OF - (NSString *) getDatabaseExpiryDate








- (int) getFullVersionStatus
{
    
    NSString *expiryDateString= [self getFullVersionExpiryDate];
    NSLog(@"Expiry Date %@",expiryDateString);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSLocale *POSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [formatter setLocale:POSIXLocale];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
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
    
    
    
}///end of - (int) getFullVersionStatus




#pragma mark- Diagnostic procedures



- (NSArray *)diagonosticProceduresTestListForSeriesId:(NSString*) series_id
{
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
    sqlite3_stmt *selectstmt = NULL;
    NSString *query = [NSString stringWithFormat:@"SELECT _id, test_name FROM diagnostic_procedure WHERE series_id=%@ ORDER BY test_name ASC",series_id];

    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
        const char *sql = [query UTF8String];
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
                char *testIdChars = (char *) sqlite3_column_text(selectstmt, 0);
                NSString *testIdString = [[NSString alloc] initWithUTF8String:testIdChars];
                
                
                char *testNameChars = (char *) sqlite3_column_text(selectstmt, 1);
                NSString *testName = [[NSString alloc] initWithUTF8String:testNameChars];
                
                // NSLog(@"Brand Name :%@",brandName);
                
                NSDictionary *brandDetails = [[NSDictionary alloc] initWithObjectsAndKeys:testIdString, testName, nil];
                [retval addObject:brandDetails];
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    return retval;
}///- end of  (NSArray *)diagonosticProceduresTestList



-(NSArray *) diagonosticProceduresDetailsOfId:(NSString*) dpId
{
    
    
    NSMutableArray *retval = [[NSMutableArray alloc] init]  ;
    sqlite3_stmt *selectstmt = NULL;
    
    NSString *query = [NSString stringWithFormat:@"SELECT diagnostic_procedure.test_name, diagnostic_procedure.test_info, diagnostic_procedure.test_steps, diagnostic_procedure.test_other_info,  diagnostic_procedure.test_remarks, brand.brand_name, series.series_name FROM diagnostic_procedure LEFT OUTER JOIN  brand ON diagnostic_procedure.brand_id=brand._id LEFT OUTER JOIN  series ON diagnostic_procedure.series_id =series._id WHERE diagnostic_procedure._id=%@",dpId];
    
     NSLog(@"Quesry is   :%@",query);
    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = [query UTF8String];
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
               
                char *test_nameChars = (char *) sqlite3_column_text(selectstmt, 0);
                NSString *test_name = [[NSString alloc] initWithUTF8String:test_nameChars];
                test_name=[test_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:test_name];
                
                char *test_infoChars = (char *) sqlite3_column_text(selectstmt, 1);
                NSString *test_info = [[NSString alloc] initWithUTF8String:test_infoChars];
                test_info=[test_info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:test_info];
                
                
                char *test_stepsChars = (char *) sqlite3_column_text(selectstmt, 2);
                NSString *test_steps = [[NSString alloc] initWithUTF8String:test_stepsChars];
                test_steps=[test_steps stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:test_steps];

                
                char *test_other_infoChars = (char *) sqlite3_column_text(selectstmt, 3);
                NSString *test_other_info = [[NSString alloc] initWithUTF8String:test_other_infoChars];
                test_other_info=[test_other_info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:test_other_info];
         
                char *test_remarksChars = (char *) sqlite3_column_text(selectstmt, 4);
                NSString *test_remarks = [[NSString alloc] initWithUTF8String:test_remarksChars];
                test_remarks=[test_remarks stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:test_remarks];
                
                char *brand_nameChars = (char *) sqlite3_column_text(selectstmt, 5);
                NSString *brand_name = [[NSString alloc] initWithUTF8String:brand_nameChars];
                brand_name=[brand_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [retval addObject:brand_name];
                
                
//                char *series_nameChars = (char *) sqlite3_column_text(selectstmt, 6);
//                NSString *series_name = [[NSString alloc] initWithUTF8String:series_nameChars];
//                series_name=[series_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                
                NSLog(@"Brand Name :%@",brand_name);
                
               // NSDictionary *brandDetails = [[NSDictionary alloc] initWithObjectsAndKeys:testIdString, testName, nil];
                //[retval addObject:brandDetails];
                
                
			}//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.
    return retval;



}////-(NSArray *) diagonosticProceduresDetailsOfId:(NSString*) dpId;


-(int) isDiagnosticProcedureAvailableForSeriesId:(NSString*) series_id{


    sqlite3_stmt *selectstmt = NULL;
    NSString *query = [NSString stringWithFormat:@"SELECT test_name FROM diagnostic_procedure WHERE series_id=%@",series_id];

    
	if (sqlite3_open([[self getDBPath] UTF8String], &_database) == SQLITE_OK) {
		
		const char *sql = [query UTF8String];
		
		if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            ////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSInteger intBrandId = sqlite3_column_int(selectstmt, 0);
                 
                
                char *testNameChars = (char *) sqlite3_column_text(selectstmt,0);
                NSString *testName = [[NSString alloc] initWithUTF8String:testNameChars];
                
                NSLog(@" Test naem  is %@",testName);
              
                return 1;
                // NSLog(@"Brand Name :%@",brandName);
                
            //    NSDictionary *brandDetails = [[NSDictionary alloc] initWithObjectsAndKeys:testIdString, testName, nil];
            //    [retval addObject:brandDetails];
			
            }//end of while
            /////#####WHILE STATEMENT TO EXTRACT THE VALUES########////////
            
        }///enf of if sqlite3_prpare_v2
        else{ NSLog(@"Error in Creating SQL statement  %s",sqlite3_errmsg(_database));}
    }
    else{ NSLog(@"Error in Opening Database  %s",sqlite3_errmsg(_database));}
    
    sqlite3_finalize(selectstmt);
    sqlite3_close(_database); //Even though the open call failed, close the database connection to release all the memory.

    return 0;
}




@end
