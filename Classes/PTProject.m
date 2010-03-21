//
//  PTProject.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTProject.h"
#import "PTManagedObject.h"
#import "PTResultsDelegate.h"

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
    [self updateFromRemoteData:dictionary];
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

#pragma mark -
#pragma mark PTRemoteObject protocol methods

- (void)updateFromRemoteData:(NSDictionary *)remoteData;
{
  self.remoteId = [[remoteData valueForKey:@"id"] valueForKey:@"content"];
  self.name     = [remoteData valueForKey:@"name"];
  self.account  = [remoteData valueForKey:@"account"];
}

+ (id)fetchRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  return [self getPath:@"/projects" withOptions:nil object:resultsDelegate];
}

- (id)createRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  NSDictionary *object = [[NSDictionary alloc] initWithObjectsAndKeys:
    self, @"project", resultsDelegate, @"resultsDelegate", nil];
  
  NSString *XMLRepresentation = [NSString stringWithFormat:@"<project><name>%@</name></project>", self.name];
  return [[self class] postPath:@"/projects" withOptions:[NSDictionary dictionaryWithObject:XMLRepresentation forKey:@"body"] object:object];  
}

- (id)updateRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  NSDictionary *object = [[NSDictionary alloc] initWithObjectsAndKeys:
    self, @"project", resultsDelegate, @"resultsDelegate", nil];
  
  NSString *XMLRepresentation = [NSString stringWithFormat:@"<project><name>%@</name></project>", self.name];
  return [[self class] putPath:[NSString stringWithFormat:@"/projects/%@", self.remoteId] withOptions:[NSDictionary dictionaryWithObject:XMLRepresentation forKey:@"body"] object:object];  
  
}

- (id)deleteRemote:(id<PTResultsDelegate>)resultsDelegate;
{
  return nil;
}

#pragma mark -
#pragma mark HTTP request delegate

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object 
{ 
  NSDictionary *projectData = [resource valueForKey:@"project"];
  
  if (projectData) {
    id<PTResultsDelegate> resultsDelegate = [object valueForKey:@"resultsDelegate"];
    PTProject *project = [object valueForKey:@"project"];
    [object release];
     
    if (project.remoteId == nil) { // this is a create, so we need to update the remote ID
      [project updateFromRemoteData:projectData];
      [resultsDelegate remoteModel:self didCreate:project];
    } else {
      [resultsDelegate remoteModel:self didUpdate:project];
    }
  } else {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    
    for(id projectData in [resource objectForKey:@"projects"]) {
      PTProject *project = [[PTProject alloc] initWithRemoteDictionary:projectData];
      [projects addObject:project];
      [project release];
    }
    
    [(id<PTResultsDelegate>)object remoteModel:self didFetch:projects];
    [projects release]; 
  }
}

@end
