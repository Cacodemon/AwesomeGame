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

- (void)drawRect:(CGRect)rect {
    
    CALayer *layer = self.layer;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 20.0;
    layer.borderWidth = 3.0;
    layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
