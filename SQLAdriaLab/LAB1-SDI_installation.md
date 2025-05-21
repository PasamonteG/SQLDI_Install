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
in the [SQLDI Knowledgecenter](https://www.ibm.com/docs/en/db2-for-zos/13?topic=insights-preparing-sql-di-installation) for Db2 13.

