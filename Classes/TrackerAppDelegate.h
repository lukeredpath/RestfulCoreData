//
//  TrackerAppDelegate.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackerViewController;
@class CRSyncManager;
@class CoreDataManager;

extern NSString *const PTTrackerSynchingObjectContext;

@interface TrackerAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;
  TrackerViewController *viewController;
  CoreDataManager *coreDataManager;
  CRSyncManager *syncManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet TrackerViewController *viewController;
@property (nonatomic, retain) IBOutlet CoreDataManager *coreDataManager;
@property (nonatomic, retain) CRSyncManager *syncManager;

@end

