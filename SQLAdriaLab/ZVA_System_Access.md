# ZVA System Access 


## ZVA Summary 

ZVA is cloud-provisioned demonstration service, using WAZI for the z/OS images.
The diagram below illustrates the nature of ZVA, and how to access it.

![zva](/aizimages/access_zva.jpg)

In order to use the ZVA Environment you should have veen issued with the following information

1. A userid and password for logging on to IBM Cloud (which opens a VPN into the ZVA Systems subnet).
2. A TCPIP Address for the Windows Client that you will access to perform the HOL exercises
3. A Windows Useid and Password to logon to the Windows Client
4. The TCPIP Address of the z/OS system that you will be accessing from the Windows Client.


## Step 1: Connect to IBM CLoud

Open a Web Browser to the following address

https://www.ibm.com/cloud/vpn-access

Logon with the userid and password that you have been assigned.


## Step 2: Open an RDP session into the ZVA Windows Image

Once the VPN tunnel is created, open an RDP session to the IP Address of your ZVA image.
( e.g. 10.148.150.44 )

Connect using the following Authentication Credentials.

User in Windows: ~\Administrator
Password: ?????????????

## Step 3: Connect to z/OS using PCOMM and Putty

The Windows Client has Program Icons for the two applications this HOL will use
1.PCOMM ( 3270 Emulator )
2.Putty ( ssh terminal to USS )


Putty should connect to wg31.washington.ibm.com 

PCOMM should connect to wg31.washington.ibm.com 

Spark Web GUI URL will be http://wg31.washington.ibm.com:8080

SQLDI Web GUI URL will be https://wg31.washington.ibm.com:15001



![rdp_session](/aizimages/rdp_session.jpg)


  