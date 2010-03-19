//
//  NSManagedObjectContext+SimpleFetches.h
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (SimpleFetches)

- (NSArray *)fetchAllOfEntity:(NSEntityDescription *)entityDescription error:(NSError **)error;;
- (NSArray *)fetchAllOfEntity:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate error:(NSError **)error;;

@end
