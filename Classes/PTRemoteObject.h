//
//  PTRemoteObject.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@protocol PTRemoteObject <NSObject>

+ (NSString *)entityName;
- (NSString *)entityName;

- (void)syncWithRemoteData:(NSDictionary *)remoteData;
- (void)syncToRemote:(id<PTResultsDelegate>)resultsDelegate;

+ (id)findAllRemote:(id<PTResultsDelegate>)resultsDelegate;

+ (void)postToRemote:(id<PTRemoteObject>)project 
     resultsDelegate:(id<PTResultsDelegate>)resultsDelegate;

@end
