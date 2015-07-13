// 
// EncryptedStore.h
//
// Copyright 2012 - 2014 The MITRE Corporation, All Rights Reserved.
//
//
/*
 *
 * Copyright � 2009-2015 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright � 2009-2015 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: T2Crypto
 * Government Agency Original Software Title: T2Crypto
 * User Registration Requested. Please send email
 * with your contact information to: robert.a.kayl.civ@mail.mil
 * Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil
 *
 */

#import <sqlite3.h>
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

typedef struct _options {
    char * passphrase;
    char * database_location;
    int * cache_size;
} EncryptedStoreOptions;

extern NSString * const EncryptedStoreType;
extern NSString * const EncryptedStorePassphraseKey;
extern NSString * const EncryptedStoreErrorDomain;
extern NSString * const EncryptedStoreErrorMessageKey;
extern NSString * const EncryptedStoreDatabaseLocation;
extern NSString * const EncryptedStoreCacheSize;

typedef NS_ENUM(NSInteger, EncryptedStoreError)
{
    EncryptedStoreErrorIncorrectPasscode = 6000,
    EncryptedStoreErrorMigrationFailed
};

@interface EncryptedStore : NSIncrementalStore
+ (NSPersistentStoreCoordinator *)makeStoreWithOptions:(NSDictionary *)options managedObjectModel:(NSManagedObjectModel *)objModel;
+ (NSPersistentStoreCoordinator *)makeStoreWithStructOptions:(EncryptedStoreOptions *) options managedObjectModel:(NSManagedObjectModel *)objModel;
+ (NSPersistentStoreCoordinator *)makeStore:(NSManagedObjectModel *) objModel
                                   passcode:(NSString *) passcode;

+ (NSPersistentStoreCoordinator *)makeStoreWithOptions:(NSDictionary *)options managedObjectModel:(NSManagedObjectModel *)objModel error:(NSError * __autoreleasing*)error;
+ (NSPersistentStoreCoordinator *)makeStoreWithStructOptions:(EncryptedStoreOptions *) options managedObjectModel:(NSManagedObjectModel *)objModel error:(NSError * __autoreleasing*)error;
+ (NSPersistentStoreCoordinator *)makeStore:(NSManagedObjectModel *) objModel
                                   passcode:(NSString *) passcode error:(NSError * __autoreleasing*)error;


- (NSNumber *)maximumObjectIDInTable:(NSString *)table;
- (NSDictionary *)whereClauseWithFetchRequest:(NSFetchRequest *)request;
- (void)bindWhereClause:(NSDictionary *)clause toStatement:(sqlite3_stmt *)statement;
- (NSString *)columnsClauseWithProperties:(NSArray *)properties;
- (NSString *) joinedTableNameForComponents: (NSArray *) componentsArray forRelationship:(BOOL)forRelationship;
- (id)valueForProperty:(NSPropertyDescription *)property
           inStatement:(sqlite3_stmt *)statement
               atIndex:(int)index;
- (NSString *)foreignKeyColumnForRelationship:(NSRelationshipDescription *)relationship;
- (void)bindProperty:(NSPropertyDescription *)property
           withValue:(id)value
              forKey:(NSString *)key
         toStatement:(sqlite3_stmt *)statement
             atIndex:(int)index;


@end
