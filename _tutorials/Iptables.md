---
layout: default
title: Iptables
---

## Iptables

[iptables](http://www.netfilter.org/projects/iptables/index.html) is used for packet filtering and NAT, and is a standard part of modern Linux firewalling. It is an alternative to UFW and PF, which do the same work in different ways. Let's look at how to get started.

Installation
------------

iptables comes in both ipv4 and ipv6 flavors. Let's begin with ipv4.

The tools necessary to create a firewall with iptables are already installed on your Debian box. So, begin by creating a file to house your rules.

    sudo touch /etc/iptables.rules

Using iptables
--------------

While iptables rules can be added and removed from the command line (more on that [here](https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands)), it's often easier to keep your ruleset in a file that can be loaded as needed.

So, let's open the file you just created:

    sudo nano /etc/iptables.rules

Here's mine for reference. Use the comments to decide what rules are useful to you. Your needs/ports may vary, but here's some of what I use for speed and security.

    *filter

    #Allow all loopback (lo) traffic and reject anything to localhost that does not originate from lo.
    -A INPUT -i lo -j ACCEPT
    -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT
    -A OUTPUT -o lo -j ACCEPT

    #Accept all established inbound connections
    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    #Allow all outbound traffic - you can modify this to only allow certain traffic
    -A OUTPUT -j ACCEPT

    #Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL).
    -A INPUT -p tcp --dport 80 -j ACCEPT
    -A INPUT -p tcp --dport 443 -j ACCEPT

    #Prevent Ping Floods
    -A INPUT -p icmp -m limit --limit 6/s --limit-burst 1 -j ACCEPT
    -A INPUT -p icmp -j DROP

    #Drop Pings
    -A OUTPUT -p icmp -o eth0 -j ACCEPT
    -A INPUT -p icmp --icmp-type echo-reply -s 0/0 -i eth0 -j ACCEPT
    -A INPUT -p icmp --icmp-type destination-unreachable -s 0/0 -i eth0 -j ACCEPT
    -A INPUT -p icmp --icmp-type time-exceeded -s 0/0 -i eth0 -j ACCEPT
    -A INPUT -p icmp -i eth0 -j DROP

    #Accept notifications of unreachable hosts
    -A INPUT -p icmp -m icmp --icmp-type destination-unreachable -j ACCEPT

    #Force SYN Packets Check
    -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

    #Drop NULL Packets
    -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

    #Allow SSH connections (note that I've changed my port from the default!)
    -A INPUT -p tcp -m state --state NEW --dport 979 -j ACCEPT

    #Allow Fastcgi Calls on 9000 (Again, this port is configured during setup!)
    -I INPUT 1 -p tcp --dport 9000 -s localhost -j ACCEPT

    #(if running your own caching DNS server!) DNS Caching
    -I INPUT 1 -p tcp --dport 53 -s localhost -j ACCEPT

    #Silently drop ports 445 and 995
    -A INPUT -p tcp --dport 995 -j REJECT
    -A INPUT -p tcp --dport 445 -j REJECT

    #Log iptables denied calls
    -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

    #Drop all other inbound - default deny unless explicitly allowed policy
    -A INPUT -j DROP
    -A FORWARD -j DROP

    COMMIT

Once you've got your iptables.rules file the way you want it, go ahead and activate those rules:

    sudo iptables-restore < /etc/iptables.rules

    #If you're using fail2ban, you'll need to restart it here:
    sudo /etc/init.d/fail2ban restart

    #Then, to confirm that your rules are working:
    sudo iptables -L -n

Final Steps
-----------

Of course, these rules aren't very useful if they aren't loaded when you reboot your server. Let's make sure they are by adding a command to load them to your machine's boot process:

    su
    nano /etc/network/if-pre-up.d/firewall

Now, add these lines to your file and save:

    #!/bin/sh
    /sbin/iptables-restore < /etc/iptables.rules

That's it!

See also:
---------

[Guide to setting up ip6tables](https://www.digitalocean.com/community/tutorials/how-to-implement-a-basic-firewall-template-with-iptables-on-ubuntu-14-04)