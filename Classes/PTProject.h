//
//  PTProject.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTResultsDelegate.h"
#import "PTObject.h"

@interface PTProject : PTObject <PTRemoteObject> {
  NSString *name;
  NSString *account;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;

- (id)initWithRemoteDictionary:(NSDictionary *)dictionary;
@end
