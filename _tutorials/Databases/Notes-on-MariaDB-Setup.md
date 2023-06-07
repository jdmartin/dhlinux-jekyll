---
layout: default
title: MariaDB/MySQL Setup
parent: Databases
last_modified_date: 2021-10-28 16:21:00 -0800
---

## Notes on MariaDB Setup

Installing MariaDB
------------------

-   sudo apt-get update
-   sudo apt-get install mariadb-server
-   cp /etc/mysql/my.cnf ~/my.cnf.backup (Always good to have a backup of the base config... just in case!)

Configure MariaDB and Setup MariaDB Databases
---------------------------------------------

After installing MySQL, it’s recommended that you run mysql\_secure\_installation, a program that helps secure MySQL. While running mysql\_secure\_installation, you will be presented with the opportunity to change the MySQL root password, remove anonymous user accounts, disable root logins outside of localhost, and remove test databases. It is recommended that you answer “yes” to these options. If you are prompted to reload the privilege tables, select “yes.” Run the following command to execute the program:

-   sudo mysql\_secure\_installation

Next, you can create a database and grant your users permissions to use databases. First, log in to MariaDB:

-   mysql -u root -p

Enter MariaDB’s root password, and you’ll be presented with a prompt where you can issue SQL statements to interact with the database.

To create a database and grant your users permissions on it, issue the following command. Note that the semicolons (;) at the end of the lines are crucial for ending the commands. Your command should look like this:

```
create database dhsi;
grant all on dhsi.* to 'dhsi_user' identified by 'dhsi';
```

In the example above, dhsi is the name of the database, dhsi\_user is the username, and dhsi is the password. Note that database usernames and passwords are only used by scripts connecting to the database, and that database user account names need not (and perhaps should not) represent actual user accounts on the system.

With that completed, you’ve successfully configured MariaDB, and you may now pass these database credentials on to your users or applications. To exit the MariaDB database administration utility issue the following command:

-   quit

Next Steps
----------

With Apache and MariaDB installed, let’s install PHP: [Notes on PHP Setup](../Notes-on-PHP-Setup)