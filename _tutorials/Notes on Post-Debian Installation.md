---
layout: default
title: Post-Debian Installation
parent: Tutorials and Setup Guides
last_modified_date: 2021-03-02 16:12:00 -0800
---

## Notes on Post-Debian Installation

**Some things to do shortly after installing Debian:**

Securing
--------

### First 5 Minutes

-   Make sure you're up-to-date and that your box is starting from a clean installation by running the following:

<!-- -->

    su (to become root)
    apt-get update && apt-get upgrade

-   We don't want to remain root if it can be avoided, so let's install the useful sudo tool. Here's how:

<!-- -->

    su
    nano /etc/apt/sources.list
    (insert a # to comment out the line near the top that refers to your .iso.  This will force apt to pull the latest releases from your network mirror.)
    save and exit nano

    apt-get update && apt-get upgrade
    apt-get install sudo

    adduser {your username here} sudo
    exit
    su - {your username here}

Congrats! Your user account now has the ability to issue sudo commands as needed.

### Firewall:

There are two options:
For the simplest firewall,

-   From within GNOME, open the Synaptic Package Manager by heading to Activities and searching for it.
-   Find gufw, and mark it for installation.
    -   Choose Apply
    -   Once done, you can close Synaptic.
-   Once installed, enter 'sudo gufw' into your terminal'
-   Unlock gufw, enable it, and make sure all incoming is blocked. All outgoing may be allowed.
-   At this point, you may add any ports you might need by clicking the + at the bottom. (e.g. 80 for HTTP traffic, 443 for HTTPS, etc.) (Hint: You can switch from 'Application' to 'Service' to make a generic rule for a given port...)

For a more hands-on method (and one that allows deeper [Fail2ban](Fail2ban "wikilink") integration, I recommend using an iptables-based firewall. (Details on setting that up are here: [iptables](iptables "wikilink"))

Intrusion Detection and Mitigation
----------------------------------

### Install Fail2ban

Fail2ban is a wonderful tool that automatically parses your logs and prevents malicious servers and humans from accessing your server.

Installation is very simple:

    sudo apt-get install fail2ban

We'll look at some customization options in the article on [Fail2ban](Fail2ban "wikilink").

-   [Useful Guide for Debian 7... still works!](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-debian-7)

### Securing SSH

Unless you have an insane death wish, or you hate Freedom, you're going to access your server via [SSH](SSH "wikilink")/[SFTP](SFTP "wikilink"). With some basic steps, we can make sure that this process is so secure that even the NSA will weep bitter tears.

By default, password authentication is used to connect to your server via SSH. A cryptographic key-pair is more secure because a private key takes the place of a password, which is generally much more difficult to brute-force. In this section we’ll create a key-pair and configure the server to not accept passwords for SSH logins.

#### Create an Authentication Key-pair

I recommend following the instructions in [this guide](https://www.linode.com/docs/security/securing-your-server#create-an-authentication-key-pair) for creating and uploading your key-pair. Just replace the word "Linode" with "server" when you read it. ;)

#### Editing the SSH Daemon Configuration

Now that our keys are safely uploaded, let's open up the configuration file for the SSH daemon:

    sudo nano /etc/ssh/sshd_config

There are a lot of options here. I'm going to ignore a bunch, but here are the things that I change:

    # What ports, IPs and protocols we listen for
    Port 979 (Whatever you choose, make sure it's open in your firewall!)
    # Use these options to restrict which interfaces/protocols sshd will bind to
    #ListenAddress ::
    #ListenAddress 0.0.0.0
    Protocol 2
    # HostKeys for protocol version 2
    HostKey /etc/ssh/ssh_host_rsa_key
    HostKey /etc/ssh/ssh_host_dsa_key
    #Use only high-grade ciphers for key exchange and session encryption
    KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com

    #Privilege Separation is turned on for security
    UsePrivilegeSeparation sandbox
    AllowUsers {{names of users that need to login only - NOT ROOT}}
    AddressFamily inet {{ipv4 connections only.}}

    # Authentication:
    LoginGraceTime 30
    PermitRootLogin no

    # Change to no to disable tunnelled clear text passwords
    PasswordAuthentication no

    X11Forwarding no
    X11DisplayOffset 10
    PrintMotd no
    PrintLastLog no
    TCPKeepAlive yes
    KeepAlive yes
    ClientAliveInterval 60
    ClientAliveCountMax 5

    # Set this to 'yes' to enable PAM authentication, account processing,
    # and session processing. If this is enabled, PAM authentication will
    # be allowed through the ChallengeResponseAuthentication and
    # PasswordAuthentication.  Depending on your PAM configuration,
    # PAM authentication via ChallengeResponseAuthentication may bypass
    # the setting of "PermitRootLogin without-password".
    # If you just want the PAM account and session checks to run without
    # PAM authentication, then enable this but set PasswordAuthentication
    # and ChallengeResponseAuthentication to 'no'.
    UsePAM no

Ok, cool. It's time to restart SSH and see that everything works. Please note that your current session shouldn't disconnect. In fact, you should try logging in again in a separate tab, rather than exiting and re-entering. This helps to avoid being locked out in the event that something went awry. ;) So, with that in mind:

    sudo systemctl restart sshd

Now, can we login in a new tab? If it works, we'll get a message about accepting keys (possibly). Hopefully, you're now looking at:

    $

Package Management
------------------

-   You should make a point of using 'sudo apt-get update && sudo apt-get upgrade' at least once a day. This will ensure your box is safe and up-to-date.

That said, you may want to look into running the unattended upgrades package. As the name would suggest, this automates the process of updating your machine. To do this:

-   1.  apt-get install unattended-upgrades
-   1.  nano /etc/apt/apt.conf.d/10periodic

You'll want to make sure your options look like these:

    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";

With that accomplished, it's time to edit another file:

-   1.  nano /etc/apt/apt.conf.d/50unattended-upgrades

You're free to edit this file as suits your needs. (You may want it to e-mail you the results, for instance.) The key bit is:

    Unattended-Upgrade::Origins-Pattern {
            // Codename based matching:
            // This will follow the migration of a release through different
            // archives (e.g. from testing to stable and later oldstable).
          "o=Debian,n=jessie";
    //      "o=Debian,n=jessie-updates";
    //      "o=Debian,n=jessie-proposed-updates";
          "o=Debian,n=jessie,l=Debian-Security";

The above will ensure that all of your stable packages are up-to-date, and that any security patches are installed.

Want a real adventure?
----------------------

-   sudo apt-get install bsdgames
-   adventure

External Links
--------------

-   [Things to do after installing Debian Jessie](http://www.dailylinuxnews.com/blog/2014/09/things-to-do-after-installing-debian-jessie/)
-   [Notes on using APT](https://www.debian.org/doc/manuals/debian-faq/ch-uptodate.en.html)
-   [Notes on Checkrestart and Needrestart](https://gehrcke.de/2014/06/good-to-know-checkrestart-from-debian-goodies/)
-   [Scheduling tasks with crontab](http://code.tutsplus.com/tutorials/scheduling-tasks-with-cron-jobs--net-8800)
-   [Linode Guide to SysAdmin Basics](https://www.linode.com/docs/tools-reference/linux-system-administration-basics)
-   [How to Use Wget and Curl to download files](http://www.thegeekstuff.com/2012/07/wget-curl/)
-   [Using tar to (de)compress files](http://www.linfo.org/tar.html)