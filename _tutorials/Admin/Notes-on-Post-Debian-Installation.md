---
layout: default
title: Post-Debian Installation
parent: Administration
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>

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

    su (if not already root)
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

For a more hands-on method (and one that allows deeper [Fail2ban](/tutorials/Server%20Security/Fail2ban/ "wikilink") integration, I recommend using an iptables-based firewall. (Details on setting that up are here: [iptables](/tutorials/Server%20Security/Iptables "wikilink"))

Intrusion Detection and Mitigation
----------------------------------

### Install Fail2ban

Fail2ban is a wonderful tool that automatically parses your logs and prevents malicious servers and humans from accessing your server.

Installation is very simple:

    sudo apt-get install fail2ban

We'll look at some customization options in the article on [Fail2ban](/tutorials/Server%20Security/Fail2ban "wikilink").

-   [Useful Guide for Debian 7... still works!](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-debian-7)

### Securing SSH

Unless you have a strong desire to have your server broken into, you're going to access your server via SSH/SFTP. With some basic steps, we can make sure that this process is so secure that even the NSA will weep bitter tears.

By default, password authentication is used to connect to your server via SSH. A cryptographic key-pair is more secure because a private key takes the place of a password, which is generally much more difficult to brute-force. In this section we’ll create a key-pair and configure the server to not accept passwords for SSH logins.

#### Create an Authentication Key-pair

I recommend following the instructions in [this guide](https://www.linode.com/docs/security/securing-your-server#create-an-authentication-key-pair) for creating and uploading your key-pair. Just replace the word "Linode" with "server" when you read it. ;)

#### Editing the SSH Daemon Configuration

Now that our keys are safely uploaded, let's open up the configuration file for the SSH daemon:

    sudo nano /etc/ssh/sshd_config

There are a lot of options here. I'm going to ignore a bunch, but here are the things that I change:

    Include /etc/ssh/sshd_config.d/*.conf

    # What ports, IPs and protocols we listen for
    Port 22

    # Use these options to restrict which protocols sshd will use
    Protocol 2

    # Supported HostKey algorithms by order of preference.
    HostKey /etc/ssh/ssh_host_ed25519_key
    #HostKey /etc/ssh/ssh_host_rsa_key
    #HostKey /etc/ssh/ssh_host_ecdsa_key

    KexAlgorithms curve25519-sha256@libssh.org
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com

    AllowUsers alice bob charlie (**just replace these with the users on your system that need access**)
    #AddressFamily inet

    KbdInteractiveAuthentication no

    # Lifetime and size of ephemeral version 1 server key
    #KeyRegenerationInterval 3600
    #ServerKeyBits 4096
    #UseRoaming no

    # Logging
    SyslogFacility AUTH
    LogLevel INFO

    # Authentication:
    LoginGraceTime 30
    PermitRootLogin prohibit-password (**or set to no**)
    StrictModes yes

    #RSAAuthentication yes
    PubkeyAuthentication yes
    AuthorizedKeysFile	.ssh/authorized_keys

    # Don't read the user's ~/.rhosts and ~/.shosts files
    IgnoreRhosts yes
    # For this to work you will also need host keys in /etc/ssh_known_hosts
    #RhostsRSAAuthentication no
    # similar for protocol version 2
    HostbasedAuthentication no
    # Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
    #IgnoreUserKnownHosts yes

    # To enable empty passwords, change to yes (NOT RECOMMENDED)
    PermitEmptyPasswords no

    # Change to yes to enable challenge-response passwords (beware issues with some PAM modules and threads)
    ChallengeResponseAuthentication no

    # Change to no to disable tunnelled clear text passwords
    PasswordAuthentication no

    # Kerberos options
    KerberosAuthentication no
    #KerberosGetAFSToken no
    #KerberosOrLocalPasswd yes
    #KerberosTicketCleanup yes

    # GSSAPI options
    GSSAPIAuthentication no
    #GSSAPICleanupCredentials yes

    X11Forwarding no
    X11DisplayOffset 10
    PrintMotd yes
    PrintLastLog no
    TCPKeepAlive no
    ClientAliveInterval 60
    ClientAliveCountMax 5
    AllowTcpForwarding no
    MaxAuthTries 3
    MaxSessions 8
    PermitUserRC no
    PermitUserEnvironment no
    UseDNS no
    #Compression no
    #UseLogin no
    #KeepAlive yes

    #MaxStartups 10:30:60
    #Banner /etc/issue.net

    # Allow client to pass locale environment variables
    #AcceptEnv LANG LC_*

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

    AcceptEnv LANG LC_*
    # override default of no subsystems
    Subsystem	sftp	/usr/lib/openssh/sftp-server

Ok, cool. It's time to restart SSH and see that everything works. Please note that your current session shouldn't disconnect. In fact, you should try logging in again in a separate tab, rather than exiting and re-entering. This helps to avoid being locked out in the event that something went awry. ;) So, with that in mind:

    sudo systemctl restart sshd

Now, can we login in a new tab? If it works, we'll get a message about accepting keys (possibly). Hopefully, you're now looking at:

    $

Package Management
------------------

-   You should make a point of using 'sudo apt-get update && sudo apt-get upgrade' at least once a day. This will ensure your box is safe and up-to-date.

That said, you may want to look into running the unattended-upgrades package. As the name would suggest, this automates the process of updating your machine. To do this:

-   1.  apt-get install unattended-upgrades

With that accomplished, it's time to edit another file:

-   1.  nano /etc/apt/apt.conf.d/50unattended-upgrades

You're free to edit this file as suits your needs. (You may want it to e-mail you the results, for instance.) The key bit is:

    Unattended-Upgrade::Origins-Pattern {
            // Codename based matching:
            // This will follow the migration of a release through different
            // archives (e.g. from testing to stable and later oldstable).
            //      "origin=Debian,codename=${distro_codename}-updates";
            //      "origin=Debian,codename=${distro_codename}-proposed-updates";
            "origin=Debian,codename=${distro_codename},label=Debian";
            "origin=Debian,codename=${distro_codename},label=Debian-Security";
            "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";

The above will ensure that all of your stable packages are up-to-date, and that any security patches are installed. You may have good reason to wait on stable packages, but consider whether there's a benefit to delaying security patches.  Also, look through the rest of that file to find options to handle automatic reboots or reloads!

External Links
--------------

-   [Things to do after installing Debian Jessie](http://www.dailylinuxnews.com/blog/2014/09/things-to-do-after-installing-debian-jessie/)
-   [Notes on using APT](https://www.debian.org/doc/manuals/debian-faq/ch-uptodate.en.html)
-   [Notes on Checkrestart and Needrestart](https://gehrcke.de/2014/06/good-to-know-checkrestart-from-debian-goodies/)
-   [Scheduling tasks with crontab](http://code.tutsplus.com/tutorials/scheduling-tasks-with-cron-jobs--net-8800)
-   [Linode Guide to SysAdmin Basics](https://www.linode.com/docs/tools-reference/linux-system-administration-basics)
-   [How to Use Wget and Curl to download files](http://www.thegeekstuff.com/2012/07/wget-curl/)
-   [Using tar to (de)compress files](http://www.linfo.org/tar.html)
