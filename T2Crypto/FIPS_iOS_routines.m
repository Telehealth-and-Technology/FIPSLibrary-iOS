//
//  FIPS_iOS_routines.m
//  ProviderResilience
//
//  Created by Brian Doherty on 3/19/15.
//
//
/*
 *
 * Copyright � 2009-2014 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright � 2009-2014 Contributors. All Rights Reserved.
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

#import <Foundation/Foundation.h>
#import "FIPS_iOS_routines.h"
#import "T2Crypto.h"

static const unsigned int FIPS_AES_KEYSIZE = 16;
static const unsigned int FIPS_AES_BLOCKSIZE = 128;
static const unsigned char FIPS_keyClue[FIPS_AES_KEYSIZE] = {'B','r','i','a','n','G','a','i','l','D','o','h','e','r','t','y'};

//
// Symbols from fips_premain.c
//static const unsigned int   MAGIC_20 = 20;
//extern const void*          FIPS_text_start(),  *FIPS_text_end();
//extern const unsigned char  FIPS_rodata_start[], FIPS_rodata_end[];
//extern unsigned char        FIPS_signature[20];
//extern unsigned int         FIPS_incore_fingerprint (unsigned char *, unsigned int);

// This Key has to be exactly 256 bits!  (16 segments @ 16 bits each)
//                                           !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !
NSString * const T2DatabaseKeyValue = @"x'd6cacacf9c1078dcc0717e1221274fefdc8743ed60097e79909cc8086e4f0733'";

// Encryption PIN
NSString * const T2Pin = @"aToZ";


#pragma mark FIPS (test to make sure we can enter FIPS mode)


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

// Make sure FIPS mode is on
BOOL FIPS_turnOn()
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
            mode = 1;
        }
    }
    else
    {
        NSLog(@"\n  FIPS mode is already on.");
    }
    
    return mode;
}

/*
// Encryption Key
NSString  *FIPS_EncryptionKey() {
    unsigned char keyBytes[FIPS_AES_KEYSIZE]; // 128 bits
    unsigned long err = 0;
    int ret = 0;
    
    AES_KEY encryptKey = {};
    
    // Seed the key (from the 'flowerpot')
    memcpy(keyBytes, FIPS_keyClue, sizeof(FIPS_keyClue));
    
    ret = AES_set_encrypt_key(keyBytes, FIPS_AES_KEYSIZE * 8, &encryptKey);
    err = ERR_get_error();
    
    FIPS_ASSERT(ret == 0);
    if(!(ret == 0)) {
        DisplayErrorMessage("\n  AES_set_encrypt_key failed", err);
    }
    
    return encryptKey;
}

// Decryption Key
NSString *FIPS_DecryptionKey() {
    unsigned char keyBytes[FIPS_AES_KEYSIZE]; // 128 bits
    unsigned long err = 0;
    int ret = 0;
    
    AES_KEY decryptKey = {};
    
    // Seed the key (from the 'flowerpot')
    memcpy(keyBytes, FIPS_keyClue, sizeof(FIPS_keyClue));
    
    ret = AES_set_decrypt_key(keyBytes, FIPS_AES_KEYSIZE * 8, &decryptKey);
    err = ERR_get_error();
    
    FIPS_ASSERT(ret == 0);
    if(!(ret == 0)) {
        DisplayErrorMessage("\n  AES_set_decrypt_key failed", err);
    }
    
    return decryptKey;
    
}
*/


// SQL Databasekey
NSString *FIPS_SQLKey() {
    return T2DatabaseKeyValue;
}

// PIN
NSString *FIPS_Pin() {
    return T2Pin;
}

// This routine toggles FIPS mode on/off....used for testing
void FIPS_flip()
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
    
    // Verify mode is consistent.
    if(1 == ret)
    {
        //BOOL state = [m_modeSwitch isOn];
        mode = FIPS_mode();
        //FIPS_ASSERT((0 != mode && YES == state) || (0 == mode && NO == state));
    }
    
    // Attempt a few operations in FIPS mode of operation
    if(1 == ret && 0 != mode)
    {
        
        static const unsigned char testBlock[FIPS_AES_BLOCKSIZE] = {'S','e','a','t','t','l','e','S','e','a','h','a','w','k','s','!'};
        
        // Generate the keys with functions
        AES_KEY encryptKey = {};
        AES_KEY decryptKey = {};
        unsigned char keyBytes[FIPS_AES_KEYSIZE]; // 128 bits
        
        unsigned char dataBytes[FIPS_AES_BLOCKSIZE];
        
        memcpy(dataBytes, testBlock, sizeof(testBlock));
        
        NSLog(@"Initialized *************************");
        NSLog(@"d: %.32s",dataBytes);
        NSLog(@"t: %.32s",testBlock);
        NSLog(@"Initialized *************************");
        
        
        do {
            
            // RAND_bytes() returns 1 on success, 0 otherwise. The error
            // code can be obtained by ERR_get_error(3).
            //ret = RAND_bytes(keyBytes, sizeof(keyBytes));
            //err = ERR_get_error();
            
            // Seed the key
            memcpy(keyBytes, FIPS_keyClue, sizeof(FIPS_keyClue));
            NSLog(@"Clue: %s",keyBytes);
            
            FIPS_ASSERT(ret == 1);
            if(!(ret == 1)) {
                DisplayErrorMessage("\n  RAND_bytes failed", err);
                break; // failed
            }
            
            ret = AES_set_encrypt_key(keyBytes, FIPS_AES_KEYSIZE * 8, &encryptKey);
            err = ERR_get_error();
            
            FIPS_ASSERT(ret == 0);
            if(!(ret == 0)) {
                DisplayErrorMessage("\n  AES_set_encrypt_key failed", err);
                break; // failed
            }
            
            ret = AES_set_decrypt_key(keyBytes, FIPS_AES_KEYSIZE * 8, &decryptKey);
            err = ERR_get_error();
            
            FIPS_ASSERT(ret == 0);
            if(!(ret == 0)) {
                DisplayErrorMessage("\n  AES_set_decrypt_key failed", err);
                break; // failed
            }
    
    
        
            //NSString *encryptKey = FIPS_EncryptionKey();
            //NSString *decryptKey = FIPS_DecryptionKey();
    
            // Encrypt bytes in dataBytes, then decrypt, so should end up with the same string
            AES_encrypt(dataBytes, dataBytes, &encryptKey);
            
            NSLog(@"Encrypted *************************");
            NSLog(@"e: %.16s",(char *)&encryptKey);
            NSLog(@"c: %.32s",dataBytes);
            NSLog(@"o: %.32s",testBlock);
            NSLog(@"Encrypted *************************");
            
            AES_decrypt(dataBytes, dataBytes, &decryptKey);
            NSLog(@"Decrypted *************************");
            NSLog(@"d: %.16s",(char*)&decryptKey);
            NSLog(@"c: %.32s",dataBytes);
            NSLog(@"o: %.32s",testBlock);
            NSLog(@"Decrypted *************************");
            
            
            // Did it round trip?
            FIPS_ASSERT(0 == memcmp(dataBytes, testBlock, sizeof(dataBytes)));
            if(!(0 == memcmp(dataBytes, testBlock, sizeof(dataBytes )))) {
                DisplayErrorMessage("\n  Data did not round trip", 0);
                //break; /* failed */
            } else {
                NSLog(@"Successful roundtrip encrypt/decrypt!");
            }
            
        } while(0);
    }
}


// Plist Encryption/Decryption

// Decrypt and return the value for the key in the specified plist (i.e.; NSDictionary)
NSString * encryptedGetStringForKeyPlist(NSString *pin, NSString *key, NSDictionary *dictionary) {
    
    // Generate the encrypted key (using the pin and the unencrypted value of the key)
    NSString *encryptedKey = encryptRaw(pin, key);
    
    // Now retrieve the encrypted value from the dictionary
    NSString *encryptedValue = [dictionary objectForKey:encryptedKey];
    
    // Return the decrypted value
    return decryptRaw(pin, encryptedValue);
    
}

// Encrypt the specified String value and write it to the plist (i.e.; NSDictionary)
void encryptedSaveStringForKeyPlist(NSString *pin, NSString *value, NSString *key, NSMutableDictionary *dictionary) {
    
    // Generate the encrypted key (using the pin and the unencrypted value of the key)
    NSString *encryptedKey = encryptRaw(pin, key);
    
    // Encrypt the value associated with this key
    NSString *encryptedValue = encryptRaw(pin, value);
    
    // Write it to the specified dictionary
    [dictionary setObject:encryptedValue forKey:encryptedKey];
    
}


// Decrypt and return the NSNumber for the key in the specified plist (i.e.; NSDictionary)
NSNumber * encryptedGetNumberForKeyPlist(NSString *pin, NSString *key, NSDictionary *dictionary) {
    
    // Generate the encrypted key (using the pin and the unencrypted value of the key)
    NSString *encryptedKey = encryptRaw(pin, key);
    
    // Now retrieve the encrypted value from the dictionary
    NSString *encryptedValue = [dictionary objectForKey:encryptedKey];
    
    NSString *tempResult = decryptRaw(pin, encryptedValue);
    NSLog(@"encryptGetNumberForKeyPlist: %@",tempResult);
    
    // Return the decrypted value
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:tempResult];
    
    return myNumber;
    
}

// Encrypt the specified NSNumber value and write it to the plist (i.e.; NSDictionary)
void encryptedSaveNumberForKeyPlist(NSString *pin, NSNumber *value, NSString *key, NSMutableDictionary *dictionary) {
    
    // Generate the encrypted key (using the pin and the unencrypted value of the key)
    NSString *encryptedKey = encryptRaw(pin, key);
    
    // Convert the value to a string
    NSString *valueString = [value stringValue];
    
    // Encrypt the value associated with this key
    NSString *encryptedValue = encryptRaw(pin, valueString);
    
    // Write it to the specified dictionary
    [dictionary setObject:encryptedValue forKey:encryptedKey];
    
}



