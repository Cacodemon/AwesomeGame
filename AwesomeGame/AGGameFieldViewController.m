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
- (CGPoint)CGPointFromAGPoint:(AGPoint)p;
- (AGPoint)AGPointFromCGPoint:(CGPoint)p;
- (AGGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (AGGameItemView*)gameItemViewAtPoint:(AGPoint)p type:(NSUInteger)type;

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

- (CGPoint)CGPointFromAGPoint:(AGPoint)p {
    CGPoint result = CGPointMake((p.i * self.itemSize.width), (p.j * self.itemSize.height));
    return result;
}

- (AGPoint)AGPointFromCGPoint:(CGPoint)p {
    AGPoint result = AGPointMake((p.x / self.itemSize.width), (p.y / self.itemSize.height));
    return result;
}

- (AGGameItemView*)gameItemViewAtPoint:(AGPoint)p type:(NSUInteger)type {
    
    AGGameItemView *result = nil;
    
    if ((p.i >= 0) && (p.i < self.horizontalItemsCount) && (p.j >= 0) && (p.j < self.verticalItemsCount)) {
        result = self.gameField[p.i][p.j];
    }
    
    if ((result == nil) || (result == (AGGameItemView*)[NSNull null])) {
        CGRect frame = CGRectZero;
        frame.origin = [self CGPointFromAGPoint:p];
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
        
        for (NSValue *value in itemTransitions) {
            
            AGGameItemTransition itemTransition;
            [value getValue:&itemTransition];
            
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AGGameItemView *gameItemView = [self gameItemViewAtPoint:AGPointMake(itemTransition.p0.i, itemTransition.p0.j) type:itemTransition.type];
                CGRect endFrame = CGRectZero;
                endFrame.size = gameItemView.frame.size;
                endFrame.origin = [self CGPointFromAGPoint:AGPointMake(itemTransition.p1.i, itemTransition.p1.j)];
        
                [UIView animateWithDuration:animationDuration animations:^{
                    gameItemView.frame = endFrame;
                } completion:^(BOOL finished) {
                    self.gameField[itemTransition.p1.i][itemTransition.p1.j] = gameItemView;
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
    
    for (NSValue *value in matchingSequences) {
        AGPointRange range;
        [value getValue:&range];
        for (NSUInteger i = range.p0.i; i <= range.p1.i; i++) {
            for (NSUInteger j = range.p0.j; j <= range.p1.j; j++) {
                [deletedItemsPositions addObject:@(AGPointMake(i, j))];
            }
        }
    }
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for (NSValue *value in deletedItemsPositions) {
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AGPoint p;
                [value getValue:&p];
                
                [UIView animateWithDuration:animationDuration animations:^{
                        [self.gameField[p.i][p.j] setAlpha:0.0];
                } completion:^(BOOL finished) {
                        [self.gameField[p.i][p.j] removeFromSuperview];
                        self.gameField[p.i][p.j] = [NSNull null];
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
            
            AGPoint p0 = [self AGPointFromCGPoint:startingLocation];
            
            if (fabs(deltaX) > fabs(deltaY)) {
                if (deltaX > 0) {
                    if (p0.i < (self.horizontalItemsCount - 1)) {
                        AGPoint p1 = AGPointMake((p0.i + 1), p0.j);
                        [self.gameEngine swapItemAtPiont0:p0 withItemAtPoint1:p1];
                    }
                } else {
                    if (p0.i > 0) {
                        AGPoint p1 = AGPointMake((p0.i - 1), p0.j);
                        [self.gameEngine swapItemAtPiont0:p0 withItemAtPoint1:p1];
                    }
                }
            } else {
                if (deltaY > 0) {
                    if (p0.j < (self.verticalItemsCount - 1)) {
                        AGPoint p1 = AGPointMake(p0.i, (p0.j + 1));
                        [self.gameEngine swapItemAtPiont0:p0 withItemAtPoint1:p1];
                    }
                } else {
                    if (p0.j > 0) {
                        AGPoint p1 = AGPointMake(p0.i, (p0.j - 1));
                        [self.gameEngine swapItemAtPiont0:p0 withItemAtPoint1:p1];
                    }
                }
            }
        }
    }
}

@end
