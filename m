From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 17:48:50 +0400
Message-ID: <1358257730.2094.4.camel@slavad-ubuntu>
References: <1358234057.2105.12.camel@slavad-ubuntu>
	 <201301151043.AA04492@capsicum.lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=eBOsxHiiafDfRwJbhowwguTdly7gLC4kWgPYPRS11I0=;
	b=a9UrTVNllGz6MEGscXGaTpshr6Ho72Q4EQIss1RuIX3j6BhABC4YHVaD0dpxsADPPDZMMqqVhY+A3C32KqDm9v7UHnM351pvAVNsM54FuCdsTSjYLmgckF1YvS1cedWz;
In-Reply-To: <201301151043.AA04492-ZdTO5nnmHvkOizVVqyxoihMFgDP4sedm@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Tue, 2013-01-15 at 19:43 +0900, Ryusuke Konishi wrote:

[snip]
> >
> >As I understand the code of nilfs_cleanerd, this code is correct without
> >your changing. The ss_nongc_ctime is the creation time of the last
> >segment not for GC. When thr is set then it compared with sui_lastmod.
> >The sui_lastmod is the timestamp of last modification. So, the
> >nilfs_cleanerd works right.
> >
> >I think that this is a bug on the kernel side. My current vision is that
> >in some environment the ns_nongc_ctime can be not updated correctly. So,
> >you have such threshold that prevent from segments clearing.
> 
> I guess the problem is caused because ss_nongc_ctime is not updated by
> the kernel module if dirty blocks created by file operations are written
> out through nilfs_clean_segments function.   Actually,
> nilfs_clean_segments() can roll together normal dirty blocks.
> 
> So, if GC is working without interruption, ss_nongc_ctime may not be
> updated long time.
> 
> If this is the cause of the problem, nilfs2 log writer should be changed
> so that nilfs->ns_nongc_ctime is updated with sci->sc_seg_ctime if
> there is a file system change (file/directory change or an ifile change).
> 
> NILFS_SC_HAVE_DELTA flag may be available for this purpose.
> 
> The ss_nongc_ctime check is needed to make GC stoppable.
> Without this check, GC can continue endlessly even if the file system
> doesn't have any change.
> 

Thank you for your detailed explanation. It is very helpful for me.

But, currently, I can't reproduce the issue. All works fine on my side.

With the best regards,
Vyacheslav Dubeyko.

> With regards,
> Ryusuke Konishi
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
