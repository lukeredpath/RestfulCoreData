//
//  PTProject.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTProject.h"

@implementation PTProject

@synthesize name;
@synthesize account;

- (void)dealloc;
{
  [remoteId release];
  [name release];
  [account release];
  [managedObject release];
  [super dealloc];
}

- (id)initWithManagedObject:(NSManagedObject *)object;
{
  if (self = [super init]) {
    [self setManagedObject:object isMaster:YES];
  }
  return self;
}

- (id)initWithRemoteDictionary:(NSDictionary *)dictionary;
{
  if (self = [super init]) {
    self.remoteId = [dictionary valueForKey:@"id"];
    self.name     = [dictionary valueForKey:@"name"];
    self.account  = [dictionary valueForKey:@"account"];
  }
  return self;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"[PTProject id:%@ name:%@]", self.remoteId, self.name];
}

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)context;
{
  return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
}

- (NSManagedObject *)newManagedObjectInContext:(NSManagedObjectContext *)context entity:(NSEntityDescription *)entity;
{
  NSManagedObject *object = [super newManagedObjectInContext:context entity:entity];
  [self syncManagedObjectToSelf:object];
  return object;
}

- (void)syncManagedObjectToSelf:(NSManagedObject *)object;
{
  [super syncManagedObjectToSelf:object];
  
  [object setValue:self.name    forKey:@"name"];
  [object setValue:self.account forKey:@"account"];
}

- (void)syncSelfToManagedObject:(NSManagedObject *)object;
{
  [super syncSelfToManagedObject:object];
  
  self.name    = [object valueForKey:@"name"];
  self.account = [object valueForKey:@"account"];
}

#pragma mark -
#pragma mark Queries

+ (NSArray *)findAll:(NSManagedObjectContext *)inContext;
{
  return [self findInContext:inContext predicate:nil];
}

+ (NSArray *)findInContext:(NSManagedObjectContext *)inContext predicate:(NSPredicate *)predicate;
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[PTProject entityFromContext:inContext]];
  [fetchRequest setPredicate:predicate];
  
  NSArray *results = [inContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  NSMutableArray *projects = [NSMutableArray arrayWithCapacity:results.count];
  
  for (NSManagedObject *object in results) {
    PTProject *project = [[PTProject alloc] initWithManagedObject:object];
    [projects addObject:project];
    [project release];
  }
  
  return projects;
}

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate;
{
                          
  return [self getPath:@"/projects" withOptions:nil object:resultsDelegate];
}

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object { 
  NSMutableArray *projects = [[NSMutableArray alloc] init];
  
  for(id item in [resource objectForKey:@"projects"]) {
    PTProject *project = [[PTProject alloc] initWithRemoteDictionary:item];
    [projects addObject:project];
    [project release];
  }
  
  [(id<PTResultsDelegate>)object remoteModel:self didFinishLoading:projects];
  [projects release];
}

@end