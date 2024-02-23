---
layout: default
title: MariaDB/MySQL Setup
parent: Databases
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>

## Notes on MariaDB Setup

Installing MariaDB
------------------

-   sudo apt-get update
-   sudo apt-get install mariadb-server
-   cp /etc/mysql/my.cnf ~/my.cnf.backup (Always good to have a backup of the base config... just in case!)

Configure MariaDB and Setup MariaDB Databases
---------------------------------------------

After installing MySQL, it’s recommended that you run `mysql_secure_installation`, a program that helps secure MySQL. While running `mysql_secure_installation`, you will be presented with the opportunity to change the MySQL root password, remove anonymous user accounts, disable root logins outside of localhost, and remove test databases. It is recommended that you answer “yes” to these options. If you are prompted to reload the privilege tables, select “yes.” Run the following command to execute the program:

-   sudo mysql\_secure\_installation

Next, you can create a database and grant your users permissions to use databases. First, log in to MariaDB:

-   mysql -u root -p

Enter MariaDB’s root password, and you’ll be presented with a prompt where you can issue SQL statements to interact with the database.

To create a database and grant your users permissions on it, issue the following command. Note that the semicolons (;) at the end of the lines are crucial for ending the commands. Your command should look like this:

```
create database testdb;
grant all on testdb.* to 'test_user' identified by 'test';
```

In the example above, testdb is the name of the database, test\_user is the username, and test is the password. 

**This is not a good password. This is for testing, and you should remove this account when you're sure everything works!** 

A better version might be:
```
create database testdb;
GRANT ALL PRIVILEGES ON testdb.* TO 'test_user'@'localhost' IDENTIFIED BY '9d63c3b5b7623d1fa3dc7fd1547313b9546c6d0fbbb6773a420613b7a17995c8';
```

In this, we have created a password by passing a text string "This is a test" to shasum:
```
 echo "This is a test" | shasum -a 256
```

Note: It's helpful to put a space before the command so that it's not logged in history. You could also use a tool like [this one from Bitwarden](https://bitwarden.com/password-generator/) or [Use a Passphrase](https://www.useapassphrase.com/) to generate a password for you.

Also note that database usernames and passwords are only used by scripts connecting to the database, and that database user account names need not (and perhaps should not) represent actual user accounts on the system.

With that completed, you’ve successfully configured MariaDB, and you may now pass these database credentials on to your users or applications. To exit the MariaDB database administration utility issue the following command:

-   quit

Next Steps
----------

With Apache and MariaDB installed, let’s install PHP: [Notes on PHP Setup](/tutorials/Languages/Notes-on-PHP-Setup)
