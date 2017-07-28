//
//  AGGameIemView.h
//  AwesomeGame
//
//  Created by user on 7/14/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGGameItemView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type;

@property (readonly, nonatomic) NSUInteger type;

@end
