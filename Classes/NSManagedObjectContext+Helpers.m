//
//  NSManagedObjectContext+Helpers.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSManagedObjectContext+Helpers.h"


@implementation NSManagedObjectContext (Helpers)

- (NSManagedObject *)insertNewObjectForEntityWithName:(NSString *)entityName;
{
  return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (NSEntityDescription *)entityDescriptionForName:(NSString *)entityName;
{
  return [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
}

@end
