//
//  DbHelper.h
//  faultguide
//
//  Created by Sudeep Talati on 21/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DbHelper : NSObject{
    sqlite3 *_database;
}

+ (DbHelper *)database;

@property (strong, nonatomic) NSUserDefaults *userDetais;


-(BOOL) copyDatabase;
-(NSString *)  getDBPath;
-(NSString *) getFullVersionExpiryDate;
-(NSArray *) brandList;


-(NSArray *) seriesListOfBrandId:(NSString*) seriesbrandId;
-(NSArray *) faultListOfBrandId:(NSString*)faultbrandId SeriesId:(NSString*)faultSeriesId;

- (int) getBrandIdOfSeries: (int) seriesId;
- (int) getParentSeriesId: (int) seriesId;
- (NSMutableArray *) addFaultDetailsToReturningArray:(NSMutableArray*)retval forBrandId:(int)intBrandId fromSqlQuery:(NSString*)query;
- (NSString *) getErrorCodeTableNameForBrandId:(int)brand_id;


- (BOOL) setFullVersionExpiryDate: (NSString*)expiry_date;
- (BOOL) setRegistrationDetails: (NSString*)email password:(NSString*)pass;
- (NSString *) getRegisteredEmailFromDb;
- (NSString *) getRegisteredPasswordFromDb;

- (int) getFullVersionStatus;

-(NSArray *) diagonosticProceduresTestListForSeriesId:(NSString*) series_id;
-(NSArray *) diagonosticProceduresDetailsOfId:(NSString*) dpId;

-(int) isDiagnosticProcedureAvailableForSeriesId:(NSString*) series_id;





@end
