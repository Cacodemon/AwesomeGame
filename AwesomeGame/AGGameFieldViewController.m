//
//  AGGameFieldViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameFieldViewController.h"
#import "AGGameItemView.h"
#import "AGGameEngine.h"
#import "AGGameItemTransition.h"

static const NSTimeInterval animationDuration = .5;

@interface AGGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) AGGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;

@property (strong) dispatch_queue_t animationQueue;

- (void)configureGame;
- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j;
- (void)getI:(NSInteger*)i j:(NSInteger*)j fromPoint:(CGPoint)point;
- (AGGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (AGGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation AGGameFieldViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationQueue = dispatch_queue_create("com.unique.name.queue", DISPATCH_QUEUE_SERIAL);
    [self subscribeToNotifications];
}

- (void)viewDidLayoutSubviews {
    [self configureGame];
}

- (void)dealloc {
    [self unsubscribeFromNotifications];
}

#pragma mark - Private Methods

- (void)configureGame {
    
    self.horizontalItemsCount = 8;
    self.verticalItemsCount = 8;
    self.itemTypesCount = 5;
    
    self.itemSize = CGSizeMake(self.gameItemsView.frame.size.width / self.horizontalItemsCount,
                               self.gameItemsView.frame.size.height / self.verticalItemsCount);
    
    self.gameField = [NSMutableArray arrayWithCapacity:self.horizontalItemsCount];
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:self.verticalItemsCount];
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            [column addObject:[NSNull null]];
        }
        [self.gameField addObject:column];
    }
    
    self.gameEngine = [[AGGameEngine alloc] initWithHorizontalItemsCount:self.horizontalItemsCount
                                                      verticalItemsCount:self.verticalItemsCount
                                                          itemTypesCount:self.itemTypesCount];
}

- (AGGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type{
    
    AGGameItemView *itemView = [[AGGameItemView alloc] initWithFrame:frame type:type];
    [self.gameItemsView addSubview:itemView];
    return itemView;
}

- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j {
    CGPoint result = CGPointMake(i * self.itemSize.width, j * self.itemSize.height);
    return result;
}

- (void)getI:(NSInteger*)i j:(NSInteger*)j fromPoint:(CGPoint)point {
    *i = point.x / self.itemSize.width;
    *j = point.y / self.itemSize.height;
}

- (AGGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type{
    
    AGGameItemView *result = nil;
    
    if ((i >= 0) && (i < self.horizontalItemsCount) && (j >= 0) && (j < self.verticalItemsCount)) {
        result = self.gameField[i][j];
    }
    
    if ((result == nil) || (result == (AGGameItemView*)[NSNull null])) {
        CGRect frame = CGRectZero;
        frame.origin = [self xyCoordinatesFromI:i j:j];
        frame.size = self.itemSize;
        result = [self createGameItemViewWithFrame:frame type:type];
    }
    
    return result;
}

#pragma mark - Notifications

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:AGGameItemsDidMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidDeleteNotification:) name:AGGameItemsDidDeleteNotification object:nil];
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification {
    
    NSArray *itemTransitions = notification.userInfo[kAGGameItemTransitions];
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for (AGGameItemTransition *itemTransition in itemTransitions) {
            
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AGGameItemView *gameItemView = [self gameItemViewAtI:itemTransition.x0 j:itemTransition.y0 type:itemTransition.type];
                CGRect endFrame = CGRectZero;
                endFrame.size = gameItemView.frame.size;
                endFrame.origin = [self xyCoordinatesFromI:itemTransition.x1 j:itemTransition.y1];
        
                [UIView animateWithDuration:animationDuration animations:^{
                    gameItemView.frame = endFrame;
                } completion:^(BOOL finished) {
                    self.gameField[itemTransition.x1][itemTransition.y1] = gameItemView;
                    dispatch_group_leave(animationGroup);
                }];
            });
        }
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification {
    
    NSArray *matchingSequences = notification.userInfo[kAGGameItems];
    
    NSMutableSet *deletedItemsPositions = [NSMutableSet set];
    
    for (AGMatchingSequence *matchingSequence in matchingSequences) {
        for (NSUInteger i = matchingSequence.startingPoint.i; i <= matchingSequence.endingPoint.i; i++) {
            for (NSUInteger j = matchingSequence.startingPoint.j; j <= matchingSequence.endingPoint.j; j++) {
                [deletedItemsPositions addObject:@{@"i" : @(i), @"j" : @(j)}];
            }
        }
    }
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for (NSDictionary *coordinates in deletedItemsPositions) {
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSUInteger i = [coordinates[@"i"] unsignedIntegerValue];
                NSUInteger j = [coordinates[@"j"] unsignedIntegerValue];
                
                [UIView animateWithDuration:animationDuration animations:^{
                        [self.gameField[i][j] setAlpha:0.0];
                } completion:^(BOOL finished) {
                        [self.gameField[i][j] removeFromSuperview];
                        self.gameField[i][j] = [NSNull null];
                    dispatch_group_leave(animationGroup);
                }];
            });
        }
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
    });
}

#pragma mark - Gesture Recognizers

- (IBAction)didRecognizePan:(UIPanGestureRecognizer *)sender {
    
    static CGPoint startingLocation;
    static CGPoint currentLocation;
    static BOOL finished;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            startingLocation = [sender locationInView:self.gameItemsView];
            currentLocation = startingLocation;
            finished = NO;
            break;
        case UIGestureRecognizerStateChanged:
            currentLocation = [sender locationInView:self.gameItemsView];
            break;
        default:
            return;
    }
    
    if (!finished ) {
        CGFloat deltaX = currentLocation.x - startingLocation.x;
        CGFloat deltaY = currentLocation.y - startingLocation.y;
        
        if ((fabs(deltaX) > (self.itemSize.width / 3)) || (fabs(deltaY) > (self.itemSize.height / 3))) {
            
            finished = YES;

            NSInteger i = 0;
            NSInteger j = 0;
            
            if (fabs(deltaX) > fabs(deltaY)) {
                if (deltaX > 0) {
                    [self getI:&i j:&j fromPoint:startingLocation];
                    if (i < (self.horizontalItemsCount - 1)) {
                        [self.gameEngine swapItemAtPiont0:AGIntegerPointMake(i, j)
                                         withItemAtPoint1:AGIntegerPointMake((i + 1), j)];
                    }
                } else {
                    [self getI:&i j:&j fromPoint:startingLocation];
                    if (i > 0) {
                        [self.gameEngine swapItemAtPiont0:AGIntegerPointMake(i, j)
                                         withItemAtPoint1:AGIntegerPointMake((i - 1), j)];
                    }
                }
            } else {
                if (deltaY > 0) {
                    [self getI:&i j:&j fromPoint:startingLocation];
                    if (j < (self.verticalItemsCount - 1)) {
                        [self.gameEngine swapItemAtPiont0:AGIntegerPointMake(i, j)
                                         withItemAtPoint1:AGIntegerPointMake(i, (j + 1))];
                    }
                } else {
                    [self getI:&i j:&j fromPoint:startingLocation];
                    if (j > 0) {
                        [self.gameEngine swapItemAtPiont0:AGIntegerPointMake(i, j)
                                         withItemAtPoint1:AGIntegerPointMake(i, (j - 1))];
                    }
                }
            }
        }
    }
}

@end
