//
//  AGGameViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameViewController.h"
#import "AGAlert.h"

@interface AGGameViewController ()

- (void)goToMainMenu;

@end

@implementation AGGameViewController


#pragma mark - Private

- (void)goToMainMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)didPressMenuButton:(id)sender {
    [AGAlert showAlertWithMessageText:@"MENU"
                      firstButtonText:@"Resume"
                     secondButtonText:@"Quit"
                     firstButtonBlock:^{
                         
                     } secondButtonBlock:^{
                         [self goToMainMenu];
                     }];

}

@end
