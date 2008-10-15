//
//  GestureDefinition.m
//  Gestures
//
//  Created by David Altenburg on 10/13/08.
//  Copyright 2008 David Altenburg. All rights reserved.
//

#import "GestureDefinition.h"


@implementation GestureDefinition

@synthesize name;

// Give it a points array. This will free the points array when the object is released. You've been warned.
- (id) initFromPoints:(CGPoint *)pointsAry withCount:(int) count {
	points = pointsAry;
	pointCount = count;
	return self;
}


- (CGPoint *) points {
	return points;
}

- (void) dealloc {
	if (points) {
		free(points);
	}
	[name release];
	[super dealloc];
}

@end
