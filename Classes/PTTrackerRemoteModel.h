//
//  PTTrackerRemoteModel.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <HTTPRiot/HRRestModel.h>

@interface PTTrackerRemoteModel : HRRestModel {
  NSString *remoteId;
  NSManagedObject *managedObject;
}
@property (nonatomic, copy) NSString *remoteId;
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, readonly) NSString *entityName;

+ (void)setAPIKey:(NSString *)apiKey;

- (void)setManagedObject:(NSManagedObject *)object isMaster:(BOOL)isMaster;
- (void)syncManagedObjectToSelf:(NSManagedObject *)object;
- (void)syncSelfToManagedObject:(NSManagedObject *)object;

+ (NSArray *)findAll:(NSManagedObjectContext *)inContext;
@end
