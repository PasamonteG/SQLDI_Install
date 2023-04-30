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






## Step 6	Configuring WMLz setup user ID	(Sysprog with USS & Security skills)	 

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




