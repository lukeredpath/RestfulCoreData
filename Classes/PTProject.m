//
//  PTProject.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTProject.h"
#import "PTManagedObject.h"

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

+ (NSString *)entityName;
{
  return @"Project";
}

- (id)initWithRemoteDictionary:(NSDictionary *)dictionary;
{
  if (self = [super init]) {
    [self syncWithRemoteData:dictionary];
  }
  return self;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"[PTProject id:%@ name:%@]", self.remoteId, self.name];
}

- (void)syncManagedObjectToSelf:(PTManagedObject *)object;
{
  [super syncManagedObjectToSelf:object];
  
  [object setValue:self.name    forKey:@"name"];
  [object setValue:self.account forKey:@"account"];
}

- (void)syncSelfToManagedObject:(PTManagedObject *)object;
{
  [super syncSelfToManagedObject:object];
  
  self.name    = [object valueForKey:@"name"];
  self.account = [object valueForKey:@"account"];
}

- (void)syncWithRemoteData:(NSDictionary *)remoteData;
{
  self.remoteId = [remoteData valueForKey:@"id"];
  self.name     = [remoteData valueForKey:@"name"];
  self.account  = [remoteData valueForKey:@"account"];
  
  if (self.managedObject) {
    [self syncManagedObjectToSelf:self.managedObject];
  }
}

- (void)syncToRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  if (self.remoteId) {
    // do remote update
  } else {
    [[self class] postToRemote:self resultsDelegate:resultsDelegate];
  }
}

#pragma mark -
#pragma mark Remote access

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  return [self getPath:@"/projects" withOptions:nil object:resultsDelegate];
}

// this is gonna be a complete hack for now
+ (void)postToRemote:(PTProject *)project resultsDelegate:(id<PTResultsDelegate>)resultsDelegate;
{ 
  NSDictionary *object = [[NSDictionary alloc] initWithObjectsAndKeys:
      project, @"project", resultsDelegate, @"resultsDelegate", nil];
  
  NSString *XMLRepresentation = [NSString stringWithFormat:@"<project><name>%@</name></project>", project.name];
  [self postPath:@"/projects" withOptions:[NSDictionary dictionaryWithObject:XMLRepresentation forKey:@"body"] object:object];  
}

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object 
{ 
  NSDictionary *projectData = [resource valueForKey:@"project"];
  
  if (projectData) {
    PTProject *project = [object valueForKey:@"project"];
    id<PTResultsDelegate> resultsDelegate = [object valueForKey:@"resultsDelegate"];
    [object release];
    
    [project syncWithRemoteData:projectData];
    [resultsDelegate remoteModel:self didFinishUpdating:project];
  } else {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    
    for(id projectData in [resource objectForKey:@"projects"]) {
      PTProject *project = [[PTProject alloc] initWithRemoteDictionary:projectData];
      [projects addObject:project];
      [project release];
    }
    
    [(id<PTResultsDelegate>)object remoteModel:self didFinishLoading:projects];
    [projects release]; 
  }
}

@end
