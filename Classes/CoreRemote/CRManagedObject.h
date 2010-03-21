//
//  CRManagedObject.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRRemoteObject;

@interface CRManagedObject : NSManagedObject {
  id<CRRemoteObject> remoteObject;
}
@property (nonatomic, retain) id<CRRemoteObject> remoteObject;
@end
