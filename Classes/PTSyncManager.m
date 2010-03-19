//
//  SyncManager.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTSyncManager.h"
#import "PTTrackerRemoteModel.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObjectContext+SimpleFetches.h"

NSString *const PTSyncManagerWillSyncNotification = @"PTSyncManagerWillSyncNotification";
NSString *const PTSyncManagerDidSyncNotification  = @"PTSyncManagerDidSyncNotification";

@implementation PTSyncManager

@synthesize managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
{
  if (self == [super init]) {
    managedObjectContext = [context retain];
  }
  return self;
}

- (void)dealloc;
{
  [managedObjectContext release];
  [super dealloc];
}

- (void)synchronizeRemote:(id)remoteModel;
{
  NSAssert1([remoteModel respondsToSelector:@selector(findAllRemote:)], 
      @"Class %@ should respond to findAllRemote:", remoteModel);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerWillSyncNotification object:self];
  
  [remoteModel performSelector:@selector(findAllRemote:) withObject:self];
}

#pragma mark PTResultsDelegate methods

- (void)remoteModel:(id)modelKlass didFinishLoading:(NSArray *)results;
{
  NSString *entityName = [modelKlass performSelector:@selector(entityName)];
  NSEntityDescription *entity = [managedObjectContext entityDescriptionForName:entityName];
  
  // TODO it seems wrong that remoteId is hardcoded here, what if I want to use UUID instead?
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteId in %@", [results valueForKeyPath:@"remoteId"]];
  NSSet *managedObjectsForResultsSet = [[NSSet alloc] initWithArray:
    [managedObjectContext fetchAllOfEntity:entity predicate:predicate error:nil]];
  
  // delete all objects that no longer exist on the server
  NSMutableSet *allObjectSet = [[NSMutableSet alloc] initWithArray:
    [managedObjectContext fetchAllOfEntity:entity error:nil]];
  [allObjectSet minusSet:managedObjectsForResultsSet];
  
  for (NSManagedObject *object in allObjectSet) {
    [managedObjectContext deleteObject:object];
  }
  [allObjectSet release];
  
  // the reason I'm munging this into dictionary keyed by remote ID is to make it easier
  // to look up an existing NSManagedObject for a given record, perhaps there is a better way?
  NSMutableDictionary *managedObjectsByRemoteId = [NSMutableDictionary dictionary];
  for (NSManagedObject *object in managedObjectsForResultsSet) {
    [managedObjectsByRemoteId setObject:object forKey:[object valueForKey:@"remoteId"]];
  }
  
  for (PTTrackerRemoteModel *record in results) {
    NSManagedObject *managedObject = [managedObjectsByRemoteId objectForKey:record.remoteId];
    
    [record setManagedObject:managedObject isMaster:NO];
    
    if (record.managedObject == nil) {
      NSManagedObject *newObject = [managedObjectContext insertNewObjectForEntityWithName:record.entityName];
      [record setManagedObject:newObject isMaster:NO];
    }
  }
  [managedObjectContext save:nil];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

@end
