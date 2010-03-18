//
//  Collection+NSIndexPathLookups.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSArray+NSIndexPathLookup.h"

@implementation NSArray (NSIndexPathLookup)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [self objectAtIndex:indexPath.row]; 
}

@end
