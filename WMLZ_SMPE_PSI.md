# Audit Trail for SMPE installation of WMLZ V2.4

## Planning Notes

1. Problem with ZVA system installing PSI from ShopZ .... hence ; save to C:\z\WMLZ folder and install from Wkstn.
2. April PSI download has less files than the March Order
3. Provision DASD for space


## Planning z Volumes

DBCLASSD - add C5DBD3
SGUSER - USER0A - USER0F ; for products and SMPE work - all 3390-27
SGEXTEAV - for SQLDI and WMLZ instances - EAV001 - EAV004 - all 3390-27

## Shop Z Download April 2023

D:\ZSHOP_PSI\WMLZ_V24_APR2023

## Big ZFS Cluster ( 20GB many volumes )

```
DEFINE -                                                
     CLUSTER -                                          
       ( -                                              
           NAME(IBMUSER.PSI.ZFS) -                      
           LINEAR -                                     
           CYL(4000 500) VOLUME(USER0A USER0B USER0C) - 
           DATACLASS(DCEXTEAV) -                        
           SHAREOPTIONS(3) -                            
       )   
```


## zOSMF workflow to install the PSI

Words

![/psi_step1](wmlzimages/psi_step1.JPG)

Word

![/psi_step2](wmlzimages/psi_step2.JPG)

Word

![/psi_step3](wmlzimages/psi_step3.JPG)

Word

![/psi_step4](wmlzimages/psi_step4.JPG)

Word

![/psi_step5](wmlzimages/psi_step5.JPG)

Word

![/psi_step6](wmlzimages/psi_step6.JPG)

Word

![/psi_step7](wmlzimages/psi_step7.JPG)

Word

![/psi_step8](wmlzimages/psi_step8.JPG)

Word

![/psi_step9](wmlzimages/psi_step9.JPG)

Word

![/psi_step10](wmlzimages/psi_step10.JPG)

Word

![/psi_step11](wmlzimages/psi_step11.JPG)

Word

![/psi_step12](wmlzimages/psi_step12.JPG)

Word

![/psi_step13](wmlzimages/psi_step13.JPG)

Word

![/psi_step14](wmlzimages/psi_step14.JPG)

Word

![/psi_step15](wmlzimages/psi_step15.JPG)

Word

![/psi_step16](wmlzimages/psi_step16.JPG)

Word
![/psi_step17](wmlzimages/psi_step17.JPG)

Word

![/psi_step18](wmlzimages/psi_step18.JPG)

Word

## Post Deploymemt Workflows

Word

