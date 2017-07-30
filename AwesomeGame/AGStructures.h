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

#pragma mark - Structures

//TODO: make NSValue category for unboxing theese

struct __attribute__((objc_boxable)) AGPoint {
    NSInteger i;
    NSInteger j;
};
typedef struct AGPoint AGPoint;

struct __attribute__((objc_boxable)) AGPointRange {
    AGPoint p0;
    AGPoint p1;
};
typedef struct AGPointRange AGPointRange;

#pragma mark - Constants

extern const AGPoint AGPiontZero;
extern const AGPointRange AGPiontRangeZero;

#pragma mark - Inline Functions

static inline AGPoint AGPointMake(NSInteger i, NSInteger j) {
    AGPoint p;
    p.i = i;
    p.j = j;
    return p;
}

static inline AGPointRange AGPointRangeMake(NSInteger i0, NSInteger j0, NSInteger i1, NSInteger j1) {
    AGPointRange r;
    r.p0 = AGPointMake(i0, j0);
    r.p1 = AGPointMake(i1, j1);
    return r;
}

#endif /* AGStructures_h */
