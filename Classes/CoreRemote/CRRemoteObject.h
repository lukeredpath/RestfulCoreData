//
//  PTRemoteObject.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@protocol CRResultsDelegate;


@protocol CRRemoteObject <NSObject>
+ (NSString *)entityName;
- (NSString *)entityName;
- (id)remoteId;
- (void)updateFromRemoteData:(NSDictionary *)remoteData;
+ (id)fetchRemote:(id<CRResultsDelegate>)resultsDelegate;
- (id)createRemote:(id<CRResultsDelegate>)resultsDelegate;
- (id)updateRemote:(id<CRResultsDelegate>)resultsDelegate;
- (id)deleteRemote:(id<CRResultsDelegate>)resultsDelegate;
@end
