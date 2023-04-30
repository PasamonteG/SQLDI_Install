# WMLZ Demployment

These are the WMLZ moving parts.

![wmlzarch](wmlzimages/wmlzarch.JPG)


There are the 21 implementation steps for WMLZ V2.4  

The [KC_Link](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=installation-roadmap) 


```
Step 1	Preparing for WMLz installation	(Sysprog, WMLz user)	 
Step 2	Planning system capacity for WMLz	(Sysprog, WMLz user)	 
Step 3	Obtaining SMP/E image and PTFs for WMLz	z/OS (Sysprog)	 
Step 4	Procuring, installing, and configuring prerequisites for WMLz (Sysprog with USS skills)	 
Step 5	Installing WMLz, including the bundled IzODA (Spark, Anaconda, and MDS) (Sysprog with USS skills) 
Step 6	Configuring WMLz setup user ID	(Sysprog with USS & Security skills)	 
Step 7	Configuring additional user IDs	(Sysprog with USS & Security skills)
Step 8	Configuring network ports for WMLz	(Sysprog with USS & Security skills)	 
Step 9	Configuring secure network communications for WMLz	(Sysprog with USS & Security skills)
        Security mechanisms: AT-TLS policy ; Keyring-based keystore ; File-based keystore
Step 10	Configuring WMLz (Sysprog with USS skills)	 
Step 11	Configuring ONNX compiler service ... Optional (Sysprog with USS skills)	
Step 12	Configuring Python runtime environment ... Optional (Sysprog with USS skills)	
Step 13	Configuring client authentication for z/OS Spark  ... Optional (Sysprog with USS skills)	 
Step 14	Configuring WML for z/OS scoring services (Sysprog with USS skills)	
        Configuration method: administration dashboard ; interactive shell scripts 
Step 15	Configuring WML for z/OS scoring services in a CICS region	... Optional (Sysprog with USS skills; CICS skills) 
Step 16	Configuring scoring services for high availability ...	Optional	(Sysprog with USS skills; Network skills)	 
Step 17	Configuring Db2 anomaly detection solution	... Optional (Sysprog with USS skills)
Step 18	Configuring WMLz for high performance ...	Optional (Sysprog with USS skills)	 
Step 19	Configuring a WMLz cluster for high availability	... Optional	(Sysprog with USS skills) 
Step 20	Configuring a standalone Jupyter notebook server	... Optional	(Sysprog with USS skills) 
Step 21	Verifying WMLz installation and configuration	... Optional	(Sysprog with USS skills)	

```

So, Tally Ho, Lets get on with it.

## Step 1	Preparing for WMLz installation	(Sysprog, WMLz user)	

[KC_pereqs_page](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-installing-prerequisites) 

***System*** z16, z15™, z14, z13®, or zEnterprise® EC12 system. ( I've got ZVDT & ZPDT, which emulate these bad boys ).

***z/OS*** z/OS 2.5 or 2.4. Bingo : z/OS V2.5 

***PTFs*** For z/OS 2.5, apply PTFs UI64830, UI64837, and UI64940. (all applied for SQLDI)

***zDNN*** For z/OS 2.5, apply APARs OA62901, OA62902, and OA62903. (all applied for SQLDI)
 
***z/OS Integrated Cryptographic Service Facility (ICSF).*** Make sure that the ICSF component is properly configured and started. 
Yup - standard part of ADCD.

***z/OS OpenSSH***. See z/OS OpenSSH for instructions. Yup

***IBM 64-bit SDK for z/OS Java*** Yup Version 8 SR6 FP25 or later.

***Db2® 12 for z/OS*** or later. Yup V12 & V13

***CICS TS for z/OS 5.6.0*** with PTFs UI77466, UI80396 and UI80397 or later only if you plan to configure and run a scoring service in a CICS region. Yup.

***IBM z/OS Container Extensions 2.4*** with PTF OA59111 applied ( PTF not found in MVST )

So, we're good to go for everything except zCX 



## Step 2	Planning system capacity for WMLz	(Sysprog, WMLz user)	

***Planning system capacity*** Ha ha ( 4 zIIPs, 1 GCP, 100GB memory, 100GB DASD ). Can emulate everything except 100GB memory.
Probably be OK.

## Step 3	Obtaining SMP/E image and PTFs for WMLz	z/OS (Sysprog)	 

Ordered WMLZ Portable Software Instance from ShopZ. Good to go. 

## Step 4	Procuring, installing, and configuring prerequisites for WMLz (Sysprog with USS skills)	 

Nothing to do, Good to go. 

## Step 5	Installing WMLz, including the bundled IzODA (Spark, Anaconda, and MDS) (Sysprog with USS skills) 

Review the [KC_Link](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-installing)

The SMP/E program installs WMLz in the default /usr/lpp/IBM/aln/v2r4 directory, which is referred as $IML_INSTALL_DIR. The directory structure should look similar to the following example:

![usspaths](wmlzimages/usspaths.JPG)

The April 2023 download 
1. is missing the IMIzOS.properties directory.
2. includes /Z25C/usr/lpp/IBM/aln/v2r4/usr/extension/installableApps/scoring-wola.war


I think I may be missing a couple of pre-reqs. 
* zCX is optional, and only needed for deep learning models
* izoda is probably only needed for the WMLZ IDE, which we dont need. Check with Maggie Lin

![zcx_and_izoda](wmlzimages/zcx_and_izoda.JPG)



## Step 6	Configuring WMLz setup user ID	(Sysprog with USS & Security skills)	

### Create <mlz_setup_userid>

```
//CREATE JOB (0),'WMLZ RACF',CLASS=A,REGION=0M,
//             MSGCLASS=H,NOTIFY=&SYSUID
//*------------------------------------------------------------*/
//RACF     EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
ADDGROUP <mlz_group> OMVS(GID(<group-identifier>)) OWNER(SYS1)
ADDUSER <mlz_setup_userid> DFLTGRP(<mlz_group>) OMVS(UID(<user-identifier>) HOME(/u/<mlz_setup_userid>) -
PROGRAM($IML_INSTALL_DIR/iml-zostools/bin/bash)) -
NAME('WMLZ ID') PASSWORD(<password>) NOOIDCARD
/*
```

where

* <mlz_setup_userid> is the user ID that you will use to configure and run WMLz.
* <mlz_group> is a RACF® group that you will use to associate WML for z/OS users and manage their access.
* <group-identifier> is the identifier for <mlz_group>.
* <user-identifier> is the identifier for <mlz_setup_userid>. Do not use UID 0 for <mlz_setup_userid>.
* $IML_INSTALL_DIR is the directory where WMLz is installed. The default is /usr/lpp/IBM/aln/v2r4.


### Paths and ZFS


Allocate a minimum of 500 MB disk space to the home directory for <mlz_setup_userid>

Create the $IML_HOME directory. Make sure that $IML_HOME is mounted to a zFS file system with at least 50 GB storage available

Consider creating the $IML_HOME/spark subdirectory  mounted on a separate zFS file system with at least 4 GB storage available.

chown –R <mlz_setup_userid>:<mlz_group> $IML_HOME/

To allocate zFS data sets for $IML_HOME and $IML_HOME/spark that are larger than 4GB, make sure that you specify DFSMS data class with extended format and extended addressability.


### USS Environment 


Configure your z/OS UNIX shell environment for <mlz_setup_userid> ```/u/<mlz_setup_userid>/.profile```

```
Copy the $IML_INSTALL_DIR/alnsamp/profile.template directory into $HOME/.profile for <mlz_setup_userid>.
/usr/lpp/IBM/aln/v2r4/alnsamp/profile.template
set 
$SPARK_HOME = /usr/lpp/IBM/izoda/spark/spark24x
$ANACONDA_ROOT = /usr/lpp/IBM/izoda/anaconda 
$JAVA_HOME = ?SQLDI 
$IML_HOME = /u/wmlz
$IML_INSTALL_DIR = /usr/lpp/IBM/aln/v2r4 
$IML_JOBNAME_PREFIX = WMLZ 
$AIE_INSTALL_DIR = /usr/lpp/IBM/aie 
If necessary, set $XL_CONFIG to the xlc.cfg file ... n/a unless using ZCX & DLC 

PATH=$IML_INSTALL_DIR/iml-zostools/bin:$IML_INSTALL_DIR/nodejs/bin:$PATH;
```


### Configure <mlz_setup_userid> access to your z/OS UNIX shell environment


#### Permissions required for configuring and starting WMLz:

$IML_HOME environment variable included in the user's profile
Permission to read and write to the $IML_HOME directory.
Permission to read and execute to the $IML_INSTALL_DIR. 

$SPARK_HOME environment variables included in the user's profile.

$ANACONDA_ROOT environment variable defined in the user's profile.

$ANACONDA_ROOT/bin defined in the $PATH environment variable in the user's profile.

Permission to read the $ANACONDA_ROOT directory.

$JAVA_HOME/bin defined in the $PATH environment variable in the user's profile.

$IBM_JAVA_OPTIONS environment variable set to -Dfile.encoding=UTF-8 in the user's profile.

Consider using a customized java.security file if all of the following factors apply to you:
- You select JCERACFKS or JCEKS as the keystore type for your WMLz.
- The Java security specification ($JAVA_HOME/lib/security/java.security) on the system where your WMLz runs lists IBMJCECCA as the top provider.
- Your WMLz does not need to use the resources in the ICSF services.
export IBM_JAVA_OPTIONS="$IBM_JAVA_OPTIONS -Djava.security.properties=$IML_HOME/configuration/java.security"

$_BPXK_AUTOCVT environment variable set to ON in the user's profile.

Read access to the RACF BPX.JOBNAME facility class so that you can assign default jobnames with the ALN prefix to the started WMLz services.
Read access to the RACF BPX.FILEATTR.PROGCTL facility class when using client authentication for z/OS Spark and Jupyter Kernel Gateway.
Read access to resources CSFDSG, CSFDSV, CSFEDH, CSFIQA, CSFIQF, CSFOWH, CSFPKG, CSFPKI, CSFPKX, CSFRNG, and CSFRNGL for ICSF services in the CSFSERV class if your system is CryptoCard-enabled.

#### Other Permissions
        
Permissions required for creating, configuring, and starting WMLz scoring service
subset of above

Permissions required for configuring WMLz scoring service in a CICS region
subset of above
        
Permissions required for configuring and running Db2® anomaly detection solution
...leave for later


### OMVS properties

```
ALTUSER <mlz_setup_userid> OMVS(ASSIZEMAX(address-space-size) MEMLIMIT(nonshared-memory-size) CPUTIMEMAX(cpu-time))
```
        
Check with ulimit

```
/bin/ulimit -a 
core file         8192b
cpu time          unlimited 
data size         unlimited 
file size         unlimited 
stack size        unlimited 
file descriptors  520000
address space     1048576k
memory above bar  24576m
```
        
### Verify


wmlz-configuration-checker.sh script in the $IML_INSTALL_DIR/alnsamp directory.

./wmlz-configuration-checker.sh -preconfig

./wmlz-configuration-checker.sh -preconfig -no-python
            
            

## Step 7	Configuring additional user IDs	(Sysprog with USS & Security skills)

## Step 8	Configuring network ports for WMLz	(Sysprog with USS & Security skills)	

## Step 9	Configuring secure network communications for WMLz	(Sysprog with USS & Security skills)
        Security mechanisms: AT-TLS policy ; Keyring-based keystore ; File-based keystore
        
        
## Step 10	Configuring WMLz (Sysprog with USS skills)

## Step 11	Configuring ONNX compiler service ... Optional (Sysprog with USS skills)

## Step 12	Configuring Python runtime environment ... Optional (Sysprog with USS skills)	

## Step 13	Configuring client authentication for z/OS Spark  ... Optional (Sysprog with USS skills)	

## Step 14	Configuring WML for z/OS scoring services (Sysprog with USS skills)	

        Configuration method: administration dashboard ; interactive shell scripts 
        
## Step 15	Configuring WML for z/OS scoring services in a CICS region	... Optional (Sysprog with USS skills; CICS skills) 

## Step 16	Configuring scoring services for high availability ...	Optional	(Sysprog with USS skills; Network skills)	

## Step 17	Configuring Db2 anomaly detection solution	... Optional (Sysprog with USS skills)

## Step 18	Configuring WMLz for high performance ...	Optional (Sysprog with USS skills)	

## Step 19	Configuring a WMLz cluster for high availability	... Optional	(Sysprog with USS skills) 

## Step 20	Configuring a standalone Jupyter notebook server	... Optional	(Sysprog with USS skills) 

## Step 21	Verifying WMLz installation and configuration	... Optional	(Sysprog with USS skills)




