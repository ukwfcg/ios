//
//  FaultDetails.h
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaultDetails : NSObject{
    int _brandId;
    int _seriesId;
    int _faultId;
    int _numberOfLeds;
    int _ledCode;
    
    NSString *_displayCode;
    NSString *_summary;
    NSString *_description;
    NSString *_possibleCause;
    NSString *_possibleSolution;
    NSString *_remarks;
}




@property (nonatomic, assign) int brandId;
@property (nonatomic, assign) int seriesId;
@property (nonatomic, assign) int faultId;
@property (nonatomic, assign) int numberOfLeds;
@property (nonatomic, assign) int ledCode;

@property (nonatomic, retain) NSString *displayCode;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *possibleCause;
@property (nonatomic, retain) NSString *possibleSolution;
@property (nonatomic, retain) NSString *remarks;

- (id)initWithfaultId:(int)faultId
             seriesId:(int)seriesId
              brandId:(int)brandId
         numberofLeds:(int)numberofLeds
              ledCode:(int)ledCode
          displayCode:(NSString *)displayCode
              summary:(NSString *)summary
          description:(NSString *)description
        possibleCause:(NSString *)possibleCause
     possibleSolution:(NSString *)possibleSolution
              remarks:(NSString *)remarks;






@end
