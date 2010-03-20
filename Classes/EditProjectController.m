//
//  EditProjectController.m
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "EditProjectController.h"
#import "PTProject.h"

@implementation EditProjectController

@synthesize project;

- (id)init;
{
  if (self = [super init]) {
    self.navigationItem.title = @"Edit Project";
  }
  return self;
}

- (void)dealloc;
{
  [project release];
  [super dealloc];
}

- (void)viewDidLoad;
{
  [super viewDidLoad];
  
  self.textField.text = self.project.name;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField
{
  self.project.name = _textField.text;

  [self.project syncManagedObject];  
  [self.managedObjectContext save:nil];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
