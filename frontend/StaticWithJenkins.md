## Static Deploy with Jenkins

This job deploys static projects in the desired server, only works with static web pages. For further information reach @jresendiz27.

### Deploy

* Go to: [Jenkins](https://ci.getmore.mx) and Log in using your account.
* Enter to the Job called `Static-Deploy`.
* Click on `Build with parameters`
![GitHub Logo](http://storage2.static.itmages.com/i/17/1026/h_1509054148_9324129_c1ba19031d.png)
* Fill all the parameters! *Read the extra information below each text input*
![GitHub Logo](http://storage7.static.itmages.com/i/17/1026/h_1509054344_7964986_75254aa755.png)
* Check the `Console output`.
![image](http://storage2.static.itmages.com/i/17/1026/h_1509054567_1178098_cf372e95e7.png)
* Wait for the project to finish.
![image](http://storage6.static.itmages.com/i/17/1026/h_1509054784_5368519_35e44d2db4.png)
* Smile and be happy!

### Things to consider

* The gh-pages branch *MUST* contain a file called `project-<PROJECT_NAME>` in the root of the project. This file will configure the nginx virtual server information, follow the example in this [file](https://github.com/BlickLabs/DevOps/blob/master/resources/frontend-server). Don't forget to change or add the domains required.
* The `deploy` task in gulp, must copy the nginx file, check `rer` repository or reach @soycamis for further information.
* **'Cause we're paranoid, always open a `ssh` connection to the production server you will deploy, and log in as root, in case something starts a fire, using that connection will help us to fix the issue!!** 
> To open an ssh connection: 
```bash
ssh -i <KEY_FILE>.pem ubuntu@<SERVER_URL>.getmore.mx -o ServerAliveInterval=60
```
Inside the server, log in as root:
```bash
sudo su 
```
_**Don't close the connection until the site is successfully deployed!**_
