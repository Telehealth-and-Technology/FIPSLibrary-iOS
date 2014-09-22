//
//  XYZAppDelegate.m
//  testSqlCipher
//
//  Created by Scott Coleman on 9/19/14.
//  Copyright (c) 2014 Scott Coleman. All rights reserved.
//

#import "XYZAppDelegate.h"
#import <sqlite3.h>


// FIPS_mode, FIPS_mode_set, ERR_get_error, etc
#include <openssl/crypto.h>
#include <openssl/err.h>

// Random operations to test FIPS mode
#include <openssl/rand.h>
#include <openssl/aes.h>

#include "fips_assert.h"


//
// Symbols from fips_premain.c
static const unsigned int   MAGIC_20 = 20;
extern const void*          FIPS_text_start(),  *FIPS_text_end();
extern const unsigned char  FIPS_rodata_start[], FIPS_rodata_end[];
extern unsigned char        FIPS_signature[20];
extern unsigned int         FIPS_incore_fingerprint (unsigned char *, unsigned int);


@implementation XYZAppDelegate


void DisplayErrorMessage(const char* msg, unsigned long err)
{
    if(!msg)
        msg = "";
    
    NSString* message = nil;
    
    if(0 == err)
        message = [NSString stringWithFormat:@"%s", msg];
    else
        message = [NSString stringWithFormat:@"%s, error code: %ld, 0x%lx", msg, err, err];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Module Error"
                                                    message:message delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    
    FIPS_ASSERT(alert != nil);
    if(alert != nil)
        [alert show];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    int mode = 0, ret = 0;
    unsigned long err = 0;
    
    /******************************************/
    
    const UInt32 p1 = (UInt32)FIPS_rodata_start;
    const UInt32 p2 = (UInt32)FIPS_rodata_end;
 //   [m_dataLabel setText:[NSString stringWithFormat:@"Data: 0x%06lx, 0x%06lx", p1, p2]];
    NSString *fred = [NSString stringWithFormat:@"Data: 0x%06lx, 0x%06lx", p1, p2];
    

    
    /******************************************/
    
    const UInt32 p3 = (UInt32)FIPS_text_start();
    const UInt32 p4 = (UInt32)FIPS_text_end();
    NSString *fred1 = [NSString stringWithFormat:@"Text: 0x%06lx, 0x%06lx", p3, p4];
    
    /******************************************/
    
    NSMutableString* f1 = [NSMutableString stringWithCapacity:MAGIC_20*2 + 8];
    FIPS_ASSERT(f1 != nil);
    
    for(unsigned int i = 0; i < MAGIC_20; i++)
        [f1 appendFormat:@"%02x", FIPS_signature[i]];
    
    //[m_embeddedLabel setText:f1];
    NSString *fred2 =f1;
        NSLog(@"%@", fred2);
    /******************************************/
    
    unsigned char calculated[MAGIC_20] = {};
    ret = FIPS_incore_fingerprint(calculated, sizeof(calculated));
    FIPS_ASSERT(ret == MAGIC_20);
    
    if(ret != MAGIC_20)
    {
        // Failure - wipe it.
        // Default is 0x00. We use 0xFF to differentiate
        memset(calculated, 0xFF, sizeof(calculated));
    }
    
    NSMutableString* f2 = [NSMutableString stringWithCapacity:MAGIC_20*2 + 8];
    FIPS_ASSERT(f1 != nil);
    
    for(unsigned int j = 0; j < MAGIC_20; j++)
        [f2 appendFormat:@"%02x", calculated[j]];
    
    //[m_calculatedLabel setText:f2];
    NSString *fred3 = f2;
    NSLog(@"%@", fred3);
    
    /******************************************/
    
    mode = FIPS_mode();
    const BOOL state = mode ? YES : NO;
    //[m_modeSwitch setOn:state];
    
    NSLog(@"\n  FIPS mode is off. Attempting to enter FIPS mode");
    
    // Lots of possible return codes here
    ret = FIPS_mode_set(1 /*on*/);
    err = ERR_get_error();
    
    FIPS_ASSERT(ret == 1);
    if(1 != ret) {
        DisplayErrorMessage("\n  FIPS_mode_set failed", err);
    } else {
         DisplayErrorMessage("\n  FIPS_mode_set SUCCESS!!!!!!!!", err);
    }
    
    
    
    
    
    
    
    
    
    int rc;
    
    
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    NSString *databasePath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                               stringByAppendingPathComponent: @"sqlcipher1.db"];
    sqlite3 *db;
    sqlite3 *db1;
    sqlite3_stmt *stmt;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [@"BIGSecret" UTF8String];
        // fred
        sqlite3_key(db, key, strlen(key));
        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            // password is correct, or, database has been initialized
            NSLog(@"pass");
            
        } else {
            // incorrect password!
            
            NSLog(@"fail");
        }
        
        rc = sqlite3_exec(db, "CREATE TABLE t1(a INTEGER, b INTEGER, c VARCHAR(100));", NULL, NULL, NULL);
        //  sqlite3_exec(db, "CREATE TABLE test_table (id integer primary key, data text, data_num integer)");
        //  sqlite3_exec(db, "INSERT INTO t1 (a,b) VALUES (?,?)", [1, 100]);
        rc = sqlite3_exec(db, "CREATE TABLE fred (a INTEGER, b INTEGER))", NULL, NULL, NULL);
        BOOL r = rc == SQLITE_OK;
        rc = sqlite3_exec(db, "INSERT INTO fred (a,b) 1,2)", NULL, NULL, NULL);
        r = rc == SQLITE_OK;
        
        
        rc = sqlite3_open([databasePath1 UTF8String], &db1);
        
        // fred
        sqlite3_key(db1, key, strlen(key));
        rc = sqlite3_prepare_v2(db1, "SELECT count(*) FROM sqlite_master;", -1, &stmt, NULL);
        rc = sqlite3_step(stmt);
		
        int rows = sqlite3_column_int(stmt, 0);
        //STAssertTrue(rows == 0 , @"bad count");
        
        sqlite3_finalize(stmt);
        
        rc = sqlite3_exec(db1, "CREATE TABLE t1(a,b);", NULL, NULL, NULL);
        //STAssertTrue(rc == SQLITE_OK , @"error creating table");
        
        rc = sqlite3_exec(db1, "INSERT INTO t1(a,b) VALUES (1,2);", NULL, NULL, NULL);
        //STAssertTrue(rc == SQLITE_OK , @"error inserting data");
        
        rc = sqlite3_prepare_v2(db1, "SELECT count(*) FROM sqlite_master;", -1, &stmt, NULL);
        rc = sqlite3_step(stmt);
		
        rows = sqlite3_column_int(stmt, 0);
        //STAssertTrue(rows == 0 , @"bad count");
        
        sqlite3_finalize(stmt);
        
        
        sqlite3_close(db1);
        
        
        
        
        
        sqlite3_close(db);
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
