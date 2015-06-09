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
 * Government Agency Original Software Designation: ProviderResilience
 * Government Agency Original Software Title: ProviderResilience
 * User Registration Requested. Please send email
 * with your contact information to: robert.a.kayl.civ@mail.mil
 * Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil
 *
 */
#include "openssl/evp.h"
// FIPS_mode, FIPS_mode_set, ERR_get_error, etc
#include "openssl/crypto.h"
#include "openssl/err.h"

// Random operations to test FIPS mode
#include "openssl/rand.h"
#include "openssl/aes.h"


#define LOGE(...) \
NSLog(@__VA_ARGS__);

#define LOGI(...) \
NSLog(@__VA_ARGS__);


#define GENERIC_BUFFER_SIZE 1024

#define EVP_aes_256_cbc_Key_LENGTH 32
#define EVP_aes_256_cbc_Iv_LENGTH 16

int const T2Error2 = -1;
int const T2Success2 = 0;

int const T2True = 1;
int const T2False = 0;
unsigned char * genericBuffer[GENERIC_BUFFER_SIZE];

// Make sure that length of cannedKeyBytes = CANNED_RI_KEY_BYTES_LENGTH!!!!!!
#define MAX_KEY_LENGTH 32
#define CANNED_RI_KEY_BYTES_LENGTH MAX_KEY_LENGTH
static const unsigned char cannedKeyBytes[] = {0x57, 0x1b, 0x2d, 0x38, 0x26, 0x52, 0xdd, 0x42,
    0xfe, 0x15, 0x5f, 0xbf, 0x1f, 0x8d, 0x2c, 0x46, 0xc7, 0xc0, 0x67, 0xdb, 0x29, 0xed, 0xa3,
    0x01, 0x55, 0x4e, 0x7f, 0x0c, 0x35, 0x57, 0x0e, 0x87};


// Make sure length of cannedSaltRaw = SALT_LENGTH!!!!
#define SALT_LENGTH 8
unsigned char mainSalt[SALT_LENGTH];
unsigned char *_salt = &mainSalt[0];
static const unsigned char cannedSaltRaw[] = {0x93, 0x0e, 0x4b, 0x4f, 0x72, 0x62, 0xaf, 0x75};

/*!
 * @typedef T2Key
 * @discussion Structure containing elements necessary for an encryption key
 *              "opaque" encryption, decryption ctx structures that libcrypto
 *              uses to record status of enc/dec operations
 */
typedef struct {
    EVP_CIPHER_CTX encryptContext;
    EVP_CIPHER_CTX decryptContext;
    int ivLength;
    int keyLength;
    unsigned char key[MAX_KEY_LENGTH], iv[MAX_KEY_LENGTH];
} T2Key;

/*!
 * @brief Utility to log a binary array as a string
 * @param binary array to log
 * @param binsz Length of input
 * @param message Message to prepend to log line
 */
void logAsHexString(unsigned char * bin, unsigned int binsz, char * message) {
    
    char *result;
    char          hex_str[]= "0123456789abcdef";
    unsigned int  i;
    
    result = (char *)malloc(binsz * 2 + 1);
    if (result == NULL) {
        return;
    }
    (result)[binsz * 2] = 0;
    
    if (!binsz)
    return;
    
    for (i = 0; i < binsz; i++) {
        (result)[i * 2 + 0] = hex_str[bin[i] >> 4  ];
        (result)[i * 2 + 1] = hex_str[bin[i] & 0x0F];
    }
    
    LOGI("   %s = : %s \n", message, result);
    free(result);
    
}

/*!
 * @brief Utility to convert binary bytes to hex string
 * @param bin array to convert
 * @param binsz Length of input
 */
char * binAsHexString_malloc(unsigned char *bin, unsigned int binsz ) {
    
    char *result;
    char          hex_str[]= "0123456789abcdef";
    unsigned int  i;
    
    result = malloc(binsz * 2 + 1);
    (result)[binsz * 2] = 0;
    
    if (!binsz)
    return NULL;
    
    for (i = 0; i < binsz; i++) {
        (result)[i * 2 + 0] = hex_str[bin[i] >> 4  ];
        (result)[i * 2 + 1] = hex_str[bin[i] & 0x0F];
    }
    
    return result;
    
}

/*!
 * @brief Utility to covet Hex string to binary
 * @param hex String to covert
 * @param stringLength Length of input (Also gets set to length of output)
 * @return  Binary representation of input string
 */
unsigned char * hexStringAsBin_malloc(unsigned char * hex, int *stringLength) {
    
    unsigned char *result;
    unsigned int  i;
    
    if (!stringLength) {
        LOGI("No string length!");
        return NULL;
    }
    
   unsigned long inStringLength = (unsigned long) *stringLength;
    
    *stringLength = *stringLength / 2;
    
    result = malloc((unsigned long) *stringLength);
    if (result == NULL) {
        LOGE("xxFAILxx   Unable to allocate memory");
        return NULL;
    }
    
    int resultIndex = 0;
    unsigned char tmp = 0;;
    for (i = 0; i < inStringLength; i++) {
        unsigned char digit = hex[i];
        //LOGI("digit = %x", digit);
        if (digit >= 0x30 && digit <= 0x39) {
            tmp = digit - 0x30;
        } else if (digit >= 0x61 && digit <= 0x66) {
            tmp = digit - 0x61 + 10;
        }
        
        if ((i & 1) == 0) {
           result[resultIndex] = (unsigned char) (tmp << 4);
            //LOGI("even - tmp = %x, resultIndex = %d, result[resultIndex] = %x", tmp, resultIndex, result[resultIndex]);
        } else {
            
            result[resultIndex] |= tmp;
            //LOGI("odd - tmp = %x, resultIndex = %d, result[resultIndex] = %x", tmp, resultIndex, result[resultIndex]);
            resultIndex++;
        }
    }
    return result;
}

void initializeCrypto() {
 
    /**
     * @brief RIKeyBytes - Bytes used as input for RIKey calculation
     * This is the initial set of bytes (password) used to create the Random Initialization Key (RIKey)
     * which will be used as a basis for all of the encryption/decryption
     *
     * There are two cases
     * if _useTestVectors is true
     *   RIKeyBytes will consist of the test password CANNED_RI_KEY_BYTES = "password"
     * else (normal operation)
     *   RIKeyBytes will be a random set of bytes
     */
    
    //LOGI(" -- Using test vectors for key ---");
    
    unsigned char *RIKeyBytes = malloc(sizeof(char) * CANNED_RI_KEY_BYTES_LENGTH );
    NSCAssert((RIKeyBytes != NULL), @"Memory allocation error for RIKey!");
    

    memcpy(RIKeyBytes, cannedKeyBytes, CANNED_RI_KEY_BYTES_LENGTH);
    memcpy(_salt,cannedSaltRaw,SALT_LENGTH);
}


/*!
 * @brief encrypts plain text
 * @param encryptContext Encryption context
 * @param plaintext bytes to encrypt
 * @param len Length of input (also gets set as length of output)
 * @return  encrypted bytes
 */
unsigned char * aes_encrypt_malloc(EVP_CIPHER_CTX * encryptContext , unsigned char * plaintext, int * len) {
    /* max ciphertext len for a n bytes of plaintext is n + AES_BLOCK_SIZE -1 bytes */
    int c_len = *len + AES_BLOCK_SIZE;
    int f_len = 0;
    unsigned char *pCiphertext = malloc((unsigned long) c_len);
    if (pCiphertext == NULL) {
        
        return NULL;
    }
    
    /* allows reusing of 'encryptContext' for multiple encryption cycles */
    EVP_EncryptInit_ex(encryptContext, NULL, NULL, NULL, NULL);
    
    /* update ciphertext, c_len is filled with the length of ciphertext generated,
     *len is the size of plaintext in bytes */
    EVP_EncryptUpdate(encryptContext, pCiphertext, &c_len, plaintext, *len);
    
    /* update ciphertext with the final remaining bytes */
    EVP_EncryptFinal_ex(encryptContext, pCiphertext+c_len, &f_len);
    
    *len = c_len + f_len;
    return pCiphertext;
}

/*!
 * @brief Decrypts encrypted test
 * @discussion
 * @param decryptContext Decryption context
 * @param ciphertext bytes to decrypt
 * @param len Length of input (also gets set as length of output)
 * @return  Decrypted bytes
 */
unsigned char * aes_decrypt_malloc(EVP_CIPHER_CTX * decryptContext, unsigned char * ciphertext, int *len) {
    /* plaintext will always be equal to or lesser than length of ciphertext*/
    int p_len = *len, f_len = 0;
    unsigned char *plaintext = malloc((unsigned long) p_len);
    if (plaintext == NULL) {
        LOGE("xxFailxx Memory allocation error");
        return NULL;
    }
    
    EVP_DecryptInit_ex(decryptContext, NULL, NULL, NULL, NULL);
    EVP_DecryptUpdate(decryptContext, plaintext, &p_len, ciphertext, *len);
    EVP_DecryptFinal_ex(decryptContext, plaintext+p_len, &f_len);
    
    *len = p_len + f_len;
    
    return plaintext;
}


/*!
 * @brief Initializes a T2Key based on a password
 * @discussion Performs KDF function on a password and salt to initialize a T2Key.
 * This is used to generate a T2Key from a password (or pin)
 * @param key_data Password to use in KDF function
 * @param key_data_len Length of password
 * @param salt Salt to use in KDF function
 * @param aCredentials T2Key to initialize
 * @return  T2Success2 or T2Error2
 */
int key_init(unsigned char * key_data, int key_data_len, unsigned char * salt, T2Key * aCredentials) {
    int i, nrounds = 5;
    
    /*
     * Gen key & IV for AES 256 CBC mode. A SHA1 digest is used to hash the supplied key material.
     * rounds is the number of times the we hash the material. More rounds are more secure but
     * slower.
     * This uses the KDF algorithm to derive key from password phrase
     */
    i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_sha1(), salt, key_data, key_data_len, nrounds, aCredentials->key, aCredentials->iv);
    if (i != EVP_aes_256_cbc_Key_LENGTH) {
        LOGI("ERROR: Key size is %d bits - should be %d bits\n", i, EVP_aes_256_cbc_Key_LENGTH * 8);
        return T2Error2;
    }
    
    // For EVP_aes_256_cbc, key length = 32 bytes, iv length = 16 types
    aCredentials->keyLength = EVP_aes_256_cbc_Key_LENGTH;
    aCredentials->ivLength = EVP_aes_256_cbc_Iv_LENGTH;
    
    //logAsHexString(( unsigned char *)aCredentials->key, (unsigned int) aCredentials->keyLength, "    key");
    //logAsHexString((unsigned char *)aCredentials->iv, (unsigned int) aCredentials->ivLength, "     iv");
    
    // Setup encryption context
    EVP_CIPHER_CTX_init(&aCredentials->encryptContext);                                     // Initialize ciipher context
    EVP_EncryptInit_ex(&aCredentials->encryptContext, EVP_aes_256_cbc(), NULL, aCredentials->key, aCredentials->iv);    // Set up context to use specific cyper type
    
    EVP_CIPHER_CTX_init(&aCredentials->decryptContext);                                     // Initialize ciipher context
    EVP_DecryptInit_ex(&aCredentials->decryptContext, EVP_aes_256_cbc(), NULL, aCredentials->key, aCredentials->iv);    // Set up context to use specific cyper type
    
    return T2Success2;
}


/*!
 * @brief encrypts string using a T2Key
 * @discussion ** Note that the plaintext input to this routine MUST be zero terminated
 * @param credentials T2Key credentials to use in encrypt/decrypt functions
 * @param pUencryptedText Zero terminated input string
 * @param outlength Gets set to length of output
 * @return  Encrypted text
 */
unsigned char * encryptStringUsingKey_malloc(T2Key * credentials, unsigned char * pUencryptedText, int * outLength) {
    int len1 = (int) strlen((char *)pUencryptedText) + (int) 1; // Make sure we encrypt the terminating 0 also!
    unsigned char* szEncryptedText =  aes_encrypt_malloc(&credentials->encryptContext, pUencryptedText, &len1);
    *outLength = len1;
    return szEncryptedText;
}

/*!
 * @brief Decrypts binary array using a T2Key
 * @discussion
 * @param credentials T2Key credentials to use in encrypt/decrypt functions
 * @param encryptedText Bytes to decrypt
 * @param inLength length if input (Also gets set to length of output)
 * @return  Decrypted binary
 */
unsigned char * decryptUsingKey_malloc1(T2Key * credentials, unsigned char * encryptedText, int * inLength) {
    unsigned char* decryptedText =  aes_decrypt_malloc(&credentials->decryptContext, encryptedText, inLength);
    return decryptedText;
}

/*!
 * @brief Encrypts an NSString given a password
 * @discussion Uses FIPS encryption/deccryption
 * @param pin Pin to use to generate a key
 * @param plainText Text to encrypt
 * @return Encrypted string
 */
NSString * encryptRaw(NSString *pin, NSString *plainText) {
    T2Key RawKey;
    genericBuffer[0] = 0;   // Clear out generic buffer in case we fail
    
    unsigned char *key_data;
    int key_data_len;
    key_data = (unsigned char *)pin.UTF8String;
    key_data_len = (int) strlen(pin.UTF8String);
 
    // Generate RawKey = kdf(PIN)
    // ------------------------------
    /* gen key and iv. init the cipher ctx object */
    if (key_init(key_data, key_data_len, (unsigned char *)cannedSaltRaw, &RawKey)) {
        NSCAssert(FALSE, @"ERROR: initializing key");
        NSString* message = [NSString stringWithFormat:@"%s", (char *) genericBuffer];
        return message;
    } else {
        
        int outLength;
        unsigned char *encryptedString = encryptStringUsingKey_malloc(&RawKey, (unsigned char *)plainText.UTF8String, &outLength);
        NSCAssert((encryptedString != NULL), @"Memory allocation error");
        
        // Note: we can't return the encrhypted string directoy because JAVA will try to
        // interpret it as a string and fail UTF-8 conversion if any of the encrypted characters
        // have the high bit set. Therefore we must return a hex string equivalent of the binary
        char *tmp = binAsHexString_malloc(encryptedString, (unsigned int) outLength);
        NSCAssert((tmp != NULL), @"Memory allocation error");
        
        if (strlen((char *)tmp) < GENERIC_BUFFER_SIZE) {
            sprintf((char*) genericBuffer, "%s", tmp);
        } else {
            LOGE("String to encrypt is too large!");
        }
        free(tmp);
    }
    NSString* message = [NSString stringWithFormat:@"%s", (char *) genericBuffer];
    return message;
    
}

/*!
 * @brief Decrypts a NSString given a password
 * @discussion Uses FIPS encryption/deccryption
 * @param pin Pin to use to generate a key
 * @param cipherText Text to decrypt
 * @return Decrypted string
 */
NSString * decryptRaw(NSString *pin, NSString *cipherText) {
    T2Key RawKey;
    genericBuffer[0] = 0;   // Clear out generic buffer in case we fail
    
    unsigned char *key_data;
    int key_data_len;
    key_data = (unsigned char *)pin.UTF8String;
    key_data_len = (int) strlen(pin.UTF8String);
    
    // Generate RawKey = kdf(PIN)
    // ------------------------------
    /* gen key and iv. init the cipher ctx object */
    if (key_init(key_data, key_data_len, (unsigned char *)cannedSaltRaw, &RawKey)) {
        NSCAssert(FALSE, @"ERROR: initializing key");
        NSString* message = [NSString stringWithFormat:@"%s", (char *) genericBuffer];
        return message;
    } else {
        
        // 03/31/15 BGD Don't try to access cipherText if it is nil!)
        //int resultLength = (int) strlen(cipherText.UTF8String);
        int resultLength = 0;
        if (cipherText != nil) {
            resultLength = (int) strlen(cipherText.UTF8String);
        } else {
            resultLength = 0;
        }
        
        unsigned char *resultBinary = hexStringAsBin_malloc((unsigned char*)cipherText.UTF8String, &resultLength);
        if (resultBinary != NULL) {
            
            unsigned char *decrypted = decryptUsingKey_malloc1(&RawKey, ( unsigned char*)resultBinary, &resultLength);
            
            NSCAssert((decrypted != NULL), @"Memory allocation error");
            
            if (resultLength < GENERIC_BUFFER_SIZE) {
                memcpy(genericBuffer, decrypted, resultLength);
            } else {
                LOGE("String to decrypt is too large!");
            }
            free(resultBinary);

            
        }
    }

    NSString* message = [NSString stringWithFormat:@"%s", (char *) genericBuffer];
    return message;
    
}




/*!
 * @brief Encrypts a key/value pair and saves them to user defaults
 * @discussion Uses FIPS encryption/deccryption
 * @param pin Pin to use to generate a key
 * @param value Value to save to user defaults
 * @param key Key to use
 */
void encryptedSaveValueForKey( NSString *pin, NSString *value, NSString *key) {
    NSString *encryptedKey = encryptRaw(pin, key);
    NSString *encryptedValue = encryptRaw(pin, value);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encryptedValue forKey:encryptedKey];
    [defaults synchronize];
}

/*!
 * @brief Decrypts a key/value pair and recalls from user defaults
 * @discussion Uses FIPS encryption/deccryption
 * @param pin Pin to use to generate a key
 * @param key Key to use
 * @return returned value
 */
NSString * encryptedGetValueForKey(NSString *pin, NSString *key) {

    NSString *encryptedKey = encryptRaw(pin, key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *encryptedValue = [defaults objectForKey:encryptedKey];
    return decryptRaw(pin, encryptedValue);
}













