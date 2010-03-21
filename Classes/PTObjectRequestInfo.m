//
//  PTObjectRequestInfo.m
//  Tracker
//
//  Created by Luke Redpath on 21/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTObjectRequestInfo.h"


@implementation PTObjectRequestInfo

@synthesize method, remoteObject, resultsDelegate;

- (id)initWithMethod:(HRRequestMethod)requestMethod;
{
  if (self = [super init]) {
    method = requestMethod;
  } 
  return self;
}

@end
