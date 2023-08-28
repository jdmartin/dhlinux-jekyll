---
layout: default
title: Iptables
parent: Server Security
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>

## Iptables

(**N.B.** You might be on a newer system that requires nftables, click on nftables on the left-hand menu to see how to handle this.)

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
    :INPUT DROP [0:0]
    :FORWARD DROP [0:0]
    :OUTPUT ACCEPT [86:13587]
    :ICMP_IN - [0:0]
    :TCP - [0:0]
    :UDP - [0:0]
    -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    -A INPUT -i lo -j ACCEPT
    -A INPUT -d 127.0.0.0/8 ! -i lo -j REJECT --reject-with icmp-port-unreachable
    -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j TCP
    -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
    -A INPUT -p icmp -m conntrack --ctstate NEW -j ICMP_IN
    -A INPUT -m limit --limit 50/min -j LOG --log-prefix "iptables denied: " --log-level 7
    -A OUTPUT -o eth0 -p icmp -m icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
    -A ICMP_IN -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP
    -A ICMP_IN -i eth0 -p icmp -m icmp --icmp-type 0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    -A ICMP_IN -i eth0 -p icmp -m icmp --icmp-type 3 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    -A ICMP_IN -i eth0 -p icmp -m icmp --icmp-type 11 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    -A ICMP_IN -p icmp -m limit --limit 6/sec --limit-burst 1 -j ACCEPT
    -A ICMP_IN -p icmp -j LOG --log-prefix "ICMP denied: " --log-level 7
    -A ICMP_IN -p icmp -j REJECT --reject-with icmp-proto-unreachable
    -A TCP -p tcp --dport 22 -m comment --comment SSH -j ACCEPT
    -A TCP -p tcp -m multiport --dports 80,443 -m comment --comment Web -j ACCEPT
    -A TCP -p tcp -m multiport --dports 25,587,993 -m comment --comment Mail -j ACCEPT
    -A TCP -p tcp -j LOG --log-prefix "TCP denied: " --log-level 7
    -A TCP -p tcp -j REJECT --reject-with tcp-reset
    -A UDP -p udp -j LOG --log-prefix "UDP denied: " --log-level 7
    -A UDP -p udp -j REJECT --reject-with icmp-port-unreachable
    COMMIT
    
    *mangle
    :PREROUTING ACCEPT [40:2858]
    :INPUT ACCEPT [40:2858]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [86:13587]
    :POSTROUTING ACCEPT [86:13587]
    -A PREROUTING -i eth0 -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
    -A PREROUTING -i eth0 -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
    -A PREROUTING -i eth0 -m conntrack --ctstate INVALID -j DROP
    -A PREROUTING -i eth0 -f -m comment --comment "Drop Fragments" -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,RST FIN,RST -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,ACK FIN -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags ACK,URG URG -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,ACK FIN -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags PSH,ACK PSH -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,PSH,URG -j DROP
    -A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
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
    apt-get install netfilter-persistent

Follow the prompts, and your firewall should reload when you reboot.  

If this approach doesn't work, you could try:

    su
    nano /etc/network/if-pre-up.d/firewall

Now, add these lines to your file and save:

    #!/bin/sh
    /sbin/iptables-restore < /etc/iptables.rules

That's it!

See also:
---------

[Guide to setting up ip6tables](https://www.digitalocean.com/community/tutorials/how-to-implement-a-basic-firewall-template-with-iptables-on-ubuntu-14-04)