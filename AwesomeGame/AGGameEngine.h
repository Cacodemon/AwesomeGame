//
//  AGGameEngine.h
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGStructures.h"

extern NSString * const AGGameItemsDidMoveNotification;
extern NSString * const AGGameItemsDidDeleteNotification;
extern NSString * const kAGGameItems;
extern NSString * const kAGGameItemTransitions;

@interface AGGameEngine : NSObject

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount;

- (void)swapItemAtPiont0:(AGIntegerPoint)p0
        withItemAtPoint1:(AGIntegerPoint)p1;

@end

@interface AGMatchingSequence : NSObject

@property AGIntegerPoint startingPoint;
@property AGIntegerPoint endingPoint;

@end;
