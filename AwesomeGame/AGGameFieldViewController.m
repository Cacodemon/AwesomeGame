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

@interface AGGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) AGGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;

- (void)configureGame;
- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j;
- (AGGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (AGGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation AGGameFieldViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribeToNotifications];
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
    AGGameItemView *itemView = [[AGGameItemView alloc] initWithFrame:frame];
    
    itemView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    
    itemView.translatesAutoresizingMaskIntoConstraints = YES;
    itemView.type = type;
    
    [self.gameItemsView addSubview:itemView];
    
    return itemView;
}

- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j {
    CGPoint result = CGPointMake(i * self.itemSize.width, j * self.itemSize.height);
    return result;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:AGGameItemsDidDeleteNotification object:nil];
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification {
    
    NSArray *itemTransitions = notification.userInfo[kAGGameItemTransitions];
    
    for (AGGameItemTransition *itemTransition in itemTransitions) {
    
        AGGameItemView *gameItemView = [self gameItemViewAtI:itemTransition.x0 j:itemTransition.y0 type:itemTransition.type];
        
        CGRect endFrame = CGRectZero;
        endFrame.size = gameItemView.frame.size;
        endFrame.origin = [self xyCoordinatesFromI:itemTransition.x1 j:itemTransition.y1];
        
        [UIView animateWithDuration:1 animations:^{
            gameItemView.frame = endFrame;
        } completion:^(BOOL finished) {
            self.gameField[itemTransition.x1][itemTransition.y1] = gameItemView;
        }];
    }
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification {
    
}

@end
