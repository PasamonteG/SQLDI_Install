# Accessing Db2 on ZVA

These notes and screenshots are an aide-memoire for connecting to DB2 z/OS in the ZVA system.


## Contents

1. SPUFI
2. Db2 Admin Tool
3. DB2 CLP
4. Jupytr Notebooks

## 1. SPUFI 

SPUFI is an acronym. (SQL Processing Using File Input).

It is a very old way of accessing Db2, that originated before Windows was born, and people had to use 3270 terminals

Find the 3270 Emulator on the desktop and open it.

![eg01](logonimages/eg01.JPG)

Enter "l tso" to logon to TSO

![eg02](logonimages/eg02.JPG)

enter your username "ibmuser"

![eg03](logonimages/eg03.JPG)

enter your password "SYS1"

![eg04](logonimages/eg04.JPG)

wait for ISPF and *** to appear, then press enter

![eg05](logonimages/eg05.JPG)

This is the ISPF main menu

![eg06](logonimages/eg06.JPG)

Enter m ( more options )

![eg07](logonimages/eg07.JPG)

Enter 15, for the Db2 sub menu

![eg08](logonimages/eg08.JPG)

Enter 1 for SPUFI

![eg09](logonimages/eg09.JPG)

The panel allows you to specify an input dataset and and output dataset, and a bunch of execution options. Press Enter to proceed

![eg10](logonimages/eg10.JPG)

Ignore the code page mismatch. Press Enter to proceed

![eg11](logonimages/eg11.JPG)

These are the default settings for interacting with Db2. Accept them. Press Enter to proceed

![eg12](logonimages/eg12.JPG)

This the edit screen for your input file.
It contains a couple of SQL statements, each with the semi colon statement delimeter.
You can edit the SQL queries here to practice running SQL. Press Enter to proceed

![eg13](logonimages/eg13.JPG)

SPUFI is now ready to submit your file. Press Enter to proceed

![eg14](logonimages/eg14.JPG)

These are the results... TA DA !. Use F8 and F7 to scroll down and up. Press F3 when you are done.

![eg15](logonimages/eg15.JPG)

This is the ISPF main menu

![eg16](logonimages/eg16.JPG)

Enter m ( more options )

![eg17](logonimages/eg17.JPG)

Enter 15, for the Db2 sub menu

![eg18](logonimages/eg18.JPG)

Enter 1 for SPUFI

![eg19](logonimages/eg19.JPG)

The panel allows you to specify an input dataset and and output dataset, and a bunch of execution options. Press Enter to proceed


The model used by SQLDI is the Bag of Words model, which is described by many places on the web such as [wikipedia](https://en.wikipedia.org/wiki/Bag-of-words_model)

Using a simple SQL query, you can do things like
- find and rank clients who are most similar to your most profitable clients. 
- find clients who have similar patterns to previous clients who closed their accounts.
- see which data items are most influential towards certain outcomes

SQLDI can operate against Db2 views, or even external data sources like IMS and VSAM.

Two of the most likely use cases for SQLDI are
1. Business Analytics Users.
2. Data Scientists who are charged with developing more targetted machine learning scoring models.


## 2. Db2 Admin Tool

SQLDI is a no charge feature of Db2 z/OS V13, but you do need to order this feature explicitly in order to get it. The screenshot below is from ShopZ, showing two separate items to order, each with the same Product ID.

![sqldi_shopz](sqldiimages/sqldi_shopz.JPG)

If you already have Db2 z/OS V13 installed, you can order SQL Data Insights as a CBPDO for it's own SMPE CSI, or to add to the Db2 SMPE CSI.

## 3. DB2 CLP

SQLDI is a standard SMPE installation, which will not be addressed in this document.

There are several pre-requisites that you should resolve before ordering SQLDI. As always, you should refer to the current page in the Db2 z/OS knowledge centre to get the latest information. [link to SQLDI Pre-Requisites](https://www.ibm.com/docs/en/db2-for-zos/13?topic=di-preparing-sql-installation)

* z/OS ( V2.4 or V2.5 ) requires several PTFs to be applied to provide the pre-requisite AI libraries.
* Db2 needs the fix for APAR PH49781
* z/OS OpenSSH and the IBM 64-bit JDK are also needed.


## 4. Jupyter Notebooks

When Planning for SQLDI deployment, it is very helpful to consider an architecture diagram of all the moving parts.

![sqldi_arch](sqldiimages/sqldi_arch.JPG)

SQLDI runs in USS ( z/OS Unix Systems Services ). It only needs to be running when you are training new models. Once the models are trained, and loaded into the model tables, SQLDI can be stopped, and Db2 z/OS will continue to serve AI-enabled queries.
