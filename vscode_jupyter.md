# Setting up Jupyter Notebooks in VSCODE

Vision is Worked Examples as storyboards in Jupyter Notebooks. 
Like a Jupyter version of George Baklarz's db2demo.

Jupyter Notebooks will have

* Intro
* Explanatory Text and Supporting Images
* Executable code
* All woven into an interactive self-paced storyline.

VSCODE is chosen as the vehicle for Jupyter, because it will also be central to devops.

Contents
1. Install Anaconda
2. Install ipykernel (Jupyter kernel)
3. Install VSCODE
4. Install VSCODE extension (python)
5. Create New Jupyter Notebook
6. installs, imports and constructs to access Db2

***Note*** 
* The youtube video below covers the basic flow of running Jupyter in VSCODE
* The correct mix of commands to work with Db2 are my own notes

[youtube video](https://www.youtube.com/watch?v=h1sAzPojKMg)

## 1. Install Anaconda

Install Anaconda
[anaconda download](https://www.anaconda.com/)

Open the anaonda prompt
![Anaonda_Prompt_Start](/vscodeimages/anaconda_prompt.JPG)

from the anaconda prompt, install the Jupyter kernel

```
conda install ipykernel 
```

## 2. Setup conda environments

You want to create different environments, with different library imports for different purposes. 
The sequences of commands below lists the existing environments, creates a new one (cw01), and activates it.

```
conda --version

conda env list

conda create --name cw01

conda activate cw01

conda env list 
```

Note: after re-booting your PC, the environment slips back to base

~[condaenvlist](/vscodeimages/condaenvlist.JPG)


## 2. Install ipykernel (Jupyter kernel)

## 3. Install VSCODE

## 4. Install VSCODE extension (python)


## 5. Create New Jupyter Notebook


## 6. installs, imports and constructs to access Db2



code.visualstudio.com
download & install
open extensions ( left bar boxes ) search for python (microsoft) install

View - command pallette
create new jupyter notebook






 
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

