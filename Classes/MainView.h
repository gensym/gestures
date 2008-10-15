//
//  MainView.h
//  Gestures
//
//  Created by David Altenburg on 10/6/08.
//  Copyright David Altenburg 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MatchedGesture.h"
#import "GestureDefinition.h"
#import "Gesture.h"

@interface MainView : UIView {
	NSMutableArray	*points;
	CGPoint			lastPoint;
	MatchedGesture  *currentGesture;
	NSMutableArray			*definedGestures;
}

@end
