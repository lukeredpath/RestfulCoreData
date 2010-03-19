//
//  NSManagedObjectContext+Helpers.h
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (Helpers)

// hat-tip: Jeff LaMarche, http://is.gd/aP0AQ
- (NSManagedObject *)insertNewObjectForEntityWithName:(NSString *)entityName;
- (NSEntityDescription *)entityDescriptionForName:(NSString *)entityName;

@end
