//
//  AGAlert.m
//  AwesomeGame
//
//  Created by user on 7/12/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGAlert.h"

@interface AGAlert ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSString *firstButtonText;
@property (nonatomic, strong) NSString *secondButtonText;

@property (nonatomic, copy) AGAlertButtonBlock firstButtonBlock;
@property (nonatomic, copy) AGAlertButtonBlock secondButtonBlock;

@end

@implementation AGAlert

#pragma mark - Convinience Methods

+ (void)showAlertWithMessageText:(NSString*)messageText
                 firstButtonText:(NSString*)firstButtonText
                secondButtonText:(NSString*)secondButtonText
                firstButtonBlock:(AGAlertButtonBlock)firstButtonBlock
               secondButtonBlock:(AGAlertButtonBlock)secondButtonBlock {
    
    AGAlert *alert = [[AGAlert alloc] initWithMessageText:messageText
                                          firstButtonText:firstButtonText
                                         secondButtonText:secondButtonText
                                         firstButtonBlock:firstButtonBlock
                                        secondButtonBlock:secondButtonBlock];
    [alert show];
}

#pragma mark - Constructors

- (instancetype)initWithMessageText:(NSString*)messageText
                    firstButtonText:(NSString*)firstButtonText
                   secondButtonText:(NSString*)secondButtonText
                   firstButtonBlock:(AGAlertButtonBlock)firstButtonBlock
                  secondButtonBlock:(AGAlertButtonBlock)secondButtonBlock {
    self = [super init];
    if (self) {
        self.messageText = messageText;
        self.firstButtonText = firstButtonText;
        self.secondButtonText = secondButtonText;
        self.firstButtonBlock = firstButtonBlock;
        self.secondButtonBlock = secondButtonBlock;
    }
    return self;
}

#pragma mark - Lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageLabel.text = self.messageText;
    [self.firstButton setTitle:self.firstButtonText forState:UIControlStateNormal];
    [self.secondButton setTitle:self.secondButtonText forState:UIControlStateNormal];
}

#pragma mark - Public Methods

- (void)show {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)hideWithCompletion:(void (^)(void))completion {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - Actions

- (IBAction)didPressFirstButton:(id)sender {
    [self hideWithCompletion:^{
        self.firstButtonBlock();
    }];
}

- (IBAction)didPressSecondButton:(id)sender {
    [self hideWithCompletion:^{
        self.secondButtonBlock();
    }];
}

@end
