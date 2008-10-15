//
//  Gesture.m
//  Gestures
//
//  Created by David Altenburg on 10/8/08.
//  Copyright 2008 David Altenburg. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture
+ (void) debugPoints:(CGPoint [])points withCount:(int) count withName:(NSString *)name {
	NSLog(@"DEBUG POINTS: ");
	NSLog(name);
	NSLog(@"[");
	for (int i = 0; i < count; i++) {
		NSLog(@"{ %f, %f }", points[i].x, points[i].y);
	}
	NSLog(@"]");
	
}



+ (CGFloat) scalePath:(CGPoint[])src toPath:(CGPoint[])dest withCount:(int)count {
	CGFloat minX = src[0].x;
	CGFloat minY = src[0].y;
	CGFloat maxX = src[0].x;
	CGFloat maxY = src[0].y;
	
	for (int i = 1; i < count; i++) {
		CGPoint point = src[i];
		if (point.x < minX) minX = point.x;
		if (point.x > maxX) maxX = point.x;
		if (point.y < minY) minY = point.y;
		if (point.y > maxY) maxY = point.y;
	}
	
	CGFloat width = maxX - minX;
	CGFloat height = maxY - minY;
	
	CGFloat scale = ((width > height) ? width : height);

	for (int i = 0; i < count; i++) {
		dest[i] = CGPointMake(src[i].x / scale, src[i].y / scale);
	}
	
	return scale;
}

+ (CGFloat) pathLength: (CGPoint*) src srcCount: (int) srcCount  {
  CGFloat length = 0.0;
	CGPoint lastPoint = src[0];
	for (int i = 1; i < srcCount; i++) {
		CGPoint	currentPoint = src[i];
		CGFloat distX = currentPoint.x - lastPoint.x;
		CGFloat distY = currentPoint.y - lastPoint.y;
		length += sqrtf(distX * distX + distY * distY);
		lastPoint = currentPoint;
	}
  return length;
}

+ (void) spacePath:(CGPoint [])src withSourceCount:(int)srcCount withTargetPath:(CGPoint[])dest withTargetCount:(int)destCount {
	CGFloat length = [self pathLength:src srcCount:srcCount];
	CGFloat targetSegmentLength = length / (destCount - 1.0);
	
	dest[0] = src[0]; 
	
	CGPoint lastSrcPoint = src[0];
	CGFloat remainingSegmentLength = targetSegmentLength;

	int src_indx = 1;
	int dest_indx = 1;
	while(dest_indx < destCount && src_indx < srcCount) {
		CGPoint nextSrcPoint = src[src_indx];
		CGFloat currentSegmentLength = sqrtf(powf(nextSrcPoint.x - lastSrcPoint.x, 2) + powf(nextSrcPoint.y - lastSrcPoint.y, 2));

		if (remainingSegmentLength > currentSegmentLength) {
			// Move to the next source segment
			remainingSegmentLength -= currentSegmentLength;
			lastSrcPoint = nextSrcPoint;
			src_indx++;
		} else if (remainingSegmentLength == currentSegmentLength) {
			// Add the target point and move to the next source segment
			dest[dest_indx++] = nextSrcPoint;
			remainingSegmentLength = targetSegmentLength;
			lastSrcPoint = nextSrcPoint;
		} else {
			// The next target point is on this segment
			CGFloat ratio = remainingSegmentLength / currentSegmentLength;
			CGPoint point = CGPointMake(
										lastSrcPoint.x + (nextSrcPoint.x - lastSrcPoint.x) * ratio,
										lastSrcPoint.y + (nextSrcPoint.y - lastSrcPoint.y) * ratio
			);
			dest[dest_indx++] = point;
			remainingSegmentLength = targetSegmentLength;
			lastSrcPoint = point;
		}
	}
	
	// Check to make sure we didn't leave any unfilled points (due to rounding errors)
	while (dest_indx < destCount) {
		dest[dest_indx++] = src[src_indx - 1];
	}
}

// src and target can be the same here. If they're different, they should have the same length
+ (CGPoint) centerPath:(CGPoint [])src withTargetPath:(CGPoint [])target withCount:(int)count {
	CGFloat minX = src[0].x;
	CGFloat minY = src[0].y;
	CGFloat maxX = src[0].x;
	CGFloat maxY = src[0].y;
	
	for (int i = 1; i < count; i++) {
		CGPoint point = src[i];
		if (point.x < minX) minX = point.x;
		if (point.x > maxX) maxX = point.x;
		if (point.y < minY) minY = point.y;
		if (point.y > maxY) maxY = point.y;
	}
	
	CGFloat centerX = (maxX + minX) / 2;
	CGFloat centerY = (maxY + minY) / 2;
	
	for (int i = 0; i < count; i++) {
		CGPoint srcPoint = src[i];
		target[i] = CGPointMake(srcPoint.x - centerX, srcPoint.y - centerY);
	}
	
	return CGPointMake(centerX, centerY);
}

+ (CGFloat) dotProductOfA:(CGPoint [])a withB:(CGPoint [])b withCount:(int)count {
	CGFloat dotProduct = 0.0;
	
	for (int i = 0; i < count; i++) {
		CGPoint	pointA = a[i];
		CGPoint pointB = b[i];
		dotProduct += pointA.x * pointB.x + pointA.y * pointB.y;
	}

	return dotProduct;
}


// Here, we define similarity as the cosine of the angle between them
+ (CGFloat) similarityOfA:(CGPoint [])a withB:(CGPoint [])b withCount:(int) count {  
	// cos a = (u • v) / (sqrt (u • u) * sqrt (v • v))
	CGFloat u_dot_v = [self dotProductOfA:a withB:b withCount:count];
	CGFloat u_dot_u = [self dotProductOfA:a withB:a withCount:count];
	CGFloat v_dot_v = [self dotProductOfA:b withB:b withCount:count];
	
	return fabs(u_dot_v / (sqrtf(u_dot_u) * sqrtf(v_dot_v)));
}

// Source and target can be the same here
+ (void) invertY:(CGPoint[])src withTarget:(CGPoint[])target withCount:(int)count {
	for (int i = 0; i < count; i++) {
		target[i] = CGPointMake(src[i].x, src[i].y * -1);
	}
}

+ (MatchedGesture *) findMatchFor:(CGPoint [])points withCount:(int)count fromDefinitions:(NSArray *)gestureDefinitions {
	CGPoint *centeredPoints = calloc(count, sizeof(CGPoint));
	CGPoint center = [self centerPath:points withTargetPath:centeredPoints withCount:count];
	CGPoint *normalizedPoints = calloc(count, sizeof(CGPoint));
	CGFloat scale = [self scalePath:centeredPoints toPath:normalizedPoints withCount:count];
	CGPoint *spacedPoints = calloc(GESTURE_POINT_COUNT, sizeof(CGPoint));
	[self spacePath:normalizedPoints withSourceCount:count withTargetPath:spacedPoints withTargetCount:GESTURE_POINT_COUNT];
	
	CGFloat maxMatch = 0.0;
	GestureDefinition *bestMatch = NULL;
	
	for (GestureDefinition *candidate in gestureDefinitions) {
		CGFloat currentMatch = [self similarityOfA:spacedPoints withB:[candidate points] withCount:GESTURE_POINT_COUNT];
		if (currentMatch > maxMatch) {
			maxMatch = currentMatch;
			bestMatch = candidate;
		}
	}
	
	free(normalizedPoints);
	free(spacedPoints);
	
	if (bestMatch) {
		CGPoint *matchedPoints = calloc(GESTURE_POINT_COUNT, sizeof(CGPoint));
		for (int i = 0; i < GESTURE_POINT_COUNT; i++) {
			CGPoint point = [bestMatch points][i];
			matchedPoints[i] = CGPointMake((point.x * scale + center.x), (point.y * scale + center.y));
			// todo - figure out what we should do about autoreleasing this
		}
		[self debugPoints:matchedPoints withCount:GESTURE_POINT_COUNT withName:@"Best match points"];
		return [[[MatchedGesture alloc] initFromPoints:matchedPoints withCount:GESTURE_POINT_COUNT] autorelease];
	} 
	
	// No match
	return NULL;
}

+ (GestureDefinition *)defineGestureFromPoints:(CGPoint [])points withCount:(int)count {
	[self debugPoints:points withCount:count withName:@"Passed in"];
	CGPoint *centeredPoints = calloc(count, sizeof(CGPoint));
	[self centerPath:points withTargetPath:centeredPoints withCount:count];
	[self invertY:centeredPoints withTarget:centeredPoints withCount:count];
	CGPoint *normalizedPoints = calloc(count, sizeof(CGPoint));
	[self scalePath:centeredPoints toPath:normalizedPoints withCount:count];
	[self debugPoints:normalizedPoints withCount:count withName:@"Scaled Points"];
	CGPoint *spacedPoints = calloc(GESTURE_POINT_COUNT, sizeof(CGPoint));
	[self spacePath:normalizedPoints withSourceCount:count withTargetPath:spacedPoints withTargetCount:GESTURE_POINT_COUNT];
	[self debugPoints:spacedPoints withCount:GESTURE_POINT_COUNT withName:@"Spaced Points"];
	free(normalizedPoints);
	return [[[GestureDefinition alloc] initFromPoints:spacedPoints withCount:GESTURE_POINT_COUNT] autorelease];
}


@end
