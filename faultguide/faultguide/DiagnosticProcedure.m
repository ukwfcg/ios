//
//  DiagnosticProcedure.m
//  faultguide
//
//  Created by Sudeep Talati on 23/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import "DiagnosticProcedure.h"
#import "DbHelper.h"


@interface DiagnosticProcedure ()

@end

@implementation DiagnosticProcedure
@synthesize scrollView=_scrollView;
@synthesize testId=_testId;
@synthesize testName=_testName;
@synthesize diagnoseData=_diagnoseData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog (@"I M In DPis: %@ and TEST Id is %@",self.testName,self.testId);
    
    
    self.diagnoseData=[[DbHelper database] diagonosticProceduresDetailsOfId:self.testId];

    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBackgroundColor: [UIColor whiteColor]];
    
    float drawingPosition=50;
//    float headingMargin=10;
//    float headingWidth=300;
//    
    
    NSString *test_name = [self.diagnoseData objectAtIndex:0];
    NSString *test_info = [self.diagnoseData objectAtIndex:1];
    NSString *test_steps = [self.diagnoseData objectAtIndex:2];
    NSString *test_other_info = [self.diagnoseData objectAtIndex:3];
    NSString *test_remarks = [self.diagnoseData objectAtIndex:4];
    NSString *brand_name = [self.diagnoseData objectAtIndex:5];
    
    
    self.title=brand_name;
    
    if([test_name length]!=0){
        UILabel *test_nameHeading =[self getUILabelForHeading:@"Test Name" atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_nameHeading];
        drawingPosition=drawingPosition+test_nameHeading.frame.size.height+5;
        
        UILabel *test_nameContent=[self getUILabelForContent:test_name atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_nameContent];
        drawingPosition=drawingPosition+test_nameContent.frame.size.height+20;
    }
   
    if([test_info length]!=0){
        UILabel *test_infoHeading =[self getUILabelForHeading:@"Information " atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_infoHeading];
        drawingPosition=drawingPosition+test_infoHeading.frame.size.height+5;
        
        UILabel *test_infoContent=[self getUILabelForContent:test_info atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_infoContent];
        drawingPosition=drawingPosition+test_infoContent.frame.size.height+20;
    }
   
    if([test_steps length]!=0){
        UILabel *test_stepsHeading =[self getUILabelForHeading:@"Steps" atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_stepsHeading];
        drawingPosition=drawingPosition+test_stepsHeading.frame.size.height+5;
        
        UILabel *test_stepsContent=[self getUILabelForContent:test_steps atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_stepsContent];
        drawingPosition=drawingPosition+test_stepsContent.frame.size.height+20;
    }
   
    if([test_other_info length]!=0){
        UILabel *test_other_infoHeading =[self getUILabelForHeading:@"Other Info" atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_other_infoHeading];
        drawingPosition=drawingPosition+test_other_infoHeading.frame.size.height+5;
        
        UILabel *test_other_infoContent=[self getUILabelForContent:test_other_info atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_other_infoContent];
        drawingPosition=drawingPosition+test_other_infoContent.frame.size.height+20;
    }
   
    if([test_remarks length]!=0){
        UILabel *test_remarksHeading =[self getUILabelForHeading:@"Remarks" atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_remarksHeading];
        drawingPosition=drawingPosition+test_remarksHeading.frame.size.height+5;
        
        UILabel *test_remarksContent=[self getUILabelForContent:test_remarks atDrawingPosition:drawingPosition];
        [self.scrollView addSubview:test_remarksContent];
        drawingPosition=drawingPosition+test_remarksContent.frame.size.height+20;
    }
    
    
    
    
    NSLog(@"Drawing position %f",drawingPosition);
    
    
    
    
    
    
    
    CGSize scrollViewcontentSize=CGSizeMake(320,drawingPosition );
    [self.scrollView setContentSize:scrollViewcontentSize];
    [self.scrollView setScrollEnabled:YES];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UILabel*) getUILabelForContent:(NSString*)content atDrawingPosition:(float) drawingPosition
{
    float contentMargin=30;
    float contentWidth=270;
    
    CGSize contentSize=[ content sizeWithFont:[UIFont fontWithName:@"Arial" size:16.0]
                            constrainedToSize:CGSizeMake(contentWidth, 9999)
                                lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect contentLabelFrame = CGRectMake(contentMargin, drawingPosition-5, contentSize.width, contentSize.height);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentLabelFrame];
    [contentLabel setText:content];
    [contentLabel setFont:[UIFont fontWithName:@"Arial" size:16.0]];
    [contentLabel setNumberOfLines:0];
    
    
    return contentLabel;
}

-(UILabel*) getUILabelForHeading:(NSString*)heading atDrawingPosition:(float) drawingPosition{
    
    float headingMargin=10;
    float headingWidth=300;
    
    CGSize headingSize=[ heading sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]
                            constrainedToSize:CGSizeMake(headingWidth, 9999)
                                lineBreakMode:NSLineBreakByWordWrapping];
    CGRect headingLabelFrame = CGRectMake(headingMargin, drawingPosition-5, headingSize.width, headingSize.height);
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:headingLabelFrame];
    [headingLabel setText:heading];
    [headingLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0]];
    [headingLabel setNumberOfLines:0];
    
    return headingLabel;
}



@end
