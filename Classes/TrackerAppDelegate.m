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
#import "PTTrackerRemoteModel.h"
#import "PTProject.h"


NSString *const PTTrackerSynchingObjectContext = @"TrackerSynchingObjectContext";

@implementation TrackerAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize viewController;
@synthesize coreDataManager;
@synthesize syncManager;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [PTTrackerRemoteModel setAPIKey:PT_API_KEY];
  
  self.coreDataManager.persistentStoreCoordinator = [CoreDataManager newPersistentStoreCoordinatorForModel:[NSManagedObjectModel mergedModelFromBundles:nil] withStoreType:NSSQLiteStoreType storePath:@"Tracker.sqlite"];
  
  [self.coreDataManager registerDefaultManagedObjectContext];
  
  NSManagedObjectContext *syncContext = [self.coreDataManager
    registerNewManagedObjectContextForKey:PTTrackerSynchingObjectContext 
                                isDefault:NO];
  
  syncManager = [[PTSyncManager alloc] initWithManagedObjectContext:syncContext];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncManagerWillSync:) name:PTSyncManagerWillSyncNotification object:self.syncManager];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncManagerDidSync:)  name:PTSyncManagerDidSyncNotification object:self.syncManager];

  viewController.managedObjectContext = [self.coreDataManager defaultManagedObjectContext];
  viewController.syncManager = self.syncManager;
  
  [window addSubview:navigationController.view];
  [window makeKeyAndVisible];
}

- (void)dealloc 
{
  [navigationController release];
  [coreDataManager release];
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
