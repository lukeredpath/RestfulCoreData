//
//  PTResultsDelegate.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//


@protocol PTResultsDelegate

@optional
- (void)remoteModel:(id)modelKlass didFinishLoading:(NSArray *)results;
@end
