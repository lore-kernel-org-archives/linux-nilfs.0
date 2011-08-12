From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: More on =?UTF-8?Q?nilfs=5Fcleanerd=20and=20excessive=20writes=20?=
 =?UTF-8?Q?=28=31=20month=20flash=20card=20life=20expetancy=29?=
Date: Fri, 12 Aug 2011 11:38:18 +0100
Message-ID: <87e2dc262f71d35a8fe5e0983fc1b7e6@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 I just did some basic measuring and it looks like the total writes by 
 nilfs_cleanerd on my SD card total about 1GB/minute (16MB/second, all my 
 card can handle). Since the system is used all the time while it is on, 
 that involves there always being things that need to be garbage 
 collected, so it runs all the time. Even assuming it performance isn't 
 an issue (running at nice 19 and ionice -c3, and performance IS an 
 issue), that still means that the SD card will get 1,440GB of writes/day 
 (1,4TB!). It's a 32GB MLC flash card, so assuming a 5,000 erase cycle 
 life of 32nm MLC (ignoring any inevitable write amplification), that 
 gives life expectancy of 160TB, or at the given rate of nilfs_cleanerd 
 churn, about 12 days of usage. Call it a month with the assumption the 
 machine isn't used all day every day.

 This is quite thoroughly unacceptable for usage on any flash media. 
 Ignoring any other optimizations that might be applicable (e.g. smaller 
 block size to minimize the number of blocks that have to be re-written), 
 my immediate redneck solution is running this every minute as a cron 
 job:


 ==========
 #!/bin/bash

 # Substitute /dev/mmcblk1p4 for your nilfs partition
 used=`df | grep /dev/mmcblk1p4 | awk '{ print $5; }' | sed -e 's/%//'`

 # If disk usage is more than 90%...
 if [ $used -gt 90 ]; then
     # If nilfs_cleanerd is not running...
     if (! pgrep nilfs_cleanerd > /dev/null ); then
         nohup nice -n 19 ionice -c 3 /sbin/nilfs_cleanerd > /dev/null 
 2>&1 &
     fi
 # If disk usage is less than 90%...
 elif [ $used -lt 80 ]; then
     pkill nilfs_cleanerd > /dev/null 2>&1
 fi
 ==========

 This could of course be improved and "enterpriseified" further, e.g. 
 check for all nilfs partitions and do the checks on all of them, make 
 the free space amount thresholds based on 1/3 and 2/3 of free space (fs 
 size - du), but this problem shouldn't really be looking for a solution 
 in a cron job.

 It's not ideal and nilfs_cleanerd should be configurable to moderate 
 itself in a similar way, but until that happens, I don't see any 
 alternative to the above cron job. The write performance is fantastic 
 for tasks that do a lot of writing, but the life expectancy issue is a 
 very real one.

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
