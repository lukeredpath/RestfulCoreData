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

@interface TrackerViewController : UITableViewController <PTResultsDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource> {
  NSManagedObjectContext *managedObjectContext;
  NSFetchedResultsController *fetchedResultsController;
  PTSyncManager *syncManager;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) PTSyncManager *syncManager;

- (void)findProjects;
- (IBAction)refreshRemote;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

