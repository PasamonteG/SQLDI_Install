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

![duck1](sqldiimages/duck1.JPG) **Verify the AI libraries are mounted at the right path.**

Open an ssh session into USS, and navigate to /usr/lpp/IBM/aie

You should expect to find the following paths and contents.

![duck2](sqldiimages/duck2.JPG)  **Setup RACF userid and group**

Create a RACF userid as the SQLDI Instance Owner. (AIDBADM)
Ensure the RACF userid has an omvs segment, with some large allowances.


![duck3](sqldiimages/duck3.JPG) **USS environment variables** 

![duck4](sqldiimages/duck4.JPG) **USS environment variables** 

![duck5](sqldiimages/duck5.JPG) **USS environment variables** 

![duck6](sqldiimages/duck6.JPG) **USS environment variables** 

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

