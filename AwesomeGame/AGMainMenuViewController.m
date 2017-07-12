//
//  ViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGMainMenuViewController.h"
#import "AGAlert.h"

@interface AGMainMenuViewController ()

@end

@implementation AGMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)didPressNewGame:(id)sender {
    [AGAlert showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                      firstButtonText:@"Yes"
                     secondButtonText:@"No"
                     firstButtonBlock:^{
                         
                     } secondButtonBlock:^{
                         
                     }];
}

@end
