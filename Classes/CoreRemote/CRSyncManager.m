//
//  SyncManager.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "CRSyncManager.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObjectContext+SimpleFetches.h"
#import "CRManagedObject.h"
#import "CRRemoteObject.h"
#import "CRSynchronizedObject.h"

NSString *const PTSyncManagerWillSyncNotification = @"PTSyncManagerWillSyncNotification";
NSString *const PTSyncManagerDidSyncNotification  = @"PTSyncManagerDidSyncNotification";

@implementation CRSyncManager

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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [managedObjectContext release];
  [super dealloc];
}

/*
 The sync managed needs to observe changes to any other managed object context in the app
 that may be used to change data, so it can detect those changes and update the remote
 objects accordingly.
 */
- (void)observeChangesToManagedObjectContext:(NSManagedObjectContext *)context;
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherManagedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)synchronizeFromRemote:(Class<CRRemoteObject>)remoteModelKlass;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerWillSyncNotification object:self];
  [remoteModelKlass fetchRemote:self];
}

/* 
 This method is called when any managed object context's that the SyncManager
 is observing are updated. This will typically be the main context being used
 by the app on the main thread.
*/
- (void)otherManagedObjectContextDidSave:(NSNotification *)note;
{
  [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerWillSyncNotification object:self];
  
  // we need to sync any new and updated objects up to the server
  NSSet *insertedObjects = [note.userInfo objectForKey:NSInsertedObjectsKey];
  NSSet *updatedObjects  = [note.userInfo objectForKey:NSUpdatedObjectsKey];
  
  for (CRManagedObject *managedObject in [insertedObjects setByAddingObjectsFromSet:updatedObjects]) {
    if (managedObject.remoteObject.remoteId) {
      [managedObject.remoteObject updateRemote:self];
    } else {
      [managedObject.remoteObject createRemote:self];
    }
  }
  
  // we also need to tell the server about any deleted objects
  for (CRManagedObject *managedObject in [note.userInfo objectForKey:NSDeletedObjectsKey]) {
    [managedObject.remoteObject deleteRemote:self];
  }
}

#pragma mark -
#pragma mark CRResultsDelegate methods

- (void)remoteModel:(id)modelKlass didFetch:(NSArray *)results
{
  NSString *entityName = [modelKlass entityName];
  NSEntityDescription *entity = [managedObjectContext entityDescriptionForName:entityName];
  
  [managedObjectContext fetchAllOfEntity:entity error:nil];
  
  // TODO it seems wrong that remoteId is hardcoded here, what if I want to use UUID instead?
  NSPredicate *matchingIdPredicate = [NSPredicate predicateWithFormat:@"remoteId in %@", [results valueForKeyPath:@"remoteId"]];
  NSSet *managedObjectsForResultsSet = [[NSSet alloc] initWithArray:
    [managedObjectContext fetchAllOfEntity:entity predicate:matchingIdPredicate error:nil]];

  // delete all objects that no longer exist on the server
  NSPredicate *hasRemoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId <> NIL"];
  NSMutableSet *allObjectSet = [[NSMutableSet alloc] initWithArray:
    [managedObjectContext fetchAllOfEntity:entity predicate:hasRemoteIdPredicate error:nil]];
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
  
  for (id<CRSynchronizedObject> remoteObject in results) {
    CRManagedObject *managedObject = [managedObjectsByRemoteId objectForKey:remoteObject.remoteId];

    if (managedObject != nil) {
      [remoteObject syncManagedObjectWithSelf:managedObject];
    } else {
      [remoteObject initializeInManagedObjectContext:self.managedObjectContext];
    }
  }
  // now post all local only objects back up to the server
  NSPredicate *localOnlyPredicate = [NSPredicate predicateWithFormat:@"remoteId = NIL"];
  NSArray *localObjects = [managedObjectContext fetchAllOfEntity:entity predicate:localOnlyPredicate error:nil];
  for (CRManagedObject *object in localObjects) {
    id<CRRemoteObject> modelInstance = [[(Class)modelKlass alloc] initWithManagedObject:object];
    [modelInstance createRemote:self];
  }
  
  [managedObjectContext save:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

- (void)remoteModel:(id)modelKlass didCreate:(id<CRRemoteObject>)remoteObject;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
  
  id<CRSynchronizedObject>synchronizedObject = (id<CRSynchronizedObject>)remoteObject;
  
  // we now need to get the faulted object in the sync context; we can't use the 
  // managedObject from the remoteObject directly as it belongs to the main thread context.
  CRManagedObject *managedObject = (CRManagedObject *)[self.managedObjectContext objectWithID:synchronizedObject.managedObjectID];
  [synchronizedObject syncManagedObjectWithSelf:managedObject];
  [self.managedObjectContext save:nil];
}

- (void)remoteModel:(id)modelKlass didUpdate:(id<CRRemoteObject>)remoteObject;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

- (void)remoteModel:(id)modelKlass didDelete:(id<CRRemoteObject>)remoteObject;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

@end
