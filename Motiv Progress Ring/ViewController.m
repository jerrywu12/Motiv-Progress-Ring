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
    self.numberOfDots = 4;
    self.radius = 100;
    self.dotLength = 10;
    
    // testing
//    [self testDrawAllDots];
    
//    self.testRound = 0;
//    [NSTimer scheduledTimerWithTimeInterval:0.05
//                                     target:self
//                                   selector:@selector(testAddDots)
//                                   userInfo:nil
//                                    repeats:YES];
    
    [self updateProgressToPercent:60];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tests

- (void)testDrawAllDots
{
    [self addProgressDot:0];
    [self addProgressDot:280];
    [self addProgressDot:290];

//    [self addProgressDot:45];
    [self addProgressDot:90];
//    [self addProgressDot:135];
    [self addProgressDot:180];
//    [self addProgressDot:225];
    [self addProgressDot:270];
//    [self addProgressDot:315];
    [self addProgressDot:360];
}

- (void)testAddDots
{
    [self addProgressDot:10 * self.testRound];

    self.testRound++;
}

#pragma mark - Reset

- (void)reset
{
    self.totalTime = 0;
    self.percentProgress = 0;

    [self updateProgressToPercent:0];
}


#pragma mark - UI Update

- (void)updateProgressToPercent:(float)percent
{
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
    int incrementDegree = 10;
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
    
    [self.progressView addSubview:dot];
}


@end
