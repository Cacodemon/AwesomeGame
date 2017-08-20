//
//  NSValue+AwesomeGame.h
//  AwesomeGame
//
//  Created by user on 8/18/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGStructures.h"

@interface NSValue (AwesomeGame)

- (AGPoint)agPoint;
- (AGPointRange)agPointRange;
- (AGGameItemTransition)agGameItemTransition;

@end
