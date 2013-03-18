//
//  DiagnosticProcedure.h
//  faultguide
//
//  Created by Sudeep Talati on 23/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiagnosticProcedure : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSString *testId;
@property (nonatomic, retain) NSString *testName;
@property (nonatomic, retain) NSArray *diagnoseData;


-(UILabel*) getUILabelForHeading:(NSString*) heading atDrawingPosition:(float) drawingPosition;
-(UILabel*) getUILabelForContent:(NSString*) content atDrawingPosition:(float) drawingPosition;



@end
