---
layout: default
title: Apache Setup
parent: Web Servers
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>

**N.B.** This page is awaiting a revamp as of July '23.

## Notes on Apache Setup

First Steps:
------------

We’ll need something to test with later on. Let’s 'sudo apt-get install lynx.'

Lynx is a beautiful old browser. You’ll love it. Unless you’re a graphic designer, in which case it hates you, and you it.

-   Do apt-get update and upgrade
-   sudo apt-get install apache2
-   A lot of applications use apache’s ‘rewrite’ capability. Let’s make sure that’s on: sudo a2enmod rewrite
-   Restart in the manner it asks, but use sudo!

Initial Configuration
---------------------

Now, we have to setup our hosts file so that our sites are registered properly with Apache (in these examples, I have chosen the hostname test.dev):

-   sudo nano /etc/hosts (You should see something like this)
```
127.0.0.1       localhost
127.0.1.1       test.dev
127.0.1.1       test.test.dev   test
```
Now, let’s configure that server to play nicely with our machine.

-   Go ahead and use sudo nano to open /etc/apache2/apache2.conf - This is a file you won’t have permissions to...
-   Scroll down to the bottom of the file. Add a line of blank space, then this: (Note: **BE SUPER CAREFUL WITH WHITESPACE!**)

    ```
    # User Customization
    <IfModule mpm_prefork_module>
        StartServers 2
        MinSpareServers 6
        MaxSpareServers 12
        MaxClients 30
        MaxRequestsPerChild 3000
    </IfModule>
    ```
-   Save, open terminal, sudo service apache2 restart

Setup a Virtual Host
--------------------

Ok, now, let’s go ahead and disable the default site and setup one of our own.

-   a2dissite 000-default.conf
-   restart apache

Now, we’re going to need a place to put our files... Let’s use /var/www/test.dev/public\_html (mkdir -p to make a chain of dirs) - We’ll have to make that directory, as it doesn't exist by default. Let's also make /var/www/test.dev/logs

Now, let’s make /etc/apache2/sites-available/test.conf

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName test.dev
    ServerAlias www.test.dev
    DocumentRoot /var/www/test.dev/public_html
    ErrorLog /var/www/test.dev/logs/error.log
    CustomLog /var/www/test.dev/logs/access.log combined
</VirtualHost>
```
-   Now, you're ready to enable your site.
    -   sudo a2ensite test.conf (This step takes the name of your conf file as an argument.)
    -   restart apache

See also:
---------

-   [PHP](/docs/PHP)
-   [MariaDB](/docs/MySQL)
