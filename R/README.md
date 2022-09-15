# Some useful R scripts and tips

1. **run.R** # no interative R script run
   - automate some tasks while you need to run ___R scripts___
     - create a standard [Project Oriented Folder Structure](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/) with folders :
       - ___~/bin___    # folder used to put some executables that you could call from script
       - ___~/lib___    # required packages which are not system available will be installed in this folder
       - ___~/data___   #  put all your input data in this folder, create your own subfolders as needed
       - ___~/output___ # put all of yours resuls in this folder, create your own subfolders as needed
    - save the resulting output to a ___scriptname___**.pdf** 
    - could send the pdf results to a email # need setup a ___scriptname___**.ini** file with yours desired settings
    - show how much time was used to run your script

### How to use? 
#### Basic
- copy 'run.R' to a ease to access folder. 
- copy example.ini to **your R Project folder**
- rename example.ini to your **scriptname.ini** and change it to your needs 
  ___warn___: 'scriptname' means the name of your script ex: climate-analisys.r
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
- create a ___.bat___ scriptask ex: proj01.bat like this:
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

#### Advanced ** Nix systems - Linux, BSD, Mac, or (WSL on Windows not covered here)
> Using __Docker__  ## First you need to have docker installed in your system

- copy run.R to your project folder
  
=>  **From you project folder do**

```bash
docker run -d --name mydockerprojname -v $(pwd):/mnt r-base:4.2.1 Rscript --vanilla run.R myscript.r
```
> Note: You can use the same command remotely logged (ssh)  and logout without end process, since "-d" parameter make process stayrunning. If perhaps machine restart you just need call: "docker start mydockerprojname"

  