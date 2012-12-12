From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 23:43:40 +0300
Message-ID: <7A92569A-D56B-45B0-9305-EBC2EDF90913@dubeyko.com>
References: <20121212145116.GE3064@wloczykij> <20121212145454.GF3064@wloczykij> <20121212161054.GG3064@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=L6Hcf/Jf4zJX3HXI0w7IcZnRX2sMQNAW1kJs1KAo1WM=;
	b=EUybvBuToeeW2EUYB06JVTtNGT/oadagZ8KjO4h4qmIFGg4Ud6PXCSB71LsUsnfpqxJ+3Lq2O+beb97FpU52d0Hyzb3SylNnzkYWebTuXxwO9jydn5X0dMu+iW13v15P;
In-Reply-To: <20121212161054.GG3064@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Dec 12, 2012, at 7:10 PM, Piotr Szymaniak wrote:

> On Wed, Dec 12, 2012 at 03:54:55PM +0100, Piotr Szymaniak wrote:
>> On Wed, Dec 12, 2012 at 03:51:16PM +0100, Piotr Szymaniak wrote:
>>> Hello,
>>> 
>>> I got a power failure today and after power restore there's a weird
>>> issue with nilfs_cleanerd:
>>> 
>>> wloczykij ~ # ll /dev/sda3
>>> brw-rw---- 1 root disk 8, 3 Dec 12 08:35 /dev/sda3
>>> 
>>> wloczykij ~ # mount | grep nilfs
>>> /dev/root on / type nilfs2 (rw,relatime)
>>> /dev/mapper/backup on /mnt/home_backup type nilfs2 (rw,gcpid=2995)
>>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=5333)
>>> 
>>> But when I try to run the cleaner:

Sorry, I slightly confused. As I understand, mount output shows that you have mounted /dev/sda3 with started nilfs_cleanerd (gcpid=5333). Why do you try to start nilfs_cleanerd by hands? Or I misunderstand something?

As I can see from strace, there is such error message:

futex(0xbff37f24, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, b7547940) = -1 EAGAIN (Resource temporarily unavailable)

I think that it is the reason of failing nilfs_cleanerd start.

Maybe, do you have working or failed nilfs_cleanerd for /dev/sda3 in background? Do you have any NILFS2-related messages in system log?

With the best regards,
Vyacheslav Dubeyko.


>>> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: start
>>> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot open nilfs on
>>> /dev/sda3: No such file or directory
>>> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot create cleanerd
>>> on /dev/sda3: No such file or directory
>>> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: shutdown
>>> 
>>> Never happend before. Shutdown should be nice (got UPS monitored by
>>> apcupsd, so I hope it worked - was in the middle of the night, so can't
>>> really tell if was superclean shutdown).
>> 
>> I should also notice, that other cleaner of different drive is working
>> without issues:
>> wloczykij ~ # ps aux | grep nilfs
>> root      2995  0.0  0.0   2348   808 ?        Ss   12:19   0:00
>> /sbin/nilfs_cleanerd -n /dev/mapper/backup /mnt/backup
> 
> Sorry for answering my own msg again.
> 
> Attached strace output.
> 
> 
> Piotr Szymaniak.
> -- 
> Gdzie  w  tym  logika? Po co w ogole sie rodzic,  jesli jedyne,  co cie
> czeka u kresu tego wszystkiego, to smierc?
>  -- Graham Masterton, "The Burning"
> <strace-nilfs_cleanerd.dontexist.out>

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
