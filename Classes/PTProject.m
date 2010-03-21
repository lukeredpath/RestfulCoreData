//
//  PTProject.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTProject.h"
#import "CRManagedObject.h"
#import "CRResultsDelegate.h"
#import "PTObjectRequestInfo.h"

@interface PTProject ()
+ (NSArray *)newCollectionFromRemoteCollection:(NSArray *)remoteCollection;
@end

#pragma mark -

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

- (void)syncManagedObjectWithSelf:(CRManagedObject *)object;
{
  [super syncManagedObjectWithSelf:object];
  
  [object setValue:self.name    forKey:@"name"];
  [object setValue:self.account forKey:@"account"];
}

- (void)syncSelfWithManagedObject:(CRManagedObject *)object;
{
  [super syncSelfWithManagedObject:object];
  
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

+ (id)fetchRemote:(id<CRResultsDelegate>)resultsDelegate;
{
  PTObjectRequestInfo *info = [[[PTObjectRequestInfo alloc] initWithMethod:HRRequestMethodGet] autorelease];
  info.resultsDelegate = resultsDelegate;
  
  return [self getPath:@"/projects" withOptions:nil object:info];
}

- (id)createRemote:(id<CRResultsDelegate>)resultsDelegate;
{
  PTObjectRequestInfo *info = [[[PTObjectRequestInfo alloc] initWithMethod:HRRequestMethodPost] autorelease];
  info.resultsDelegate = resultsDelegate;
  info.remoteObject = self;
  
  NSString *XMLRepresentation = [NSString stringWithFormat:@"<project><name>%@</name></project>", self.name];
  NSDictionary *requestData = [NSDictionary dictionaryWithObject:XMLRepresentation forKey:@"body"];
  
  return [[self class] postPath:@"/projects" withOptions:requestData object:info];  
}

- (id)updateRemote:(id<CRResultsDelegate>)resultsDelegate;
{
  PTObjectRequestInfo *info = [[[PTObjectRequestInfo alloc] initWithMethod:HRRequestMethodPut] autorelease];
  info.resultsDelegate = resultsDelegate;
  info.remoteObject = self;
  
  NSString *XMLRepresentation = [NSString stringWithFormat:@"<project><name>%@</name></project>", self.name];
  NSDictionary *requestData = [NSDictionary dictionaryWithObject:XMLRepresentation forKey:@"body"];
  
  return [[self class] putPath:[NSString stringWithFormat:@"/projects/%@", self.remoteId] withOptions:requestData object:info];  
  
}

- (id)deleteRemote:(id<CRResultsDelegate>)resultsDelegate;
{
  PTObjectRequestInfo *info = [[[PTObjectRequestInfo alloc] initWithMethod:HRRequestMethodDelete] autorelease];
  info.resultsDelegate = resultsDelegate;
  info.remoteObject = self;
  
  return [[self class] deletePath:[NSString stringWithFormat:@"/projects/%@", remoteId] withOptions:nil object:info];
}

#pragma mark -
#pragma mark HTTP request delegate

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object 
{ 
  PTObjectRequestInfo *requestInfo = (PTObjectRequestInfo *)object;
  
  switch (requestInfo.method) {
    case HRRequestMethodGet: {
      NSArray *projects = [self newCollectionFromRemoteCollection:[resource valueForKey:@"projects"]];
      [requestInfo.resultsDelegate remoteModel:self didFetch:projects];
      [projects release];
      break;
    }
    case HRRequestMethodPost: {
      [requestInfo.remoteObject updateFromRemoteData:[resource valueForKey:@"project"]];
      [requestInfo.resultsDelegate remoteModel:self didCreate:requestInfo.remoteObject];
      break;
    }
    case HRRequestMethodPut: {
      [requestInfo.resultsDelegate remoteModel:self didUpdate:requestInfo.remoteObject];
      break;
    }
    default:
      NSAssert(NO, @"Request info should always contain a valid HRRequestMethod");
      break;
  }
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response object:(id)object;
{
  PTObjectRequestInfo *requestInfo = (PTObjectRequestInfo *)object;
  
  if (response.statusCode == 200 && requestInfo.method == HRRequestMethodDelete) {
    [requestInfo.resultsDelegate remoteModel:self didDelete:requestInfo.remoteObject];
  }
}

#pragma mark -
#pragma mark Private methods

+ (NSArray *)newCollectionFromRemoteCollection:(NSArray *)remoteCollection;
{
  NSMutableArray *projects = [[NSMutableArray alloc] init];
  for(id projectData in remoteCollection) {
    PTProject *project = [[PTProject alloc] initWithRemoteDictionary:projectData];
    [projects addObject:project];
    [project release];
  }
  return projects;
}

@end
