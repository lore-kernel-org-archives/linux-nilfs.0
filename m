From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 29 Mar 2013 15:29:17 +0400
Message-ID: <1364556557.11128.28.camel@slavad-ubuntu>
References: <20121127151924.GW4028@wloczykij>
	 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
	 <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu>
	 <20121128205943.GZ4028@wloczykij> <1354172459.2077.11.camel@slavad-ubuntu>
	 <20130328120700.GK1672@wloczykij>
	 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
	 <20130329074249.GL1672@wloczykij> <1364544910.11128.9.camel@slavad-ubuntu>
	 <20130329103710.GM1672@wloczykij>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=bJFk1fe3vK8E3wYBZkMD52sbBwMRjNUWlp//tT27DBk=;
	b=Q/pO45A0y7oa9KhVEz7n5yrlLa5tx9Yz5pcgqj67Q7Y9+y2KYYyh1uTotktWtBunT8JCiDLG8uJxarIwJE4tFi6tD8W5x0Thx4n4NKEQcOeUHRmj5KysHLsRTlXR/PMf;
In-Reply-To: <20130329103710.GM1672@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2013-03-29 at 11:37 +0100, Piotr Szymaniak wrote:
> On Fri, Mar 29, 2013 at 12:15:10PM +0400, Vyacheslav Dubeyko wrote:
> > I meant that sysrq-trigger output ends with resume about runnable tasks
> > and locks in the system (for example):
> > *snip*
> > So, I need in full sysrq-trigger output for understanding situation on
> > your side. Could you share it?
> 
> If this should be in echo t > /proc/sysrq-trigger then I shared full
> output already. Maybe I'm missing some (debug?) features in kernel for
> more verbose output.
> 

I haven't any special additional configuration options for MagicSysRq in
my kernel configuration. It is simply enabled.

As I see (https://www.kernel.org/doc/Documentation/sysrq.txt), it is
possible to define log level by means of setting value
in /proc/sys/kernel/sysrq. I have "1" (enable all functions of sysrq) in
this file. Maybe, have you another log level on your side?

> 
> > > Btw looking at ps aux output it seems, that this flush is hanging there
> > > almost from first boot:
> > > root       937 88.2  0.0      0     0 ?        S    Feb17 50160:39 [flush-8:0]
> > > 
> > 
> > Could you share "cat /proc/partitions" and "mount" outputs? I need to
> > understand what partition is processed by [flush-8:0].
> 
> ~ # cat /proc/partitions
> major minor  #blocks  name
> 
>    8        0    3915776 sda
>    8        1      32768 sda1
>    8        2      65536 sda2
>    8        3    3816448 sda3
>    8       16  156290904 sdb
>    8       17    4200966 sdb1
>    8       18     273105 sdb2
>    8       19  146810002 sdb3
>    8       20    5004247 sdb4
>  254        0      65536 dm-0
>  254        1  146808974 dm-1
> 
> 
> ~ # mount
> rootfs on / type rootfs (rw)
> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=16150)
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
> udev on /dev type devtmpfs (rw,nosuid,relatime,size=10240k,nr_inodes=221714,mode=755)
> devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620)
> shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> /dev/mapper/chome on /home type btrfs (rw,noatime)
> 

I see two nilfs_cleanerd deamons from "ps ax" output:

1520 ?        Ss     0:25 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.conf /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
16150 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sda3 /

But I can't understand what partition is serviced by nilfs_cleanerd with
pid #1520. Could you share more details about it?

Thanks,
Vyacheslav Dubeyko.

> 
> > > > I can easily reproduce the issue by big file (100 - 500 GB) deletion
> > > > or truncation. Please, find description in:
> > > > http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01504.html.
> > > 
> > > If this brings something new - I'm not using huge files like that (this
> > > flush above is a 3.7G device). But if this reproduces the issue, it
> > > could be related.  (:
> > > 
> > 
> > Yes, it is really important to understand the situation on your side.
> > Because you can have another reason of the issue with similar symptoms.
> > So, we need to investigate your case more deeply, I think.
> 
> Got this issue on two different machines, but none of them uses nilfs2 at
> device bigger then 60G (in fact, the partitions are, afair, around 30G and the
> mentioned 3.7G).
> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
