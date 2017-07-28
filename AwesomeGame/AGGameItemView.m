//
//  AGGameIemView.m
//  AwesomeGame
//
//  Created by user on 7/14/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameItemView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation AGGameItemView

- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CALayer *layer = self.layer;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 15.0;
    layer.borderWidth = 3.0;
    layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)didMoveToSuperview {
    [self setBackgroundColor:[self colorForType:self.type]];
}

- (UIColor*)colorForType:(NSUInteger)type {
    UIColor *result = nil;
    
    switch (type) {
        case 0:
            result = [UIColor redColor];
            break;
        case 1:
            result = [UIColor greenColor];
            break;
        case 2:
            result = [UIColor blueColor];
            break;
        case 3:
            result = [UIColor magentaColor];
            break;
        case 4:
            result = [UIColor yellowColor];
            break;
        case 5:
            result = [UIColor cyanColor];
            break;
        case 6:
            result = [UIColor orangeColor];
            break;
        default:
            break;
    }
    
    return result;
}

@end
