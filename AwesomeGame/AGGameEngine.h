//
//  AGGameEngine.h
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGGameEngine : NSObject

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)n verticalItemsCount:(NSUInteger)m;
- (void)swapItemsAtX0:(NSUInteger)x0 y0:(NSUInteger)y0 witItemAtX1:(NSUInteger)x1 y1:(NSUInteger)y1;

@end
