//
//  AGIngameMenuViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGIngameMenuViewController.h"

@interface AGIngameMenuViewController ()

- (void)dismissSelf;
- (void)goToMainMenu;

@end

@implementation AGIngameMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToMainMenu {
    [(UINavigationController*)self.presentingViewController popToRootViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)didPressResumeButton:(id)sender {
    [self dismissSelf];
}

- (IBAction)didPressQuitButton:(id)sender {
    [self dismissSelf];
    [self goToMainMenu];
}

@end
