//
//  ViewController.h
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *functionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *progressMessageLabel;

// Input UI

// Percentage
- (IBAction)setProgressToPercent25:(id)sender;
- (IBAction)setProgressToPercent75:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *percentInputField;
- (IBAction)updatePercentProgress:(id)sender;

// dot color
- (IBAction)dotColorToggle:(id)sender;

// dot diameter
- (IBAction)dotDiameterToggle:(id)sender;

- (IBAction)resetButtonPressed:(id)sender;

@end

