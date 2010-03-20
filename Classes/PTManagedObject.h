//
//  PTManagedObject.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTObject.h"

@interface PTManagedObject : NSManagedObject {
  id<PTRemoteObject> remoteObject;
}
@property (nonatomic, retain) id<PTRemoteObject> remoteObject;
@end
