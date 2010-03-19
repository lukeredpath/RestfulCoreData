//
//  PTProject.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTResultsDelegate.h"
#import "PTTrackerRemoteModel.h"

@interface PTProject : PTTrackerRemoteModel {
  NSString *name;
  NSString *account;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)context;

+ (NSArray *)findInContext:(NSManagedObjectContext *)inContext predicate:(NSPredicate *)predicate;

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate;
@end
