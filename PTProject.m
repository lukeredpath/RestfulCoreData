//
//  PTProject.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTProject.h"

@implementation PTProject

@dynamic remoteId;
@dynamic name;
@dynamic account;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
  return [self initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
}

- (void)updateFromRemoteDictionary:(NSDictionary *)dictionary;
{
  self.remoteId = [dictionary valueForKey:@"id"];
  self.name     = [dictionary valueForKey:@"name"];
  self.account  = [dictionary valueForKey:@"account"];
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"[PTProject id:%@ name:%@]", self.remoteId, self.name];
}

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)context;
{
  return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
}

#pragma mark -
#pragma mark Queries

+ (NSArray *)findAll:(NSManagedObjectContext *)inContext;
{
  return [self findInContext:inContext predicate:nil];
}

+ (NSArray *)findAllWithRemoteIds:(NSArray *)arrayOfRemoteIds inContext:(NSManagedObjectContext *)inContext;
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteId in %@", arrayOfRemoteIds];
  return [self findInContext:inContext predicate:predicate];
}

+ (NSArray *)findInContext:(NSManagedObjectContext *)inContext predicate:(NSPredicate *)predicate;
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[PTProject entityFromContext:inContext]];
  [fetchRequest setPredicate:predicate];
  
  NSArray *results = [inContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  return results;
}

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
{
  NSDictionary *delegateObject = [[NSDictionary alloc] initWithObjects:
    [NSArray arrayWithObjects:resultsDelegate, context, nil] forKeys:
    [NSArray arrayWithObjects:@"resultsDelegate", @"resultsContext", nil]];
                           
  return [PTRemoteProject getPath:@"/projects" withOptions:nil object:delegateObject];
}

@end

#pragma mark -

@implementation PTRemoteProject

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object { 
  id<PTResultsDelegate> resultsDelegate = [object valueForKey:@"resultsDelegate"];
  NSManagedObjectContext *managedObjectContext = [object valueForKey:@"resultsContext"];
  
  [object release];
  
  NSArray *remoteIds = [resource valueForKeyPath:@"projects.id"];
  NSMutableArray *projects = [[PTProject findAllWithRemoteIds:remoteIds inContext:managedObjectContext] mutableCopy];

  for(id item in [resource objectForKey:@"projects"]) {
    NSPredicate *predicateForExisting = [NSPredicate predicateWithFormat:@"remoteId == %@", [item valueForKey:@"id"]];
    
    PTProject *project;
    
    NSArray *candidates = [projects filteredArrayUsingPredicate:predicateForExisting];
    if (candidates.count == 1) {
      project = [candidates objectAtIndex:0];
    } else {
      project = [[PTProject alloc] initWithManagedObjectContext:managedObjectContext];
      [projects addObject:project];
      [project release];
    }
    [project updateFromRemoteDictionary:item];
  }
  [managedObjectContext save:nil];
  
  [resultsDelegate remoteModel:self didFinishLoading:projects];
  [projects release];
}

@end


