//
//  ProgressRingViewController.m
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import "ProgressRingViewController.h"

@interface ProgressRingViewController ()

@property (strong, nonatomic) IBOutlet UIView *progressView;

// Progress Ring
@property (strong, nonatomic) NSTimer *progressDrawingTimer;
@property NSInteger percentProgress;
@property int drawingRound;

// Input Toggle
@property int dotColorCount;
@property int dotDiameterCount;


@end

@implementation ProgressRingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Progress ring
    self.numberOfDots = 50;
    self.ringRadius = 120;
    self.dotRadius = 6;
    self.dotColor = [UIColor whiteColor];
    self.dotColorCount = 0;

    // Time
    self.hour = 7;
    self.min = 27;
    
    [self addGradientForProgressView];
    
    // Testing (init value)
    [self updateProgressWithPercent:60];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.progressDrawingTimer invalidate];
    self.progressDrawingTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI Update

- (void)addGradientForProgressView
{
    // Gradient
    UIColor *topColor = [UIColor colorWithRed:130.0f/255.0f
                                        green:130.0f/255.0f
                                         blue:170.0f/255.0f
                                        alpha:1.0f];
    
    UIColor *bottomColor = [UIColor colorWithRed:40.0f/255.0f
                                           green:40.0f/255.0f
                                            blue:60.0f/255.0f
                                           alpha:1.0f];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.progressView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [self.progressView.layer insertSublayer:gradient atIndex:0];
}

- (void)updateProgressWithPercent:(float)percent
{
    // set percent data
    self.percentProgress = percent;
    
    // update text "7 h 27 m"
    self.totalTimeLabel.attributedText = [self formatTimeLabelStringHour:self.hour min:self.min];
    
    // update text "reached 75% goal"
    self.progressMessageLabel.text = [NSString stringWithFormat:@"reached %i%% goal", (int)percent];
    
    // update progress ring
    [self updateProgressRingToPercent:percent];
}

- (NSMutableAttributedString *)formatTimeLabelStringHour:(int)hour min:(int)min
{
    // time string
    NSDictionary * timeAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:46.0f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                      };
    
    NSDictionary * timeFormatAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:23.0f],
                                            NSForegroundColorAttributeName : [UIColor whiteColor]
                                            };
    
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", hour] attributes:timeAttributes];
    
    [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"h " attributes:timeFormatAttributes]];
    
    [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", min] attributes:timeAttributes]];
    
    [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"m" attributes:timeFormatAttributes]];
    
    return mutableAttributedString;
}


#pragma mark - Reset

- (void)reset
{
    self.drawingRound = 0;
    
    self.percentProgress = 0;
    
    [self.progressDrawingTimer invalidate];
    
    // reset label to 0%
    self.progressMessageLabel.text = [NSString stringWithFormat:@"reached %i%% goal", 0];
    
    // remove all the dots
    for (UIView *subview in self.progressView.subviews) {
        if (subview.tag > 0) {
            [subview removeFromSuperview];
        }
    }
}


#pragma mark - Progress Ring

- (void)updateProgressRingToPercent:(float)percent
{
    int incrementDegree = 360 / self.numberOfDots;
    int degree = (float)self.percentProgress / 100 * 360;
    
    if (degree >= (incrementDegree * self.drawingRound)) {
        
        self.progressDrawingTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                                     target:self
                                                                   selector:@selector(increaseProgress)
                                                                   userInfo:nil
                                                                    repeats:YES];
    }
    else {
        self.progressDrawingTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                                     target:self
                                                                   selector:@selector(decreaseProgress)
                                                                   userInfo:nil
                                                                    repeats:YES];
    }
}

- (void)increaseProgress
{
    int incrementDegree = 360 / self.numberOfDots;
    int degree = (float)self.percentProgress / 100 * 360;
    
    if (degree >= (incrementDegree * self.drawingRound)) {
        [self addProgressDot:incrementDegree * self.drawingRound];
        self.drawingRound++;
    }
    else if (self.drawingRound > 0) {
        [self.progressDrawingTimer invalidate];
        self.progressDrawingTimer = nil;
    }
}

- (void)decreaseProgress
{
    int incrementDegree = 360 / self.numberOfDots;
    int degree = (float)self.percentProgress / 100 * 360;
    
    if (degree < (incrementDegree * self.drawingRound)) {
        [self removeProgressDot:self.drawingRound];
        self.drawingRound--;
    }
    else {
        [self.progressDrawingTimer invalidate];
        self.progressDrawingTimer = nil;
    }
}

- (void)addProgressDot:(int)degree
{
    // create dot view
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dotRadius, self.dotRadius)];
    dot.backgroundColor = self.dotColor;
    dot.layer.cornerRadius = self.dotRadius / 2.0;
    
    // normalize the position
    CGFloat normalizeWidth = self.progressView.bounds.size.width / 2 - self.dotRadius / 2;
    CGFloat normalizeHeight = self.progressView.bounds.size.height / 2 - self.dotRadius / 2;
    dot.frame = CGRectOffset(dot.frame, normalizeWidth, normalizeHeight);
    
    // adjust according to ring radius and degree
    float offsetHeight = self.ringRadius * cosf(degree * M_PI / 180);
    float offsetWidth = self.ringRadius * sinf(degree * M_PI / 180);
    dot.frame = CGRectOffset(dot.frame, offsetWidth, 0 - offsetHeight);
    
    // track dot view
    if (self.drawingRound > 0) {
        dot.tag = self.drawingRound;
    }
    else {
        dot.tag = 1; // avoid degree 0
    }
    
    [self.progressView addSubview:dot];
}

- (void)removeProgressDot:(int)drawingRound
{
    // remove set of dots
    for (UIView *subview in self.progressView.subviews) {
        if (subview.tag == self.drawingRound) {
            [subview removeFromSuperview];
        }
    }
}


#pragma mark - UI Inputs

// Percentage
- (IBAction)setProgressToPercent25:(id)sender{
    [self updateProgressWithPercent:25.0f];
}

- (IBAction)setProgressToPercent75:(id)sender {
    [self updateProgressWithPercent:75];
}

// Dot Coloring
- (IBAction)dotColorToggle:(id)sender
{
    self.dotColorCount++;
    
    UIColor *color = [UIColor whiteColor];
    if (self.dotColorCount == 1) {
        color = [UIColor redColor];
    }
    else if (self.dotColorCount == 2) {
        color = [UIColor blueColor];
    }
    else if (self.dotColorCount == 3) {
        color = [UIColor blackColor];
    }
    else {
        color = [UIColor whiteColor];
        self.dotColorCount = 0;
    }
    
    self.dotColor = color;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    
    for (UIView *subview in self.progressView.subviews) {
        if (subview.tag > 0) {
            subview.backgroundColor = dotColor;
        }
    }
}

// Dot Diameter
- (IBAction)dotDiameterToggle:(id)sender
{
    self.dotDiameterCount++;
    
    NSInteger radius = self.dotRadius;
    if (self.dotDiameterCount == 1) {
        radius = 4;
    }
    else if (self.dotDiameterCount == 2) {
        radius = 10;
    }
    else if (self.dotDiameterCount == 3) {
        radius = 20;
    }
    else {
        radius = 6;
        self.dotDiameterCount = 0;
    }
    
    self.dotRadius = radius;
}

- (void)setDotRadius:(NSInteger)dotRadius
{
    _dotRadius = dotRadius;
    
    for (UIView *subview in self.progressView.subviews) {
        if (subview.tag > 0) {
            CGRect frame = subview.frame;
            frame.size.height = self.dotRadius;
            frame.size.width = self.dotRadius;
            frame.origin.x += (float)(subview.frame.size.width - self.dotRadius) / 2;
            frame.origin.y += (float)(subview.frame.size.height - self.dotRadius) / 2;
            subview.frame = frame;
            subview.layer.cornerRadius = self.dotRadius / 2.0;
        }
    }
}

// Reset Button
- (IBAction)resetButtonPressed:(id)sender
{
    [self reset];
}


@end
