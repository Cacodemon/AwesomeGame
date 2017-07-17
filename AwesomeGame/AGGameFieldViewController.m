//
//  AGGameFieldViewController.m
//  Lesson03
//
//  Created by user on 7/7/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGGameFieldViewController.h"
#import "AGGameItemView.h"

@interface AGGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;

@end

@implementation AGGameFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger n = 5;
    NSUInteger m = 5;
    
    CGFloat margin = 5;
    
    CGFloat containerWidth = self.gameItemsView.frame.size.width;
    CGFloat containerHeight = self.gameItemsView.frame.size.height;
    
    CGFloat itemWidth = (containerWidth / (CGFloat)n);
    CGFloat itemHeight = (containerHeight / (CGFloat)m);
    
    for (NSUInteger i = 0; i < n; i++) {
        for (NSUInteger j = 0; j < m; j++) {
            CGFloat itemX = i * itemWidth;
            CGFloat itemY = j * itemHeight;
            CGRect itemFrame = CGRectMake(itemX + margin, itemY + margin, itemWidth - margin * 2, itemHeight - margin * 2);
            AGGameItemView *itemView = [[AGGameItemView alloc] initWithFrame:itemFrame];
            
            itemView.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleBottomMargin;
            
            itemView.translatesAutoresizingMaskIntoConstraints = YES;
            itemView.backgroundColor = [UIColor redColor];
            
            [self.gameItemsView addSubview:itemView];
        }
    }
}

@end
