//
//  TrackerViewController.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTResultsDelegate.h"

@class PTSyncManager;

@interface TrackerViewController : UITableViewController <PTResultsDelegate, UITableViewDataSource> {
  NSArray *projects;
  NSManagedObjectContext *managedObjectContext;
  PTSyncManager *syncManager;
}
@property (nonatomic, retain) NSArray *projects;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) PTSyncManager *syncManager;

- (void)findProjects;
- (IBAction)refreshRemote;
@end

