//
//  PTProject.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTTrackerModel.h"
#import "PTResultsDelegate.h"
#import "PTTrackerRemoteModel.h"

@interface PTProject : PTTrackerModelBase {

}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *remoteId;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)findAll:(NSManagedObjectContext *)inContext;
+ (NSArray *)findAllWithRemoteIds:(NSArray *)arrayOfRemoteIds inContext:(NSManagedObjectContext *)inContext;

+ (NSArray *)findInContext:(NSManagedObjectContext *)inContext predicate:(NSPredicate *)predicate;

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
@end

#pragma mark -

@interface PTRemoteProject : PTTrackerRemoteModel
@end
