---
layout: default
title: Projects
nav_order: 1
---
<h5>Page Last Updated: {{ page.last_modified_at | date: '%Y %B %d' }}</h5>
<br>

{: .no_toc }
<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Projects
{: .no_toc }
Here are some things you might want to try, now that you've got your Linux box up and running:


### Install A CMS / Publishing Platform
{:toc}
-   [Install Wordpress](https://codex.wordpress.org/Installing_WordPress)
-   [Install Drupal](https://www.drupal.org/docs/8/install)
-   [Install Omeka](https://omeka.org/)


### Install a Web Framework
{:toc}
-   [Install Django](https://www.djangoproject.com/)
-   [Install Ruby on Rails](http://rubyonrails.org/)
-   [Install Laravel](https://laravel.com/)

N.B. If you want to install more than one of those (and why not?), you might want to learn about how to host multiple sites that are being served by different domain names. This is where the concept of [Virtual Hosts](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-debian-8) comes in. 

If you want to try this, remember that you can make up your own names in your hosts file (this is step 5 in that previous link). I often use a name like this on my home network: someName.local. You are, of course, encouraged to be creative. :)


### Other Fun Programming Things
{:toc}
-   [Install node.js](https://nodejs.org/en/) ([Install node.js on Debian](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions) -- ask about a fun caveat...)
    -   [Try Nodeschool for all sorts of skills](https://nodeschool.io/#workshopper-list)
-   [Take the Command Line Challenge](https://cmdchallenge.com/)
-   [Why not learn more about BASH?](http://guide.bash.academy/) (You can make useful scripts for any system that runs [BASH](../../Docs/BASH). That could be Linux, Unix, Mac, or even Windows!)
-   [Another BASH tutorial](http://ryanstutorials.net/bash-scripting-tutorial/)


### Install an XML Database / Tool
{:toc}
-   [Install eXist-db](http://exist-db.org/exist/apps/homepage/index.html)
-   [Install BaseX](http://basex.org/products/download/all-downloads/) (Hint: There's an *apt* version, too.)


### Anything Else
{:toc}
There are thousands and thousands of things to try... pick any program you like and see how it works. Part of the fun of this is breaking stuff. ;)