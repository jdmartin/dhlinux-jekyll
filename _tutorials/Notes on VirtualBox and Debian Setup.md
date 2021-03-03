---
layout: default
title: VirtualBox and Debian Setup
parent: Tutorials and Setup Guides
last_modified_date: 2021-03-02 15:58:00 -0800
---

## Notes on VirtualBox and Debian Setup

Installing / Updating:

`    VirtualBox: `[`https://www.virtualbox.org/wiki/Downloads`](https://www.virtualbox.org/wiki/Downloads)

Make sure to grab the Extension Pack, too!

`    Debian: `[`Download` `the` `latest` `stable`](https://www.debian.org/CD/http-ftp/)` (For 64-bit computers, get the amd64.  For 32-bit, i386.)`

Just grab the .iso for DVD1. It should have everything you need, and anything else can be pulled down from inside Debian.

Getting Started:
----------------

-   Install Virtualbox, along with its extension pack, and then open it.
    -   Select New, Give it a name, Select Linux, Other Linux 64-bit. (Other Linux 64 has much better performance than Debian option. WTF?)
        -   Make sure to choose Other Linux 32-bit, if you're using a 32-bit machine.
    -   Default RAM is ok, but I like 2GB. (I’ve got a 16GB machine.) (Let’s say 1/4 RAM as guideline for cap, but always leave at least 1GB for host OS.)
    -   Create a virtual HD is fine on defaults, but you do have the option to choose formats that might work with Parallels or VMWare.
    -   Size choice is down to preference.
        -   I usually choose 'dynamic,' but I have an SSD so speed is less of a problem.
        -   That said, there's a speed hit on dynamic. So, if you don't have an SSD, or you feel the need to eke out every yoctosecond (10<sup>-24</sup>), choose fixed.
    -   Size limit is 8GB by default. I expanded to 12GB. Go for at least 8.

Setting up the VirtualBox environment
-------------------------------------

-   Single-click your new Linux install in Virtualbox, and then click Settings.
-   Add a processor at some point (Settings / System / Processor) - Let’s say “half” available, with two at a minimum.
-   Add video memory (Settings / Display) if planning to use GUI (max it)
-   Check in (Settings / network / advanced settings) to ensure you are using the Paravirtualized Network (virtio-net) otherwise VirtualBox will be emulating the hardware, which makes both molasses and turtles seem speedy.
-   Click OK once you're done with making changes to Settings.

Setting up Debian
-----------------

-   Single-click select your Linux machine in Virtualbox, and click Start.
-   On select virtual HD, browse for the Debian iso, then press start.
-   Choose Install for the traditional method (that's what I'll follow here.)
    -   Pick your language (I'll be proceeding in English) <b>Note: Pressing enter during this process will automatically choose and advance. If a screen has multiple options, use space to toggle</b>
    -   Set your location
    -   Set your keyboard
    -   Set a hostname. For this course, I'm choosing "dhsi" (<b>N.B.</b> Ignore the quotation marks in this instruction sheet, unless I tell you not to.)
    -   For your domain, you can leave it blank (if it's a workstation and not a server). For this course, I'm choosing "dhsi.dev" (We'll set that up later...)
    -   Now, the root user. You should use a password manager to generate a strong password. <b>However,</b> in this course, every password is "dhsi" (Shh, don't tell anyone...)
        -   After root, create a user called "dhsi" with a password "dhsi"
    -   Pick a time zone
    -   For the disk partition, we'll use the "Guided - use entire disk" option. If you want disk encryption, it's "Guided - use entire disk and set up encrypted LVM." Keep it simple, for now, and we'll talk.
        -   Choose the only disk available. ;)
        -   All files in one partition.
        -   Finish and write changes. (It'll ask you to confirm. Do so.)
    -   No need to scan another CD or DVD, so choose "no."
    -   Yes, use a mirror for packages. Pick whatever’s closest to you. (At home, I use MIT’s csail)
        -   No need for a proxy.
    -   The survey is up to you. It's anonymous (for reals), and just indicates what packages are used on what kind of hardware.
    -   Use space on the services page: Add GNOME (if you desire a graphical desktop, you can run without, but it's easier for our class), remove Printer, add ssh server, hit enter
    -   Install the GRUB boot loader.
        -   Choose /dev/sda
    -   Hit continue

Your first boot
---------------

-   Login to your desktop
-   Click activities, and type "terminal" into the search box. (I like to right-click it and add to favorites for easy access later.)
    -   Open a terminal
        -   If you're like me, you like a dark theme. (Edit / Preferences / Use dark theme variant)

Ok, now...

### Making VirtualBox Less Ugly

-   Type 'su' and give the root password to become root.
-   Let's fix a small thing that could be annoying once we delete / remove that installer .iso
    -   Type 'nano /etc/apt/sources.list' and hit enter
    -   At the start of the line that begins "deb cdrom" insert a '\#' so it reads '\#deb cdrom'
    -   Press (ctrl + x) and then 'y' and enter to save and exit.
-   Ok, now let's get ready to make things less ugly by running this: apt-get install build-essential module-assistant
    -   Confirm and watch many lines appear from the aether.
-   Still as root: m-a prepare
    -   Confirm and see even more lines scroll by at ludicrous speed!
-   Now, in Virtualbox, click Devices &gt; Install Guest Additions in virtualbox window to mount the guest addition image. (Mounts to /media/cdrom0)
    -   Choose 'Cancel' when a box pops up in GNOME.
-   Back in the terminal, run 'sh /media/cdrom0/VBoxLinuxAdditions.run' (If this won't work, Reboot, because VirtualBox reasons, and then try again.)

Now, reboot (in terminal: 'reboot', or click the triangle in the top right of GNOME and choose 'Restart' from the power icon.)

-   -   Hopefully enjoy a nicer desktop. (Just drag the virtualbox window to resize it. The desktop should fill the available space.)

<Category:Setup>