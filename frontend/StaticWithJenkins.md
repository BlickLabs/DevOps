## Frontend Projects

For this projects we use a [layout](https://github.com/BlickLabs/generator-frontend-dev) designed by 
[@AlanSanchezP](https://github.com/AlanSanchezP), all the information about the use of the layout is in the project Readme

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

* The gh-pages branch  *MUST* contains a file called `project-<PROJECT_NAME>`. This file will contain the nginx virtual server information, follow the example in this [file](https://github.com/BlickLabs/DevOps/blob/master/resources/frontend-server). Don't forget to change or add the domains required.
* The `deploy` task in gulp, must copy the nginx file, check `rer` repository or reach @soycamis for further information.

