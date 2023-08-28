---
layout: default
title: QuickStart
nav_order: 1
has_children: false
---
_Page Last Updated: {{ page.date | date: '%Y %B %d' }}_
<br>
## Ten-Minute QuickStart Guide

Hey, friend.  If you're here, I'm assuming you want to build a secure server quickly. Let's talk about the absolute basics that I undertake when installing Debian (or Debian-based linuxes).

### General Tips and Advice:
- Make sure you have documentation for any custom configuration changes you make. You'll be thankful later when you're trying to figure out why you added "this weird thing" to "this weird config file."
- Develop a backup strategy.  We'll talk about this elsewhere in the wiki, but [here](https://wiki.archlinux.org/title/Synchronization_and_backup_programs)'s a good resource to get you started.

### Steps to achieve a baseline of security:
1. Patch.  Run: `apt-get update; apt-get upgrade`
2. Turn on unattended-upgrades. (See the bottom of [this](../Admin/Notes-on-Post-Debian-Installation/) similar entry.)
3. Turn on needrestart. Run: `apt-get install needrestart`.
4. Restart if needed.
5. Turn on your firewall. (See [this entry](../Server Security/Iptables/) on iptables.)

And that's honestly it.  From here, you can start thinking about the different services you want to run, or the types of users who might need to access your system (and how to securely achieve this). For me, personally, I would recommend something like this:

- Setup [fail2ban](../Server Security/Fail2ban/).
- Install and configure my services.
- Consider something like [Tailscale](https://tailscale.com/) or [Teleport](https://goteleport.com/) so that I can close my SSH port.
- Have fun!