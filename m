From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Wed, 18 Sep 2013 10:18:26 +0400
Message-ID: <1379485106.2365.11.camel@slavad-ubuntu>
References: <5238DAD8.3070804@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=eB7feSYeuowqhgzQs4akoBa/sQaapdre/vdjzSBrbxo=;
	b=QqDvrD+u98RdLLacJETqL0Ur0CBaTrm4EMHCgZ+kIxvuF7bp1OMcATLm6s3Lbi97Cdvu67tevGHxYcc5pQR6DvLz1NoWhZINDefDt71+vvXIIkUAg0j+32mzTtMKZQyS;
In-Reply-To: <5238DAD8.3070804-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Michael,

On Tue, 2013-09-17 at 18:42 -0400, Michael L. Semon wrote:
> Hi!  I have an old multi-boot x86 PC that I use for testing.
> One of its root partitions is NILFS2, and it is booted via LILO and
> a JFS-formatted /boot partition.  All seems fine, but the umount of /
> can hang, especially when NILFS2 had to recover / on boot in read-only
> mode due to a crash.  Using KDB to get stack traces, I wonder if 
> segctord is waiting for an event that will not happen.
> 

As far as I can see, your NILFS2 file system was remounted in RO mode
because of internal error. Could you confirm my understanding?

> [Actually, the umount of NILFS2 partitons can hang in other cases, too.
> This is a narrow case that I can repeat fairly often.]
> 
> Is there a guaranteed good way to shutdown nilfs_cleanerd and NILFS2
> properly on system shutdown?  I tried to ensure that the killall5
> program doesn't touch nilfs_cleanerd on shutdown, but that solution
> has started to not work again.
> 

So, if you have remount in RO mode after some file system operations
then NILFS2 will have troubles with flushing and as a result with
shutdown. Such situation takes place because of continuous trying to
flush dirty pages without success in nilfs_write_page() and
nilfs_mdt_write_page(). This issue was fixed in patch [1].

But I believe that now we understand the reason of the issue with
remounting in RO mode. I posted the patch [2] two weeks ago. This patch
is under discussion yet.

Please, feel free to report about the issue again if these patches will
not solve your problem.

Thanks,
Vyacheslav Dubeyko.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8c26c4e2694a163d525976e804d81cd955bbb40c
[2] http://www.spinics.net/lists/linux-fsdevel/msg68054.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
