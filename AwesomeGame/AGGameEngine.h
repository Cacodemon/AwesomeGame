//
//  AGGameEngine.h
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const AGGameItemsDidMoveNotification;
extern NSString * const AGGameItemsDidDeleteNotification;
extern NSString * const kAGGameItems;
extern NSString * const kAGGameItemTransitions;

@interface AGGameEngine : NSObject

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount;

- (void)swapItemAtX0:(NSUInteger)x0
                  y0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
                  y1:(NSUInteger)y1;

@end
