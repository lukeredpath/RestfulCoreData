//
//  PTResultsDelegate.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//


@protocol PTRemoteObject;


@protocol PTResultsDelegate
@optional
- (void)remoteModel:(id)modelKlass didFetch:(NSArray *)results;
- (void)remoteModel:(id)modelKlass didCreate:(id<PTRemoteObject>)remoteObject;
- (void)remoteModel:(id)modelKlass didUpdate:(id<PTRemoteObject>)remoteObject;
@end
