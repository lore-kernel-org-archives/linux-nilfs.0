From: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Subject: Re: nilfs bad btree node and broken bmap
Date: Mon, 3 Jul 2017 16:12:46 -0300
Message-ID: <CAOdi6iZRhYa9tz=ggpCMWf=gLWAxd8KqnQ0sSV80bLGM0FCPUw@mail.gmail.com>
References: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg@mail.gmail.com>
 <22870.39764.148116.59757@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fabricadeideias-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Zn2+ld+7aDW9TYxml07O2q2PIZou4NhcNnGjT+c83SI=;
        b=MfaPQqfRIfZKdyweaOOfIvUUhq8Y5cgvTLnNuWSJX2hxVKNW/cicfcunSiPYGGNe1n
         nKUBxeHSoizWh5YEFRLThQ9jBcXu/zuQcIcxOdoeoaJ6bG5Q7sD2DOKlnrtbDf/9zzUq
         7wiXqTxbzmY7OInFaYKk21kb/vLy9WNhEWuuo1CWYfYLm58JBFtLujJKU4p/SytbhnCX
         J1073rsOfn1z0hQXUrPsNULFUq05uNxTIlK06VzU8qBzP3XtgrCq7QLwBkaZOEJCzDth
         iuHm4lNdOja1jg2sx4jKpTUJuHL087iiTL+Akgu5pa/m+xwXtWkSEcRwJYM+OQkL1JFX
         E5+g==
In-Reply-To: <22870.39764.148116.59757-HsBtKtDIwYdYO2OccljXW7VCufUGDwFn@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Iip2UmYkHbXO@public.gmane.org>
Cc: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-06-30 15:41 GMT-03:00 Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Iip2UmYkHbXO@public.gmane.org>:
>> I have a 8TG nilfs2 disk with started changing to read-only by itself.
>
> Highly unlikely.

Why you say so? Do you think I`m calling some read-only remount? I can
assure you I`m not. It`s some error detecting routine that triggers
this read-only remount.

>> My log files are full of the following error messages:
>
>> Jun 28 15:57:08 c1-df kernel: [ 1637.138168] NILFS (sdd1): bad btree node (ino=6069196, blocknr=446552325): level = 69, flags = 0x24, nchildren = 8203
>> Jun 28 15:57:08 c1-df kernel: [ 1637.139363] NILFS error (device sdd1): nilfs_bmap_lookup_contig: broken bmap (inode number=6069196)
>
> These are typical of some IO error, even a transient one, or
> more simply the outcome of a crash with not well implemented
> barriers. I notice that the errors happen with a time offset of
> "1637" seconds, that is less than 30 minutes after a reboot.

Yes, these messages appeared just about 30 minutes after I rebooted
the machine trying to see if a reboot (and consequent new mounting)
would fix the issue.

This device is auto remounted read-only very quickly after being mounted.

>> I have already checked and there are not errors on the disk.
>
> How did you check?

smartctl -t long /dev/sdX

resulted in a "No error found" report log.

>> How can I fix this?
>
> Mount earlier checkpoints until you find a "clean" one, then
> delete later "unclean" checkpoints.  If there is no earlier
> "clean" checkpoint, some IO error has damaged existing data.

While trying it, the checkpoint list suddenly got reduced from the
thousands of entries it had to less than 20 and started also to
present a few corrupted checkpoints at the beginning of the list:

# lscp /dev/sdd1
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
 9023380516061122833  172852864--1725596255-48 06:50:13   ss    i
4950690465199330146 2045974694022012474
 5296068189917196282  1778420707--1725596255-48 13:21:03   cp    -
14177017742416589113 7491717754959394247
 1157707752023265537  -1859323591--1725596255-48 16:23:13   ss    -
12280754577374290737 15446864286208281490
 1609204614858096249  1999416923--1725596255-48 21:08:38   ss    i
3600571124657065622 12156172216455180106
16492959802278112302  -1005506824--1725596255-48 05:37:43   ss    -
11759415802487770311 15182905133685067495
 3737236050226985035  -1235112073--1725596255-48 02:12:42   ss    -
7876034599887446652 4574778715896039703
 1897681074103846001  -993498507--1725596255-48 11:15:02   ss    -
4713367178533865852 12495665640457683873
 5629031927472857828  -1020115369--1725596255-48 22:25:13   ss    -
4617052897507868927 12971493170585062941
 2526176666379534699  -1001874240--1725596255-48 00:39:51   ss    -
3112984405336493942 6943670751485548929
              531055  2017-05-16 09:38:15   cp    -   1524462858   38902090
              531056  2017-05-16 09:38:20   cp    -   1524461428   38902076
              531057  2017-05-16 09:38:26   cp    -   1524461427   38902075
              531218  2017-05-16 09:52:12   cp    -   1524461427   38902075
              531219  2017-05-16 09:52:17   cp    -   1524461427   38902075
              531223  2017-05-16 09:52:39   cp    -   1524461427   38902075
              531228  2017-05-16 09:53:10   cp    -   1524461427   38902075
              531229  2017-05-16 09:53:17   cp    -   1524461427   38902075
              531230  2017-05-16 09:53:23   cp    -   1524461427   38902075
              531242  2017-05-16 09:54:29   cp    -   1524461427   38902075
              531323  2017-05-16 10:01:25   cp    -   1524461427   38902075
              531443  2017-05-16 10:11:40   cp    -   1524461427   38902075
              531455  2017-05-16 10:12:41   cp    -   1524461427   38902076
              531456  2017-05-16 10:12:45   cp    -   1524461484   38902076

I wonder maybe nilfs2 isn't for me at all.

Thanks for your help and attention,

Rodrigo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
