From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Cache Churn
Date: Tue, 23 Aug 2011 14:38:49 +0900 (JST)
Message-ID: <20110823.143849.52186207.ryusuke@osrg.net>
References: <09449c6acbe526ffa056cf4b7d005032@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <09449c6acbe526ffa056cf4b7d005032-tp2ajI7sM87MEvS+BUbURm2TqnkC6wfpXqFh9Ls21Oc@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 10 Aug 2011 12:17:45 +0100, Gordan Bobic wrote:
>  Another performance related problem I am seeing due to nilfs_cleanerd 
>  is that it causes unhealthy amounts of cache churn. It's reads and 
>  writes are buffered, which inevitably means that things it reads will 
>  get cached. Since it is going through all the blocks on the fs that have 
>  any garbage to collect, it will eat through all the available memory 
>  pretty quickly. It also means that it will push out of caches things 
>  that really should stay in caches.

Interesting report.  nilfs_cleanerd only reads log header and does not
read payload blocks.  Data blocks are instead read and copied by the
nilfs kernel code, and they are freed every time reclamation call of a
few segments has ended.

I guess the abnormal cache churn arose from other causes, seems that
DAT file access is suspicious.  (The DAT file holds metadata used to
convert virtual block addresses to real disk block addresses).

>  Since cleanerd's actual disk I/O is going to have no correlation with 
>  actual file access pattern, is there a way to make cleanerd always 
>  operate with something like the O_DIRECT flag so that is's reads won't 
>  fill up the page cache?

If the problem comes from internal metadata accesses like the DAT file
access, O_DIRECT is not applicable.

>  This is a pretty serious problem on small machines running of cheap 
>  flash (think ARM machines with 512MB of RAM and slow flash media).
> 
>  The quick and dirty workaround I am pondering at the moment is to set 
>  up a cron job that runs once/minute, checks df, and starts/kills 
>  nilfs_cleanerd depending on how much free space is available, but that's 
>  not really a solution.
> 
>  Gordan

Does your kernel version equal to or newer than v2.6.37 ?

Last year, we changed cache usage for the DAT file on that kernel.
This might influence the issue.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
