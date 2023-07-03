---
layout: default
title: Cron
parent: Administration
---
<h5>Page Last Updated: {{ page.last_modified_at | date: '%Y %B %d' }}</h5>
<br>

## Cron

The Cron daemon allows you to schedule programs to run at regular intervals. This can be useful for backing up, checking uptime, or any number of things. Options are stored in your crontab file. To view the contents of your crontab, enter:

    crontab -l

    #N.B. You can also view root's crontab:
    sudo crontab -l

Yours is likely empty save for some comments on cron usage. To edit that file:

    crontab -e

    #Again, you can edit root's with:
    sudo crontab -e

Here's a sample crontab file from my server:

    # m h  dom mon dow   command
    01 03 * * *  /opt/spamtraining.sh > /var/log/sa-learn.log 2>&1
    40 03 * * *  find /var/backups/mysql/* -mtime +7 -exec rm {} \;
    01 04 * * *  /opt/expireoldspam.sh
    45 04 * * 0,3  /opt/mc_back.sh
    15 05 * * 0,3  find /var/games/backups/* -mtime +5 -exec rm {} \;

It's important to note that time in crontab is given in the format minute, hour, day of month, month, day of week. You can supply numbers or wildcards (\*) for all of these.

-   Day of week is a little unusual, in that the options are 0-7. This is because both 0 and 7 are both recognized as Sunday.
-   Note, you can also have multiple selections for any of these options (as in the last two lines of the example above). Simply separate your choices by a comma.

Given all that, let's break down one line from the above:

    01 04 * * *  /opt/expireoldspam.sh

This executes a script "expireoldspam.sh" at 04:01 on every day of every month.

(Yes, it is redundant to have every day and every day of the week selected. Regardless, Cron wants you to supply all five options. You can also say something like 01 04 \* \* 2 which will execute only on Tuesdays at 04:01.)

See also:
---------

- [Digital Ocean's Guide on Cron](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-on-a-vps)
- [Crontab Guru - For easy scheduling](https://crontab.guru/)