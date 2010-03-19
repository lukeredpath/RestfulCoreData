//
//  NewProjectController.m
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NewProjectController.h"
#import "NSManagedObjectContext+Helpers.h"
#import "PTProject.h"

@implementation NewProjectController

@synthesize managedObjectContext;
@synthesize textField;

- (void)dealloc;
{
  [managedObjectContext release];
  [super dealloc];
}

- (id)init;
{
  if (self = [super initWithNibName:@"NewProjectView" bundle:nil]) {
    self.navigationItem.title = @"Create Project";
  }
  return self;
}

- (void)didReceiveMemoryWarning;
{
  
}

#pragma mark -
#pragma mark View methods

- (void)viewDidLoad;
{
}

- (void)viewDidUnload;
{
}

- (void)viewDidAppear:(BOOL)animated;
{
  [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}

#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
  [_textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField
{
  PTProject *project = [[PTProject alloc] init];
  project.name = _textField.text;
  project.account = @"LJR Software Ltd"; // TODO, provide a form for this
  
  NSManagedObject *newObject = [self.managedObjectContext insertNewObjectForEntityWithName:project.entityName];
  [project setManagedObject:newObject isMaster:NO];
  
  [self.managedObjectContext processPendingChanges];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView datasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return @"Enter your project's name";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  // no need for cell reuse here as there only ever be a single cell
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  textField.frame = CGRectInset(cell.contentView.frame, 20, 10);
  [cell.contentView addSubview:textField];  
  return [cell autorelease];
}

@end
