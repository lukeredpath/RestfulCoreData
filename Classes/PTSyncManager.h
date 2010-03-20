//
//  SyncManager.h
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTResultsDelegate.h"
#import "PTObject.h"

extern NSString *const PTSyncManagerWillSyncNotification;
extern NSString *const PTSyncManagerDidSyncNotification;

@interface PTSyncManager : NSObject <PTResultsDelegate> {
  NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
- (void)observeChangesToManagedObjectContext:(NSManagedObjectContext *)context;
- (void)synchronizeFromRemote:(Class<PTRemoteObject>)remoteModelKlass;
@end
