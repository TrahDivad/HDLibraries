//
//  HDModelController.m
//  HDLibraries
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDModelController.h"
#import "HDFoundation.h"
#import "NimbusCore.h"


@interface HDModelController ()

@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end


@implementation HDModelController

#pragma mark - Lifecycle

+ (HDModelController*)sharedInstance
{
	return (HDModelController*)HDCreateSingleton(^{
		return [HDModelController new];
	});
}

#pragma mark - Properties

- (NSManagedObjectModel*)managedObjectModel
{
	if (_managedObjectModel == nil) {
		if (self.modelURL != nil) {
			self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
		} else {
			self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
		}
		
		NIDASSERT(_managedObjectModel != nil);
	}
	
	return _managedObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (_managedObjectContext == nil) {
		NSManagedObjectContext* newManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[newManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		self.managedObjectContext = newManagedObjectContext;
		
		NIDASSERT(_managedObjectContext != nil);
	}
	
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator == nil) {
		self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
		
		NIDASSERT(_persistentStoreCoordinator != nil);
	}

	return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (void)addStoreWithURL:(NSURL*)storeURL
{
	BOOL readOnly = NO;
	NSFileManager* fileManager = [NSFileManager new];
	
	if ([fileManager fileExistsAtPath:[storeURL path]] && ![fileManager isWritableFileAtPath:[storeURL path]]) {
		readOnly = YES;
	}
	
	[self addStoreWithURL:storeURL readOnly:readOnly];
}

- (void)addStoreWithURL:(NSURL*)storeURL readOnly:(BOOL)readOnly
{
	NIDASSERT(storeURL != nil);
	
	NSDictionary* storeOptions = @{
		NSReadOnlyPersistentStoreOption: @(readOnly),
		NSMigratePersistentStoresAutomaticallyOption: @YES,
		NSInferMappingModelAutomaticallyOption: @YES
	};
	
	NSError* error = nil;
	[self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error];
	NIDASSERT(error == nil);
}

- (void)assignObjectToFirstWritableStore:(NSManagedObject*)object
{
	for (NSPersistentStore* store in [self.persistentStoreCoordinator persistentStores]) {
		NSNumber* isReadOnlyNumber = store.options[NSReadOnlyPersistentStoreOption];
		
		if ((isReadOnlyNumber == nil) || ![isReadOnlyNumber boolValue]) {
			[self.managedObjectContext assignObject:object toPersistentStore:store];
			return;
		}
	}
	
	NIDERROR(@"Could not find a writable persistent store to assign object.");
}

- (void)saveContext
{
	NSError* error = nil;
	[self saveContextWithError:&error];
	NIDASSERT(error == nil);
}

- (BOOL)saveContextWithError:(NSError**)error
{
	NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
	
	if (managedObjectContext && [managedObjectContext hasChanges]) {
		return [managedObjectContext save:error];
	} else {
		return YES;
	}
}

@end
