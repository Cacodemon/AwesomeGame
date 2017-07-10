//
//  AGHighscoresManager.m
//  AwesomeGame
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGHighscoresManager.h"

#define USE_DUMMY_RECORDS

NSString * const kHighscoresPlace = @"kHighscoresPlace";
NSString * const kHighscoresDate = @"kHighscoresDate";
NSString * const kHighscoresScores = @"kHighscoresScores";

static AGHighscoresManager *sharedInstance;

@implementation AGHighscoresManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AGHighscoresManager new];
    });
    return sharedInstance;
}

- (void)addRecord:(NSUInteger)scores {
    //TBD
}

- (NSArray*)allRecords {
    
    NSArray *result = [NSArray new];
    
#ifdef USE_DUMMY_RECORDS
    result = @[
               @{
                   kHighscoresPlace   : @"1",
                   kHighscoresDate    : @"01.02.2017",
                   kHighscoresScores  : @"984837218"
                   },
               @{
                   kHighscoresPlace   : @"2",
                   kHighscoresDate    : @"23.01.2017",
                   kHighscoresScores  : @"98483721"
                   },
               @{
                   kHighscoresPlace   : @"3",
                   kHighscoresDate    : @"11.03.2017",
                   kHighscoresScores  : @"84837218"
                   },
               @{
                   kHighscoresPlace   : @"4",
                   kHighscoresDate    : @"02.02.2017",
                   kHighscoresScores  : @"8437218"
                   },@{
                   kHighscoresPlace   : @"5",
                   kHighscoresDate    : @"09.05.2017",
                   kHighscoresScores  : @"937218"
                   },
               @{
                   kHighscoresPlace   : @"6",
                   kHighscoresDate    : @"13.12.2016",
                   kHighscoresScores  : @"48218"
                   }
               ];
#endif //USE_DUMMY_RECORDS
    
    return result;
}

@end
