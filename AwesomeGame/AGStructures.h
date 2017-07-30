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
typedef struct AGIntegerPoint AGPoint;

extern const AGPoint AGPiontZero;

static inline AGPoint AGPointMake(NSUInteger i, NSUInteger j)
{
    AGPoint p; p.i = i; p.j = j; return p;
}

#endif /* AGStructures_h */
