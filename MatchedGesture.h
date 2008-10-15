//
//  MatchedGesture.h
//  Gestures
//
//  Created by David Altenburg on 10/13/08.
//  Copyright 2008 David Altenburg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MatchedGesture : NSObject {
	NSString *name;
	CGPoint *points;
	int pointCount;
}

@property(nonatomic, retain) NSString *name;

- (id) initFromPoints:(CGPoint *)pointsAry withCount:(int) count;
- (void) getPoints:(CGPoint *)toPopulate withCount:(int) count;
- (int) count;
@end
