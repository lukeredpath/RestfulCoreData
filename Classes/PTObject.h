//
//  PTTrackerRemoteModel.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <HTTPRiot/HRRestModel.h>
#import "CRSynchronizedObject.h"

#pragma mark -

@interface PTObject : HRRestModel <CRSynchronizedObject> {
  NSDecimalNumber *remoteId;
  CRManagedObject *managedObject;
  NSString *entityName;
}
@property (nonatomic, retain) NSDecimalNumber *remoteId;
@property (nonatomic, retain) CRManagedObject *managedObject;
@property (nonatomic, copy) NSManagedObjectID *managedObjectID;
@property (nonatomic, readonly) NSString *entityName;
@end
