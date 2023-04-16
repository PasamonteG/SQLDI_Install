# Data Science Datasets 

The following datasets are currently being used for Colliding Worlds demonstrations

1. CHURN dataset. (The IVP sample of Telco customers who have churned).
2. Credit Card Fraud. (Synthetic credit card fraud dataset from Kaggle)
3. Penguins (A Classical data science sample data)
4. Irises (Another Classical data science sample data)

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



## 3. Penguins  


## 4. Irises  


