//
//  CoreDataManager.h
//  CoreDataDemo
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@interface CoreDataManager : NSObject {
  NSMutableDictionary *managedObjectContexts;
  NSString *defaultContextKey;
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
+ (id)sharedManager;

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)prepareForExit;

- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key;
- (NSManagedObjectContext *)defaultManagedObjectContext;
- (void)registerNewManagedObjectContextForKey:(NSString *)key isDefault:(BOOL)isDefault;
- (void)registerDefaultManagedObjectContext;

+ (id)newPersistentStoreCoordinatorForModel:(NSManagedObjectModel *)model withStoreType:(NSString *)storeType storePath:(NSString *)pathToStoreFile;
@end
