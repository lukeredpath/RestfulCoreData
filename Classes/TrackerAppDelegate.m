//
//  TrackerAppDelegate.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "TrackerAppDelegate.h"
#import "TrackerViewController.h"
#import "CoreDataManager.h"

NSString *const PTTrackerSynchingObjectContext = @"TrackerSynchingObjectContext";

@implementation TrackerAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  NSPersistentStoreCoordinator *coordinator = [CoreDataManager newPersistentStoreCoordinatorForModel:[NSManagedObjectModel mergedModelFromBundles:nil] withStoreType:NSSQLiteStoreType storePath:@"Tracker.sqlite"];
  [[CoreDataManager sharedManager] setPersistentStoreCoordinator:coordinator];
  [coordinator release];
  
  [[CoreDataManager sharedManager] registerDefaultManagedObjectContext];
  [[CoreDataManager sharedManager] registerNewManagedObjectContextForKey:PTTrackerSynchingObjectContext isDefault:NO];

  viewController.managedObjectContext = [[CoreDataManager sharedManager] defaultManagedObjectContext];
  
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
}

- (void)dealloc {
  [viewController release];
  [window release];
  [super dealloc];
}

@end
