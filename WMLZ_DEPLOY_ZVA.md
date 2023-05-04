# Deploying WMLZ V2.4 on ZVA

Watson Machine Learing for z/OS (WMLZ) is IBM's premiere product for supporting the AI lifecycle of machine learning and deep learning models on z/OS.
WMLZ deploymemt is mostly implemented with Uniz System Services (USS) within z/OS.
This document provides a step-by-step worked example of how to deploy it and use it.
The worked example is based on a z/OS V2.5 system image that IBM can provision for clients for demonstrations and skills transfer.
However, this document is written in a generic way, so that it can be helpful to clients deploying WMLZ in their own systems.

**Note** This document is a worked example, written as a simple "getting started" scenario. It should be used in conjunction with the official WMLZ product documentation, which is localed [here](https://www.ibm.com/docs/en/wml-for-zos/2.4.0).

## Two Documents

There are two documents covering WMLZ V2.4

1. ***This*** document, the WMLZ Deployment document, which is an audit trail of how to deploy WMLZ V2.4
2. The [Lab_Exercises](https://github.com/zeditor01/collidingworlds/blob/main/WMLZ_Lab_Exercises.md) document, which should be used in conjunction with the ZVA-provisioned image for taking a WMLZ test drive.



## Contents

1. Purpose of this deployment worked example
2. Planning and Pre-Requisites
3. Deploying a simple WMLZ Instance
4. Installation Verification Test
5. Operational Considerations
6. Expanded Usage Scenarios
7. References and Further Reading



## 1.0 Purpose of this deployment worked example

The purpose of this document is to provide a clear and simple worked example of what is involved in deploying Watson Machine Learning for z/OS.

This document is written in support of a ***"Test Drive"*** system, bookable from Techzone or ZVA, that can be provisioned by IBMers for the purposes of self-education, demonstrations or customer workshops.

It ***IS NOT*** a performance test environment.

It ***IS*** a functional test environment for the purposes of learning about dpeloying and using WMLZ/


## 2.0 Planning and Pre-Requisites

WMLZ requires a considerable amount of hardware resources to deploy. Bare minimum spec is 1 CP, 4 zIIPs, 100GB memory, 300GB DASD. The requirements are documented in the knowledge centre at this link [link](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-planning-system-capacity)

The Knowledge Center provides a helpful representation of the architectural components of WMLZ.

![wmlzarch](wmlzzvaimages/components_all.JPG)

However, for this simple worked example (which serves models that were developed elsewhere) we are not going to be deploying all the components.

* We will only deploy the online and CICS scoring services. (zCX deep learning services can be deployed later).
* We will not install python or the Jupyter notebook components. 
* We will not configure izODA and the MDS feature for accessing data sources for model development.
* We will not deploy the optional Db2 anomoly detection solution

Having selected a subset of components for a first deployment, the diagram below summarizes what this simple worked example aims to cover.

![wmlzarch](wmlzzvaimages/components_simple.JPG)

* The user interface service supports html pages that allow WMLZ administration to be performed.
* The user management service interacts with other components to perform requested actions 
* The core services manage the administration tasks (e.g. configure a scoring service or deploy a model) 
* The scoring services are responsible to support application requests to invoke models
* The spark integration service is responsible for invoking spark processes
* Db2 z/OS is used to stor the WMLZ metadata
* Your chosen System Authorisation Facility (eg: RACF) is responsible for authentication and encryption services using keyrings and certifictes

The interaction between the various services is performed using TCPIP. You will need a range of ports to be reserved for WMLZ. You should also be aware that other z/OS products may also be using IzODA and Spark components, and you will need to choose which products get to use the default ports for IzODA and Spark, and which products are configured to use non-default ports.

## 3.0 Deploying a simple WMLZ Instance

There are the 21 implementation steps for WMLZ V2.4 which are well documented in 
the [Knowledge Center](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=installation-roadmap) 

The list below is an overview of the 21 steps, including an indication of the skills required to complete them, and whether they are needed for this ***simple*** worked example.



* Step 1	Preparing for WMLz installation	(Sysprog - High Level Planning)	 
* Step 2	Planning system capacity for WMLz	(Sysprog - Detailed Planning)	 
* Step 3	Obtaining SMP/E image and PTFs for WMLz	(Sysprog - ShopZ order)	 
* Step 4	Procuring, installing, and configuring prerequisites for WMLz (Sysprog with SMPE and USS skills)	 
* Step 5	Installing WMLz, including the bundled IzODA (Spark, Anaconda, and MDS) (Sysprog with SMPE skills) 
* Step 6	Configuring WMLz setup user ID	(Sysprog with USS & Security skills)	 
* Step 7	Configuring additional user IDs	(Sysprog with USS & Security skills) ***... omitted this time***
* Step 8	Configuring network ports for WMLz	(Sysprog with USS & Security skills)	 
* Step 9	Configuring secure network communications for WMLz	(Sysprog with USS & Security skills)
* Step 10	Configuring WMLz (Sysprog with USS skills)	 
* Step 11	Configuring ONNX compiler service ... Optional (Sysprog with USS  & zCX skills)  ***... omitted this time***	
* Step 12	Configuring Python runtime environment ... Optional (Sysprog with USS skills)	 ***... omitted this time***
* Step 13	Configuring client authentication for z/OS Spark  ... Optional (Sysprog with USS skills)	 ***... omitted this time*** 
* Step 14	Configuring WML for z/OS scoring services (Sysprog with USS skills)	
* Step 15	Configuring WML for z/OS scoring services in a CICS region	... Optional (Sysprog with USS skills; CICS skills) 
* Step 16	Configuring scoring services for high availability ...	Optional	(Sysprog with USS skills; Network skills)	 
* Step 17	Configuring Db2 anomaly detection solution	... Optional (Sysprog with USS skills)  ***... omitted this time***
* Step 18	Configuring WMLz for high performance ...	Optional (Sysprog with USS skills)	 ***... omitted this time*** 
* Step 19	Configuring a WMLz cluster for high availability	... Optional	(Sysprog with USS skills)  ***... omitted this time***
* Step 20	Configuring a standalone Jupyter notebook server	... Optional	(Sysprog with USS skills)  ***... omitted this time***
* Step 21	Verifying WMLz installation and configuration	... Optional	(Sysprog with USS skills)	

An audit trail of following each of the required steps above follows now


### 3.1 Step 1 Preparing for WMLz installation	 

Be sure to check all the pre-requisites carefully on [pereqs_page](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-installing-prerequisites) 

A brief summary of meeting the pre-reqs in this system is as follow.

***System*** z16, z15™, z14, z13®, or zEnterprise® EC12 system. (This example is deployed on a ZVDT-virtualised Z server).

***z/OS*** z/OS 2.5 or 2.4. (This example is running z/OS V2.5, taken from the ADCD distribution volumes) 

***PTFs*** For z/OS 2.5, apply PTFs UI64830, UI64837, and UI64940. (all applied)

***zDNN*** For z/OS 2.5, apply APARs OA62901, OA62902, and OA62903. (all applied, even though this worked example won't deploy zCX)
 
***z/OS Integrated Cryptographic Service Facility (ICSF).***  (Yup - standard part of ADCD.)

***z/OS OpenSSH***. See z/OS OpenSSH for instructions. (Yup - standard part of ADCD.)

***IBM 64-bit SDK for z/OS Java*** Yup Version 8 SR6 FP25 or later. (Yup - standard part of ADCD.)

***Db2® 12 for z/OS*** or later. (Yup - ADCD includes both Db2 z/OS V12 and V13.)

***CICS TS for z/OS 5.6.0*** with PTFs UI77466, UI80396 and UI80397 or later. (Yup - ADCD includes CICS V5.6 and V6.1).

***IBM z/OS Container Extensions 2.4*** with PTF OA59111 applied (zCX container extensions is not supported by ZD&T and ZVDT)

So, we're good to go!

### 3.2 Step 2 Planning system capacity for WMLz	

The [minimum system capacity](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-planning-system-capacity) is described as 4 zIIPs, 1 GCP, 100GB memory, 100GB DASD. If you wanted to perform model training on WMLZ, the same link gives capacity guidelines for different intensities of model training.

This deployment, using the "Z Virtual Access" service for demonstrations is based on ZVDT. The system resources given to a ZVDT applicance can be varied to satisfy the minimum requirements listed above.

### 3.3 Step 3 Obtaining SMP/E image and PTFs for WMLz	

WMLZ should be ordered from ShopZ as a Portable Software Instance, screenshot below

![shopz](wmlzzvaimages/shopz.JPG)

Use the "Download to host" sample JCL to download the PSI image files into a large ZFS on your z/OS system. 
The base size of the PSI image is about 20GB, so you will need to allocate a large multi-volume ZFS with extended data class attributes to store the image.
Use the z/OSMF Software Configuration app to download the PSI image to your ZFS.

### 3.4 Step 4 Procuring, installing, and configuring prerequisites for WMLz 

In this worked example I was fortunate that all the pre-requisites were already installed. 

### 3.5 Step 5 Installing WMLz, including the bundled IzODA (Spark, Anaconda, and MDS) 

This document does not attempt to capture the SMPE download and install process, 
because there is nothing special or different about the SMPE process for WMLZ.
The only thing that is slightly unusual is the size of the WMLZ portable software instance, which is about 20GB.

Once the PSI image is downloaded from ShopZ you will need to switch to the Deploymemts tab of z/OSMF Software Configuration app to deploy the software to z/OS.

Be sure the run all the post-deployment steps which allocate ZFS file systems and polish of the SMPE CSI dataset.

Having chosen a HLQ of ***WMLZ*** The following target libraries will be deployed.

```
'WMLZ.AZK.SAZKBIN' 
'WMLZ.AZK.SAZKCNTL'
'WMLZ.AZK.SAZKDBRM'
'WMLZ.AZK.SAZKEXEC'
'WMLZ.AZK.SAZKLOAD'
'WMLZ.AZK.SAZKMAP' 
'WMLZ.AZK.SAZKMENU'
'WMLZ.AZK.SAZKOBJX'
'WMLZ.AZK.SAZKPENU'
'WMLZ.AZK.SAZKRPC' 
'WMLZ.AZK.SAZKSAMP'
'WMLZ.AZK.SAZKSLIB'
'WMLZ.AZK.SAZKSMAP'
'WMLZ.AZK.SAZKTENU'
'WMLZ.AZK.SAZKXATH'
'WMLZ.AZK.SAZKXCMD'
'WMLZ.AZK.SAZKXEXC'
'WMLZ.AZK.SAZKXSQL'
'WMLZ.AZK.SAZKXTOD'
'WMLZ.AZK.SAZKXVTB'
```

Much of the WMLZ product us deployed within USS. Parmlib should be updated to permanently mount the following ZFS filesystems at the mountpoints prescribed for WMLZ. Specifically 

* WMLZ mountpoint is ```/usr/lpp/IBM/aln```
* Anaconda mountpoint is ```/usr/lpp/IBM/izoda/anaconda```
* Spark mopuntpoint is ```/usr/lpp/IBM/izoda/spark```

```
/* WMLZ ZFS */                                   
MOUNT FILESYSTEM('WMLZ.OMVS.SALNROOT')           
      TYPE(ZFS)                                  
      MODE(RDWR)                                 
      NOAUTOMOVE                                 
      MOUNTPOINT('/usr/lpp/IBM/aln/v2r4')        
/* WMLZ ANACONDA */                              
MOUNT FILESYSTEM('WMLZ.OMVS.SANBZFS')            
      TYPE(ZFS)                                  
      MODE(RDWR)                                 
      NOAUTOMOVE                                 
      MOUNTPOINT('/usr/lpp/IBM/izoda/anaconda')  
/* WMLZ SPARK */                                 
MOUNT FILESYSTEM('WMLZ.OMVS.SAZKROOT')           
      TYPE(ZFS)                                  
      MODE(RDWR)                                 
      NOAUTOMOVE                                 
      MOUNTPOINT('/usr/lpp/IBM/izoda/spark') 
```

SMPE will create the SMPE Zone ```WMLZ.SMPE.GLOBAL.CSI``` which you can inspect. It will show that you installed 4 FMIDs, as follows.

* HANA110 (anaconda)
* HAQN240 (WMLZ Base)
* HMDS120 (MDS - ie DVM)
* HSPK120 (spark)


### 3.6 Step 6 Configuring WMLz setup user ID	 

The WMLZ setup userid is the anchor point for deploying WMLZ. 
This is because WMLZ mostly runs in USS, and needs to run in an environment that controls Paths, Libraries, Environment Variables, RACF certificates and so forth. The WMLZ setup userid must have a .profile that defines the environment perfectly, so that when the WMLZ services are started under the WMLZ setup userid they can access everything that they need at runtime.

The [knowledge_center](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-configuring-setup-user-id) does a very good job of explaining the hows and whys of setting up the wmlz setup userid. This paper provides the jobs that were used to create the userid in this worked example.

The job below (in IBMUSER.NEALEJCL(WMLZUSER) on the ZVA system) was used to create the RACF group and USERID.

```
//IBMUSERJ JOB  (FB3),'INIT 3380 DASD',CLASS=A,MSGCLASS=H,    
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1)                  
//*                                                           
//*   JOB TO CREATE WMLZ SETUP USERID                         
//*                                                           
//RACF     EXEC PGM=IKJEFT01,REGION=0M                        
//SYSTSPRT DD SYSOUT=*                                        
//SYSTSIN  DD *                                               
                                                              
ADDGROUP WMLZGRP OMVS(AUTOGID) OWNER(SYS1)                    
                                                              
AU WMLZADM NAME('WMLZADM') PASSWORD(SYS1) -                   
OWNER(SYS1) DFLTGRP(WMLZGRP) UACC(READ) OPERATIONS SPECIAL   -
TSO(ACCTNUM(ACCT#) PROC(DBSPROCD) JOBCLASS(A) MSGCLASS(X) -   
HOLDCLASS(X) SYSOUTCLASS(X) SIZE(4048) MAXSIZE(0))     -      
OMVS(HOME(/u/wmlzadm) -                                       
PROGRAM(/usr/lpp/IBM/aln/v2r4/iml-zostools/bin/bash) -        
CPUTIMEMAX(86400) -                                           
MEMLIMIT(32G) ASSIZEMAX(1200000000) AUTOUID)                  
                                                              
PERMIT ACCT#     CLASS(ACCTNUM) ID(WMLZADM)                   
PERMIT ISPFPROC  CLASS(TSOPROC) ID(WMLZADM)                   
PERMIT DBSPROC   CLASS(TSOPROC) ID(WMLZADM)                   
PERMIT JCL       CLASS(TSOAUTH) ID(WMLZADM)                   
PERMIT OPER      CLASS(TSOAUTH) ID(WMLZADM)                   
PERMIT ACCT      CLASS(TSOAUTH) ID(WMLZADM)                   
PERMIT MOUNT     CLASS(TSOAUTH) ID(WMLZADM)                   
                                                              
```
        

### Paths and ZFS


Allocate a minimum of 500 MB disk space to the home directory for <mlz_setup_userid>

Create the $IML_HOME directory. Make sure that $IML_HOME is mounted to a zFS file system with at least 50 GB storage available

Consider creating the $IML_HOME/spark subdirectory  mounted on a separate zFS file system with at least 4 GB storage available.

chown –R <mlz_setup_userid>:<mlz_group> $IML_HOME/

To allocate zFS data sets for $IML_HOME and $IML_HOME/spark that are larger than 4GB, make sure that you specify DFSMS data class with extended format and extended addressability.

Actual Job to setup home directory space
```
//IBMUSERJ JOB  (FB3),'CREATE ZFS',CLASS=A,MSGCLASS=H,                  
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1)                            
//********************************************************************  
//CREATE   EXEC PGM=IDCAMS,REGION=0M                                    
//SYSPRINT DD SYSOUT=*                                                  
//SYSIN    DD *                                                         
  DEFINE -                                                              
       CLUSTER -                                                        
         ( -                                                            
             NAME(IBMUSER.WMLZHOME.ZFS) -                               
             LINEAR -                                                   
             CYL(600 50) VOLUME(USER0A USER0B USER0C) -                 
             DATACLASS(DCEXTEAV) -                                      
             SHAREOPTIONS(3) -                                          
         )                                                              
/*                                                                      
//*                                                                     
// SET ZFSDSN='IBMUSER.WMLZHOME.ZFS'                                    
//FORMAT   EXEC PGM=IOEAGFMT,REGION=0M,COND=(0,LT),                     
// PARM='-aggregate &ZFSDSN -compat'                                    
//SYSPRINT DD SYSOUT=*                                                  
//STDOUT   DD SYSOUT=*                                                  
//STDERR   DD SYSOUT=*                                                  
//SYSUDUMP DD SYSOUT=*                                                  
//CEEDUMP  DD SYSOUT=*                                                  
//*                                                                     
//*                                                                     
//* Mount the dataset at the mountpoint directory                       
//*                                                                     
//MOUNT    EXEC PGM=IKJEFT01,REGION=0M,DYNAMNBR=99,COND=(0,LT)          
//SYSTSPRT  DD SYSOUT=*                                                 
//SYSTSIN   DD *                                                        
  PROFILE MSGID WTPMSG                                                  
  MOUNT TYPE(ZFS) +                                                     
    MODE(RDWR) +                                                        
    MOUNTPOINT('/u/wmlzadm') +                                          
    FILESYSTEM('IBMUSER.WMLZHOME.ZFS')                                  
/*                                                                      
```

and permenant mount

```
/* WMLZADM ZFS */                          
MOUNT FILESYSTEM('IBMUSER.WMLZHOME.ZFS')   
      TYPE(ZFS)                            
      MODE(RDWR)                           
      NOAUTOMOVE                           
      MOUNTPOINT('/u/wmlzadm')             
```


and change ownership

```
drwxr-xr-x   2 WMLZADM  WMLZGRP        0 May  1 01:04 wmlzadm
```

IML_HOME (where the WMLZ instance will be laid down?)

create the path ```/u/aiz/wmlz```

and change ownership

```
drwxr-xr-x   2 WMLZADM  WMLZGRP        0 May  1 01:15 wmlz
```

Create an ACS Rule to place HLQ on SGEXTEAV

```
CDS Name  : SYS1.S0W1.SCDS

DATACLAS  SYS1.SMS.CNTL            ACSSTORD  IBMUSER   
                                                       
                                                       
MGMTCLAS  -----------------------  --------  --------  
                                                       
                                                       
STORCLAS  SYS1.SMS.CNTL            STORCLAS  IBMUSER   
                                                       
                                                       
STORGRP   SYS1.SMS.CNTL            STORGRP   IBMUSER   


===

WHEN (&DSN = &AIZ_HLQ)                
  DO                                  
    SET &STORCLAS = 'SCEXTEAV'        
    EXIT CODE(0)                      
  END                                 
  
  

WHEN (&STORCLAS= 'SCEXTEAV')          
  DO                                  
    SET &STORGRP = 'SGEXTEAV'
    WRITE '&STORGRP = ' &STORGRP      
    EXIT CODE(0)                      
  END                                 
  
  
```

Create the ZFS ( must be able to grow HUGE 50GB plus ) using JCL in ```IBMUSER.NEALEJCL(IMLHOME)```.

```
//IBMUSERJ JOB  (FB3),'CREATE ZFS',CLASS=A,MSGCLASS=H,                
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1)                          
//********************************************************************
//CREATE   EXEC PGM=IDCAMS,REGION=0M                                  
//SYSPRINT DD SYSOUT=*                                                
//SYSIN    DD *                                                       
  DEFINE -                                                            
       CLUSTER -                                                      
         ( -                                                          
             NAME(AIZ.WMLZ.ZFS) -                                     
             LINEAR -                                                 
             CYL(4000 200) VOLUME(EAV001 EAV002) -                    
             DATACLASS(DCEXTEAV) -                                    
             SHAREOPTIONS(3) -                                        
         )                                                            
/*                                                                    
//*                                                                   
// SET ZFSDSN='AIZ.WMLZ.ZFS'                                          
//FORMAT   EXEC PGM=IOEAGFMT,REGION=0M,COND=(0,LT),                   
// PARM='-aggregate &ZFSDSN -compat'                                  
//SYSPRINT DD SYSOUT=*                                                
//STDOUT   DD SYSOUT=*                                                
//STDERR   DD SYSOUT=*                                                
//SYSUDUMP DD SYSOUT=*                                                
//CEEDUMP  DD SYSOUT=*                                                
//*                                                                   
//*                                                                   
//* Mount the dataset at the mountpoint directory                     
//*                                                                   
//MOUNT    EXEC PGM=IKJEFT01,REGION=0M,DYNAMNBR=99,COND=(0,LT)        
//SYSTSPRT  DD SYSOUT=*                                               
//SYSTSIN   DD *                                                      
  PROFILE MSGID WTPMSG                                                
  MOUNT TYPE(ZFS) +                                                   
    MODE(RDWR) +                                                      
    MOUNTPOINT('/u/aiz/wmlz') +                                       
    FILESYSTEM('AIZ.WMLZ.ZFS')                                        
/*                                                                    
```

and mount it permenantly

```
/* WMLZ IMLHOME ZFS */            
MOUNT FILESYSTEM('AIZ.WMLZ.ZFS')  
      TYPE(ZFS)                   
      MODE(RDWR)                  
      NOAUTOMOVE                  
      MOUNTPOINT('/u/aiz/wmlz')   
```

and change the owner

```
chown wmlzadm:wmlzgrp wmlz
```

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

I used this from ```/u/wmlzadm/.profile```

```
# This is a sample user profile for <mlz_setup_userid> which is used to install and configure IBM Watson Machine Learning for z/OS                      
# Place the customized version of the .profile file under the user home of <mlz_setup_userid>                                                           
                                                                                                                                                        
                                                                                                                                                        
# Spark environment variable                                                                                                                            
export SPARK_HOME=/usr/lpp/IBM/izoda/spark/spark24x                                                                                                     
                                                                                                                                                        
# Anaconda environment variable                                                                                                                         
export ANACONDA_ROOT=/usr/lpp/IBM/izoda/anaconda                                                                                                        
                                                                                                                                                        
# Java environment variable                                                                                                                             
export JAVA_HOME=/usr/lpp/java/J8.0_64                                                                                                                  
                                                                                                                                                        
# AIE environment variable                                                                                                                              
# export AIE_INSTALL_DIR=/usr/lpp/IBM/aie                                                                                                               
                                                                                                                                                        
# WML for z/OS environment variable                                                                                                                     
export IML_HOME=/u/aiz/wmlz                                                                                                                             
                                                                                                                                                        
# WML for z/OS environment variable                                                                                                                     
export IML_INSTALL_DIR=/usr/lpp/IBM/aln/v2r4                                                                                                            
                                                                                                                                                        
# WML for z/OS environment variable                                                                                                                     
export IML_JOBNAME_PREFIX=ALN                        #REQUIRED Jobname prefix for each service. Default value is ALN                                    
                                                     # Job name prefix has max 4 characters limit. First character has to be alphabetic. The rest charac
                                                                                                                                                        
# COBOL cob2 utility installation directory                                                                                                             
export COBOL_INSTALL_DIR=/usr/lpp/IBM/cobol/igyv6r4                                                                                                     
                                                                                                                                                        
# PATH                                                                                                                                                  
PATH=/bin:                                                                                                                                              
PATH="${IML_INSTALL_DIR}"/iml-zostools/bin:$PATH                                                                                                        
PATH=$PATH:"${ANACONDA_ROOT}"/bin                    #OPTIONAL Only set this if you have ANACONDA_ROOT environment variable set                         
PATH=$PATH:"${JAVA_HOME}"/bin                                                                                                                           
PATH=$PATH:"${SPARK_HOME}"/bin:"${SPARK_HOME}"/sbin                                                                                                     
PATH=$PATH:"${IML_INSTALL_DIR}"/nodejs/bin                                                                                                              
PATH=$PATH:"${COBOL_INSTALL_DIR}/bin"                #OPTIONAL Only set this if you have COBOL_INSTALL_DIR environment variable set                     
                                                                                                                                                        
export PATH="$PATH"                                                                                                                                     
                                                                                                                                                        
#LIBPATH                                                                                                                                                
LIBPATH=/lib:/usr/lib                                                                                                                                   
LIBPATH=$LIBPATH:"${AIE_INSTALL_DIR}"/zdnn/lib       #OPTIONAL Only set this if you have AIE_INSTALL_DIR environment variable set                       
LIBPATH=$LIBPATH:"${JAVA_HOME}"/bin/classic                                                                                                             
LIBPATH=$LIBPATH:"${JAVA_HOME}"/bin/j9vm                                                                                                                
LIBPATH=$LIBPATH:"${JAVA_HOME}"/lib/s390x                                                                                                               
LIBPATH=$LIBPATH:"${SPARK_HOME}"/lib                                                                                                                    
                                                                                                                                                        
export LIBPATH="$LIBPATH"                                                                                                                               
                                                                                                                                                        
                                                                                                                                                        
# Other system environment variables                                                                                                                    
export IBM_JAVA_OPTIONS="-Dfile.encoding=UTF-8"                                                                                                         
export IBM_JAVA_OPTIONS="$IBM_JAVA_OPTIONS -Djava.security.properties=${IML_HOME}/configuration/java.security"  #OPTIONAL Only add this if you have a cu
export _BPXK_AUTOCVT=ON                                                                                                                                 
export _BPX_SHAREAS=NO                                                                                                                                  
export _ENCODE_FILE_NEW=ISO8859-1                                                                                                                       
export _ENCODE_FILE_EXISTING=UNTAGGED                                                                                                                   
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"                                                                                                
# export STEPLIB=<DSN1:DSN2:DSN3>                 #OPTIONAL Set up the load library search order for executable files. Consider setting this when xlc   
                                                    #EX: STEPLIB=IGY.V6R4M0.SIGYCOMP:CBC.SCCNCMP                                                        
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

```
./wmlz-configuration-checker.sh -preconfig

./wmlz-configuration-checker.sh -preconfig -no-python
```

First time round The checker threw some errors and warning

### 3.7 Step 7 Configuring additional user IDs	 

***omitted this time*** No need for additional users in this worked example.

### 3.8 Step 8 Configuring network ports for WMLz	

Blah blah blah 

### 3.9 Step 9 Configuring secure network communications for WMLz	

Blah blah blah 

### 3.10 Step 10 Configuring WMLz  

Blah blah blah 

### 3.11 Step 11 Configuring ONNX compiler service ... Optional (Sysprog with USS  & zCX skills)  

***omitted this time*** Using the IBM Deep Learning compiler to support ONNX models requires z/OC container extensions to be deployed.
zCX can be deployed using an IBM-provided workflow in z/OSMF.
This is outside the scope of this worked example.

### 3.12 Step 12 Configuring Python runtime environment ... Optional  	 

***omitted this time*** Using python for data wrangling and model development is outside the scope of this worked example.

### 3.13 Step 13 Configuring client authentication for z/OS Spark  ... Optional  

***omitted this time*** Client authentication is outside the scope of this worked example.

### 3.14 Step 14 Configuring WML for z/OS scoring services  	

Blah blah blah 

### 3.15 Step 15 Configuring WML for z/OS scoring services in a CICS region	

Blah blah blah 

### 3.16 Step 16 Configuring scoring services for high availability ...	Optional	 

***omitted this time*** outside the scope of this worked example.

### 3.17 Step 17 Configuring Db2 anomaly detection solution	... Optional  

***omitted this time*** outside the scope of this worked example.

### 3.18 Step 18 Configuring WMLz for high performance ...	Optional  

***omitted this time*** outside the scope of this worked example.

### 3.19 Step 19 Configuring a WMLz cluster for high availability	... Optional	 

***omitted this time*** outside the scope of this worked example.

### 3.20 Step 20 Configuring a standalone Jupyter notebook server	... Optional	 

***omitted this time*** outside the scope of this worked example.


## 4.0 Installation Verification Test

Finally - Step 21 - the installation verification test.

## 5.0 Operational Considerations


## 6.0 Expanded Usage Scenarios


## 7.0 References and Further Reading



