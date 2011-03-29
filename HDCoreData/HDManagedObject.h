//
//  HDManagedObject.h
//  HDLibraries
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HDManagedObject : NSManagedObject

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason;
- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError;

@end