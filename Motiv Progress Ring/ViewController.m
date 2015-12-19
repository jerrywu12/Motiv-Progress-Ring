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

@property NSInteger numberOfDots;
@property NSInteger radius;
@property NSInteger dotLength;


// Progress ring
// number of dots

// Data
@property int totalHr, totalMin;
@property int totalTime;
@property int totalGoalTime;

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
    self.dotLength = 15;
    
    // testing
//    [self testDrawAllDots];
    
    self.testRound = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(testAddDots)
                                   userInfo:nil
                                    repeats:YES];
    [self reset];
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

    [self updateUI];
}


#pragma mark - UI Update

- (void)updateUI
{

    self.progressMessageLabel.text = [NSString stringWithFormat:@"reached %i%% goal", self.totalTime];
}


#pragma mark - Progress Ring

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




+ (id)loadController:(Class)classType {
    NSString *className = NSStringFromClass(classType);
    UIViewController *controller = [[classType alloc] initWithNibName:className bundle:nil];
    return controller;
}

@end
