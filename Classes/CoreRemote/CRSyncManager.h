//
//  SyncManager.h
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRResultsDelegate.h"

@protocol CRRemoteObject;

extern NSString *const PTSyncManagerWillSyncNotification;
extern NSString *const PTSyncManagerDidSyncNotification;

@interface CRSyncManager : NSObject <CRResultsDelegate> {
  NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
- (void)observeChangesToManagedObjectContext:(NSManagedObjectContext *)context;
- (void)synchronizeFromRemote:(Class<CRRemoteObject>)remoteModelKlass;
@end
