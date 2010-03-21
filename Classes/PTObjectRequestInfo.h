//
//  PTObjectRequestInfo.h
//  Tracker
//
//  Created by Luke Redpath on 21/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <HTTPRiot/HRGlobal.h>

@protocol PTRemoteObject, PTResultsDelegate;

@interface PTObjectRequestInfo : NSObject
{
  HRRequestMethod method;
  id<PTRemoteObject> remoteObject;
  id<PTResultsDelegate> resultsDelegate;
}
- (id)initWithMethod:(HRRequestMethod)requestMethod;

@property (nonatomic, assign) HRRequestMethod method;
@property (nonatomic, assign) id<PTRemoteObject> remoteObject;
@property (nonatomic, assign) id<PTResultsDelegate> resultsDelegate;
@end
