//
//  SyncManager.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTSyncManager.h"
#import "PTTrackerRemoteModel.h"

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
  NSEntityDescription *entity = [modelKlass performSelector:@selector(entityFromContext:) withObject:managedObjectContext];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteId in %@", [results valueForKeyPath:@"remoteId"]];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entity];
  [fetchRequest setPredicate:predicate];
  
  NSArray *managedObjectsForResults = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  NSMutableDictionary *managedObjectsByRemoteId = [NSMutableDictionary dictionary];
  for (NSManagedObject *object in managedObjectsForResults) {
    [managedObjectsByRemoteId setObject:object forKey:[object valueForKey:@"remoteId"]];
  }
  
  for (PTTrackerRemoteModel *record in results) {
    NSManagedObject *managedObject = [managedObjectsByRemoteId objectForKey:record.remoteId];
    
    [record setManagedObject:managedObject isMaster:NO];
    
    if (record.managedObject == nil) {
      record.managedObject = [[record newManagedObjectInContext:managedObjectContext entity:entity] autorelease];
    }
  }
  NSLog(@"Records %@", results);
  
  [managedObjectContext save:nil];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PTSyncManagerDidSyncNotification object:self];
}

@end
