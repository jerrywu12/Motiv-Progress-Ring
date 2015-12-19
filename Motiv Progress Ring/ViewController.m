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

@property NSInteger percentProgress;

// Input Toggle
@property int dotColorCount;
@property int dotDiameterCount;

// Progress Ring
@property int drawingRound;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Progress ring
    self.numberOfDots = 50;
    self.ringRadius = 120;
    self.dotRadius = 6;
    self.dotColor = [UIColor whiteColor];
    
    // Time
    self.hour = 7;
    self.min = 27;
    
    self.dotColorCount = 0;
    
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
    
    // reset label to 0%
    self.progressMessageLabel.text = [NSString stringWithFormat:@"reached %i%% goal", 0];

    // remove all the dots
    for (UIView *subview in self.progressView.subviews) {
        [[subview viewWithTag:101] removeFromSuperview];
    }
}


#pragma mark - UI Update


- (void)updateProgressToPercent:(float)percent
{
    [self reset];
    
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


#pragma mark - Progress Ring

- (void)updateProgressRingToPercent:(float)percent
{
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
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dotRadius, self.dotRadius)];
    dot.backgroundColor = [UIColor whiteColor];
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
    dot.tag = 101;
    
    [self.progressView addSubview:dot];
}


#pragma mark - UI Inputs

// Percentage
- (IBAction)setProgressToPercent25:(id)sender{
    [self updateProgressToPercent:25.0f];
}

- (IBAction)setProgressToPercent75:(id)sender {
    [self updateProgressToPercent:75];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)updatePercentProgress:(id)sender {
    [self updateProgressToPercent:60];

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
    
    for (UIView *subview in self.progressView.subviews) {
        ((UIView *)[subview viewWithTag:101]).backgroundColor = color;
    }
}


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
    
    [self updateProgressToPercent:self.percentProgress];
}

- (IBAction)resetButtonPressed:(id)sender
{
    [self reset];
}


@end
