//
//  Gesture.h
//  Gestures
//
//  Created by David Altenburg on 10/8/08.
//  Copyright 2008 David Altenburg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchedGesture.h"
#import "GestureDefinition.h"

#define GESTURE_POINT_COUNT 32

@interface Gesture : NSObject {

}

+ (GestureDefinition *) defineGestureFromPoints:(CGPoint [])points withCount:(int)count;
+ (MatchedGesture *) findMatchFor:(CGPoint [])points withCount:(int)count fromDefinitions:(NSArray *)gestureDefinitions;

@end
