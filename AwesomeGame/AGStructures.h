//
//  AGStructures.h
//  AwesomeGame
//
//  Created by user on 7/30/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef AGStructures_h
#define AGStructures_h

struct AGIntegerPoint {
    NSInteger i;
    NSInteger j;
};
typedef struct AGIntegerPoint AGIntegerPoint;

extern const AGIntegerPoint AGIntegerPiontZero;

static inline AGIntegerPoint AGIntegerPointMake(NSUInteger i, NSUInteger j)
{
    AGIntegerPoint p; p.i = i; p.j = j; return p;
}

#endif /* AGStructures_h */
