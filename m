From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Very low write-performance and troubles with RPM
Date: Thu, 25 Apr 2013 12:00:25 +0400
Message-ID: <1366876825.3181.6.camel@slavad-ubuntu>
References: <CAFvQSYS5E7wFLyc___yvSBDaDsPyjEJ19XUs2M3UEN1nXJcumg@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=a3R51k7zE+b7KzhqxODxt/wELJtS2u687d8um9fA5w0=;
	b=HHwkzXsHs6zBnxFn/9WA1sfDIQbgUdj6wlatXFE0fqHQId7wdDjty6mImbNiUpbao7frppjJalQwTFxT5Rzuy4dm5iU+d2uw00FEvRP4PyIJGALpNaG7JhRWzeb+Vb3f;
In-Reply-To: <CAFvQSYS5E7wFLyc___yvSBDaDsPyjEJ19XUs2M3UEN1nXJcumg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Wed, 2013-04-24 at 15:53 +0200, Clemens Eisserer wrote:
> Hi.
> 
> I am in the process of migrating to nilfs2 for my root-filesystem
> running Fedora-19-alpha.
> Basically the system works quite fine, except:
> 
> 1. RPM checks for free inodes prior installing a package, which
> doesn't make any sence of course.
> I can pass "--ignoresize" to RPM which disables those checks, however,
> I haven't found any way to disable it when using the "yum" package
> manager.
> Is there any way to make nilfs2 report a large number of unused inodes
> instead of "0"?
> 

Thank you for the issue report. You simply encounter the non-implemented
part of the NILFS2 driver. It needs to be fixed.

> 2. Write-operations are very slow (a few mb/s) and a lot of time is
> spent inside:
> - segctord
> - the application performing the filesystem operations.
> 

I think that anyway NILFS2 driver needs in optimization efforts.

> I've recorded a system-wide profile of extracting a tar archive as
> well as a larger delete operation (rm):
> https://plus.google.com/photos/118350688762629274389/albums/5870410083987119137?authkey=CPu0iK2TiOWsoQE
> 
> Any idea what could be going wrong here?
> 

As I understand, you mean long duration of delete operation for big
files. Unfortunately, this is a side effect of managing checkpoint
information during deletion operation. As I understand, it needs to
implement extents support for improving this.

Thanks,
Vyacheslav Dubeyko.

> Thank you in advance, Clemens
> 
> PS: I am using nilfs-utils-2.1.4-3.fc19.x86_64 and linux
> 3.9.0-0.rc6.git2.3.fc19.x86_64.
> the root-filesystem is an encrypted luks container (worked quite will
> with ext4, so don't think this is causing the issue)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
