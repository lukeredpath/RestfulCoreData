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
- (id)remoteId;
- (void)updateFromRemoteData:(NSDictionary *)remoteData;
+ (id)fetchRemote:(id<PTResultsDelegate>)resultsDelegate;
- (id)createRemote:(id<PTResultsDelegate>)resultsDelegate;
- (id)updateRemote:(id<PTResultsDelegate>)resultsDelegate;
- (id)deleteRemote:(id<PTResultsDelegate>)resultsDelegate;

@end
