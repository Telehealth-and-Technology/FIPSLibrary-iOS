// ====================================================================
// Copyright (c) 2013 The OpenSSL Project. Rights for redistribution
// and usage in source and binary forms are granted according to the
// OpenSSL license.
// ====================================================================
//  ViewController.m
//
//  Created by Tim Hudson, Steve Marquess, Jeffrey Walton on 1/5/13.
// ====================================================================

#import "ViewController.h"

//
// FIPS_mode, FIPS_mode_set, ERR_get_error, etc
#include <openssl/crypto.h>
#include <openssl/err.h>

// Random operations to test FIPS mode
#include <openssl/rand.h>
#include <openssl/aes.h>

//
// Debug instrumentation
#include "fips_assert.h"

#include "T2Crypto.h"

#import "sqlite3.h"

// Audio stuff
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>




//
// Symbols from fips_premain.c
static const unsigned int   MAGIC_20 = 20;
extern const void*          FIPS_text_start(),  *FIPS_text_end();
extern const unsigned char  FIPS_rodata_start[], FIPS_rodata_end[];
extern unsigned char        FIPS_signature[20];
extern unsigned int         FIPS_incore_fingerprint (unsigned char *, unsigned int);



int testPassCount = 0;
int testFailCount = 0;
int testTotalCount = 0;
int iterations = 0;
BOOL databaseTestsPassed = false;
NSString *testDescription = @"";
int retVal;

const int NUM_ITERATIONS = 1;


@interface ViewController ()

@end

@implementation ViewController

@synthesize m_dataLabel, m_textLabel;

@synthesize m_embeddedLabel, m_calculatedLabel;

@synthesize  m_modeSwitch;

@synthesize m_mainView;



NSString *startTest(NSString *testDescription) {
    NSLog(@"%@  ------ Starting test ",testDescription);
    return testDescription;
}

void assertT2Test(bool result, NSString *testDescription) {
    testTotalCount++;
    if (result) {
        NSLog(@"          PASSED - Iteration %d, %@ ",iterations, testDescription);
        testPassCount++;
    }
    else {
        unsigned long err = ERR_get_error();
        NSLog(@"       xxFAIL - Iteration %d, %@ - Error code %lu",iterations, testDescription, err);

        testFailCount++;
    }
}





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

// We get here when the user flips the "mode switched" switch on the UI
-(IBAction) modeSwitched
{
    int mode = 0, ret = 0;
    unsigned long err = 0;
    
    mode = FIPS_mode();
    FIPS_ASSERT(1 == mode || 0 == mode);
    
    if(mode == 0)
    {
        NSLog(@"\n  FIPS mode is off. Attempting to enter FIPS mode");
        
        // Lots of possible return codes here
        ret = FIPS_mode_set(1 /*on*/);
        err = ERR_get_error();
        
        FIPS_ASSERT(ret == 1);
        if(1 != ret) {
            DisplayErrorMessage("\n  FIPS_mode_set failed", err);
        }
        else {
            NSLog(@"\n  Successfully entered FIPS mode");
        }
    }
    else
    {
        NSLog(@"\n  FIPS mode is on. Attempting to exit FIPS mode");
        
        ret = FIPS_mode_set(0 /*off*/);
        err = ERR_get_error();
        
        FIPS_ASSERT(ret == 1);
        if(1 != ret) {
            DisplayErrorMessage("\n  FIPS_mode_set failed", err);
        }
        else {
            NSLog(@"\n  Successfully exited FIPS mode");
        }

    }
    
    // Verify the polled FIPS mode agrees with the switch setting
    if(1 == ret)
    {
        BOOL state = [m_modeSwitch isOn];
        mode = FIPS_mode();
        FIPS_ASSERT((0 != mode && YES == state) || (0 == mode && NO == state));
    }
    

    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /******************************************/
    
    FIPS_ASSERT(m_dataLabel != nil);
    FIPS_ASSERT(m_textLabel != nil);
    FIPS_ASSERT(m_embeddedLabel != nil);
    FIPS_ASSERT(m_calculatedLabel != nil);
    FIPS_ASSERT(m_modeSwitch != nil);
    
    /******************************************/
    
    const UInt32 p1 = (UInt32)FIPS_rodata_start;
    const UInt32 p2 = (UInt32)FIPS_rodata_end;
    [m_dataLabel setText:[NSString stringWithFormat:@"Data: 0x%06lx, 0x%06lx", (long) p1, (long) p2]];
    
    /******************************************/
    
    const UInt32 p3 = (UInt32)FIPS_text_start();
    const UInt32 p4 = (UInt32)FIPS_text_end();
    [m_textLabel setText:[NSString stringWithFormat:@"Text: 0x%06lx, 0x%06lx", (long)p3, (long)p4]];
    
    /******************************************/
    
    NSMutableString* f1 = [NSMutableString stringWithCapacity:MAGIC_20*2 + 8];
    FIPS_ASSERT(f1 != nil);
    
    for(unsigned int i = 0; i < MAGIC_20; i++)
        [f1 appendFormat:@"%02x", FIPS_signature[i]];
    
    [m_embeddedLabel setText:f1];
    
    /******************************************/
    
    unsigned char calculated[MAGIC_20] = {};
    unsigned int ret = FIPS_incore_fingerprint(calculated, sizeof(calculated));
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
    
    [m_calculatedLabel setText:f2];
    [m_calculatedLabel setText:f1];     // TODO remove this when compiler issue is fixed! - Note, this affects simulatoer only
    
    /******************************************/
    
    
    // Start Unit Tests:
    
    iterations++;
//		while(iterations++ < NUM_ITERATIONS) {
    
    
    // ------------------------------------------
    // Test 1 - Test we can enter/edit FIP mode
    // ------------------------------------------
    testDescription = startTest(@"Test 1.0 Confirm FIP mode");
    retVal = FIPS_mode_set(1 /*on*/);
    int fipsMode = FIPS_mode();
    assertT2Test(retVal == T2True, testDescription );
    assertT2Test(fipsMode == T2FipsModeOn, testDescription );
    
    testDescription = startTest(@"Test 1.1 Confirm FIP mode");
    retVal = FIPS_mode_set(0 /*off*/);
    fipsMode = FIPS_mode();
    assertT2Test(retVal == T2True, testDescription );
    assertT2Test(fipsMode == T2FipsModeOff, testDescription );
    
    testDescription = startTest(@"Test 1.2 Confirm FIP mode");
    retVal = FIPS_mode_set(1 /*on*/);
    fipsMode = FIPS_mode();
    assertT2Test(retVal == T2True, testDescription );
    assertT2Test(fipsMode == T2FipsModeOn, testDescription );
    
    
    
    // Make sure that the UI switch agrees with the current FIP mode
    const int mode = FIPS_mode();
    const BOOL state = mode ? YES : NO;
    [m_modeSwitch setOn:state];

    // ------------------------------------------
    // Test 2 - Test low level encrypt routines (AES_encrypt....
    // ------------------------------------------
    testLowLevelEncryptDecrypt();
    
    // ------------------------------------------
    // Test 3,4 - Test raw string encrypt/descypt
    // ------------------------------------------
    
    // Note that we intintially don't call initializeCrypto() here - these routines are stand alone
    // and need no initialization
    testDescription = startTest(@"Test 3.0 Test raw string encrypt/decrypt");
    NSString *plainText = @"This is a test string to encrypt";
    NSString *pin = (@"This is a funky $$$ pin");
    
    NSString *encryptedText = encryptRaw(pin, plainText);
    NSString *decryptedText = decryptRaw(pin, encryptedText);
    assertT2Test(![encryptedText isEqualToString:plainText], testDescription ); // Make sure encryped is different
    assertT2Test([decryptedText isEqualToString:plainText], testDescription );  // Make sure reconstructed is same
    
    testDescription = startTest(@"Test 4.0 Test raw string encrypt/decrypt - blank string, blank pin");
    plainText = @"";
    pin = (@"");
    
    encryptedText = encryptRaw(pin, plainText);
    decryptedText = decryptRaw(pin, encryptedText);
    assertT2Test(![encryptedText isEqualToString:plainText], testDescription ); // Make sure encryped is different
    assertT2Test([decryptedText isEqualToString:plainText], testDescription ); // Make sure reconstructed is same
    
    
    // ------------------------------------------
    // Test 5/6 - Test raw binary encrypt/decrypt
    // ------------------------------------------
    testDescription = startTest(@"Test 5,6 Test raw binary encrypt/decrypt");
    pin = @"password";
    NSString *s1 = @"012345678901234567890123456789";
    const char *utfS1 = [s1 UTF8String];
    NSData *d1 = [NSData dataWithBytes:utfS1 length:strlen(utfS1)];
    
    // Test Binary encrypt/decrypt:
    NSData *encryptedData = encryptBytesRaw(pin, d1);
    NSData *decryptedData = decryptBytesRaw(pin, encryptedData);
    assertT2Test(![encryptedData isEqualToData:d1], testDescription ); // Make sure encryped is different
    assertT2Test([decryptedData isEqualToData:d1], testDescription ); // Make sure reconstructed is same
    
    // ------------------------------------------
    // Test 7 - Test key/value interface
    // ------------------------------------------
    testDescription = startTest(@"Test 7.0 Test raw string encrypt/decrypt");
    initializeCrypto(); // Initialize module
    
    // Now test out key/value interface
    NSString *value = @"Some value";
    NSString *value1 = @"Some other value";
    NSString *key1 = @"Some key";
    NSString *key2 = @"Some  other key";
    
    encryptedSaveValueForKey( pin, value, key1);
    encryptedSaveValueForKey( pin, value1, key2);

//    NSLog(@"INFO: Saved value: \"%@\" with key: \"%@\" ",value, key1);
//    NSLog(@"INFO: Saved value: \"%@\" with key: \"%@\" ",value, key2);
//    NSLog(@"");
    
    NSString *recalledValue = encryptedGetValueForKey(pin, key1);
    assertT2Test([recalledValue isEqualToString:value], testDescription );

    recalledValue = encryptedGetValueForKey(pin, key2);
    assertT2Test([recalledValue isEqualToString:value1], testDescription );

//    NSLog(@"INFO: Recalled value: \"%@\" with key \"%@\" ",recalledValue, key1);
//    NSLog(@"INFO: Recalled value: \"%@\" with key \"%@\" ",recalledValue, key2);
    
    // ------------------------------------------
    // Test 8 - Test SqlCipher
    // ------------------------------------------
    testSqlCipher();
    
    
    // ------------------------------------------
    // Test 9 - Test file encryption - you have to listen for this!
    // ------------------------------------------
    testDescription = startTest(@"Test 9.0 Test file encryption - you have to listen for this!");
    
    NSString *inputFilePath = [NSString stringWithFormat:@"%@/test124.mp3", [[NSBundle mainBundle] resourcePath]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *encryptedFilePath = [documentsDirectory stringByAppendingPathComponent:@"t4.mp3"];
    NSString *decryptedFilePath = [documentsDirectory stringByAppendingPathComponent:@"decrypted.mp3"];
    NSString *crazyPin = @"9q34un 9vq34ute noaerpt9uertv[!%!#$^&^*^%&*))%2032498132064684;asdjjf;fsjfd;fkjkflja;fdjfeie11";
    
    int result = processBinaryFile(inputFilePath,encryptedFilePath,T2Encrypt ,crazyPin);
    
    if (result == 0) {
        result = processBinaryFile(encryptedFilePath,decryptedFilePath,T2Decrypt ,crazyPin);
        
        if (result == 0) {
            // Play the decrypted file, to confirm it has been encrypted then decrypted properly.
            NSURL *fileURL = [NSURL fileURLWithPath:decryptedFilePath];
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            //  player.numberOfLoops = -1; //Infinite
            [player play];
        } else {
            assertT2Test(FALSE, testDescription );
            NSLog(@"**** Error with output file");
        }
    } else {
        assertT2Test(FALSE, testDescription );
        NSLog(@"**** Error with input file");
    }
    
    
    NSLog(@"-------------------------------------------------------------");
    NSLog(@"  Iteration %d", iterations);
    NSLog(@"-------------------------------------------------------------");

    NSLog(@"   Iteration %d  - Tests passed: %d ", iterations, testPassCount);
    NSLog(@"   Iteration %d  - Tests failed: %d ", iterations, testFailCount);

    if (testPassCount == testTotalCount) {
        NSLog(@"   ++ ALL TESTS PASSED ++ ");
       // updateView("PASSED - All t2Crypto tests");
    }
    else {
        NSLog(@"   ** ONE OF MORE t2Crypto FAILED! ** ");
        //updateView("** ONE OF MORE t2Crypto FAILED! **");
    }
    
    
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Note, make sure we are in fips mode before we start this test
void testLowLevelEncryptDecrypt() {
    
    testDescription = startTest(@"Test 2.0 Test Low Level Encrypt");
    int fipsMode = FIPS_mode();
    assertT2Test(fipsMode == T2FipsModeOn, testDescription );


    static const unsigned int AES_KEYSIZE = 16;
    static const unsigned int AES_BLOCKSIZE = 16;
        
    static const unsigned char testBlock[AES_BLOCKSIZE] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
        
    AES_KEY encryptKey = {};
    AES_KEY decryptKey = {};
    unsigned char keyBytes[AES_KEYSIZE]; // 128 bits
    unsigned char dataBytes[AES_BLOCKSIZE];
        
    memcpy(dataBytes, testBlock, sizeof(dataBytes));

            
    // RAND_bytes() returns 1 on success, 0 otherwise. The error
    // code can be obtained by ERR_get_error(3).
    retVal = RAND_bytes(keyBytes, sizeof(keyBytes));
    assertT2Test(retVal == T2True, testDescription );
    
    retVal = AES_set_encrypt_key(keyBytes, AES_KEYSIZE * 8 /*bits*/, &encryptKey);
    assertT2Test(retVal == 0, testDescription );

    retVal = AES_set_decrypt_key(keyBytes, AES_KEYSIZE * 8 /*bits*/, &decryptKey);
    assertT2Test(retVal == 0, testDescription );

    // Encrypt bytes in dataBytes, then decrypt, se should end up with the same string!
    AES_encrypt(dataBytes, dataBytes, &encryptKey);
    AES_decrypt(dataBytes, dataBytes, &decryptKey);
    assertT2Test(0 == memcmp(dataBytes, testBlock, sizeof(dataBytes)), testDescription );
}

// Note, make sure we are in fips mode before we start this test
void testSqlCipher() {
    
    testDescription = startTest(@"Test 8.0 Test SqlCipher");
    
    NSString *databasePath;
    sqlite3 *contactDB;
    NSString *docsDir;
    NSArray *dirPaths;
    
    NSString *dbValueName = @"My name";
    NSString *dbValueAddress = @"My address";
    NSString *dbValuePhone = @"My phone";
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
            
                                const char* key = [@"StrongPassword" UTF8String];
                                sqlite3_key(contactDB, key, (int)strlen(key));
            
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
                assertT2Test(NO, testDescription );
            }
            sqlite3_close(contactDB);
        } else {
            NSLog(@"Failed to open/create database");
            assertT2Test(NO, testDescription );
        }
    }
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")",
                               dbValueName, dbValueAddress, dbValuePhone];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            assertT2Test(YES, testDescription );
            NSLog(@"Contact added");
        } else {
            assertT2Test(NO, testDescription );
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    
    //const char *dbpath = [_databasePath UTF8String];
    //sqlite3_stmt    *statement;

    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT name, address, phone FROM contacts WHERE name=\"%@\"",
                              dbValueName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 1)];
                NSString *phoneField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 2)];
                NSString *nameField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 0)];
                NSLog(@"Match found");
                assertT2Test([addressField isEqualToString:dbValueAddress], testDescription );
                assertT2Test([phoneField isEqualToString:dbValuePhone], testDescription );
                assertT2Test([nameField isEqualToString:dbValueName], testDescription );
            } else {
                NSLog(@"Match not found");
                assertT2Test(NO, testDescription );
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


@end
