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

1. SMPE Installation
2. Planning and Pre-Requisites
3. Deploying a simple WMLZ Instance
4. Installation Verification Test
5. Operational Considerations
6. Expanded Usage Scenarios
7. References and Further Reading



## 1.0 SMPE Installation

WMLZ should be ordered from ShopZ as a Portable Software Instance, screenshot below

![shopz](wmlzzvaimages/shopz.JPG)

Use the Download to host JCL to download the PSI image files into a large ZFS on your z/OS system. 
The base size of the PSI image is about 20GB, so you will need to allocate a large multi-volume ZFS with extended data class attributes to store the image.
Use the z/OSMF Software Configuration app to download the PSI image to your ZFS.

Once the PSI image is downloaded you will need to switch to the Deploymemts tab of z/OSMF Software Configuration app to deploy the software to z/OS. 

## 2.0 Planning and Pre-Requisites

WMLZ requires a considerable amount of hardware resources to deploy. Bare minimum spec is 1 CP, 4 zIIPs, 100GB memory, 300GB DASD. The requirements are documented in the knowledge centre at this link [link](https://www.ibm.com/docs/en/wml-for-zos/2.4.0?topic=wmlz-planning-system-capacity)




## 3.0 Deploying a simple WMLZ Instance

scope = no python. Just online and cics scoring services.

## 4.0 Installation Verification Test


## 5.0 Operational Considerations


## 6.0 Expanded Usage Scenarios


## 7.0 References and Further Reading



