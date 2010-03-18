//
//  UIApplication+Directories.m
//  CoreDataDemo
//
//  Created by Luke Redpath on 18/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "UIApplication+Directories.h"


@implementation UIApplication (Directories)

+ (NSString *)documentsDirectory;
{
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
