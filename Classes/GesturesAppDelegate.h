//
//  GesturesAppDelegate.h
//  Gestures
//
//  Created by David Altenburg on 10/6/08.
//  Copyright David Altenburg 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface GesturesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

