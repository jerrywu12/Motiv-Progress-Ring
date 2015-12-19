//
//  ProgressRingViewController.h
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressRingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *progressStatusContainer;

@property (strong, nonatomic) IBOutlet UILabel *functionTitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *totalTimeField;
@property (strong, nonatomic) IBOutlet UITextField *progressMessageField;

@end
