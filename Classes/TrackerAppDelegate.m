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
#import "PTSyncManager.h"

NSString *const PTTrackerSynchingObjectContext = @"TrackerSynchingObjectContext";

@implementation TrackerAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize viewController;
@synthesize syncManager;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  NSPersistentStoreCoordinator *coordinator = [CoreDataManager newPersistentStoreCoordinatorForModel:[NSManagedObjectModel mergedModelFromBundles:nil] withStoreType:NSSQLiteStoreType storePath:@"Tracker.sqlite"];
  [[CoreDataManager sharedManager] setPersistentStoreCoordinator:coordinator];
  [coordinator release];
  
  [[CoreDataManager sharedManager] registerDefaultManagedObjectContext];
  
  NSManagedObjectContext *syncContext = [[CoreDataManager sharedManager] 
    registerNewManagedObjectContextForKey:PTTrackerSynchingObjectContext isDefault:NO];
  
  syncManager = [[PTSyncManager alloc] initWithManagedObjectContext:syncContext];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncManagerWillSync:) name:PTSyncManagerWillSyncNotification object:self.syncManager];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncManagerDidSync:)  name:PTSyncManagerDidSyncNotification object:self.syncManager];

  viewController.managedObjectContext = [[CoreDataManager sharedManager] defaultManagedObjectContext];
  viewController.syncManager = self.syncManager;
  
  [window addSubview:navigationController.view];
  [window makeKeyAndVisible];
}

- (void)dealloc 
{
  [navigationController release];
  [syncManager release];
  [viewController release];
  [window release];
  [super dealloc];
}

#pragma mark -
#pragma mark PTSyncManager network activity indication

- (void)syncManagerWillSync:(NSNotification *)note;
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)syncManagerDidSync:(NSNotification *)note;
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
