//
//  NSValue+AwesomeGame.m
//  AwesomeGame
//
//  Created by user on 8/18/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NSValue+AwesomeGame.h"

@implementation NSValue (AwesomeGame)

- (AGPoint)agPoint {
    AGPoint result;
    [self getValue:&result];
    return result;
}

- (AGPointRange)agPointRange {
    AGPointRange result;
    [self getValue:&result];
    return result;
}

- (AGGameItemTransition)agGameItemTransition {
    AGGameItemTransition result;
    [self getValue:&result];
    return result;
}

@end
