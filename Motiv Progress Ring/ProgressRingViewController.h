//
//  ProgressRingViewController.h
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressRingViewController : UIViewController


#pragma mark - Public Properties

// Progress Ring UI
@property (nonatomic) int numberOfDots;
@property (nonatomic) NSInteger ringRadius;
@property (nonatomic) NSInteger dotRadius;
@property (strong, nonatomic) UIColor *dotColor;

// Time Data
@property int hour, min;

// update percent progress UI
- (void)updateProgressWithPercent:(float)percent;


@property (strong, nonatomic) IBOutlet UILabel *functionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *progressMessageLabel;


// Inputs

// Percent Progress
- (IBAction)setProgressToPercent25:(id)sender;
- (IBAction)setProgressToPercent75:(id)sender;

// dot color toggling
- (IBAction)dotColorToggle:(id)sender;

// dot diameter toggling
- (IBAction)dotDiameterToggle:(id)sender;

// Reset Button
- (IBAction)resetButtonPressed:(id)sender;

@end