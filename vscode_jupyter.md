# Setting up Jupyter Notebooks in VSCODE

Vision is Worked Examples as storyboards in Jupyter Notebooks. 
Like a Jupyter version of George Baklarz's db2demo.

Jupyter Notebooks will have

* Intro
* Explanatory Text and Supporting Images
* Executable code
* All woven into an interactive self-paced storyline.

VSCODE is chosen as the vehicle for Jupyter, because it will also be central to devops.

Install Anaconda
anaconda prompt:
conda install ipykernel 

code.visualstudio.com
download & install
open extensions ( left bar boxes ) search for python (microsoft) install

View - command pallette
create new jupyter notebook


conda --version

conda env list

conda create --name cw01

conda activate cw01

conda env list 




 
VSCODE
choose env = cw01 (Python 3.11.3)

pip install ipython-sql==0.4.1

pip install ibm_db

pip install sqlalchemy==1.4.47

pip install ibm_db_sa

import sys,os,os.path
os.environ['IBM_DB_HOME']='C:\Program Files\IBM\SQLLIB'

import ibm_db
import ibm_db_sa
import sqlalchemy
%load_ext sql

%sql ibm_db_sa://db2admin:l0nep1ne@localhost:50000/SAMPLE
%sql select * from q.org

