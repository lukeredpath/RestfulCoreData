//
//  EditProjectController.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NewProjectController.h"

@class PTProject;

@interface EditProjectController : NewProjectController {
  PTProject *project;
}
@property (nonatomic, retain) PTProject *project;
@end
