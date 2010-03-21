//
//  PTTrackerRemoteModel.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <HTTPRiot/HRRestModel.h>
#import "PTResultsDelegate.h"
#import "PTSynchronizedObject.h"
#import "PTRemoteObject.h"

#pragma mark -

@interface PTObject : HRRestModel <PTSynchronizedObject> {
  NSString *remoteId;
  PTManagedObject *managedObject;
  NSString *entityName;
}
@property (nonatomic, copy) NSString *remoteId;
@property (nonatomic, retain) PTManagedObject *managedObject;
@property (nonatomic, copy) NSManagedObjectID *managedObjectID;
@property (nonatomic, readonly) NSString *entityName;
@end
