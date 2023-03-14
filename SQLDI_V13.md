# SQL Data Insights Feature of Db2 V13

SQL Data Insights is a standard feature of Db2 V13, that provides AI-enabled queries. 
This document provides a step-by-step worked example of how to deploy it and use it.
The worked example is based on a z/OS V2.5 system image that IBM can provision for clients for demonstrations and skills transfer.
However, this document is written in a generic way, so that it can be helpful to clients deploying SQLDI in their own systems.

**Note** This document is a worked example, written as a simple "getting started" scenario. It should be used in conjunction with the official Db2 z/OS product documentation, which is referenced at the end of this document.


## Contents

1. SQL Data Insights Overview
2. Ordering SQLDI
3. Installation with SMPE
4. Planning for SQLDI deployment
5. Deploying an SQLDI instance
6. Installation Verification Test
7. Usage Scenarios ( Tables, Views and Aliases )
8. Usage Considerations
9. References and Further Reading

## 1. SQL Data Insights Overview 

The core concept of SQL Data Insights is to build and train a neural network model for a Db2 table or view, load it into a model table that is associated with the base table, so that a range of Db2 BIFs (built-in-functions) can used within SQL queries for find patterns in the data. For example, if you have a table containing a list of clients and their important characteristics, you can discover which clients are most similar to a chosen client or cluster of clients.

![sqldi_concept](sqldiimages/sqldi_concept.JPG)

Using a simple SQL query, you can do things like
- find and rank clients who are most similar to your most profitable clients. 
- find clients who have similar patterns to previous clients who closed their accounts.
- see which data items are most influential towards certain outcomes

SQLDI can operate against Db2 views, or even external data sources like IMS and VSAM.

Two of the most likely use cases for SQLDI are
1. Business Analytics Users.
2. Data Scientists who are charged with developing more targetted machine learning scoring models.


## 2. Ordering SQLDI

SQLDI is a no charge feature of Db2 z/OS V13, but you do need to order this feature explicitly in order to get it. The screenshot below is from ShopZ, showing two separate items to order, each with the same Product ID.

![sqldi_shopz](sqldiimages/sqldi_shopz.JPG)

If you already have Db2 z/OS V13 installed, you can order SQL Data Insights as a CBPDO for it's own SMPE CSI, or to add to the Db2 SMPE CSI.

## 3. Installation with SMPE

SQLDI is a standard SMPE installation, which will not be addressed in this document.

There are several pre-requisites that you should resolve before ordering SQLDI. As always, you should refer to the current page in the Db2 z/OS knowledge centre to get the latest information. [link to SQLDI Pre-Requisites](https://www.ibm.com/docs/en/db2-for-zos/13?topic=di-preparing-sql-installation)

* z/OS ( V2.4 or V2.5 ) requires several PTFs to be applied to provide the pre-requisite AI libraries.
* Db2 needs the fix for APAR PH49781
* z/OS OpenSSH and the IBM 64-bit JDK are also needed.


## 4. Planning for SQLDI deployment

When Planning for SQLDI deployment, it is very helpful to consider an architecture diagram of all the moving parts.

![sqldi_arch](sqldiimages/sqldi_arch.JPG)

SQLDI runs in USS ( z/OS Unix Systems Services ). It only needs to be running when you are training new models. Once the models are trained, and loaded into the model tables, SQLDI can be stopped, and Db2 z/OS will continue to serve AI-enabled queries.

The model training process has 3 main stages
1. Select the contents of the Subject table/view, and fetch the contents into USS
2. Use a Spark cluster (in USS) to train the model
3. Call the DSNUTILU stored procedure to load the model table in in Db2.

SQLDI needs a few integration points with Db2 z/OS and RACF. The notes below explain the diagram.

***The USS Side (reading top down)***

* The AI libraries (shipped as z/OS PTFs) are installed by z/OS convention to the following USS path: /usr/lpp/IBM/aie  
* The SQLDI product code is provided as a ZFS during the SMPE install process, which must be mounted at /usr/lpp/IBM/db2sqldi/v1r1
* The SQLDI deployment process creates an instance of SQLDI which needs to be mounted on a large ZFS. (4GB minimum, 100GB recommended)
* Once the SQLDI instance is started there are multiple services running, to perform the model training.
* SQLDI provides two helpful user interfaces, both accessible via browser.

1. The SQLDI Service is the primary administration interface, for training new models.
2. The Spark service

***The z/OS Side (reading top down)***

* A RACF userid must be created as the SQLDI owner. It must be a member of RACF Group SQLDIGRP.
* A keyring, with a signed certificate is needed for authentication of the SQLDI instance to RACF.
* The Db2-supplied stored procedures and the WLM environments that they run in must be correctly installed
* An SQLDI Catalog must be created for Db2 z/OS to keep track of the AI-Enabled objects and model tables

Keep this architecture diagram in you mind as you review the SQLDI Instance Deployment notes below.

## 5. Deploying an SQLDI instance

Deploying an SQLDI instance takes about 5 minutes. The hard work is lining up all the ducks in a row before you run the **sqldi.sh create** script!

The comprehensive guide is found in the Db2 z/OS V13 Knowledge Centre [here](https://www.ibm.com/docs/en/db2-for-zos/13?topic=insights-installing-configuring-sql-di).
The goal of this document is provide an easy-to-consume worked example, which will help you consume the Knowledge Centre.

All the jobs used for deployment of SDI in this worked example were saved to PDS ***IBMUSER.SDISETUP***
![sdisetup](sqldiimages/sdisetup.JPG)


![duck1](sqldiimages/duck1.JPG) **Verify the AI libraries are mounted at the right path.**

Open an ssh session into USS, and navigate to /usr/lpp/IBM/aie

You should expect to find 5 sub-directories, each with contents provided from the installation of the z/OS PTFs.

```
 /usr/lpp/IBM/aie >ls -al
total 112
drwxr-xr-x   7 OMVSKERN OMVSGRP     8192 Mar  7 00:00 .
drwxr-xr-x  52 OMVSKERN OMVSGRP     8192 Mar  6 23:20 ..
drwxr-xr-x   2 OMVSKERN OMVSGRP     8192 Jun  8  2022 IBM
drwxr-xr-x   5 OMVSKERN OMVSGRP     8192 Mar  7 00:01 blas
drwxr-xr-x   4 OMVSKERN OMVSGRP     8192 May  6  2022 zade
drwxr-xr-x   4 OMVSKERN OMVSGRP     8192 May 17  2022 zaio
drwxr-xr-x   4 OMVSKERN OMVSGRP     8192 Mar 15  2022 zdnn

```

![duck2](sqldiimages/duck2.JPG) **Verify the SQLDI libraries are mounted at the right path.**

Open an ssh session into USS, and navigate to /usr/lpp/IBM/db2sqldi/v1r1

You should expect to find 5 sub-directories, each with contents provided from the installation of SQLDI.

```
 /usr/lpp/IBM/db2sqldi/v1r1 >ls -al
total 176
drwxr-xr-x   7 OMVSKERN SYS1        8192 Mar  6 23:29 .
drwxr-xr-x   3 OMVSKERN OMVSGRP     8192 Mar  6 23:20 ..
drwxr-xr-x   2 OMVSKERN SYS1        8192 Mar  6 23:29 IBM
-rw-r--r--   2 OMVSKERN SYS1       17940 Mar  6 23:29 NOTICE
-rw-r--r--   2 OMVSKERN SYS1         203 Mar  6 23:29 README
drwxr-xr-x  12 OMVSKERN SYS1        8192 Feb 23  2022 spark24x
drwxr-xr-x   6 OMVSKERN SYS1        8192 May 18  2022 sql-data-insights
drwxr-xr-x   3 OMVSKERN SYS1        8192 May 17  2022 templates
drwxr-xr-x   3 OMVSKERN SYS1        8192 May 17  2022 tools
```

* IBM contains binaries
* spark24x contains the an embedded copy of spark
* sql-data-insights contains the code for SQLDI
* templates contains sample templates for the .profile settings for the SQLDI userid and JCL to operate the SQLDI components
* tools contains a copy of the bash shell, which you could copy to /bin/bash if you wanted.


![duck3](sqldiimages/duck3.JPG)  **Setup RACF userid and group**

A RACF userid is required to be the SQLDI instance owner.
* It must have an omvs segment with minimum values for CPUTIMEMAX(86400), MEMLIMIT(32G) ASSIZEMAX(1200000000)
* Ideally it should default to the bash shell PROGRAM(/bin/bash)
* The home directory HOME(/u/aidbadm) will need a .profile that sets many USS environment variables 

The job below was used to create the AIDBADM userid.

***IBMUSER.SDISETUP(SDIUSCRT)***
```
//IBMUSERJ JOB  (USR),'ADD USER',CLASS=A,MSGCLASS=H,                    
//       NOTIFY=&SYSUID,MSGLEVEL=(1,1),REGION=0M                        
//********************************************************************  
//*                                                                  *  
//* CREATE SQDLI USERIDS                                             *  
//*                                                                  *  
//********************************************************************  
//NEWID    EXEC PGM=IKJEFT01,DYNAMNBR=75,TIME=100,REGION=6M             
//SYSPRINT DD SYSOUT=*                                                  
//SYSTSPRT DD SYSOUT=*                                                  
//SYSTERM  DD DUMMY                                                     
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR                                    
//SYSLBC   DD DSN=SYS1.BRODCAST,DISP=SHR                                
//SYSTSIN  DD *                                                         
  AU AIDBADM NAME('AIDBADM') PASSWORD(SYS1)             -               
   OWNER(SYS1) DFLTGRP(SYS1) UACC(READ) OPERATIONS SPECIAL   -          
   TSO(ACCTNUM(ACCT#) PROC(DBSPROCD) JOBCLASS(A) MSGCLASS(X) -          
      HOLDCLASS(X) SYSOUTCLASS(X) SIZE(4048) MAXSIZE(0))     -          
    OMVS(HOME(/u/aidbadm) PROGRAM(/bin/bash) CPUTIMEMAX(86400) -        
    MEMLIMIT(32G) ASSIZEMAX(1200000000) AUTOUID)                        
  PERMIT ACCT#     CLASS(ACCTNUM) ID(AIDBADM)                           
  PERMIT ISPFPROC  CLASS(TSOPROC) ID(AIDBADM)                           
  PERMIT DBSPROC   CLASS(TSOPROC) ID(AIDBADM)                           
  PERMIT JCL       CLASS(TSOAUTH) ID(AIDBADM)                           
  PERMIT OPER      CLASS(TSOAUTH) ID(AIDBADM)                           
  PERMIT ACCT      CLASS(TSOAUTH) ID(AIDBADM)                           
  PERMIT MOUNT     CLASS(TSOAUTH) ID(AIDBADM)                           
  AD 'AIDBADM.*'  OWNER(AIDBADM) UACC(READ) GENERIC                     
```

Additionally, the SQLDI instance owner (and any other userids that will use SQLDI model training) ***must*** be a member of RACF group SQLDIGRP.

***IBMUSER.SDISETUP(SDIRACFG)***
```
//IBMUSERJ JOB  (FB3),'INIT 3380 DASD',CLASS=A,MSGCLASS=H, 
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1),              
//             REGION=0M,COND=(4,LT)                       
//S1       EXEC PGM=IKJEFT01                               
                                                           
//SYSTSPRT DD SYSOUT=*                                     
                                                           
//SYSPRINT DD SYSOUT=*                                     
                                                           
//SYSTSIN  DD *                                            
                                                           
ADDGROUP SQLDIGRP OMVS(AUTOGID) OWNER(IBMUSER)             
                                                           
CONNECT (AIDBADM)  GROUP(SQLDIGRP) OWNER(IBMUSER)          
                                                           
CONNECT (IBMUSER) GROUP(SQLDIGRP) OWNER(IBMUSER)           
                                                           
SETROPTS RACLIST(FACILITY) REFRESH                         
                                                           
/*                                                         
```

![duck4](sqldiimages/duck4.JPG) **USS environment variables** 

The SQLDI userid must have several USS environment variables correctly set, so that the binaries and libraries of SQLDI can be found at runtime. The .profile file for user AIDBADM has been edited ( from # SQLDI Setup onwards ) to set the correct paths and variables.

***/u/aidbadm/.profile***
```
# JAVA                                                                  
export JAVA_HOME=/usr/lpp/java/J8.0_64                                  
export PATH=$PATH:/apps/zospt/bin:/usr/lpp/java/J8.0_64/bin             
# ZOAU REQUIREMENTS                                                     
export _BPXK_AUTOCVT=ON                                                 
export ZOAU_HOME=/usr/lpp/IBM/zoautil                                   
export PATH=${ZOAU_HOME}/bin:$PATH                                      
# ZOAU MAN PAGE REQS (OPTIONAL)                                         
export MANPATH=${ZOAU_HOME}/docs/%L:$MANPATH                            
export CLASSPATH=${ZOAU_HOME}/lib/*:${CLASSPATH}                        
export LIBPATH=${ZOAU_HOME}/lib:${LIBPATH}                              
# IBM Python - Ansible supported                                        
export PATH=/usr/lpp/IBM/cyp/v3r9/pyz/bin:$PATH                         
export PYTHONPATH=/usr/lpp/IBM/cyp/v3r9/pyz                             
export PYTHONPATH=${PYTHONPATH}:${ZOAU_HOME}/lib                        
# Rocket Ported Git                                                     
export _CEE_RUNOPTS='FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)'                
export PATH=/usr/lpp/Rocket/rsusr/ported/bin:$PATH  

# SQLDI Setup                                                           
export SQLDI_INSTALL_DIR=/usr/lpp/IBM/db2sqldi/v1r1                     
export ZADE_INSTALL_DIR=/usr/lpp/IBM/aie/zade                           
export ZAIE_INSTALL_DIR=/usr/lpp/IBM/aie                                
export BLAS_INSTALL_DIR=/usr/lpp/IBM/aie/blas                           
export SPARK_HOME=$SQLDI_INSTALL_DIR/spark24x                           
# SQLDI PATH                                                            
PATH=/bin:$PATH                                                         
PATH=$SQLDI_INSTALL_DIR/sql-data-insights/bin:$PATH                     
PATH=$SQLDI_INSTALL_DIR/tools/bin:$PATH                                 
PATH=$ZADE_INSTALL_DIR/bin:$PATH                                        
PATH=$PATH:$JAVA_HOME/bin                                               
export PATH=$PATH                                                       
# SQLDI LIBPATH                                                         
LIBPATH=/lib:/usr/lib                                                   
LIBPATH=$LIBPATH:$JAVA_HOME/bin/classic                                 
LIBPATH=$LIBPATH:$JAVA_HOME/bin/j9vm                                    
LIBPATH=$LIBPATH:$JAVA_HOME/lib/s390x                                   
LIBPATH=$LIBPATH:$SPARK_HOME/lib                                        
LIBPATH=$BLAS_INSTALL_DIR/lib:$LIBPATH                                  
LIBPATH=$ZAIE_INSTALL_DIR/zade/lib:$LIBPATH                             
LIBPATH=$ZAIE_INSTALL_DIR/zdnn/lib:$LIBPATH                             
LIBPATH=$ZAIE_INSTALL_DIR/zaio/lib:$LIBPATH                             
export LIBPATH=$LIBPATH                                                 
# SQLDI OTHER                                                           
export IBM_JAVA_OPTIONS="-Dfile.encoding=UTF-8"                         
export _BPXK_AUTOCVT=ON                                                 
export _BPX_SHAREAS=NO                                                  
export _ENCODE_FILE_NEW=ISO8859-1                                       
export _ENCODE_FILE_EXISTING=UNTAGGED                                   
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"                
export TERM=xterm                                                       
alias vi1='vi -W filecodeset=utf-8'                                     
alias vi2='vi -W filecodeset=iso8859-1'                                 
alias ll='ls -ltcpa'                                                    
export PS1=' ${PWD} >'                                                  
```


![duck5](sqldiimages/duck5.JPG) **RACF Certificate and Keyring** 

A RACF certificate is required for SQLDI to authenticate with RACF when it interacts with Db2. 
In this worked example we use a self-signed certificate and connect it to a keyring. 

The steps in the job below perform the following functions
* Create a Keyring (WMLZRING)
* Create a Certificate Authority cert
* Create a Certificate signed by the CA Cert.
* Connect both the CACert and the Certificate to the keyring
* Permit user AIDBADM and IBMUSER read access to cerificates owned by AIDBADM
* Refresh RACF

***IBMUSER.SDISETUP(RACFKEYR)***
```
//IBMUSERJ JOB  (USR),'ADD USER',CLASS=A,MSGCLASS=H,                  
//       NOTIFY=&SYSUID,MSGLEVEL=(1,1),REGION=0M                      
//********************************************************************
//*                                                                  *
//* CREATE RACF KEYRING FOR SQLDI V12                                *
//*                                                                  *
//********************************************************************
//S1       EXEC PGM=IKJEFT01                                          
//SYSTSPRT DD   SYSOUT=*                                              
//SYSPRINT DD   SYSOUT=*                                              
//SYSTSIN  DD   *                                                     
RACDCERT ADDRING(WMLZRING) ID(AIDBADM)                                
                                                                      
RACDCERT GENCERT CERTAUTH +                                           
SUBJECTSDN( +                                                         
      CN('STLAB41') +                                                 
      C('US') +                                                       
      SP('CA') +                                                      
      L('SAN JOSE') +                                                 
      O('IBM') +                                                      
      OU('WMLZ') +                                                    
) +                                                                   
ALTNAME( +                                                            
      EMAIL('nmarion@us.ibm.com') +                                   
) +                                                                   
WITHLABEL('WMLZCACert') +                                             
NOTAFTER(DATE(2025/01/01))                                            
                                                                      
RACDCERT GENCERT ID(AIDBADM) +                                        
SUBJECTSDN( +                                                         
      CN('STLAB41') +                                                 
      C('US') +                                                       
      SP('CA') +                                                      
      L('SAN JOSE') +                                                 
      O('IBM') +                                                      
      OU('WMLZ') +                                                    
) +                                                                   
ALTNAME( +                                                            
      EMAIL('nmarion@us.ibm.com') +                                   
) +                                                                   
WITHLABEL('WMLZCert_WMLZID') +                                        
SIGNWITH(CERTAUTH LABEL('WMLZCACert')) +                              
NOTAFTER(DATE(2025/01/01))                                            
                                                                      
RACDCERT ID(AIDBADM) CONNECT(CERTAUTH LABEL('WMLZCACert') +           
RING(WMLZRING))                                                       
                                                                      
RACDCERT ID(AIDBADM) CONNECT(ID(AIDBADM) LABEL('WMLZCert_WMLZID') +   
RING(WMLZRING) USAGE(PERSONAL))                                       
                                                                      
PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY) ID(AIDBADM) ACCESS(READ) 
PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY) ID(IBMUSER) ACCESS(READ) 
                                                                      
SETROPTS RACLIST(FACILITY) REFRESH                                    
                                                                      
/*                                                                          
```

**Note** The RACF jobs are case-sensitive. You must use CAPS-OFF when editing these PDS members to ensure that the RACF artefacts are created correctly. Otherwise you risk the SQLDI instance creation failing if it can't find the RACF certificates and keyring.

Verify the succesful creation of certificates and connection to the keyring with this job. (case-sensitive again).

***IBMUSER.SDISETUP(RACFCHK)***
```
//IBMUSERJ JOB  (USR),'ADD USER',CLASS=A,MSGCLASS=H,                  
//       NOTIFY=&SYSUID,MSGLEVEL=(1,1),REGION=0M                      
//********************************************************************
//*                                                                  *
//* CHECK  RACF KEYRING FOR SQLDI V12                                *
//*                                                                  *
//********************************************************************
//S1       EXEC PGM=IKJEFT01                                          
//SYSTSPRT DD SYSOUT=*                                                
//SYSPRINT DD SYSOUT=*                                                
//SYSTSIN  DD *                                                       
                                                                      
RACDCERT LISTRING(WMLZRING) ID(AIDBADM)                               
                                                                      
RACDCERT CERTAUTH LIST(LABEL('WMLZCACert'))                           
                                                                      
RACDCERT LIST(LABEL('WMLZCert_WMLZID')) ID(AIDBADM)                   
                                                                      
/*                                                                    
```

**Note** a Return code of 0 from this job does not necessarily mean that the objects were found as expected. You must explicitly check the job joutput, as in the screenshot below.

![racfchk](sqldiimages/racfchk.JPG)


![duck6](sqldiimages/duck6.JPG) **Create a HUGE ZFS** 

SQLDI model training can take up a lot of disk space. You need to prepare a ZFS for the SQLDI instance which is at least 4GB in size, or the SQLDI instance creation will fail. In a real-world environment where you are training models on large volumes of data, the disk space may need to be much larger.

In this worked example a ZFS called IBMUSER.SDI13.ZFS is created and mounted at /u/sqldi13

***IBMUSER.SDISETUP(CRTZFS)***
```
//IBMUSERJ JOB  (SDI),'CREATE ZFS',CLASS=A,MSGCLASS=H,                
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1)                          
//********************************************************************
//*                                                                  *
//* PURPOSE: CREATE ZFS DATASET AND MOUNTPOINT                       *
//*                                                                  *
//********************************************************************
//CREATE   EXEC PGM=IDCAMS,REGION=0M                                  
//SYSPRINT DD SYSOUT=*                                                
//SYSIN    DD *                                                       
  DEFINE -                                                            
       CLUSTER -                                                      
         ( -                                                          
             NAME(IBMUSER.SDI13.ZFS) -                                
             LINEAR -                                                 
             CYL(4000 1000) VOLUME(USER0A) -                          
             DATACLASS(DCEXTEAV) -                                    
             SHAREOPTIONS(3) -                                        
         )                                                            
/*                                                                    
//*                                                                   
// SET ZFSDSN='IBMUSER.SDI13.ZFS'                                       
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
    MOUNTPOINT('/u/sqldi13') +                                          
    FILESYSTEM('IBMUSER.SDI13.ZFS')                                     
/*                                                                      
```

Once you have created and mounted the ZFS, there are a couple more things to do.

Permenantly mount the ZFS in a PARMLIB member

***USER.Z25C.PARMLIB(BPXPRMZZ)***
```
/* Neale's CODE */                               
MOUNT FILESYSTEM('IBMUSER.SDI13.ZFS')            
      TYPE(ZFS)                                  
      MODE(RDWR)                                 
      NOAUTOMOVE                                 
      MOUNTPOINT('/u/sqldi13')                   
/* Neale's CODE */                               
MOUNT FILESYSTEM('SDI.V1R1.ZFS')                 
      TYPE(ZFS)                                  
      MODE(RDWR)                                 
      NOAUTOMOVE                                 
      MOUNTPOINT('/usr/lpp/IBM/db2sqldi/v1r1')   
```

Grow the ZFS to ensure that it is over 4GB in size. This can be done from USS using the following commands

***Command to determine the size of the ZFS (in KB)***
```
IBMUSER:/u: >df -k /u/sqldi13

Mounted on     Filesystem                Avail/Total    Files      Status
/u/sqldi13     (SQLDI.V13.ZFS)           2488135/2880000 4294966001 Available
```

***Command togrow the ZFS***
```
zfsadm grow -aggregate SQLDI.V12.ZFS -size 5000000
```

***Command to verify the increased size of the ZFS (in KB)***
```
IBMUSER:/u: >df -k /u/sqldi13

Mounted on     Filesystem                Avail/Total    Files      Status
/u/sqldi13     (SQLDI.V13.ZFS)           4608239/5000400 4294966001 Available
```


![duck7](sqldiimages/duck7.JPG) **USS environment variables** 

![duck8](sqldiimages/duck8.JPG) **USS environment variables** 

![duck9](sqldiimages/duck9.JPG) **USS environment variables** 

![duck10](sqldiimages/duck10.JPG) **USS environment variables** 




## 6. Installation Verification Test


## 7. Usage Scenarios ( Tables, Views and Aliases )


## 8. Usage Considerations

order of columns.

keeping model tables updated.


## 9. References and Further Reading

ccc

