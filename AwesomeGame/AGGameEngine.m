//
//  AGGameEngine.m
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameEngine.h"
#import "AGGameItemTransition.h"

@implementation AGMatchingSequence

- (NSString*)description {
    return [NSString stringWithFormat:@"(%ld, %ld) -> (%ld, %ld)", (long)self.i0, (long)self.j0, (long)self.i1, (long)self.j1];
}

@end


NSString * const AGGameItemsDidMoveNotification = @"AGGameItemDidMoveNotification";
NSString * const AGGameItemsDidDeleteNotification = @"AGGameItemDidDeleteNotification";
NSString * const kAGGameItems = @"kAGGameItems";
NSString * const kAGGameItemTransitions = @"kAGGameItemTransitions";

@interface AGGameEngine ()

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;

@property BOOL canRevertUserAction;

@property NSUInteger userX0;
@property NSUInteger userY0;
@property NSUInteger userX1;
@property NSUInteger userY1;

@property (nonatomic, strong) NSMutableArray *gameField;

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;

- (void)configureGameField;
- (NSUInteger)generateNewItemType;
- (void)applyUserAction;
- (void)checkMatchingItems;
- (void)fillGaps;
- (void)deleteItems:(NSArray*)matchingSequences;
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
    
    NSLog(@"(%ld; %ld) -> (%ld; %ld)", (long)x0, (long)y0, (long)x1, (long)y1);
    id tmp = self.gameField[x0][y0];
    self.gameField[x0][y0] = self.gameField[x1][y1];
    self.gameField[x1][y1] = tmp;
    
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    
    AGGameItemTransition *itemTransition = [AGGameItemTransition new];
    itemTransition.x0 = x0;
    itemTransition.y0 = y0;
    itemTransition.x1 = x1;
    itemTransition.y1 = y1;
    itemTransition.type = [self.gameField[x0][y0] integerValue];
    [newItemTransitions addObject:itemTransition];
    
    itemTransition = [AGGameItemTransition new];
    itemTransition.x0 = x1;
    itemTransition.y0 = y1;
    itemTransition.x1 = x0;
    itemTransition.y1 = y0;
    itemTransition.type = [self.gameField[x1][y1] integerValue];
    [newItemTransitions addObject:itemTransition];
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    self.userX0 = x0;
    self.userY0 = y0;
    self.userX1 = x1;
    self.userY1 = y1;
    
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
    NSMutableArray *matchingItems = [NSMutableArray arrayWithCapacity:10];
    
    //C
    size_t array_size = self.itemTypesCount * sizeof(NSUInteger);
    NSUInteger *counters = (NSUInteger*)malloc(array_size);
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        memset(counters, 0, array_size);
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            NSUInteger currentValue = [self.gameField[i][j] unsignedIntegerValue];
            NSUInteger nextValue = INT_MAX;
            if (j < self.verticalItemsCount-1) {
                nextValue = [self.gameField[i][j+1] unsignedIntegerValue];
            }
            counters[currentValue]++;
            if (currentValue != nextValue) {
                NSUInteger sequence_length = counters[currentValue];
                if (sequence_length >=3 ) {
                    AGMatchingSequence *matchingSequence = [AGMatchingSequence new];
                    matchingSequence.i0 = i;
                    matchingSequence.j0 = j - sequence_length + 1;
                    matchingSequence.i1 = i;
                    matchingSequence.j1 = j;
                    [matchingItems addObject:matchingSequence];
                }
                counters[currentValue] = 0;
            }
        }
    }
    
    for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
        memset(counters, 0, array_size);
        for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
            NSUInteger currentValue = [self.gameField[i][j] unsignedIntegerValue];
            NSUInteger nextValue = INT_MAX;
            if (i < self.horizontalItemsCount-1) {
                nextValue = [self.gameField[i+1][j] unsignedIntegerValue];
            }
            counters[currentValue]++;
            if (currentValue != nextValue) {
                NSUInteger sequence_length = counters[currentValue];
                if (sequence_length >=3 ) {
                    AGMatchingSequence *matchingSequence = [AGMatchingSequence new];
                    matchingSequence.i0 = i - sequence_length + 1;
                    matchingSequence.j0 = j;
                    matchingSequence.i1 = i;
                    matchingSequence.j1 = j;
                    [matchingItems addObject:matchingSequence];
                }
                counters[currentValue] = 0;
            }
        }
    }
    
    free(counters);
    //end of C
    
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
        for (NSInteger j = self.verticalItemsCount - 1; j >= 0; j--) {
            if (self.gameField[i][j] == [NSNull null]) {
                
                AGGameItemTransition *itemTransition = [AGGameItemTransition new];
                itemTransition.x0 = i;
                itemTransition.x1 = i;
                itemTransition.y1 = j;
                itemTransition.y0 = j - self.verticalItemsCount;
                
                NSUInteger newItemType = [self generateNewItemType];
                self.gameField[i][j] = @(newItemType);
                itemTransition.type = newItemType;
                
                for (NSInteger k = j - 1; k >= 0; k--) {
                    if (self.gameField[i][k] != [NSNull null]) {
                        self.gameField[i][j] = self.gameField[i][k];
                        self.gameField[i][k] = [NSNull null];
                        itemTransition.y0 = k;
                        itemTransition.type = [self.gameField[i][j] integerValue];
                        break;
                    }
                }
                
                [newItemTransitions addObject:itemTransition];
            }
        }
    }
    
    [self notifyAboutItemsMovement:newItemTransitions];
    [self checkMatchingItems];
}

- (void)deleteItems:(NSArray*)matchingSequences {
    
    for (AGMatchingSequence *matchingSequence in matchingSequences) {
        for (NSUInteger i = matchingSequence.i0; i <= matchingSequence.i1; i++) {
            for (NSUInteger j = matchingSequence.j0; j <= matchingSequence.j1; j++) {
                self.gameField[i][j] = [NSNull null];
            }
        }
    }
    
    [self notifyAboutItemsDeletion:matchingSequences];
    [self fillGaps];
}

- (void)revertUserAction {
    
    NSUInteger x0 = self.userX0;
    NSUInteger y0 = self.userY0;
    NSUInteger x1 = self.userX1;
    NSUInteger y1 = self.userY1;
    
    id tmp = self.gameField[x0][y0];
    self.gameField[x0][y0] = self.gameField[x1][y1];
    self.gameField[x1][y1] = tmp;
    
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    
    AGGameItemTransition *itemTransition = [AGGameItemTransition new];
    itemTransition.x0 = x0;
    itemTransition.y0 = y0;
    itemTransition.x1 = x1;
    itemTransition.y1 = y1;
    itemTransition.type = [self.gameField[x0][y0] integerValue];
    [newItemTransitions addObject:itemTransition];
    
    itemTransition = [AGGameItemTransition new];
    itemTransition.x0 = x1;
    itemTransition.y0 = y1;
    itemTransition.x1 = x0;
    itemTransition.y1 = y0;
    itemTransition.type = [self.gameField[x1][y1] integerValue];
    [newItemTransitions addObject:itemTransition];
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    self.canRevertUserAction = NO;
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
