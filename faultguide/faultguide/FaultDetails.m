//
//  FaultDetails.m
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FaultDetails.h"
#import <Foundation/Foundation.h>

@implementation FaultDetails

@synthesize brandId=_brandId;
@synthesize seriesId=_seriesId;
@synthesize faultId=_faultId;
@synthesize numberOfLeds=_numberOfLeds;
@synthesize ledCode=_ledCode;
@synthesize displayCode=_displayCode;
@synthesize summary=_summary;
@synthesize description=_description;
@synthesize possibleCause=_possibleCause;
@synthesize possibleSolution=_possibleSolution;
@synthesize remarks=_remarks;



////*THIS IS THE METHOD NAME **//////
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
              remarks:(NSString *)remarks
{
    if ((self = [super init])) {
        self.brandId=brandId;
        self.seriesId=seriesId;
        self.faultId=faultId;
        self.numberOfLeds=numberofLeds;
        self.ledCode=ledCode;
        self.displayCode=displayCode;
        self.summary=summary;
        self.description=description;
        self.possibleCause=possibleCause;
        self.possibleSolution=possibleSolution;
        self.remarks=remarks;
        
    }
    return self;
}

@end
