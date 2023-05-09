# AI at Scale on IBM Z - Level 3 Hands-On Workbook

***Contents***

1. Objectives and Scope of this workbook
2. Accessing the ZVA environment to perform the hands-on exercises
3. Using Opensource Data Science Tools with IBM Z Data Sources
4. Using Db2 z/OS SQL Data Insights to support the data wrangling process
5. Developing and Training a Model
6. Deploying the Model to Watson Machine Learning for z/OS
7. Calling the Model from CICS for realtime scoring of CICS transactions
8. Calling the Model from anywhere using REST APIs
9. Developing AI scoring services with SQL Data Insights
10. Review the AI lifecycle support available on IBM Z

## 1. Objectives and Scope of this workbook

This workbook is a companion intended for use with the Test Drive System for AI Solutions on z/OS available at 'Z Virtual Access' (ZVA)

* The ZVA image includes a range of Data and AI software on z/OS, prepared and ready for a test drive.
* This workbook is a guided tour for using that software to progress through an AI lifecycle process. (Data analysis, Model Training, Deploying Scoring Models, and Calling the Models from OLTP environments).

The objective is to provide practical insight into deploying AI solutions on the IBM Z platform, using a worked example that is documented in this workbook.

A sister workbook is also available to allow practitioners to rehearse the deployment of the software, to gain experience in the deployment processes before performing a deployment in a customer environment.

## 2. Accessing the ZVA environment to perform the hands-on exercises

[zTrial](https://www.ibm.com/z/trials) is an internet-facing portal for clients to book demonstrations and test environments for z/OS software. The images in zTrial have been carefully designed to provide easy-to-use, well-structured, scripted environments as a self-serve experience. Any client can request a specific zTrial environment, and it will be provisioned in a day or so, and remain accessible for 4 days.

ZVA is the IBM-internal development version of zTrial. It is the place where polished zTrial images are developed. IBMers can request ZVA images for use by either IBMers or clients. ZVA images can be used for hands-on-labs or demonstrations. IBMers can request ZVA images for customer workshops at the following URL within the IBM firewall. [ZVA_Portal](https://zva.wdc1a.cirrus.ibm.com/)

Both ZVA and zTrial images consist of
- a networked combination of a Windows Client and a z/OS server.
- prepared with software and data for specified z Software fanmiliarisation.
- and accessible over the internet, either from a web browser, or an RDP client.


### 2.1 Access to the ZVA image.

When you receive your signon creditials, they will look something like this.

|URL|User ID for Web browser|Password|
| --- | --- | --- | 	 	 	 
|https://T-2428-130-198-93-170.ibmztrialmachines.com/	|Administrator	|qufG2d4LiCJG8xvg1B7W!|

or this

|IP Address for Remote Desktop|User ID for Remote Desktop|Password|
| --- | --- | --- | 	 	 
|T-2428-130-198-93-170.ibmztrialmachines.com	|w-2428-k\Administrator	|qufG2d4LiCJG8xvg1B7W!|


The easiest method of accessing the ZVA image is to click on the Browser URL, and cut and paste the userid and password into the logon screen.

If you prefer to use a Remote Desktop Protocol client, paste the RDP IP Address into your RDP client, and then paste the userid and password into the logon screen.


### 2.2 Starting Point

The system that you connect to will be a Windows client, with various tools that access the z/OS image.

* Personal Communications Client - for 3270 access to the host (wg31.washington.ibm.com) on port 23.
* Putty - for ssh connection to z/OS unix system services (USS) on port 22.
* DB2 Connect Command Line Processor (DB2 CLP) for SQL access to Db2 z/OS V13 on port 5045.
* Chrome browser - for http access to the z/OS Software Services ( SQLDI, WMLZ etc... )
* VS Code - ubiquitous development IDE with plugins for Db2 z/OS, Python, Jupyter Notebooks etc...

The userids and passwords that you will be using are
* IBMUSER (SYS1) - a z/OS superuser with limitless powers ;-)
* AIDBADM (AIDBADM) - the SQLDI administrator userid

The z/OS system is pre-installed with
* z/OS V2.5
* Db2 z/OS V13 
* SQL Data Insights feature of Db2 z/OS V13
* Watson Machine Learning for z/OS V2.4

Db2 z/OS V13 will be started already. It's connection details are
* Subsystem ID = DBDG
* DRDA Location Name = DALLASD
* TCPIP hostname = wg31.washington.ibm.com
* DRDA Port = 5045

The outline of the Lab Exercises in the rest of this document is as follows 

3. Using Opensource Data Science Tools with IBM Z Data Sources
4. Using Db2 z/OS SQL Data Insights to support the data wrangling process
5. Developing and Training a Model
6. Deploying the Model to Watson Machine Learning for z/OS
7. Calling the Model from CICS for realtime scoring of CICS transactions
8. Calling the Model from anywhere using REST APIs
9. Developing AI scoring services with SQL Data Insights


## 3. Using Opensource Data Science Tools with IBM Z Data Sources

## 4. Using Db2 z/OS SQL Data Insights to support the data wrangling process

## 5. Developing and Training a Model

## 6. Deploying the Model to Watson Machine Learning for z/OS

## 7.Calling the Model from CICS for realtime scoring of CICS transactions

## 8.Calling the Model from anywhere using REST APIs

## 9.Developing AI scoring services with SQL Data Insights

## 10. Review the AI lifecycle support available on IBM Z



