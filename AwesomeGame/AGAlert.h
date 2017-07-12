//
//  AGAlert.h
//  AwesomeGame
//
//  Created by user on 7/12/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AGAlertButtonBlock)(void);

@interface AGAlert : UIViewController

+ (void)showAlertWithMessageText:(NSString*)messageText
                 firstButtonText:(NSString*)firstButtonText
                secondButtonText:(NSString*)secondButtonText
                firstButtonBlock:(AGAlertButtonBlock)firstButtonBlock
               secondButtonBlock:(AGAlertButtonBlock)secondButtonBlock;

- (instancetype)initWithMessageText:(NSString*)messageText
                    firstButtonText:(NSString*)firstButtonText
                   secondButtonText:(NSString*)secondButtonText
                   firstButtonBlock:(AGAlertButtonBlock)firstButtonBlock
                  secondButtonBlock:(AGAlertButtonBlock)secondButtonBlock;

- (void)show;

@end
