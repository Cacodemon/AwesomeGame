//
//  AGHighscoresViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGHighscoresViewController.h"
#import "AGHighscoresTableViewCell.h"
#import "AGHighscoresManager.h"

@interface AGHighscoresViewController () <UITableViewDelegate, UITableViewDataSource>

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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AGHighscoresManager sharedInstance] allRecords].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGHighscoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"AGHighscoresTableViewCellPrototype"];
    
    if (!cell) {
        cell = [[AGHighscoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"AGHighscoresTableViewCellPrototype"];
    }
    
    NSDictionary *record = [[[AGHighscoresManager sharedInstance] allRecords] objectAtIndex:indexPath.row];
    [cell setHighscoresRecord:record];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

//TBD

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self goToMainMenu];
}

@end
