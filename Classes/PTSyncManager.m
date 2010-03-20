//
//  SyncManager.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTSyncManager.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObjectContext+SimpleFetches.h"
#import "PTManagedObject.h"

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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [managedObjectContext release];
  [super dealloc];
}

- (void)observeChangesToManagedObjectContext:(NSManagedObjectContext *)context;
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidUpdate:) name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)synchronizeFromRemote:(Class<PTRemoteObject>)remoteModelKlass;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerWillSyncNotification object:self];
  [remoteModelKlass findAllRemote:self];
}

/* 
 This method is called when any managed object context's that the SyncManager
 is observing are updated. This will typically be the main context being used
 by the app on the main thread.
*/
- (void)managedObjectContextDidUpdate:(NSNotification *)note;
{
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerWillSyncNotification object:self];
  
  // we need to post any newly created objects up to the server
  NSArray *insertedObjects = [note.userInfo objectForKey:NSInsertedObjectsKey];
  for (PTManagedObject *managedObject in insertedObjects) {
    [managedObject.remoteObject syncToRemote:self];
  }
}

#pragma mark PTResultsDelegate methods

- (void)remoteModel:(Class<PTRemoteObject>)remoteModelKlass didFinishLoading:(NSArray *)results;
{
  NSString *entityName = [remoteModelKlass entityName];
  NSEntityDescription *entity = [managedObjectContext entityDescriptionForName:entityName];
  
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
  
  for (PTObject *record in results) {
    PTManagedObject *managedObject = [managedObjectsByRemoteId objectForKey:record.remoteId];
    
    [record setManagedObject:managedObject isMaster:NO];
    
    if (record.managedObject == nil) {
      [record initializeInManagedObjectContext:self.managedObjectContext];
    }
  }
  // now post all local only objects back up to the server
  NSPredicate *localOnlyPredicate = [NSPredicate predicateWithFormat:@"remoteId = NIL"];
  NSArray *localObjects = [managedObjectContext fetchAllOfEntity:entity predicate:localOnlyPredicate error:nil];
  for (PTManagedObject *object in localObjects) {
    id<PTRemoteObject> modelInstance = [[(Class)remoteModelKlass alloc] initWithManagedObject:object];
    // [remoteModelKlass postToRemote:modelInstance resultsDelegate:self];
  }
  
  [managedObjectContext save:nil];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

- (void)remoteModel:(id)modelKlass didFinishUpdating:(id)updatedObject;
{
  [managedObjectContext save:nil];
}

@end
