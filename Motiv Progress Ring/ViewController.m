//
//  ViewController.m
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "ProgressRingViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) ProgressRingViewController *progressRingVC;
@property (strong, nonatomic) NSTimer *progressDrawingTimer;

@property NSInteger numberOfDots;
@property NSInteger radius;
@property NSInteger dotLength;

@property NSInteger percentProgress;


// Progress ring
// number of dots

// Data
@property int totalHr, totalMin;
@property int totalTime;
@property int totalGoalTime;

// Progress Ring
@property int drawingRound;

@property int testRound;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressRingVC = [[ProgressRingViewController alloc] init];
    
    // Progress ring
    self.numberOfDots = 50;
    self.radius = 120;
    self.dotLength = 6;
    
    // Testing
    [self updateProgressToPercent:60];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Reset

- (void)reset
{
    self.percentProgress = 0;

    [self.progressDrawingTimer invalidate];
    
//    NSUInteger subviewsCount = self.view.subviews.count;
//    
//    for(int i = subviewsCount - 1; i >= 0; i--)
//    {
//        [[self.view viewWithTag:101] removeFromSuperview];
//    }
}


#pragma mark - UI Update

- (void)updateProgressToPercent:(float)percent
{
    [self reset];
    
    // update text "reached 75% goal"
    self.progressMessageLabel.text = [NSString stringWithFormat:@"reached %i%% goal", (int)percent];
    
    // update progress ring
    [self updateProgressRingToPercent:percent];
}


#pragma mark - Progress Ring

- (void)updateProgressRingToPercent:(float)percent
{
    // set percent data
    self.percentProgress = percent;
    
    self.drawingRound = 1;

    self.progressDrawingTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                                 target:self
                                                               selector:@selector(drawProgress)
                                                               userInfo:nil
                                                                repeats:YES];
    
    
}

- (void)drawProgress
{
    int incrementDegree = 360 / self.numberOfDots;
    
    int degree = (float)self.percentProgress / 100 * 360;

    if (degree >= (incrementDegree * self.drawingRound)) {
        
        [self addProgressDot:incrementDegree * self.drawingRound];
        
        self.drawingRound++;
    }
    else {
        [self.progressDrawingTimer invalidate];
        self.drawingRound = 1;
    }
}


- (void)addProgressDot:(int)degree
{
    // create dot view
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dotLength, self.dotLength)];
    dot.backgroundColor = [UIColor whiteColor];
    
    // normalize the position
    CGFloat normalizeWidth = self.progressView.bounds.size.width / 2 - self.dotLength / 2;
    CGFloat normalizeHeight = self.progressView.bounds.size.height / 2 - self.dotLength / 2;
    dot.frame = CGRectOffset(dot.frame, normalizeWidth, normalizeHeight);
    
    // adjust according to radius and degree
    float offsetHeight = self.radius * cosf(degree * M_PI / 180);
    float offsetWidth = self.radius * sinf(degree * M_PI / 180);
    dot.frame = CGRectOffset(dot.frame, offsetWidth, 0 - offsetHeight);
    
    // track dot view
    dot.tag = 101;
    
    [self.progressView addSubview:dot];
}


#pragma mark - UI Inputs

- (IBAction)setProgressToPercent25:(id)sender {
    [self updateProgressToPercent:25.0f];
}

- (IBAction)setProgressToPercent75:(id)sender {
    [self updateProgressToPercent:75];
}

- (IBAction)updatePercentProgress:(id)sender {
    [self updateProgressToPercent:60];

}


@end
