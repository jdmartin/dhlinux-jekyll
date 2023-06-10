---
layout: default
title: PHPMyAdmin Setup
parent: Languages
nav_order: 2
---
<h5>Page Last Updated: {{ page.last_modified_at | date: '%Y %B %d' }}</h5>
<br>

## Notes on PHPMyAdmin Setup

Installing phpMyAdmin
---------------------

Installing phpMyAdmin is a very simple process. Just:

-   sudo apt-get install phpmyadmin

Securing Our Installation
-------------------------

Unfortunately, older versions of phpMyAdmin have had serious security vulnerabilities, including allowing remote users to eventually exploit root on the underlying virtual private server. One can prevent a majority of these attacks through a simple process: locking down the entire directory with Apache's native user/password restrictions which will prevent these remote users from even attempting to exploit older versions of phpMyAdmin.

### Set Up the .htaccess File

To set this up, start off by allowing the .htaccess file to work within the phpmyadmin directory. You can accomplish this in the phpmyadmin configuration file:

-   sudo nano /etc/phpmyadmin/apache.conf

Under the directory section, add the line “AllowOverride All” under “Directory Index”, making the section look like this:

```
<Directory /usr/share/phpmyadmin>
        Options FollowSymLinks
        DirectoryIndex index.php
        AllowOverride All
        [...]
```

### Configure the .htaccess file

With the .htaccess file allowed, we can proceed to set up a native user whose login would be required to even access the phpmyadmin login page.

Start by creating the .htaccess page in the phpmyadmin directory:

-   sudo nano /usr/share/phpmyadmin/.htaccess

Follow up by setting up the user authorization within .htaccess file. Copy and paste the following text in:

```
AuthType Basic
AuthName "Restricted Files"
AuthUserFile /etc/.htpasswd
Require valid-user
```

**AuthType**: This refers to the type of authentication that will be used to the check the passwords. The passwords are checked via HTTP and the keyword Basic should not be changed. 

**AuthName**: This is text that will be displayed at the password prompt. You can put anything here. 

**AuthUserFile**: This line designates the server path to the password file (which we will create in the next step.) 

**Require valid-user**: This line tells the .htaccess file that only users defined in the password file can access the phpMyAdmin login screen. Create the htpasswd file

Now we will go ahead and create the valid user information.

### Creating the .htpasswd file

We use the htpasswd command, and place the file in a directory of your choice as long as it is not accessible from a browser. Although you can name the password file whatever you prefer (I'm using /etc/.htpasswd), the convention is to name it .htpasswd.

-   sudo htpasswd -c /path/to/passwords/.htpasswd username

A prompt will ask you to provide and confirm your password.

Once the username and passwords pair are saved you can see that the password is encrypted in the file by using cat to view it.

Finish up by restarting apache:

-   sudo service apache2 restart

Accessing phpMyAdmin
--------------------

phpMyAdmin will now be much more secure since only authorized users will be able to reach the login page. Accessing 'youripaddress/phpmyadmin' in iceweasel should display a login screen. The user/pass are the ones you just created in the .htpasswd file.

Fill it in with the username and password that you generated. After you login you can access phpMyAdmin with the **MariaDB** username and password of your choice. (N.B. You'll probably need root, or a similar super-user, to create/delete databases.)