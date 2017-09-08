//
//  AGGameEngine.m
//  AwesomeGame
//
//  Created by user on 7/17/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameEngine.h"
#import "NSValue+AwesomeGame.h"

NSString * const AGGameItemsDidMoveNotification = @"AGGameItemDidMoveNotification";
NSString * const AGGameItemsDidDeleteNotification = @"AGGameItemDidDeleteNotification";
NSString * const kAGGameItems = @"kAGGameItems";
NSString * const kAGGameItemTransitions = @"kAGGameItemTransitions";

@interface AGGameEngine ()

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;

@property BOOL canRevertUserAction;

@property AGPoint point0;
@property AGPoint point1;

//TODO: extract to AGTwoDimentionalArray class

@property (nonatomic, strong) NSMutableArray *gameField;

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;

- (void)_swapItemAtPiont0:(AGPoint)p0 withItemAtPoint1:(AGPoint)p1;
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

- (void)swapItemAtPiont0:(AGPoint)p0
        withItemAtPoint1:(AGPoint)p1 {

    NSLog(@"(%ld; %ld) -> (%ld; %ld)", (long)p0.i, (long)p0.j, (long)p1.i, (long)p1.j);
    
    [self _swapItemAtPiont0:p0 withItemAtPoint1:p1];
    
    self.point0 = p0;
    self.point1 = p1;
    
    [self applyUserAction];
}

#pragma mark - Private

- (void)_swapItemAtPiont0:(AGPoint)p0
         withItemAtPoint1:(AGPoint)p1 {
    
    id tmp = self.gameField[p0.i][p0.j];
    self.gameField[p0.i][p0.j] = self.gameField[p1.i][p1.j];
    self.gameField[p1.i][p1.j] = tmp;
    
    AGGameItemTransition itemTransition1 = AGGameItemTransitionMake(p0.i, p0.j, p1.i, p1.j, [self.gameField[p0.i][p0.j] unsignedIntegerValue]);
    AGGameItemTransition itemTransition2 = AGGameItemTransitionMake(p1.i, p1.j, p0.i, p0.j, [self.gameField[p1.i][p1.j] unsignedIntegerValue]);
    
    [self notifyAboutItemsMovement:@[@(itemTransition1), @(itemTransition2)]];
}

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
                    AGPointRange range = AGPointRangeMake(i, (j - sequence_length + 1), i, j);
                    [matchingItems addObject:@(range)];
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
                    AGPointRange range = AGPointRangeMake((i - sequence_length + 1), j, i, j);
                    [matchingItems addObject:@(range)];
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
                
                NSUInteger newItemType = [self generateNewItemType];
                self.gameField[i][j] = @(newItemType);
                
                AGGameItemTransition itemTransition = AGGameItemTransitionMake(i, (j - self.verticalItemsCount), i, j, newItemType);
                
                for (NSInteger k = j - 1; k >= 0; k--) {
                    if (self.gameField[i][k] != [NSNull null]) {
                        self.gameField[i][j] = self.gameField[i][k];
                        self.gameField[i][k] = [NSNull null];
                        itemTransition.p0.j = k;
                        itemTransition.type = [self.gameField[i][j] integerValue];
                        break;
                    }
                }
                
                [newItemTransitions addObject:@(itemTransition)];
            }
        }
    }
    
    [self notifyAboutItemsMovement:newItemTransitions];
    [self checkMatchingItems];
}

- (void)deleteItems:(NSArray*)matchingSequences {
    
    for (NSValue *value in matchingSequences) {
        AGPointRange range = [value agPointRange];
        for (NSUInteger i = range.p0.i; i <= range.p1.i; i++) {
            for (NSUInteger j = range.p0.j; j <= range.p1.j; j++) {
                self.gameField[i][j] = [NSNull null];
            }
        }
    }
    
    [self notifyAboutItemsDeletion:matchingSequences];
    [self fillGaps];
}

- (void)revertUserAction {
    [self _swapItemAtPiont0:self.point0 withItemAtPoint1:self.point1];
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
