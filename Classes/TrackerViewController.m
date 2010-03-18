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

@implementation TrackerViewController

@synthesize projects;
@synthesize managedObjectContext;

- (id)initWithCoder:(NSCoder *)aDecoder;
{
  if (self = [super initWithCoder:aDecoder]) {
    projects = [[NSArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  self.tableView.rowHeight = 54;
  
  self.projects = [PTProject findAll:self.managedObjectContext];

  if (self.projects.count > 0) {
    [self.tableView reloadData];
  }
  
  [PTProject findAllRemote:self insertIntoManagedObjectContext:self.managedObjectContext];
  
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark -
#pragma mark PTResultsDelegate protocol

- (void)remoteModel:(id)modelKlass didFinishLoading:(NSArray *)results;
{
  self.projects = results;
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
