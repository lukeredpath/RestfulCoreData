//
//  PTObjectRequestInfo.h
//  Tracker
//
//  Created by Luke Redpath on 21/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <HTTPRiot/HRGlobal.h>

@protocol CRRemoteObject, CRResultsDelegate;

@interface PTObjectRequestInfo : NSObject
{
  HRRequestMethod method;
  id<CRRemoteObject> remoteObject;
  id<CRResultsDelegate> resultsDelegate;
}
- (id)initWithMethod:(HRRequestMethod)requestMethod;

@property (nonatomic, assign) HRRequestMethod method;
@property (nonatomic, assign) id<CRRemoteObject> remoteObject;
@property (nonatomic, assign) id<CRResultsDelegate> resultsDelegate;
@end
