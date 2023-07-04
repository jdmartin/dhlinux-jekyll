---
layout: default
title: Nginx Setup
parent: Web Servers
---
<h5>Page Last Updated: {{ page.last_modified_at | date: '%Y %B %d' }}</h5>
<br>

**N.B.** This page is awaiting a revamp as of July '23.

## Notes on Nginx Setup

First Steps
-----------

Installing Nginx (pronounced "engine-X") is pretty straightforward. Assuming we don't need to set any unusual configuration options, the Debian package is the easiest way to get started. To do this:

-   sudo apt-get install nginx

Having done that, let's make sure we have backup copies of our configuration files in case something goes wrong:

    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

    #Or, for a fancier version that preserves the date as part of the filename:
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.$(date "+%b_%d_%Y_%H.%M.%S")

Nginx Configuration
-------------------

While this section is developed, there is an excellent guide for nginx on Debian Jessie [here](https://www.linode.com/docs/websites/nginx/how-to-configure-nginx).

Setting up for PHP and MySQL/MariaDB support
--------------------------------------------

Nginx is lightweight and modular. As such, certain features that are standard on Apache need to be enabled.

Let's see some more notes on PHP and Database setup [here](https://www.linode.com/docs/guides/how-to-install-the-lemp-stack-on-debian-10/).

Optimizing for Speed
--------------------

Nginx is pretty fast, but we can always do better. Let's look at [this guide](https://www.linode.com/docs/websites/nginx/configure-nginx-for-optimized-performance).