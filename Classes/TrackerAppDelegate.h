//
//  TrackerAppDelegate.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackerViewController;

extern NSString *const PTTrackerSynchingObjectContext;

@interface TrackerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TrackerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TrackerViewController *viewController;

@end

