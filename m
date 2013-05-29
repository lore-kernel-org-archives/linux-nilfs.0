From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Wed, 29 May 2013 10:39:33 +0400
Message-ID: <1369809573.2253.31.camel@slavad-ubuntu>
References: <519D2B96.9000106@antoneliasson.se>
	 <1369291449.2673.15.camel@slavad-ubuntu>
	 <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=I51iib11zaxMmpjFf1wDh0QMLDKWmqI3mtbv5W/p/0k=;
	b=EqUF/lFMqs7eYFwDGe6AyzHSHh+Ypey1PsDFBh5DOtS/GCJBGy37heLu2SfB9Fxn+f1WhmohAuuW4D+r9ghd8ukxSBedIdfRaRBlxHyPIR27aGPxb9tiaO3le6RCyFfO;
In-Reply-To: <51A0E62D.5060600-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton

On Sat, 2013-05-25 at 18:26 +0200, Anton Eliasson wrote:

[snip]
> More specifically, I have a virtual machine running Windows XP in /home, 
> a nilfs filesystem, and a virtual machine running Windows 7 in 
> /Supplement. /Supplement is an ext4 volume in the same LVM volume group 
> as /home on the same slow hard drive. I can crash the host by either:
> 
> * Starting both machines at the same time.
> * Starting the W7 machine first and when it is fully booted to the 
> desktop, but still doing I/O intensive Windows stuff, starting the WXP 
> machine.
> 
> If I first start the WXP machine and let it boot to the desktop, at the 
> point where it is actually I/O idle, I can safely start the W7 machine. 
> After that I found no trouble installing software updates and logging in 
> and out of both machines at the same time, though the HDD made it very 
> slow of course.

Currently, I am thinking about reproducing path. It is really important
to have clear reproducing path. But I haven't clear picture of your
environment yet. As I understand, you have two virtual VmWare machine
(Win XP and Win 7). Am I correct?

Moreover, I am thinking about the fact that virtual machine on different
volumes influence on each other in the issue environment. Currently, I
haven't clear understanding of this.

> /etc/fstab
> ----------
>      tmpfs		/tmp	tmpfs	nodev,nosuid	0	0
>      /dev/mapper/riven-arch	/         	nilfs2    	rw,noatime,discard 0 0
>      /dev/mapper/riven-home	/home     	nilfs2    	rw,noatime,discard 0 0
>      /dev/mapper/riven-swap  none            swap            defaults 
>          0 0
>      /dev/riven-proto/supplement /Supplement ext4 defaults,noatime 0 0
> # some NFS mounts excluded
>

As I can see, riven-arch, riven-home and riven-swap are under device
mapper but riven-proto is not. Could you share more details about how
your Logical Volumes environment was prepared?

Current state of fsck.nilfs2 doesn't give many useful details. But debug
output of fsck.nilfs2 contains detailed info about first superblock,
second superblock and segment summaries of all segments. I think that
this output can give to me more understanding about NILFS2 volume state.
Could you share debug output of fsck.nilfs2 for me?

You can found archive with fsck.nilf2 source code in this place:
(http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz). Please, build fsck.nilfs2 but don't install it. The fsck.nilfs2 on the initial state of development. Currently, fsck.nilfs2 doesn't make any writing operations. So, you can execute command in such way: "fsck.nilfs2 -v debug [device] 2> [output-file]". The output file has a big size, usually.

I am preparing patch for NILFS2 driver with debug output. I think that
it makes sense to get more detail about the issue on your side because
you can reproduce the issue stably. So, I'll send you this patch as it
will be ready. Have you opportunity to patch your kernel and share debug
output for the reproduced issue case?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
