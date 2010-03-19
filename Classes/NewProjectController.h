//
//  NewProjectController.h
//  Tracker
//
//  Created by Luke Redpath on 19/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewProjectController : UITableViewController <UITextFieldDelegate> {
  NSManagedObjectContext *managedObjectContext;
  UITextField *textField;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@end
