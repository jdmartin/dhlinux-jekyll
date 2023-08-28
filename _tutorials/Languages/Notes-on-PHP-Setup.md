---
layout: default
title: PHP Setup
parent: Languages
nav_order: 2
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>

## Notes on PHP Setup

First Step
----------

Let's get PHP installed:

-   sudo apt-get install php8.2 php-pear

Configuring PHP
---------------

Let’s use 'sudo nano' to take a look in /etc/php/8.2/apache2/php.ini

**N.B.** If you're using this with nginx, or something else, you may want to edit /etc/php/8.2/fpm/php.ini or /etc/php/8.2/cli/php.ini instead.

We want to find and ensure that the following configuration defaults are correctly installed:

```
max_execution_time = 30
memory_limit = 128M
display_errors = Off 
log_errors = On
error_log = /var/log/php/error.log
register_globals = Off <-- May not exist.  That's a good thing.
```

You will need to create the log directory for PHP and give the Apache user ownership:

-   sudo mkdir /var/log/php
-   sudo chown www-data /var/log/php

Preparing the Environment
-------------------------

If you need support for MySQL in PHP, then you must install the php5-mysql package with the following command:

-   sudo apt-get install php8.2-mysql

After making changes to the PHP configuration file, restart Apache by issuing the following command:

-   sudo service apache2 restart

Testing the Install
-------------------

With this completed, PHP should be fully functional. Create /var/www/test.dev/public\_html/index.php (N.B. I'm assuming your hostname is test.dev. Change as needed.)

```
<?php
       echo '<h1>Hello World</h1>';
?>
```

-   Use Firefox to load <http://test/index.php>

Using PHP By Default
--------------------

Suppose we wanted to change the default index for our site. Here’s how:

-   Let’s cd to /var/www/test.conf/public\_html
-   sudo nano .htaccess
-   DirectoryIndex index.php (Can be whatever)
-   Save, exit, sudo chown www-data:www-data .htaccess

<!-- -->

-   Now, let’s sudo nano /etc/apache2/apache2.conf
-   Use CTRL+W to find '&lt;Directory /var/www'
-   Entry should look like:

<!-- -->

    <Directory /var/www/>
         Options Indexes FollowSymLinks MultiViews
         AllowOverride Indexes
         Require all granted
    </Directory>

-   sudo service apache2 reload
-   Use Firefox to visit <http://test>
-   Now, use Firefox to visit <http://test/index.html>

Ta-da!