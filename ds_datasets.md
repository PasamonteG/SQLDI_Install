# Data Science Datasets 

The following datasets are currently being used for Colliding Worlds demonstrations

1. CHURN dataset. (The IVP sample of Telco customers who have churned).
2. Credit Card Fraud. (Synthetic credit card fraud dataset from Kaggle)
3. Penguins and Iris (Classical data science sample datasets)


## 1. CHURN dataset. 

This one is created by running ```IBMUSER.SDISETUP(DSNTIJAI)```

It's DDL structure is

```
CREATE TABLE DSNAIDB.CHURN              
  (                                     
    CUSTOMERID            VARCHAR(30),  
    GENDER                VARCHAR(10),  
    SENIORCITIZEN         VARCHAR(10),  
    PARTNER               VARCHAR(10),  
    DEPENDENTS            VARCHAR(10),  
    TENURE                INTEGER,      
    PHONESERVICE          VARCHAR(10),  
    MULTIPLELINES         VARCHAR(20),  
    INTERNETSERVICE       VARCHAR(30),  
    ONLINESECURITY        VARCHAR(30),  
    ONLINEBACKUP          VARCHAR(30),  
    DEVICEPROTECTION      VARCHAR(30),  
    TECHSUPPORT           VARCHAR(30),  
    STREAMINGTV           VARCHAR(30),  
    STREAMINGMOVIES       VARCHAR(20),  
    CONTRACT              VARCHAR(20),  
    PAPERLESSBILLING      VARCHAR(10),  
    PAYMENTMETHOD         VARCHAR(30),  
    MONTHLYCHARGES        DECIMAL(10,2),
    TOTALCHARGES          DECIMAL(10,2),
    CHURN                 VARCHAR(10)   
  ) IN DSNAIDB3.DSNAITS1;               
                                        
 CREATE UNIQUE INDEX DSNAIDB.CHURNIX    
   ON DSNAIDB.CHURN                     
   (CUSTOMERID);                        
                                        
COMMIT;                                 
                                        
GRANT SELECT ON DSNAIDB.CHURN TO PUBLIC;
                                        
```

## 2. Credit Card Fraud.  

Dataset was created by IBM (Erik Altman)

Download from Kaggle [kagglelink](https://www.kaggle.com/datasets/ealtman2019/credit-card-transactions)

Users

![users](/datasetimages/users.JPG)

Cards

![cards](/datasetimages/cards.JPG)

Transactions

![transactions](/datasetimages/transactions.JPG)



## 3. Penguins and Iris

Downloaded from Kaggle. Create DDL based on the CSV contents.

```
drop table EXPLORE.PENGUINS ;
drop table EXPLORE.IRIS ;
drop DATABASE EXPLORE ;

CREATE DATABASE "EXPLORE"
	BUFFERPOOL BP0
	INDEXBP BP0
	STOGROUP SYSDEFLT
	CCSID EBCDIC;

CREATE  TABLESPACE "TSPENG"
	IN EXPLORE
	USING STOGROUP SYSDEFLT
	  PRIQTY 7200
	  SECQTY 14400
	PCTFREE 0
	TRACKMOD NO
	SEGSIZE 64
	BUFFERPOOL BP0
	CCSID EBCDIC
	CLOSE NO
	LOCKMAX SYSTEM
	LOCKSIZE ANY
	MAXROWS 255;

CREATE  TABLESPACE "TSIRIS"
	IN EXPLORE
	USING STOGROUP SYSDEFLT
	  PRIQTY 7200
	  SECQTY 14400
	PCTFREE 0
	TRACKMOD NO
	SEGSIZE 64
	BUFFERPOOL BP0
	CCSID EBCDIC
	CLOSE NO
	LOCKMAX SYSTEM
	LOCKSIZE ANY
	MAXROWS 255;
	
Create Table EXPLORE.PENGUINS (
ID integer,
species CHAR(30),
island CHAR(30),
bill_length_mm decimal(7,2),
bill_depth_mm decimal(7,2),
flipper_length_mm decimal(7,2),
body_mass_g decimal(7,2),
sex CHAR(10),
year integer )
IN "EXPLORE"."TSPENG"
AUDIT NONE
DATA CAPTURE NONE
CCSID EBCDIC
;

Import from penguins.ixf of ixf
METHOD P (1,2,3,4,5,6,7,8,9)
insert into EXPLORE.PENGUINS ( ID, species, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year ) ;

Create Table EXPLORE.IRIS (
Id integer,
SepalLengthCm decimal(7,2),
SepalWidthCm decimal(7,2),
PetalLengthCm decimal(7,2),
PetalWidthCm decimal(7,2),
Species CHAR(30) ) 
IN "EXPLORE"."TSIRIS"
AUDIT NONE
DATA CAPTURE NONE
CCSID EBCDIC
;

Import from Iris.ixf of ixf
METHOD P (1,2,3,4,5,6)
insert into EXPLORE.IRIS ( Id, SepalLengthCm, SepalWidthCm, PetalLengthCm, PetalWidthCm, Species ) ;
```

And Check the data with a select

```
C:\Users\neale\Box\00_CollidingWorlds\kaggle\archive\move>db2 select * from explore.penguins

ID          SPECIES                        ISLAND                         BILL_LENGTH_MM BILL_DEPTH_MM FLIPPER_LENGTH_MM BODY_MASS_G SEX        YEAR
----------- ------------------------------ ------------------------------ -------------- ------------- ----------------- ----------- ---------- -----------
          1 Adelie                         Torgersen                               39.10         18.70            181.00     3750.00 male              2007
          2 Adelie                         Torgersen                               39.50         17.40            186.00     3800.00 female            2007
          3 Adelie                         Torgersen                               40.30         18.00            195.00     3250.00 female            2007
          4 Adelie                         Torgersen                                   -             -                 -           - NA                2007
          5 Adelie                         Torgersen                               36.70         19.30            193.00     3450.00 female            2007
          6 Adelie                         Torgersen                               39.30         20.60            190.00     3650.00 male              2007
          7 Adelie                         Torgersen                               38.90         17.80            181.00     3625.00 female            2007
          8 Adelie                         Torgersen                               39.20         19.60            195.00     4675.00 male              2007
          9 Adelie                         Torgersen                               34.10         18.10            193.00     3475.00 NA                2007
         10 Adelie                         Torgersen                               42.00         20.20            190.00     4250.00 NA                2007
         11 Adelie                         Torgersen                               37.80         17.10            186.00     3300.00 NA                2007
         12 Adelie                         Torgersen                               37.80         17.30            180.00     3700.00 NA                2007
         13 Adelie                         Torgersen                               41.10         17.60            182.00     3200.00 female            2007
         14 Adelie                         Torgersen                               38.60         21.20            191.00     3800.00 male              2007
         15 Adelie                         Torgersen                               34.60         21.10            198.00     4400.00 male              2007
         16 Adelie                         Torgersen                               36.60         17.80            185.00     3700.00 female            2007
         17 Adelie                         Torgersen                               38.70         19.00            195.00     3450.00 female            2007
         18 Adelie                         Torgersen                               42.50         20.70            197.00     4500.00 male              2007
         19 Adelie                         Torgersen                               34.40         18.40            184.00     3325.00 female            2007
         20 Adelie                         Torgersen                               46.00         21.50            194.00     4200.00 male              2007
         21 Adelie                         Biscoe                                  37.80         18.30            174.00     3400.00 female            2007
         22 Adelie                         Biscoe                                  37.70         18.70            180.00     3600.00 male              2007
         23 Adelie                         Biscoe                                  35.90         19.20            189.00     3800.00 female            2007
         24 Adelie                         Biscoe                                  38.20         18.10            185.00     3950.00 male              2007
         25 Adelie                         Biscoe                                  38.80         17.20            180.00     3800.00 male              2007
         26 Adelie                         Biscoe                                  35.30         18.90            187.00     3800.00 female            2007
         27 Adelie                         Biscoe                                  40.60         18.60            183.00     3550.00 male              2007
         28 Adelie                         Biscoe                                  40.50         17.90            187.00     3200.00 female            2007
         29 Adelie                         Biscoe                                  37.90         18.60            172.00     3150.00 female            2007
         30 Adelie                         Biscoe                                  40.50         18.90            180.00     3950.00 male              2007
         31 Adelie                         Dream                                   39.50         16.70            178.00     3250.00 female            2007
         32 Adelie                         Dream                                   37.20         18.10            178.00     3900.00 male              2007
         33 Adelie                         Dream                                   39.50         17.80            188.00     3300.00 female            2007
         34 Adelie                         Dream                                   40.90         18.90            184.00     3900.00 male              2007
         35 Adelie                         Dream                                   36.40         17.00            195.00     3325.00 female            2007
         36 Adelie                         Dream                                   39.20         21.10            196.00     4150.00 male              2007
         37 Adelie                         Dream                                   38.80         20.00            190.00     3950.00 male              2007
```

and

```
C:\Users\neale\Box\00_CollidingWorlds\kaggle\archive\move>db2 select * from explore.iris

ID          SEPALLENGTHCM SEPALWIDTHCM PETALLENGTHCM PETALWIDTHCM SPECIES
----------- ------------- ------------ ------------- ------------ ------------------------------
          1          5.10         3.50          1.40         0.20 Iris-setosa
          2          4.90         3.00          1.40         0.20 Iris-setosa
          3          4.70         3.20          1.30         0.20 Iris-setosa
          4          4.60         3.10          1.50         0.20 Iris-setosa
          5          5.00         3.60          1.40         0.20 Iris-setosa
          6          5.40         3.90          1.70         0.40 Iris-setosa
          7          4.60         3.40          1.40         0.30 Iris-setosa
          8          5.00         3.40          1.50         0.20 Iris-setosa
          9          4.40         2.90          1.40         0.20 Iris-setosa
```


