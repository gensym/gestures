//
//  MainView.m
//  Gestures
//
//  Created by David Altenburg on 10/6/08.
//  Copyright David Altenburg 2008. All rights reserved.
//

#import "MainView.h"

@implementation MainView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	NSLog(@"Init");
	points = [[NSMutableArray alloc] initWithCapacity:32];
	definedGestures = [[NSMutableArray alloc] initWithCapacity:8];
	
	
	CGPoint firstGesture[] = {CGPointMake(-1, -1), CGPointMake(-1, 1), CGPointMake(1, 1), CGPointMake(1, -1)};
	[definedGestures addObject:[Gesture defineGestureFromPoints:firstGesture withCount:4]];

	CGPoint secondGesture[] = {CGPointMake(-1, 0), CGPointMake(1, 0)};
	[definedGestures addObject:[Gesture defineGestureFromPoints:secondGesture withCount:2]];
	
	currentGesture = nil;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 20.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	CGPoint *buffer = (CGPoint *) calloc([points count], sizeof(CGPoint));
	for (int i = 0; i < [points count]; i++) {
		[[points objectAtIndex:i] getValue:&buffer[i]];
	}
	CGContextAddLines(context, buffer, [points count]);
	CGContextStrokePath(context);
	free(buffer);
	
	if (currentGesture) {
		CGContextSetLineWidth(context, 5.0);
		CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
		int count = [currentGesture count];
		CGPoint *gesturePoints = calloc(count, sizeof(CGPoint));
		[currentGesture getPoints:gesturePoints withCount:count];
		CGContextAddLines(context, gesturePoints, count);
		CGContextStrokePath(context);
		free(gesturePoints);
	}
}

- (void) addTracedPoint:(NSSet *)touches {
	if ([touches count] > 0) {
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:self];
		lastPoint = point;
		[points addObject:[NSValue valueWithCGPoint:point]];
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesBegan");
	if (currentGesture != nil) {
		[currentGesture release];
		currentGesture = nil;
	}
	[points removeAllObjects];
	[self addTracedPoint:touches];
}

- (void) matchGesturesToPoints {
	CGPoint *buffer = (CGPoint *) calloc([points count], sizeof(CGPoint));
	for (int i = 0; i < [points count]; i++) {
		[[points objectAtIndex:i] getValue:&buffer[i]];
	}
	currentGesture = [Gesture findMatchFor:buffer withCount:[points count] fromDefinitions:definedGestures];
	[currentGesture retain];
	free(buffer);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesEnded");
	[self addTracedPoint:touches];
	[self matchGesturesToPoints];
	[self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesMoved");
	[self addTracedPoint:touches];
	[self setNeedsDisplay];
} 

- (void)dealloc {
	[points release];
	[definedGestures release];
	[currentGesture release];
    [super dealloc];
}

@end
