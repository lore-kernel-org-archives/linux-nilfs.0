From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/9] nilfs2: add /sys/fs/nilfs/features group
Date: Tue, 22 Apr 2014 11:20:50 +0400
Message-ID: <1398151250.2181.13.camel@slavad-CELSIUS-H720>
References: <1397837276.2178.52.camel@slavad-CELSIUS-H720>
	 <20140421.020501.511716674.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=MnIrmvuYzasZ/kfO3EU6SclmkllASrOP95DNo9zKViA=;
	b=pMbetUUmUSSduXO2u6sVR593By7GZb7qmavnuB3VySwOVpeYTLF1PDVlOpZ88kGgX4cyD6KN8UdtBzMTMWmOmfjnRGfBhEgeuLkX2TBPyHpYJbCaQBQpRGFHY13rYh0R;
In-Reply-To: <20140421.020501.511716674.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Mon, 2014-04-21 at 02:05 +0900, Ryusuke Konishi wrote:

[snip]
> > There are two formats - seconds and human-readable format.
> > You can set preferable time format by command
> > (for example, setting human-readable format):
> > 
> > 'echo human-readable > /sys/fs/nilfs/features/time_format'
> 
> I don't think you shouldn't globally switch the time format like this.
> I think two or more sysfs files should be added per format, or
> either one should be selected if avoiding complexity.
> 
> Think the situation where userland programs read time stamp
> information on the sysfs interface.  They will malfunction if a user
> incidentally changes the format through the time_format file.  The
> format of sysfs files should never depend on other changeable status.
> 

OK. I agree. So, I choose to have two sysfs files (for example,
last_seg_write_time for human-readable format and
last_seg_write_time_secs for output in seconds). 

> The features directory of sysfs interface should have global features
> which are independent to nilfs instance or version (e.g. nilfs3, etc)
> since you chose "nilfs" for the fs directory name.  The revision file
> is self-contradictory in that sense.  I think it should be placed in
> each device directory.  Otherwise, we should use "nilfs2" as for the
> fs directory name.
> 

In current implementation:
(1) fs/nilfs/features/revision - show current supported revision by file
system driver.
(2) fs/nilfs/<device>/revision - show file system revision that it saved
in superblock of the volume. As a result, it shows the revision of file
system is created on a volume.

I suppose that we have identical understanding. And current
implementation provides information about revision in the proper way. If
I misunderstand something, please, correct me.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
