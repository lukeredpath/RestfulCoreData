//
//  NSManagedObjectContext+SimpleFetches.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSManagedObjectContext+SimpleFetches.h"


@implementation NSManagedObjectContext (SimpleFetches)

- (NSArray *)fetchAllOfEntity:(NSEntityDescription *)entityDescription error:(NSError **)error;
{
  return [self fetchAllOfEntity:entityDescription predicate:nil error:error];
}

- (NSArray *)fetchAllOfEntity:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate error:(NSError **)error; 
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDescription];
  [request setPredicate:predicate];
  
  NSArray *results = [self executeFetchRequest:request error:error];
    [request release];
  
  return results;
}

@end
