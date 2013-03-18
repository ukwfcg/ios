//
//  DetailViewController.h
//  faultguide
//
//  Created by Sudeep Talati on 25/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaultDetails.h"




@interface DetailViewController : UIViewController



@property (nonatomic, assign) FaultDetails *faultDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *displayCodeLabel;

@property (nonatomic, assign) NSString *seriesName;
@property (nonatomic, retain) NSString *brandName;


 


- (int) parseChartoInt:(char)c;
-(UILabel*) getUILabelForHeading:(NSString*) heading atDrawingPosition:(float) drawingPosition;
-(UILabel*) getUILabelForContent:(NSString*) content atDrawingPosition:(float) drawingPosition;

@end
