//
//  CRResultsDelegate.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//


@protocol CRRemoteObject;


@protocol CRResultsDelegate
@optional
- (void)remoteModel:(id)modelKlass didFetch:(NSArray *)results;
- (void)remoteModel:(id)modelKlass didCreate:(id<CRRemoteObject>)remoteObject;
- (void)remoteModel:(id)modelKlass didUpdate:(id<CRRemoteObject>)remoteObject;
- (void)remoteModel:(id)modelKlass didDelete:(id<CRRemoteObject>)remoteObject;
@end
