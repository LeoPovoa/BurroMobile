//
//  BurroMobileAppDelegate.m
//  BurroMobile
//
//  Created by Carlos Leonardo Ramos Póvoa on 01/02/10.
//  Copyright LogGeo 2010. All rights reserved.
//

#import "BurroMobileAppDelegate.h"
#import "BurroMobileViewController.h"

@implementation BurroMobileAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
