# T2 Encryption Library - iOS
*The T2 Encrpytion Library provides FIPS 140-2 compliant data-at-rest security to iOS applications*  


## About the Library
This library is used in T2 iOS applications to provide data-at-rest security that complies with [FIPS 140-2](https://en.wikipedia.org/wiki/FIPS_140-2) specifications for encryption.  

  

## Getting Started

### IOS Build Instructions

Note that buildall.sh builds all of the openssl/fips files then puts the results in directory specified in setEnvOpenSslFiles.sh 

**Tools Necessary for Build** 

---   
	MAC OS-X  
	Xcode 4.x 
	Xcode 5.x (or 6.x)
	
*Note: you need both sets of Xcode tools. The simulator uses 5.x but due to a compiler issue the device needs 4.x*

#### Steps:  
***
1. Download files
2. Build files
3. Test result

###### 1. Download Files  
First, obtain fips/opsnssl files copy them to fcids/dev:  

*Option 1 (the official way):*
> Obtain the official dist and copy openssl-fips-??tar.gz, and  openssl-1.0.1?.tar.gz to the fcids/dev, and fcids/devSim directory"  

*Option 2:*    
>	Copy the files from the local distribution  
>	use command: 
>	```cp localFipsSslFiles/*.gz ./dev && cp localFipsSslFiles/*.gz ./devSim"```  
>	
>	(Alternately, the main build file will offer to copy these files for you if they are missing)
>
>	Results:  
>	
>		fcids/dev  
>		openssl-fips-??tar.gz	  
>		openssl-1.0.1?.tar.gz  

Next obtain sqlcipher source files:   
*Option 1 (the official way):*  
>			cd fcids
>			git clone git.t2.local:/git/mobile/crossplatform/sqlcipher.git
		
*Option 2:*
>	Copy the files from the local distribution (use command cp -r localFipsSslFiles/sqlcipher ./)
>	(Alternately, the main build file will offer to copy these files for you if they are missing)
		
		Results: 
			fcids/sqlcipher
				.. Lots of files and directories (~2.9 Gb)

###### 2. Build Files
First, confirm the correct openssl and fips files are specified for the build in the file setEnvOpenSslFiles.sh  
		
Currently the defauls are: openssl-1.0.1f, openssl-fips-2.0.2  

Next, execute main build file: ```sudo ./buildAll.sh```

###### 3. IOS test programs
**fips-pi**  ```fcids/test/fips-pi/fips-pi.xcodeproj```

Native IOS program that links in crypto library at
>		/usr/local/ssl/Release-iphoneos/libcrypto.a (default location for t2 build)
		
Presents ui that allows uses to manuall enter/edit fips mode  

User needs to examine log file (in xcode) to make sure there are no errors when switching into and out of fips mode.  
	
**testCordova**  ```fcids/test/testcordova/platforms/ios/testcordova.xcodeproj```

Coirdova program that links in crypto library at
>		/usr/local/ssl/Release-iphoneos/libcrypto.a

Does very basic db insert to verify operation of IOS portion of Cordova-SqlcipherPlugin

***  
  


## Known Issues
There are no known issues with the library at this time. 


## License and Contributors

### Contributors
David Coleman  
Scott Coleman  
[David Cooper](https://github.com/dccooper/)   
Bob Kayl  
Steve Ody 

### License
2016 The National Center for Telehealth and Technology
Provider Resilience is Licensed under the NASA Open Source License.
>
 >
 > Copyright  2009-2014 United States Government as represented by
 > the Chief Information Officer of the National Center for Telehealth
 > and Technology. All Rights Reserved.
 >
 > Copyright  2009-2014 Contributors. All Rights Reserved.
 >
 > THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 > REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 > COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 > AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 > THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 > INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 > REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 > DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 > HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 > RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 >
 > Government Agency: The National Center for Telehealth and Technology  
 > Government Agency Original Software Designation: ProviderResilience  
 > Government Agency Original Software Title: ProviderResilience  
 > User Registration Requested.  
 > Please send email with your contact information to: robert.a.kayl.civ@mail.mil  
 > Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil  
 >



## About The National Center for Telehealth & Technology
Our mission at the [National Center for Telehealth & Technology] is to lead the innovation of mobile health and telehealth solutions to deliver psychological health and traumatic brain injury care and support to our nation’s warriors, veterans and their families. T2 is a Department of Defense organization, a component center of the [Defense Centers of Excellence for Psychological Health and Traumatic Brain Injury].

Our vision is world-class health care and optimized health in the DoD through effective leveraging of behavioral science and technology. 


[National Center for Telehealth & Technology]: http://t2health.dcoe.mil
[Defense Centers of Excellence for Psychological Health and Traumatic Brain Injury]: http://dcoe.mil
