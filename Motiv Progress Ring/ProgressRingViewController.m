//
//  ProgressRingViewController.m
//  Motiv Progress Ring
//
//  Created by Jerry Wu on 12/18/15.
//  Copyright © 2015 Jerry. All rights reserved.
//

#import "ProgressRingViewController.h"

@interface ProgressRingViewController ()

@end

@implementation ProgressRingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalTimeField.text = @"hello";
    self.view.backgroundColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
