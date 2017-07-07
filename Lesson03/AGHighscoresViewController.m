//
//  AGHighscoresViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGHighscoresViewController.h"

@interface AGHighscoresViewController ()

- (void)goToMainMenu;

@end

@implementation AGHighscoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private

- (void)goToMainMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self goToMainMenu];
}

@end
