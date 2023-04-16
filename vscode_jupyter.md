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
3. Setup conda environments
4. Install VSCODE
5. Install VSCODE extension (python)
6. Create New Jupyter Notebook
7. installs, imports and constructs to access Db2

***Note*** 
* The youtube video below covers the basic flow of running Jupyter in VSCODE
* The correct mix of commands to work with Db2 are my own notes

[youtube video](https://www.youtube.com/watch?v=h1sAzPojKMg)

## 1. Install Anaconda

Install Anaconda from here [anaconda download](https://www.anaconda.com/)

## 2. Install ipykernel (Jupyter kernel)

Open the anaonda prompt:

![Anaonda_Prompt_Start](/vscodeimages/anaconda_prompt.JPG)

from the anaconda prompt, install the Jupyter kernel

```
conda install ipykernel 
```

## 3. Setup conda environments

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

![condaenvlist](/vscodeimages/condaenvlist.JPG)


## 4. Install VSCODE

Get code from [code.visualstudio.com](code.visualstudio.com)

download & install

Start the VSCODE IDE.


## 5. Install VSCODE extension (python)

open extensions ( boxes icon in the left side bar ) search for python (microsoft) 

![installpython](/vscodeimages/installpython.JPG)

Press the blue "install button" if it isn't already installed.


## 6. Create New Jupyter Notebook

Open the command palette ("View" + "command pallette") 

![commandpalette](/vscodeimages/commandpalette.JPG)

and create new jupyter notebook 

![createnewjupyternotebook](/vscodeimages/createnewjupyternotebook.JPG)

Then start adding sections of "markdown" documentation and "python" code blocks to build your notebook.

## 7. installs, imports and constructs to access Db2

First up, create a coda environment for this particular use case. (we created "cw01" in step 3 above). 
This environment will start with base python only, and we will have to install and import ***only*** the libraries that we want, and at the specific version we want.

***Note:*** at time of writing these notes the ibm_db_sa library was incompatible with the then current versions of ipython-sql and sqlalchemy. 
This will probably be fixed by the time these notes are read, but the example below shows how to install specific versions of libraries into your conda environment.

The screenshot below shows how to "Select Kernel" to be used 

![selectenv](/vscodeimages/selectenv.JPG)

After changing kernels, or installing new libraries, it is sometimes necessary to restart the kernel. 
Also it is frequently helpful to clear all outputs, so that the notebook can be started afresh.
The screenshot below shows the location of these controls.

![restart](/vscodeimages/restart.JPG)

 
A Notebook to query Db2 ( either DB2 LUW or Db2 z/OS ) needs four libraries to be installed.

```
pip install ipython-sql==0.4.1

pip install ibm_db

pip install sqlalchemy==1.4.47

pip install ibm_db_sa
```

Next, the 'IBM_DB_HOME' environment variable needs to be set, so that the ibm_db and ibm_db_sa libraries can find the db2 code to establish a connection to Db2. 
Note that in this case, a Db2 server product is installed, and the database drivers are found in the ```C:\Program Files\IBM\SQLLIB``` path. However, if your system only has the Db2 client or driver installed, the path will depend on where you installed it.
```
import sys,os,os.path
os.environ['IBM_DB_HOME']='C:\Program Files\IBM\SQLLIB'
```
Now, we can import the libraries.

```
import ibm_db
import ibm_db_sa
import sqlalchemy
```

And we can load the ipython-sql extension that allows SQL Magic to happen. (SQL Magic is just elegant SQL coding and result set formatting to make embedding SQL in Jupyter notebooks to be efficient, elegant and pleasing.

```
%load_ext sql
```

Finally, we can use the %sql and %%sql commands to perform SQL connect, select and all other SQL verbs.

```
%sql ibm_db_sa://db2admin:l0nep1ne@localhost:50000/SAMPLE 

%sql select * from q.org
```

![sql1](/vscodeimages/sql1.JPG)

%sql only allows for a single statement to be executed, while the %%sql allows a block of SQL to be executed

![sql2](/vscodeimages/sql2.JPG)

To learn more about using db2magic, please check out the [db2magic documentation](https://ibm.github.io/db2-jupyter/linevscell/))

That's it!
