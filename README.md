#AMControl

##Description

With this small Mac OS X (10.9, 10.10) App you can start and stopp the Mac OSX-builtin Apache and MySql Servers.
It is like a tiny version of the XAMPP Control without additional software and overloaded stuff.

This is how the App looks in Mavericks.

![Mac OSX App to control apache, mysql](https://raw.githubusercontent.com/lh84/AMControl/master/githubAMControl.png "App")

---

At the moment there is no possibility to change the paths to the server applications.
The command  `apachectl`will be used to start and stop Apache webserver and `/usr/local/opt/mysql/bin/mysql.server ` is used to start MySQL server. 

If you want to use the app you have to compile it with xcode or you can download this repo as zip file, extract it and put the AMP Control.app to your Applications folder.

### TODO

If you have any ideas just let me know or open a ticket [here](https://github.com/lh84/AMControl/issues/new).

### License

Open Source under MIT License

