//
//  PTTrackerRemoteModel.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTTrackerRemoteModel.h"


@implementation PTTrackerRemoteModel

@synthesize remoteId;
@synthesize managedObject;
@dynamic entityName;

static NSString *apiKey;

+ (void)initialize {
  [self setDelegate:self];
  [self setBaseURL:[NSURL URLWithString:@"http://www.pivotaltracker.com/services/v3"]];
  [self setFormat:HRDataFormatXML];
  
  if (apiKey != nil) {
    [self setHeaders:[NSDictionary dictionaryWithObject:apiKey forKey:@"X-TrackerToken"]];
  }
}

- (NSManagedObject *)newManagedObjectInContext:(NSManagedObjectContext *)context entity:(NSEntityDescription *)entity;
{
  return [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

+ (NSString *)entityName;
{
  return nil;
}

- (NSString *)entityName;
{
  return [[self class] entityName];
}

#pragma mark -
#pragma mark Configuration

+ (void)setAPIKey:(NSString *)key;
{
  apiKey = [key copy];
}

#pragma mark -
#pragma mark NSManagedObject synching

- (void)setManagedObject:(NSManagedObject *)object isMaster:(BOOL)isMaster;
{
  self.managedObject = object;
  
  if (isMaster) {
    [self syncSelfToManagedObject:object];
  } else {
    [self syncManagedObjectToSelf:object];
  }
}

- (void)syncManagedObjectToSelf:(NSManagedObject *)object;
{
  [object setValue:self.remoteId forKey:@"remoteId"];
}

- (void)syncSelfToManagedObject:(NSManagedObject *)object;
{
  self.remoteId = [object valueForKey:@"remoteId"];
}

#pragma mark -
#pragma mark Queries

+ (NSArray *)findAll:(NSManagedObjectContext *)inContext;
{
  return [self findInContext:inContext predicate:nil];
}

#pragma mark -
#pragma mark Default HRRestConnection delegate methods

+ (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object 
{
  NSLog(@"Connection error %@", error);
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error 
              response:(NSHTTPURLResponse *)response object:(id)object 
{
  NSLog(@"Response error %@, %@", response, error);
  if (response) {
    NSLog(@"Response code %d", [response statusCode]);
  }
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error 
          responseBody:(NSString *)string 
{
  NSLog(@"Parse error %@", error);
}

@end
