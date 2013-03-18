//
//  DetailViewController.m
//  faultguide
//
//  Created by Sudeep Talati on 25/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize faultDetails=_faultDetails;
@synthesize scrollView=_scrollView;
@synthesize brandName=_brandName;
@synthesize seriesName=_seriesName;

 

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
    NSLog(@"Summary is %@",self.faultDetails.summary);
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBackgroundColor: [UIColor whiteColor]];
    
    
    
    /*IMAGES FOR LED**/
    /*CREATING IMAGES ARRAY FOR ANIMATIONS*/
    int numberOfFames = 2;
    NSMutableArray *offImagesArray = [NSMutableArray arrayWithCapacity:numberOfFames];
    for (int i=1; i<=numberOfFames; ++i)
    {
        [offImagesArray addObject:[UIImage imageNamed:
                                   [NSString stringWithFormat:@"nolit.gif"]]];
    }
    
    NSMutableArray *onImagesArray = [NSMutableArray arrayWithCapacity:numberOfFames];
    for (int i=1; i<=numberOfFames; ++i)
    {
        [onImagesArray addObject:[UIImage imageNamed:
                                  [NSString stringWithFormat:@"lit.gif"]]];
    }
    
    NSMutableArray *blinkingImagesArray = [NSMutableArray arrayWithCapacity:numberOfFames];
    for (int i=1; i<=numberOfFames; ++i)
    {
        [blinkingImagesArray addObject:[UIImage imageNamed:
                                        [NSString stringWithFormat:@"blink%d.gif", i]]];
        //                                      [NSString stringWithFormat:@"lit.gif"]]];
    }

    
    float drawingPosition=20;
    float headingMargin=10;
    float headingWidth=300;
//    float contentMargin=30;
//    float contentWidth=270;
    
    
    
    /*GET THE FRAME AND ASSIGN THE DRAWING POSITION*/
    CGRect displayCodeLabelFrame = self.displayCodeLabel.frame;
    displayCodeLabelFrame.origin.y = drawingPosition;
    /*ASSIGN FRAME TO THELABEL*/
    NSString *capsDisplayCode=[self.faultDetails.displayCode uppercaseString];
    self.displayCodeLabel.font=[UIFont fontWithName:@"DBLCDTempBlack" size:30.0];
    [self.displayCodeLabel setText:capsDisplayCode];
    self.displayCodeLabel.frame=displayCodeLabelFrame;
    int lightsStartLocation= displayCodeLabelFrame.origin.x+displayCodeLabelFrame.size.width;
    
    
    NSString *ledCodeText=[NSString stringWithFormat:@"%d",self.faultDetails.ledCode];
    int len = [ledCodeText length];
    NSLog (@"String length is %i", len);
    NSLog (@"LED CODE Text %@", ledCodeText);
    
    int shiftByPixel=0;
    for(int i=0;i<len;i++)
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(lightsStartLocation+shiftByPixel,drawingPosition,30,30)] ;
        [self.view addSubview:imageView];
        imageView.animationDuration = 1;
        
        char c=[ledCodeText characterAtIndex:i];
        NSLog(@"CODE :%c ",c);
        /**LED CODE 1=Off || 2=On || 3=Blinking */
        //            int ch=(int)c;
        int ch=[self parseChartoInt:c];
        NSLog(@"INT CODE :%d ",ch);
        switch (ch) {
            case 1:
                imageView.animationImages = offImagesArray;
                [imageView startAnimating];
                break;
            case 2:
                imageView.animationImages = onImagesArray;
                [imageView startAnimating];
                break;
            case 3:
                imageView.animationImages = blinkingImagesArray;
                [imageView startAnimating];
                break;
            default:
                break;
        }
        
        shiftByPixel=shiftByPixel+35;
        
        
    }///END OF FOR
    /*Setting the next Drawing Position*/
    //drawingPosition=drawingPosition+displayCodeLabelFrame.size.height;
    
    
    
    NSString *brandSeriesName=[[NSString alloc] initWithFormat:@"%@ - %@",self.brandName,self.seriesName ];
    
    /*TITLE HEADING - BRAND AND SERIES NAME*/
    CGSize headingSize=[brandSeriesName     sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:24.0]
                                       constrainedToSize:CGSizeMake(headingWidth, 9999)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect headingLabelFrame = CGRectMake(headingMargin, drawingPosition-5, headingSize.width, headingSize.height);
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:headingLabelFrame];
    [headingLabel setText:brandSeriesName];
    [headingLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:24.0]];
    [headingLabel setNumberOfLines:0];
    [self.scrollView addSubview:headingLabel];
    
    /*Setting the next Drawing Position*/
    drawingPosition=drawingPosition+headingLabel.frame.size.height+20;
    
    /*TITLE HEADING - BRAND AND SERIES NAME*/
  /*
    NSString *summary=@"The Da Vinci Code is a 2003 mystery-detective novel written by Dan Brown. It follows symbologist Robert Langdon and Sophie Neveu as they investigate a murder in Paris's Louvre Museum and discover a battle between the Priory of Sion and Opus Dei over the possibility of Jesus having been married to Mary Magdalene. The title of the novel refers to, among other things, the fact that the murder victim is found in the Grand Gallery of the Louvre, naked and posed like Leonardo da Vinci's famous drawing, the Vitruvian Man, with a cryptic message written beside his body and a pentacle drawn on his chest in his own blood.The novel is part of the exploration of alternative religious history, whose central plot point is that the Merovingian kings of France were descendants from the bloodline of Jesus Christ and Mary Magdalene, ideas derived from Clive Prince's The Templar Revelation (1997) and books by Margaret Starbird. Chapter 60 of the book also references another book, The Holy Blood and the Holy Grail (1982) though Dan Brown has stated that this was not used as research material.The book has provoked a popular interest in speculation concerning the Holy Grail legend and Magdalene's role in the history of Christianity. The book has been extensively denounced by many Christian denominations as an attack on the Roman Catholic Church. It has also been consistently criticized for its historical and scientific inaccuracies. The novel nonetheless became a worldwide bestseller[1] that sold 80 million copies as of 2009[2] and has been translated into 44 languages. Combining the detective, thriller, and conspiracy fiction genres, it is Brown's second novel to include the character Robert Langdon, the first being his 2000 novel Angels & Demons. In November 2004, Random House published a Special Illustrated Edition with 160 illustrations. In 2006, a film adaptation was released by Sony's Columbia Pictures.";
    */
   
    
    
    
    if([self.faultDetails.summary length]!=0){
    UILabel *summaryHeading =[self getUILabelForHeading:@"Summary" atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:summaryHeading];
    drawingPosition=drawingPosition+summaryHeading.frame.size.height+5;
    
    UILabel *summaryContent=[self getUILabelForContent:self.faultDetails.summary atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:summaryContent];
    drawingPosition=drawingPosition+summaryContent.frame.size.height+20;
    }
    
    
    if([self.faultDetails.description length ]!=0){
    UILabel *descriptionHeading =[self getUILabelForHeading:@"Description" atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:descriptionHeading];
    drawingPosition=drawingPosition+descriptionHeading.frame.size.height+5;
    UILabel *descriptionContent=[self getUILabelForContent:self.faultDetails.description atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:descriptionContent];
    drawingPosition=drawingPosition+descriptionContent.frame.size.height+20;
    }
        
        
    
    if([self.faultDetails.possibleCause length ]!=0){
    UILabel *possibleCauseHeading =[self getUILabelForHeading:@"Possible Cause" atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:possibleCauseHeading];
    drawingPosition=drawingPosition+possibleCauseHeading.frame.size.height+5;
    UILabel *possibleCauseContent=[self getUILabelForContent:self.faultDetails.possibleCause atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:possibleCauseContent];
    drawingPosition=drawingPosition+possibleCauseContent.frame.size.height+20;
    }
    
    if([self.faultDetails.possibleSolution length ]!=0){
    UILabel *possibleSolutionHeading =[self getUILabelForHeading:@"Possible Solution" atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:possibleSolutionHeading];
    drawingPosition=drawingPosition+possibleSolutionHeading.frame.size.height+5;
    UILabel *possibleSolutionContent=[self getUILabelForContent:self.faultDetails.possibleSolution atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:possibleSolutionContent];
    drawingPosition=drawingPosition+possibleSolutionContent.frame.size.height+20;
    }
    
    if([self.faultDetails.remarks length ]!=0){
    UILabel *remarksHeading =[self getUILabelForHeading:@"Remarks" atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:remarksHeading];
    drawingPosition=drawingPosition+remarksHeading.frame.size.height+5;
    UILabel *remarksContent=[self getUILabelForContent:self.faultDetails.remarks atDrawingPosition:drawingPosition];
    [self.scrollView addSubview:remarksContent];
    drawingPosition=drawingPosition+remarksContent.frame.size.height+20;
    }
    
    
    
    
    
    
    NSLog(@"Drawing position %f",drawingPosition);
    

    
    
    
    
    
    CGSize scrollViewcontentSize=CGSizeMake(320,drawingPosition );
    [self.scrollView setContentSize:scrollViewcontentSize];
    [self.scrollView setScrollEnabled:YES];
    
    

}///end of view did load


-(void) viewWillAppear : (BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark User Defined Methods

- (int) parseChartoInt:(char)c
{
    /*ASCII CODE OF '0' subtactde from original number gives original number*/
    int i=c-'0';
    
    return i;
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
