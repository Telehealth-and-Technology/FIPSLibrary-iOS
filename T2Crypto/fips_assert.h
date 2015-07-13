// ====================================================================
// Copyright (c) 2013 The OpenSSL Project. Rights for redistribution
// and usage in source and binary forms are granted according to the
// OpenSSL license.
// ====================================================================
//  fips_assert.h
//
//  Created by Tim Hudson, Steve Marquess, Jeffrey Walton on 1/5/13.
// ====================================================================

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

#import <Availability.h>

#ifndef __IPHONE_4_0
# warning "This project uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#define UNUSED(x) ((void)(x))

#ifndef fips_assert_h
#define fips_assert_h

#include <stdlib.h>

#if !defined(NDEBUG)

#include <signal.h>

int InstallDebugTrapHandler();

#  define FIPS_ASSERT(x) { \
  if(!(x)) { \
    fprintf(stderr, "Assertion failed: %s(%d): %s\n", (char*)(__FILE__), (int)__LINE__, (char*)(__func__)); \
    raise(SIGTRAP); \
  } \
}

#else

#  define FIPS_ASSERT(x) UNUSED(x)

#endif

#endif // fips_assert.h
