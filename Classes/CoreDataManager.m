//
//  CoreDataManager.m
//  CoreDataDemo
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "CoreDataManager.h"
#import "UIApplication+Directories.h"

static NSString *CoreDataManagerDefaultContextKey = @"CoreDataManagerDefaultContextKey";

@implementation CoreDataManager

@synthesize persistentStoreCoordinator;

- (void)dealloc;
{
  [persistentStoreCoordinator release];
  [managedObjectContexts release];
  [defaultContextKey release];
  [super dealloc];
}

- (id)init;
{
  if (self = [super init]) {
    managedObjectContexts = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)prepareForExit;
{
  for (NSManagedObjectContext *context in [managedObjectContexts allValues]) {
    if ([context hasChanges]) {
      [context save:nil];
    } 
  }
}

#pragma mark -
#pragma mark NSManagedObjectContext registration

- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key;
{
  return [managedObjectContexts objectForKey:key];
}

- (NSManagedObjectContext *)defaultManagedObjectContext;
{
  return [managedObjectContexts objectForKey:defaultContextKey];
}

- (void)registerNewManagedObjectContextForKey:(NSString *)key isDefault:(BOOL)isDefault;
{
  NSAssert1(![managedObjectContexts.allKeys containsObject:key], 
          @"Duplicate key, managed object context already registered for key %@", key);

  NSAssert(self.persistentStoreCoordinator != nil, 
          @"A persistent store coordinator is required to create managed object contexts");

  NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  [managedObjectContexts setObject:managedObjectContext forKey:key];
  [managedObjectContext release];
  
  if (isDefault == YES) {
    defaultContextKey = [key copy];
  }
}

- (void)registerDefaultManagedObjectContext;
{
  [self registerNewManagedObjectContextForKey:CoreDataManagerDefaultContextKey isDefault:YES];
}

#pragma mark -
#pragma mark Factory methods

+ (id)newPersistentStoreCoordinatorForModel:(NSManagedObjectModel *)model withStoreType:(NSString *)storeType storePath:(NSString *)storePath;
{
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

  NSURL *storeUrl = [NSURL fileURLWithPath:[[UIApplication documentsDirectory] stringByAppendingPathComponent:storePath]];
    [coordinator addPersistentStoreWithType:storeType configuration:nil URL:storeUrl options:nil error:nil];
 
  return coordinator;
}

#pragma mark -
#pragma mark Singleton boilerplate

static id sharedManager = nil;

+ (void)initialize 
{
  if (self == [CoreDataManager class]) {
    sharedManager = [[self alloc] init];
  }
}

+ (id)sharedManager 
{
  return sharedManager;
}

@end
