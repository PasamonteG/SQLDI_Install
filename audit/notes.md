# Build Notes

## ZCX Port PD


https://towardsdatascience.com/how-to-run-jupyter-notebook-on-docker-7c9748ed209f 



## Ben's ZPDT Image with ZCX 

```
ZCX
Download Ben's Image

IPL
Edit USER.Z25C.TCPPARMS ( 192.168.1.171 z/OS 192.168.1.172 DVIPA )

S GLZ,JOBNAME=ZCXBT01,CONF='/global/zcx/instances/ZCXBT01/start.json' 

ssh ibmuser@192.168.1.171

su - ZCXADM1

ssh admin@192.168.1.172 -p 8022

docker run hello-world 
```

Performance

* Devmap -3 CPUs and No zIIPs
* 30 mins IPL at Max CPU 
* ZCX 10 - 15 mins high CPU
* Settles down to ~ 30% CPU


Accessing containers from IBM


https://ibm.github.io/ibm-z-oss-hub/main/main.html 

Get from IBM Could Account, your apikey.json login file
```
{
	"name": "zvazcx",
	"description": "API Key for access to IBM Z and Linux One Container Registry",
	"createdAt": "2023-02-12T21:10+0000",
	"apikey": "GDbj5_GqG8h0IFcgTXPxs-l5A41RWn60EAkUH_saIEpM"
}
```


Logon to ZCX

```
ssh ibmuser@192.168.1.171 -p 65522 

su - ZCXADM1 
PWD SYS1 

ssh admin@192.168.1.172 -p 8022


> docker login -u iamapikey icr.io
Password:             <-Paste the text of your apikey here
Login Succeeded

> docker pull icr.io/ibmz/kafka@sha256:4419e017475e4082f8a03574f2b74195a689650c3f1ed8962874783e3dd4bf4a

Notes for Jupyter-notebook 
docker run --rm -it -p 8888:8888 icr.io/ibmz/jupyter-notebook:6.4.5

Mapping ports - like I did in CDC Kafka
docker run -idt -v cdcvol:/cdcinstance/ -p 11701:11701 zcdckafka 


docker run --rm -d -p 9080:8888 icr.io/ibmz/jupyter-notebook:6.4.12   


docker ps -a 

docker images 

docker rm ****

docker stop **** 


admin@S0W1-ZCXBT01:~$ docker run --rm -it -p 8888:8888 icr.io/ibmz/jupyter-notebook:6.4.5
Unable to find image 'icr.io/ibmz/jupyter-notebook:6.4.5' locally
6.4.5: Pulling from ibmz/jupyter-notebook
3cf1497b05fd: Pull complete
7668e4250dea: Pull complete
75c1ec87b783: Pull complete
686ef0793758: Pull complete
c82b3159ebd1: Pull complete
598280b39250: Pull complete
239d65a3902d: Pull complete
8d7f866e4276: Pull complete
1096179d4c9f: Pull complete
b036dda467ae: Pull complete
411b8ef9cb63: Pull complete
Digest: sha256:1a2835af7c850455e52a6f53b9e83a53d4864ee4f5ff17bad3596e37698b2452
Status: Downloaded newer image for icr.io/ibmz/jupyter-notebook:6.4.5
[I 21:28:28.980 NotebookApp] Writing notebook server cookie secret to /home/jovyan/.local/share/jupyter/runtime/notebook_cookie_secret
[I 21:28:34.148 NotebookApp] Serving notebooks from local directory: /
[I 21:28:34.149 NotebookApp] Jupyter Notebook 6.4.5 is running at:
[I 21:28:34.150 NotebookApp] http://localhost:8888/?token=c187ccb3ef0711c08be33a98b47922fdad17532ada3e83ca
[I 21:28:34.151 NotebookApp]  or http://127.0.0.1:8888/?token=c187ccb3ef0711c08be33a98b47922fdad17532ada3e83ca
[I 21:28:34.152 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 21:28:34.262 NotebookApp] No web browser found: could not locate runnable browser.
[C 21:28:34.271 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-7-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=c187ccb3ef0711c08be33a98b47922fdad17532ada3e83ca
     or http://127.0.0.1:8888/?token=c187ccb3ef0711c08be33a98b47922fdad17532ada3e83ca  
     
     
```

## SQLDI V12 TP 

Mount a ZFS at /u/ibmuser/CODE 

Upload the Goodies
```
fasttcp.sh
ethtool -K enp88s0 rx off
ethtool -K enp88s0 gso off
ethtool -K enp88s0 gro off
ethtool -K enp88s0 rxvlan off
ethtool -K enp88s0 txvlan off


ftp 192.168.1.171
binary

put aie_4-20-22.pax /u/ibmuser/CODE/aie_4-20-22.pax
put sql-data-insights.pax /u/ibmuser/CODE/sql-data-insights.pax

quote site lrecl=80 recfm=FB
quote site cyl
quote site primary=10
quote site secondary=10
cd 'SQLDI'
put AIDB0211.IMAGE.AIDBDBRM.SEQ
put AIDB0211.IMAGE.AIDBLOAD.SEQ
put AIDBSAMP.SEQ
quit

TSO 6
RECEIVE inda('SQLDI.AIDB0211.IMAGE.AIDBDBRM.SEQ')
DA('IBMUSER.SDIV12.AIDBDBRM')
RECEIVE INDA('SQLDI.AIDB0211.IMAGE.AIDBLOAD.SEQ')
DA('IBMUSER.SDIV12.AIDBLOAD')
RECEIVE inda('SQLDI.AIDBSAMP.SEQ')
DA('IBMUSER.SDIV12.AIDBSAMP')

```

## SQLDI V13 

Create SMPE CSI for the FMID HDBDD18


```
IBMUSER.NEALEJCL(SMPALA)
IBMUSER.NEALEJCL(SMPALB)

-> SDIV13.SMP**
-> SDIV13.GLOBAL.CSI 

SQL Data Insights installs in the DBS (P115) SREL

Pre-Requisites

5698-DB2 IBM Db2 13 for z/OS plus APAR PH45358

5650-ZOS z/OS 2.4 or 2.5, with z/OS Supervisor APAR OA62728

5655-DGH IBM 64-bit SDK for z/OS Java Technology Edition Version 8 SR7, FP11 or higher

Any one of the following:
5650-ZOS z/OS 2.4 with APARs OA62489, OA62886 and OA62887 (for IBM Z Deep Neural Network
Library, including IBM Z AI Optimization Library and IBM Z AI Data Embedding Library)

5650-ZOS z/OS 2.5 with APARs OA62901, OA62902 and OA62903 (for IBM Z Deep Neural Network
Library, including IBM Z AI Optimization Library and IBM Z AI Data Embedding Library)

```

Transfer the CBPDO to ZFS

```
C:\000\7312889728_000010_PROD>pscp -P 65522 -r * ibmuser@192.168.1.171:/u/ibmuser/smpe/STP63159
```

Unpack the RIMLIB

```
//IBMUSERJ JOB  (FB3),'RIMLIB EXTR',CLASS=A,MSGCLASS=H,               
//             NOTIFY=&SYSUID,MSGLEVEL=(1,1)                          
//********************************************************************
//*                                                                  *
//* UNPACK SAMPLE JOBS FOR SQLDIV13                                  *
//*                                                                  *
//********************************************************************
//UNZIP    EXEC PGM=GIMUNZIP,REGION=0M,PARM='HASH=NO'                 
//SYSUT3   DD UNIT=SYSALLDA,SPACE=(CYL,(5,1))                         
//SYSUT4   DD UNIT=SYSALLDA,SPACE=(CYL,(5,1))                         
//SMPJHOME DD PATH='/usr/lpp/java/J7.1'                               
//SMPCPATH DD PATH='/usr/lpp/smp/classes/'                            
//SMPOUT   DD SYSOUT=*                                                
//SYSPRINT DD SYSOUT=*                                                
//SMPDIR   DD PATH='/u/ibmuser/smpe/STP63159/SMPRELF',                
//            PATHDISP=KEEP                                           
//SYSIN    DD *                                                       
<GIMUNZIP>                                                            
<ARCHDEF                                                              
name="CBCACHE.IBM.HDBDD18.F1.pax.Z"                                   
volume="USER0A"                                                       
newname="IBMUSER.SDIV13.RIMLIB">                                      
</ARCHDEF>                                                            
</GIMUNZIP>                                                           
/*                                                                    
```

SMP Receive Process

```
RCVPDO


```


## ZCX deploy containers 

### Basic Access 

Commands to get into ZCX & Containers

```
ssh ibmuser@192.168.1.171

su - ZCXADM1

ssh admin@192.168.1.172 -p 8022

docker run hello-world 
```

Commands to operate ZCX & Containers

```
docker ps -a

docker images

docker stop <imageid>

docker rmi <imageid> 
```

Commands to get inside a container and do stuff.

```
docker exec –it <cont_id> /bin/bash
```

Commands to move data between the outside world, USS, ZCX and a container.

```

git clone <blah blah ... IBM Z Australia Github>
- brings stuff to /global/tensorflow

Now move from USS ZFS to ZCX with sshd
Ensure SSHD is running on port 22 rather than 65522
edit /etc/ssh/sshd_config

logged on as zcxadm1 ( with the .ssh subdirectory and keys )

sftp -P 8022 admin@192.168.1.172

cd /home/admin/tensorflow
lcd /global/tensorflow
put -r *

Finally use docker cp commands to copy into an actove container

docker run -d --name jupytercpy -v tfmodels:/models:rw -p 8888:8888 e7b441088e73 --ip=0.0.0.0 --allow-root

docker cp /home/admin/tensorflow/tensorflow_serving/servables/tensorflow/testdata jupytercpy:/models

```


### Useful URLs 

IBM ICR page for Tensorflow

https://ibm.github.io/ibm-z-oss-hub/containers/tensorflow-serving.html

Tensorflow Website

https://github.com/tensorflow/serving

Andrew Sica Guide 

https://ibm.github.io/ai-on-z-101/ai-on-z-samples/tf-zcx-zos/




### Accessing containers from the IBM Z & LinuxONE COntainer Registry.

Must be logged on the IBM Cloud


ssh from USS (as zcxadm1) into ZCX 
```
ssh admin@192.168.1.172 -p 8022
```

Perform login
```
> docker login -u iamapikey icr.io
Password:             <-Paste the text of your apikey here
Login Succeeded

GDbj5_GqG8h0IFcgTXPxs-l5A41RWn60EAkUH_saIEpM 
```

### Jupyter-notebook container

IBM Registry
```
https://ibm.github.io/ibm-z-oss-hub/containers/index.html

https://ibm.github.io/ibm-z-oss-hub/containers/jupyter-notebook.html

docker pull icr.io/ibmz/jupyter-notebook@sha256:1a2835af7c850455e52a6f53b9e83a53d4864ee4f5ff17bad3596e37698b2452
	
6.4.5 works ; v7.0.0a definitely does not.
```

If you pull the container - you can refer to the image_id ( e7b441088e73 ; 9d29acbb437e ) in the docker run command.
```
docker run -it --name jupyter172 -v jupyter-data:/home/notebooks:rw -e NBDIR=/home/notebooks -p 8888:8888 9d29acbb437e --ip=0.0.0.0 --allow-root
```

and then open browser pointing at the container (using the token spat out by the docker run command output).

```
http://192.168.1.172:8888/tree?token=f1e2a6f1e1dafc732e92fab59d11457522c2a8360b3f9d4e
```


### Tensorflow Serving container

IBM Registry
```
https://ibm.github.io/ibm-z-oss-hub/containers/index.html

[https://ibm.github.io/ibm-z-oss-hub/containers/jupyter-notebook.html](https://ibm.github.io/ibm-z-oss-hub/containers/tensorflow-serving.html)

docker pull icr.io/ibmz/tensorflow-serving@sha256:d232a0532342a29ed49d9cd61957793af07da6e8fba4d4c1da808124bb5909b7
	
working with v2.4.0
```

download for this container is sloooow ( ~ 600 MB )


Prepping the container. Both IBM and Tensorflow docco show cloning the sample models to the container hosting platform, and referencing that as a mounted disk volume. However, I had already copied the samples repository to a volume ( tfmodels ). So I am trying to modify the supplied docker run command to reference that. Whether it succeeds or not, I will attempt the example method afterwards.

Planned Execution

```
docker run -it --rm -p 8501:8501 -v tfmodels:/models/saved_model_half_plus_two_cpu -e MODEL_NAME=half_plus_two 27d0d64d5b2a &

curl -d '{"instances": [1.0, 2.0, 5.0]}' -X POST http://192.168.1.172:8501/v1/models/half_plus_two:predict

Returns => { "predictions": [2.5, 3.0, 4.5] }
```

Alternate Execution

```
TESTDATA="/home/admin/tensorflow/tensorflow_serving/servables/tensorflow/"

docker run -it --rm -p 8501:8501 -v "$TESTDATA/saved_model_half_plus_two_cpu:/models/half_plus_two" -e MODEL_NAME=half_plus_two <image_id> &

curl -d '{"instances": [1.0, 2.0, 5.0]}' -X POST http://192.168.1.172:8501/v1/models/half_plus_two:predict

Returns => { "predictions": [2.5, 3.0, 4.5] }
```

Actual Result : Auth error

```
admin@S0W1-ZCXBT01:~$ echo $TESTDATA
/home/admin/tensorflow_serving/servables/tensorflow/testdata
admin@S0W1-ZCXBT01:~$ docker run -it --rm -p 8501:8501 -v "$TESTDATA/saved_model_half_plus_two_cpu:/models/half_plus_two" -e MODEL_NAME=half_plus_two 27d0d64d5b2a
docker: Error response from daemon: authorization denied by plugin zcxauthplugin: Request to bind mount the path '/home/admin/tensorflow_serving/servables/tensorflow/testdata/saved_model_half_plus_two_cpu' with rw mode is disabled for Docker running on IBM zCX appliance instance.
See 'docker run --help'.

chmod 777 ***/tensorflow
same authentication failure.
```

