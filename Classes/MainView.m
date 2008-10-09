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
	
}

- (void)drawRect:(CGRect)rect {
	
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 20.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	CGPoint *buffer = (CGPoint *) malloc(sizeof(CGPoint) * [points count]);
	for (int i = 0; i < [points count]; i++) {
		[[points objectAtIndex:i] getValue:&buffer[i]];
	}
	CGContextAddLines(context, buffer, [points count]);
	CGContextStrokePath(context);
	free(buffer);

}


- (void) drawTracedLine {
	[self setNeedsDisplay];
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
	[points removeAllObjects];
	[self addTracedPoint:touches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesEnded");
	[self addTracedPoint:touches];
	[self drawTracedLine];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesMoved");
	[self addTracedPoint:touches];
	[self drawTracedLine];
}


- (void)dealloc {
	[points release];
    [super dealloc];
}





@end
