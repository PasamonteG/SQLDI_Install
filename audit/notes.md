# Build Notes

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

## SQLDI V12 TP 



