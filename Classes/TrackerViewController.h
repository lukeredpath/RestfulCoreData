//
//  TrackerViewController.h
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRResultsDelegate.h"

@class CRSyncManager;

@interface TrackerViewController : UITableViewController <CRResultsDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource> {
  NSManagedObjectContext *managedObjectContext;
  NSFetchedResultsController *fetchedResultsController;
  CRSyncManager *syncManager;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) CRSyncManager *syncManager;

- (void)findProjects;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)refreshRemote;
- (IBAction)showNewProjectScreen;
@end

