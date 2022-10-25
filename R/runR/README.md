# **run.R**

> Is a R script to help develop R scripts for long run analysys or make  sripts more easily reproducible.

1. **run.R** # Features
   - automate some tasks while you need to run _**R scripts**_
     - create a standard [Project Oriented Folder Structure](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/) with folders :
       - _**~/bin**_    # folder used to put some executables that you could call from script
       - _**~/lib**_    # required packages which are not system available will be installed in this folder
       - _**~/input**   #  put all your input data in this folder, create your own subfolders as needed
       - _**~/output**_ # put all of yours resuls in this folder, create your own subfolders as needed
    - save the resulting output to a _**scriptname**_**.pdf**
    - could send the pdf results to a email # need setup a **scriptname.ini** file with yours desired settings
    - show how much time was used to run your script

### How to use?

#### Basic

- copy 'run.R' to a ease to access folder.
- copy example.ini to **your R Project folder**
- rename example.ini to your **scriptname.ini** and adjust it to your needs
  ***warn*** : 'scriptname' means the name of your script ex: climate-analisys.r
- from your R Project folder do:
    > Rscript --vanilla run.R myscript.r

#### Remote Login using ssh ! Linux (Nix) ou Windows

```bash
ssh user@myhost
```

##### from remote shell # Linux do

> Note: you could add path to run.R or/and your r script

```bash
cd projectfolder
nohup Rscript --vanilla run.R myscript.r
exit
```

#### from remote shell # Windows

- create a _**.bat**_ scriptask ex: proj01.bat like this:

```bat
rem Used to Rum my analisys as windows task
rem You could add othet commands here, like: del output/*.*
rem ex: cd \projects\proj01\
Rscript --vanilla run.R myscript.r
```

- then run this 'proj01.bat' as windows ex:

```bat
schtasks /create /SC ONCE  /TN proj01 /TR \users\myuser\projects\proj01\project-script01.bat /ST <HH:MM>
```

> <<HH:MM>> horas e minutos pra iniciar.

#### Advanced - Using **Docker**
1. First you need to have docker installed in your system

2. copy run.R to your project folder
  
=>  **From you project folder do**

```bash
docker run -d --name mydockerprojname -v $(pwd):/mnt r-base:4.2.1 Rscript --vanilla run.R myscript.r
```

> Note: You can use the same command remotely logged (ssh)  and logout without end process, since "-d" parameter make process stayrunning. If perhaps machine restart you just need call: "docker start mydockerprojname"
