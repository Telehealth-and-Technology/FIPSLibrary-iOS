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
 * Government Agency Original Software Designation: ProviderResilience
 * Government Agency Original Software Title: ProviderResilience
 * User Registration Requested. Please send email
 * with your contact information to: robert.a.kayl.civ@mail.mil
 * Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.milcryp
 *
 */
void initializeCrypto();
NSString * decryptRaw(NSString *pin, NSString *cipherText);
NSString * encryptRaw(NSString *pin, NSString *plainText);

/*!
 * @brief encrypts char * string (utf 8)  using a pin
 * @discussion ** Note that the plaintext input to this routine MUST be zero terminated
 * @param pPin Pin use in encrypt/decrypt functions
 * @param pPlainText Zero terminated input string
 * @param outlength Gets set to length of output
 * @return  Encrypted text
 */
unsigned char * encryptCharString(unsigned char * pPin, unsigned char * pUencryptedText, int * outLength);

/*!
 * @brief ederypts char * string (utf 8)  using a pin
 * @discussion ** Note that the pEncryptedText input to this routine MUST be zero terminated
 * @param pPin Pin use in encrypt/decrypt functions
 * @param pEncryptedText Zero terminated input string
 * @param outlength Gets set to length of output
 * @return  Decrypted text
 */
unsigned char * decryptCharString(unsigned char * pPin, unsigned char * pUencryptedText, int * outLength);

static NSString* encodeKey = @"T2!SEf1l3*";

void encryptedSaveValueForKey( NSString *pin, NSString *value, NSString *key);
NSString * encryptedGetValueForKey(NSString *pin, NSString *key);


NSData * encryptBytesRaw(NSString *pin, NSData *bytes);
NSData * decryptBytesRaw(NSString *pin, NSData *bytes);

enum T2Operation :NSInteger {
    T2Encrypt = 1,
    T2Decrypt = -1,
    T2NOOP = 0
    
};

enum T2Enums :NSInteger{
    T2Error = -1,
    T2Success = 0,
    T2True = 1,
    T2False = 0,
    T2FipsModeOn = 1,
    T2FipsModeOff = 0
};



int processBinaryFile( NSString* inputFile, NSString* outputFile, int operation, NSString* password);

