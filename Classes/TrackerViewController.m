//
//  TrackerViewController.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "TrackerViewController.h"
#import "NSArray+NSIndexPathLookup.h"
#import "PTProject.h"
#import "PTSyncManager.h"

@implementation TrackerViewController

@synthesize projects;
@synthesize managedObjectContext;
@synthesize syncManager;

#pragma mark -

- (void)dealloc 
{
  [projects release];
  [managedObjectContext release];
  [syncManager release];
  [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
  if (self = [super initWithCoder:aDecoder]) {
    projects = [[NSArray alloc] init];
  }
  return self;
}

- (void)didReceiveMemoryWarning 
{
  [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View methods

- (void)viewDidLoad {
  self.tableView.rowHeight = 54;
  
  [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncManagerDidSync:) 
            name:NSManagedObjectContextDidSaveNotification
          object:self.syncManager.managedObjectContext];
  
  [self findProjects];  
  [self refreshRemote];
  
  [super viewDidLoad];
}

- (void)viewDidUnload 
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self];
}

#pragma mark -
#pragma mark Data management

- (void)refreshRemote;
{
  [self.syncManager synchronizeRemote:[PTProject class]];
}

- (void)findProjects;
{
  self.projects = [PTProject findAll:self.managedObjectContext];
}

#pragma mark -
#pragma mark Notifications

- (void)syncManagerDidSync:(NSNotification *)note;
{
  [managedObjectContext mergeChangesFromContextDidSaveNotification:note];
  [self findProjects];
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

static NSString *ProjectCellIdentifier = @"ProjectCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProjectCellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ProjectCellIdentifier] autorelease];
  }  
  PTProject *project = [projects objectAtIndexPath:indexPath];

  cell.textLabel.text = project.name;
  cell.detailTextLabel.text = project.account;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
  return self.projects.count;
}

@end
