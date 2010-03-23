//
//  TrackerViewController.m
//  Tracker
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "TrackerViewController.h"
#import "NSArray+NSIndexPathLookup.h"
#import "NSManagedObjectContext+Helpers.h"
#import "PTProject.h"
#import "CRSyncManager.h"
#import "NewProjectController.h"
#import "EditProjectController.h"

@implementation TrackerViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize syncManager;

#pragma mark -

- (void)dealloc 
{
  [fetchedResultsController release];
  [managedObjectContext release];
  [syncManager release];
  [super dealloc];
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
  [self.syncManager synchronizeFromRemote:[PTProject class]];
}

- (void)findProjects;
{
  if (fetchedResultsController == nil) {
    NSFetchRequest *projectsFetchRequest = [[NSFetchRequest alloc] init];
    [projectsFetchRequest setEntity:[self.managedObjectContext entityDescriptionForName:[PTProject entityName]]];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *accountSort = [[NSSortDescriptor alloc] initWithKey:@"account" ascending:YES];
    [projectsFetchRequest setSortDescriptors:[NSArray arrayWithObjects:accountSort, nameSort, nil]];
      
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:projectsFetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"account" cacheName:@"Projects"];
    fetchedResultsController.delegate = self;
    
    [nameSort release];
    [accountSort release];
    [projectsFetchRequest release];
  }
  
  [fetchedResultsController performFetch:nil];
}

/*
 it seems the only issue when using NSFetchedResultsController is that we
 want to deal with our model object, not the raw NSManagedObject. For now, this
 seems like a reasonable workaround, even if we are creating and autoreleasing 
 an object each time we call this method. We could cache this if performance
 was an issue.
*/
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  PTProject *project = [[PTProject alloc] initWithManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
  return [project autorelease];
}

#pragma mark -
#pragma mark Actions

- (IBAction)showNewProjectScreen;
{
  NewProjectController *newProjectController = [[NewProjectController alloc] init];
  newProjectController.managedObjectContext = self.managedObjectContext;
  [self.navigationController pushViewController:newProjectController animated:YES];
  [newProjectController release];
}

#pragma mark -
#pragma mark Notifications

- (void)syncManagerDidSync:(NSNotification *)note;
{
  [managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:note waitUntilDone:NO];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
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
  PTProject *project = [self objectAtIndexPath:indexPath];

  cell.textLabel.text = project.name;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", project.remoteId];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{ 
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
  return [sectionInfo name];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  EditProjectController *editController = [[EditProjectController alloc] init];
  editController.project = [self objectAtIndexPath:indexPath];
  editController.managedObjectContext = self.managedObjectContext;
  [self.navigationController pushViewController:editController animated:YES];
  [editController release];
}

// implement swipe to delete support
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    PTProject *project = [self objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:(NSManagedObject *)project.managedObject];
  }
  [self.managedObjectContext save:nil];
}

@end
