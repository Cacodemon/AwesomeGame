//
//  AGGameEngine.m
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameEngine.h"

NSString * const AGGameItemsDidMoveNotification = @"AGGameItemDidMoveNotification";
NSString * const AGGameItemsDidDeleteNotification = @"AGGameItemDidDeleteNotification";
NSString * const kAGGameItems = @"kAGGameItems";

@interface AGGameEngine ()

@property NSUInteger m;
@property NSUInteger n;

@property BOOL canRevertUserAction;

@property (nonatomic, strong) NSArray *gameField;

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;

- (void)applyUserAction;
- (void)checkMatchingItems;
- (void)fillGaps;
- (void)deleteItems:(NSArray*)items;
- (void)revertUserAction;

@end

@implementation AGGameEngine

#pragma mark - Constructors

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)m
                          verticalItemsCount:(NSUInteger)n {
    return nil;
}

#pragma mark - Public Mathods

- (void)swapItemAtX0:(NSUInteger)x0
                  y0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
                  y1:(NSUInteger)y1 {
    [self applyUserAction];
}

#pragma mark - Private

- (void)applyUserAction {
    //todo: do stuff
    //todo: notifyAboutItemsMovement
    self.canRevertUserAction = YES;
    [self checkMatchingItems];
}

- (void)checkMatchingItems {
    NSArray *matchingItems = [NSArray new];
    //todo: fill matchingItems
    if (matchingItems.count > 0) {
        self.canRevertUserAction = NO;
        [self deleteItems:matchingItems];
    } else {
        if (self.canRevertUserAction == YES) {
            [self revertUserAction];
        }
        else {
            //go to "awaiting input" state
        }
    }
}

- (void)fillGaps {
    NSArray *newItems = [NSArray new];
    //todo: generate new items
    [self notifyAboutItemsMovement:newItems];
    [self checkMatchingItems];
}

- (void)deleteItems:(NSArray*)items {
    //todo: do stuff
    [self notifyAboutItemsDeletion:items];
    [self fillGaps];
}

- (void)revertUserAction {
    //todo: do stuff
    //todo: notifyAboutItemsMovement
}

#pragma mark - Notifications

- (void)notifyAboutItemsMovement:(NSArray*)items {
    NSNotification *notification = [NSNotification notificationWithName:AGGameItemsDidMoveNotification object:nil userInfo:@{kAGGameItems : items}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutItemsDeletion:(NSArray*)items {
    NSNotification *notification = [NSNotification notificationWithName:AGGameItemsDidDeleteNotification object:nil userInfo:@{kAGGameItems : items}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
