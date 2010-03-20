//
//  PTSynchronizedObject.h
//  Tracker
//
//  Created by Luke Redpath on 20/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@class PTManagedObject;

@protocol PTSynchronizedObject <NSObject>

/*
 * Used to create a new instance from a local managed object.
 * 
 * Will generally be called when restoring a set of objects from an
 * NSManagedObjectContext.
 */
- (id)initWithManagedObject:(PTManagedObject *)object;

/* 
 * Used to initialize an instance in an NSManagedObjectContext. Will
 * create a new managed object in the given context and initialize its properties 
 * with data from the instance using setManagedObject:isMaster with isMaster:NO.
 *
 * Will generally be called in one of the following situations:
 * - The object has been fetched from the remote server and doesn't exist locally.
 * - A new object has been created locally.
 */
- (void)initializeInManagedObjectContext:(NSManagedObjectContext *)context;

/*
 * Associates an instance with a managed object. If isMaster: is set to YES,
 * the instance's properties will be updated from the managed object. If NO,
 * the managed object will be updated from the instance.
 */
- (void)setManagedObject:(PTManagedObject *)object isMaster:(BOOL)isMaster;

/*
 * Sync's the objects existing managed object with itself. This will typically
 * be called after updating properties on the object (to commit the changes back
 * to Core Data).
 */
- (void)syncManagedObject;

/*
 * Sets a managed object's properties to the values of the instance's own
 * matching properties. The base implementation only syncs the remote ID
 * property. Typically overridde by sub-classes to set their own unique properties. 
 */
- (void)syncManagedObjectToSelf:(PTManagedObject *)object;

/*
 * Sets the object's properties to the values from the managed object.
 */
- (void)syncSelfToManagedObject:(PTManagedObject *)object;

@end
