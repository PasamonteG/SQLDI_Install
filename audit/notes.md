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


## ZCX deploy containers 




