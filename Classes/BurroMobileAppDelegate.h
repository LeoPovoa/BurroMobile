//
//  BurroMobileAppDelegate.h
//  BurroMobile
//
//  Created by Carlos Leonardo Ramos Póvoa on 01/02/10.
//  Copyright LogGeo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BurroMobileViewController;

@interface BurroMobileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BurroMobileViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BurroMobileViewController *viewController;

@end

