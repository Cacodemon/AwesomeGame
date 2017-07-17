//
//  AGGameEngine.m
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameEngine.h"

@interface AGGameEngine ()

@property NSUInteger n;
@property NSUInteger m;

@property (nonatomic, strong) NSArray *gameField;

- (void)fillGaps;
- (NSArray*)matchingItems;
- (void)removeItems:(NSArray*)items;

- (void)notifyAboutRemovingItems:(NSArray*)removedItems;
- (void)notifyAboutMovingItems:(NSArray*)movedItems;
- (void)notifyAboutCreatingItems:(NSArray*)createdItems;

@end

@implementation AGGameEngine

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)n verticalItemsCount:(NSUInteger)m {
    return nil;
}

- (void)swapItemsAtX0:(NSUInteger)x0 y0:(NSUInteger)y0 witItemAtX1:(NSUInteger)x1 y1:(NSUInteger)y1 {
    //swap itmems
    NSArray *matchingItems = [self matchingItems];
    if (matchingItems.count > 0) {
        [self removeItems:matchingItems];
    } else {
        //undo swap
    }
}

- (void)fillGaps {
    
}

- (NSArray*)matchingItems {
    NSArray *result = [NSArray new];
    //do work
    return result;
}

- (void)removeItems:(NSArray*)items {
    if (items.count > 0) {
        //do work
        [self notifyAboutRemovingItems:items];
        [self fillGaps];
    }
    
}

@end
