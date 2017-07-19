//
//  AGGameEngine.m
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameEngine.h"
#import "AGGameItemTransition.h"

NSString * const AGGameItemsDidMoveNotification = @"AGGameItemDidMoveNotification";
NSString * const AGGameItemsDidDeleteNotification = @"AGGameItemDidDeleteNotification";
NSString * const kAGGameItems = @"kAGGameItems";
NSString * const kAGGameItemTransitions = @"kAGGameItemTransitions";

@interface AGGameEngine ()

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;

@property BOOL canRevertUserAction;

@property (nonatomic, strong) NSMutableArray *gameField;

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;

- (void)configureGameField;
- (NSUInteger)generateNewItemType;
- (void)applyUserAction;
- (void)checkMatchingItems;
- (void)fillGaps;
- (void)deleteItems:(NSArray*)items;
- (void)revertUserAction;

@end

@implementation AGGameEngine

#pragma mark - Constructors

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount {
    self = [super init];
    if (self) {
        self.horizontalItemsCount = horizontalItemsCount;
        self.verticalItemsCount = verticalItemsCount;
        self.itemTypesCount = itemTypesCount;
        [self configureGameField];
        [self fillGaps];
    }
    return self;
}

#pragma mark - Public Methods

- (void)swapItemAtX0:(NSUInteger)x0
                  y0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
                  y1:(NSUInteger)y1 {
    [self applyUserAction];
}

#pragma mark - Private

- (void)configureGameField {
    self.gameField = [NSMutableArray arrayWithCapacity:self.horizontalItemsCount];
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:self.verticalItemsCount];
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            [column addObject:[NSNull null]];
        }
        [self.gameField addObject:column];
    }
}

- (NSUInteger)generateNewItemType {
    NSUInteger result = arc4random_uniform(INT_MAX) % self.itemTypesCount;
    return result;
}

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
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            if (self.gameField[i][j] == [NSNull null]) {
                NSUInteger newItemType = [self generateNewItemType];
                self.gameField[i][j] = @(newItemType);
                AGGameItemTransition *itemTransition = [AGGameItemTransition new];
                itemTransition.x0 = i;
                itemTransition.y0 = -j - 1;
                itemTransition.x1 = i;
                itemTransition.y1 = j;
                itemTransition.type = newItemType;
                [newItemTransitions addObject:itemTransition];
            }
        }
    }
    
    [self notifyAboutItemsMovement:newItemTransitions];
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

- (void)notifyAboutItemsMovement:(NSArray*)itemTransitions {
    NSNotification *notification = [NSNotification notificationWithName:AGGameItemsDidMoveNotification
                                                                 object:nil
                                                               userInfo:@{kAGGameItemTransitions : itemTransitions}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutItemsDeletion:(NSArray*)items {
    NSNotification *notification = [NSNotification notificationWithName:AGGameItemsDidDeleteNotification
                                                                 object:nil
                                                               userInfo:@{kAGGameItems : items}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
