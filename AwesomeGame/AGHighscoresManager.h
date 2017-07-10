//
//  AGHighscoresManager.h
//  AwesomeGame
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHighscoresPlace;
extern NSString * const kHighscoresDate;
extern NSString * const kHighscoresScores;

@interface AGHighscoresManager : NSObject

+ (instancetype)sharedInstance;

- (void)addRecord:(NSUInteger)scores;
- (NSArray*)allRecords;

@end
