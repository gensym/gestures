//
//  GesturesAppDelegate.m
//  Gestures
//
//  Created by David Altenburg on 10/6/08.
//  Copyright David Altenburg 2008. All rights reserved.
//

#import "GesturesAppDelegate.h"
#import "RootViewController.h"

@implementation GesturesAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
