From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Cache Churn
Date: Wed, 10 Aug 2011 12:17:45 +0100
Message-ID: <09449c6acbe526ffa056cf4b7d005032@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 Another performance related problem I am seeing due to nilfs_cleanerd 
 is that it causes unhealthy amounts of cache churn. It's reads and 
 writes are buffered, which inevitably means that things it reads will 
 get cached. Since it is going through all the blocks on the fs that have 
 any garbage to collect, it will eat through all the available memory 
 pretty quickly. It also means that it will push out of caches things 
 that really should stay in caches.

 Since cleanerd's actual disk I/O is going to have no correlation with 
 actual file access pattern, is there a way to make cleanerd always 
 operate with something like the O_DIRECT flag so that is's reads won't 
 fill up the page cache?

 This is a pretty serious problem on small machines running of cheap 
 flash (think ARM machines with 512MB of RAM and slow flash media).

 The quick and dirty workaround I am pondering at the moment is to set 
 up a cron job that runs once/minute, checks df, and starts/kills 
 nilfs_cleanerd depending on how much free space is available, but that's 
 not really a solution.

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
