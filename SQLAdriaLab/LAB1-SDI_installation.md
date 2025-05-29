# IBM SQL Data Insights for Db2 v13 Installation Lab

The purpose of this repository is to guide the participant though a worked example of how to setup and use SQL Data Insights. The hands on lab consists of a Windows Image (with 3270 emulator and putty) and a Linux on Z image running a z/OS guest. 

The HOL was originally written in github using markdown. If you prefer to access these instructions in a web browser, open the repository at the link below. _TO-DO: PROVIDE LINK TO THE INSTALLATION GUIDE_

## Contents
The following ten steps cover what you need to do to get "Up and Running" with SQLDI Technology for Db2 V13. 
Step 11 is added for problem determination steps just in case things don't work out perfectly.

1. SQL DI Deployment Overview and Planning
2. Prepare the SQLDI Administration Userid and Group
3. Prepare a large ZFS for SQLDI_HOME
4. Upload and Install the SQL DI Technology components
5. Prepare a certificate and Keyring for user authentication
6. Prepare network ports
7. Create the SQLDI Server Instance
8. Create Db2 Artefacts to support SQLDI (catalog tables, procs, udfs and packages)
9. Create the sample table for IVP Testing
10. Perform an IVP Test
11. Problem Determination Steps

## 1. SQL DI Deployment Overview and Planning

This section explains the context of the SQLDI Hands on Learning

1. The components and dependences of an SQLDI Instance
2. The HOL Environment that will be used for the Setup Lab

### 1.1 The Components and Dependencies of an SQLDI Instance

The first step is to understand all the components that are needed to build an SQLDI environment, their dependencies, and how they interact with each other.
Study the diagram below, and read the notes that follow.

![SQLDI Components](../sqldiimages/sqldi_arch.JPG)

The SQLDI Server is a set of services running in USS, which interact with artefacts in Db2 z/OS.

#### Left Hand Side: The SQLDI Server instance
SQL Data Insights is a very self-contained package that installs easily into USS. 
It includes it's own copy of Spark, db2 jdbc driver, model training services, web server for the SQLDI browser interface, as well as tools like the bash shell.
All you need to do is install it from the correct SMP/E FMID that comes with Db2 v13 (5698-DB2, FMID: HDBDD18).

After installation, you must create an SQLDI instance. This is dependent on a number of USS and z/OS pre-requsuites being set correctly.

* The USS environment must reflect the correct PATH and LIBPATH variables for the various Z AI libraries, the deep learning compiler etc...
* The script to create an SQLDI instance must be executed by the SQLDI instance userid, which must have the correct RACF properties
* It must reference a RACF keyring containing the authentication certificate to access z/OS
* It must also specify the network ports that SQLDI and Spark will use.
* It must also specify a USS paths with enough space to deploy the SQLDI instance.

The script to create an SQLDI instance is easy to invoke. The hard work is the careful planning and provisioning of the environment that it needs.

#### Right Hand Side: The Db2 z/OS V13 subsystem, with several artifacts to support the SQLDI Server instance

You need 

* a standard Db2 V13 system, with the DB2-provided procedures and their WLM environments and associated PROCLIB members.
* The SQLDI pseudo catalog for the SQLDI server to store metadata
* Several new SQLDI stored proedures, Three UDFs and corresponding packages to be bound.
* A new WLM environment for the UDFs to execute in, and create a PROCLIB member to invoke them.

The notes above are a summary of the key pre-requisite considerations for SQLDI deployment. A comprehensive list of requiremnents is published 
in the [SQLDI Knowledge Center](https://www.ibm.com/docs/en/db2-for-zos/13?topic=insights-preparing-sql-di-installation) for Db2 13.

### 1.2 The HOL Environment that will be used for the Setup Lab

The Hands on Learning lab is hosted in a virtualised environment accessed via the Cloud using ZVA. Booking requests can be made by IBMers, so that the environment will not be freely ready after the labs you are running today.

The diagram below illustrates the nature of ZVA, and how to access it. Documented here: [ZVA_System_Access.](ZVA_System_Access.md).

![zva](/aizimages/access_zva.jpg)

The rest of this document contains the instructions for you to install and configure SQLDI on the ZVA image. 

**You will NEED to Know The following**

### Userids and Passwords in z/OS.

The z/OS userids and passwords that you will be using once you have accessed the ZVA or ZTrial system are

* IBMUSER ( password SYS1 ) is a high privilege z/OS userid with Db2 Access
* AIDBADM ( password aidbadm ) is the userid that will be used as the SQLDI instance owner.

### TCPIP hostnames.
Do **NOT** attempt to use TCPIP addresses during this HOL. The z/OS TCPIP stack has not been customised during the ZVA provisioning process.
You must use hostnames, which have been setup.

From **Windows** you should point the applications (PCOMM and putty) at the z/OS system using hostname wg31.

![putty_wg31](/aizimages/putty_wg31.png)

![pcomm_wg31](/aizimages/pcomm_wg31.jpg)

From **USS** (where SQLDI runs) you should define your SQLDI and Spark instances to be located at hostname wg31.washington.ibm.com.

---

**TASK**

Let's check that all the components needed in USS are in place.

You will ned to login as **ibmuser** into the PuTTY terminal.

![Login using PuTTY](/aizimages/login_ibmuser.png)

![List path with libraries](/aizimages/list_usrlpp.png)

![Verify the SQLDI libraries are mounted](/aizimages/list_usrlpp_2.png)

---

## 2. Prepare the SQLDI Administration Userid and Group
There are two parts to this task. The first pertaining to RACF profiles, the second pertaining to USS environment variables.

In a nutshell, you need to setup the following:
1. A RACF userid with an omvs segment to be the SQLDI instance owner.
2. which has generous CPU and Memory limits to reflect the fact that model training might take some time.
3. which is a member of a RACF group named SQLDIGRP. 
4. and has USS environment settings that include PATH and LIBPATH values to link to all the Z AI libraries and the Deep Learning Compiler.

**Note: Db2 permissions** The SQLDI instance owner itself does not need Db2 permissions. 
The userid that logs onto SQLDI via the Web UI will need to be a member of SQLDIGRP **and** will also need Db2 privileges.

We will use this logistical planning matter as a basis for problem determination later on on the HOL.

### 2.1 RACF User Profiles
 
Decide on a userid that will be the SQLDI owner within USS. 

You will create **AIDBADM** user:

---

**TASK**

The JCL that was used to define RACF userid is found in `IBMUSER.SDISETUP(SDIUSCRT)` . It is standard RACF user profile, with a TSO signon and an omvs id.

![IBMUSER.SDISETUP](/aizimages/RACF_JCL.png)

Submit the JCL:

![Submit member `SDIUSCRT`](/aizimages/RACF_JCL_sub.png)

---

**TASK**

If you want to make additional RACF userids able to operate SQLDI, those users would also need similar customisation as the following steps for AIDBADM.

With the TSO command `tso lu iadbadm omvs` you can display the RACF user profile, or you can go using the panels:

* ISPF main panel
* m.3 ( for RACF )
* 4 ( for user profiles )
* D - AIDBADM ( to display the user profile for AIDBADM )
* s - OMVS ( to include the omvs segment details 0

If the lab has been reset correctly, AIDBADM will be a member of the RACF Group 'SYS1', and will have an omvs segment with various omvs properties set.

![](/aizimages/racf_aidbadm.jpg)

---

Check the RACF profiles for user AIDBADM.

---

**TASK**

For each of the users, they need an OMVS segment with certain properties specified.
We want to see the following values set for the SQLDI user.

* CPUTIMEMAX 864000 (to avoid the risk of timeouts during long model training tasks)
* MEMLIMIT 4GB minimum (because SQLDI and Spark need sufficient memory)
* PROGRAM /bin/sh (or change it to /bin/bash if you prefer that as a default)
* HOME /u/aidbadm (to follow the standard convention for the home directory of a user)

If the OMVS properties needs to be amended, go to RACF User Profiles ( ISPF M.3.4 ) and select "2" to change the user profile of AIDBADM

![](/aizimages/aidbadm02.jpg)

Specify that you want to change optional features 

![](/aizimages/aidbadm03.jpg)

Select omvs

![](/aizimages/aidbadm04.jpg)

Edit CPUMAXTIME and MEMLIMIT to meet the crieria

![](/aizimages/aidbadm05.jpg)

And verify the changes 

![](/aizimages/aidbadm06.jpg)


### 2.2 RACF Group Profiles

A RACF Group profile with the specific name "SQLDIGRP" is required for SQLDI, and userids that invoke SQLDI must be added into that group.
You need to create the "SQLDIGRP" group and connect user "AIDBADM" to it.
You can do this in any one of the following ways:

1. using the RACF Panels ( ISPF M.3 ) 
2. Using TSO commands below from ISPF Option 6.  
3. Customising and Submitting the Job in `IBMUSER.SDISETUP(SDIRACFG)` illustrated below

If you choose the third option, this is the JCL that you must customize and submit.

```JCL
//IBMUSERJ  JOB (FB3),'IBMUSER',NOTIFY=&SYSUID,    
// MSGCLASS=H,CLASS=A,MSGLEVEL=(1,1),                        
//         REGION=0M,COND=(4,LT)                 
//S1       EXEC PGM=IKJEFT01                                 
                                                             
//SYSTSPRT DD SYSOUT=*                                       
                                                             
//SYSPRINT DD SYSOUT=*                                       
                                                             
//SYSTSIN  DD *                                              
                                                             
ADDGROUP SQLDIGRP OMVS(AUTOGID) OWNER(IBMUSER)                 
                                                             
CONNECT (AIDBADM) GROUP (SQLDIGRP) OWNER(IBMUSER)

CONNECT (IBMUSER) GROUP (SQLDIGRP) OWNER(IBMUSER)
                                                             
SETROPTS RACLIST(FACILITY) REFRESH                           
                                                             
/*                                                                                                             
```

And verify that aidbadm is now a member of group SQLDIGRP

![Command](/aizimages/aidbadm_group_command.png)

![Command result](/aizimages/aidbadm_group_check.png)

### 2.3 USS Environment Variables

The RACF user profile for AIDBADM has been checked for having an omvs segment, and for the required properties to run SQLDI.

The environment variables for a userid operating in USS are a mixture of environment variables set at a system level, and environment variables set for a specific useric using the `.profile`.

The **aidbadm** user needs to define PATH and LIBPATH environment variables so that all the required executables can be invoked at runtime.

---

**TASK**

Open a terminal session into USS (e.g. using putty) and **logon as aidbadm**. You should find yourself in the home directory for the aidbadm user.

Now, list all the files in your home directory with the `ls -al` command. (Files beginning with `.` are hidden unless you specify `-al`.)

![aidbadm user path in USS](/aizimages/aidbadm_uss_path.png)


(**Note:** Contents may differ from your screen)

```bash
 /u/aidbadm >ls -al
total 192
drwxr-xr-x   3 AIDBADM  SYS1        8192 Jul 28 02:20 .
drwxr-xr-x  40 OMVSKERN SYS1       16384 Jan 25  2022 ..
-rw-------   1 AIDBADM  SYS1        6312 Jul 27 06:35 .bash_history
-rwxr-xr-x   1 AIDBADM  SYS1        2891 Jul 26 23:58 .profile
-rwxr-xr-x   1 AIDBADM  SYS1        2891 Jul 26 23:58 .profile.aidbadm
-rw-------   1 AIDBADM  SYS1        1654 Jul 28 02:20 .sh_history

```

You can easily list the contents of the .profile with the `cat` command as follows:
(**NOTE:** Contents in your profile may differ form this output)

```bash
 /u/aidbadm >cat .profile
export HOST=$(uname -n)
export PS1=' ${PWD} >'
export NET_IP=`host $HOST | grep addresses | awk ' { print \$5 } ' `
export LANG=En_US
export TERM=xterm
set -o vi
export _BPXK_AUTOCVT=ON
export _BPX_SHAREAS=NO
_BPXK_AUTOCVT=ON

# PATH -
PATH=".:${HOME}/bin:/usr/sbin:/usr/bin:${PATH}:/usr/local/bin:/usr/lpp/ldap/sbin:/usr/lpp/NFS"

# Add BASH to PATH
export PATH=/u/user1/tools/bash-4.3.48-2/bin:${PATH}

# use latest java version
if [ -r /usr/lpp/java/J8.0_64 ]
then
  export JAVA_HOME=${JAVA_HOME:-/usr/lpp/java/J8.0_64}
  export PATH="${PATH}:${JAVA_HOME}/bin"
  #Needed by jaydebeapi to find libj9a2e.so
  export LIBPATH=$LIBPATH:${JAVA_HOME}/lib/s390x:${JAVA_HOME}/lib/s390x/classic
fi

if [ -z "$IBM_JAVA_OPTIONS" ]; then
  export IBM_JAVA_OPTIONS="-Dfile.encoding=UTF-8"
else
  if [[ ! "$IBM_JAVA_OPTIONS" == *"-Dfile.encoding=UTF-8"* ]]; then
      export IBM_JAVA_OPTIONS=$IBM_JAVA_OPTIONS:-Dfile.encoding=UTF-8
  fi
fi

if [ -r .envfile ]
then
  echo "execute ENVIRONMENT .envfile "
  . .envfile
fi

```

Some required variables (like `JAVA_HOME`) are already specified, but none of the required SQLDI library paths are defined.

Even though we haven't yet installed the AI libraries and the SQLDI libraries, this HOL is structured to keep all the user profile settings together, and we know exactly what the paths will be.

If you are comfortable with the vi editor, then you can edit the `.profile` inside USS. Most of us would prefer to use the ISPF editor, as shown below.

Open ISPF edit (Option 2) and open the **`/u/aidbadm/.profile`** USS file.

```bash
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
export BLAS_INSTALL_DIR=/usr/lpp/cbclib
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

Save the file. Then lets check whether the `.profile` is being invoked when the aidbadm user logs on.

---

**TASK**

Open a new putty session, and logon as aidbadm. Then type the command **env** to see all the current environment variables.

Logging on will invoke the `.profile` script. 
Note that if you are already logged on within USS you need to invoke the `.profile` again to reflect your changes. 

![env](/aizimages/env.jpg)

You might find it easier to check individual environment settings with an **echo** command. For example

![echo](/aizimages/echo.jpg)

---

**TASK**

Some users with non-english keyboards at the Europe and AP Technical Academy had great difficulty in editing the .profile file using ISPF. 
If you encounter similar difficulties, please don’t waste your time attempting to overcome such challenges. 
Instead, you could replace the existing `.profile` file with a pre-customised file.

1. Log on to putty as user **ibmuser**.

2. `cd /u/ibmuser` and then list the files `ls -la`

![ibmuser path](/aizimages/ready_profile.png)

3. `cp .profile.aidbadm /u/aidbadm/.profile`

![ibmuser path](/aizimages/copy_profile.png)

4. `ls -al /u/aidbadm`

**!!! Alternative Task : !!!** Edit the `.profile`  and check that the following environment variables are set correctly. Type them if needed.

* PATH
* LIBPATH
* ZAIE_INSTALL_DIR
* SQLDI_INSTALL_DIR
* ZADE_INSTALL_DIR
* BLAS_INSTALL_DIR 
* JAVA_HOME
* SPARK_HOME

---

## 3. Prepare a large ZFS for SQLDI_HOME

The requirements for the zFS are that it will support an `SQLDI_HOME` path over over 100GB (for a realistic small system). The script to create the SQLDI instance checks the ZFS and fails in it is less than 4GB.

---

**TASK**

You will need to go to your TSO session and search for `IBMUSER.SDISETUP(CRTZFS)`

![IBMUSER.SDISETUP(CRTZFS)](/aizimages/zFs_create.png)

And then submit the JCL.

![JCL for zFS generation](/aizimages/CRTZFS_JCL.png)

Wait for the correct execution and result for the JCL

![Successful execution](/aizimages/return_00.png)


You can check the size of the ZFS in KB with the following command in USS, it has been mounted from the creation JCL. Use the VT100 terminal connected to USS. Command `df -k /u/sqldi13`:

![Check size of the zFS](/aizimages/df_test.png)

Now grow the zFS to ensure that it is over 4GB in size, use the command `zfsadm grow -aggregate IBMUSER.SDI13.ZFS -size 5000000`:

![Grow command for zFS](/aizimages/zfsadm.png)

Change `/u/sqldi13` ownership to AIDBADM user. Command: `chown AIDBADM /u/sqldi13`.

Check that it worked. Command: `ls -latr /u/sqldi13/`

![Check ownership change](/aizimages/check_chown.png)

---

## 4. Create SQLDI Pseudo-catalog

---

**TASK**

You will need to go to your TSO session and search for `IBMUSER.SDISETUP(DSNTIJAI)`, and execute the JCL.

![Create pseudo-catalog](/aizimages/DSNTIJAI.png)

and wait for the correct return code. 

---

## 5. Prepare a Certificate and Keyring for SQLDI

Authentication for the SQLDI server is achieved by referencing a certificate in a RACF keyring during the SQLDI instance creation.

Additionally, we could setup network encryption rules using RACF certificates and PAGENT rules. 
z/OS uses Application-Transparent TLS (AT-TLS), so there would be no differnce in the SQLDI setup steps.
Encryption is outside the scope of this HOL.

A JCL job for creating a keyring containing a self-signed certificate is provided in `IBMUSER.SDISETUP(RACFKEYR)`.
Logon to TSO, review and submit this job to create the RACF artefacts.
The steps performed by this job are

1. create a keyring 
2. create a certificate authority (identified by label WMLZCACert)
3. create a certificate (identified by label `WMLZCert_WMLZID`) and signed by the CA above
4. connect both the user certificate and the CA certificate to the keyring
5. grant permission to list the keyring to aidbadm (and any other user that might want to list it)
6. perform a RACF refresh

--- 

**TASK** 

Go to dataset `IBMUSER.SDISETUP(RACFKEYR)`

![RACFKEYR member](/aizimages/RACFKAYR_member.png)

And then submit the job:

![RACFKEYR execution](/aizimages/RACFKAYR_sub.png)

You can check the status of the RACF objects by submitting `IBMUSER.SDISETUP(RACFCHK)`:

![RACFCHK member](/aizimages/RACFCHK_member.png)

![RACFCHK member](/aizimages/RACFCHK_SUB.png)

