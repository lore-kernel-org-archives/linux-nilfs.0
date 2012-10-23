From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 23 Oct 2012 17:35:30 +0400
Message-ID: <1350999330.2041.48.camel@slavad-ubuntu>
References: <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014200836.GK27763@wloczykij> <1350281888.2488.9.camel@slavad-ubuntu>
	 <20121018201528.GS27763@wloczykij> <1350628991.2028.25.camel@slavad-ubuntu>
	 <20121019101421.GT27763@wloczykij> <1350973913.2041.25.camel@slavad-ubuntu>
	 <20121023084100.GW27763@wloczykij> <1350984395.2041.32.camel@slavad-ubuntu>
	 <20121023115458.GA27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=KekMn+FVEhGgpICcxEafE00pepeGsB4S+RvDi9FoFH4=;
	b=dQJfzzyAcao9a+Kws8QXmJLObsteDT2ZH8B8t9yvgmrRVlJEDI8FS+UGIMc9ddFmzR0XNIvbGTmZJwyWqSXHikHRqTXgEpz6cUIlPEmO9jS5Bv0LO81zJ+uT6VEpzw3G;
In-Reply-To: <20121023115458.GA27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2012-10-23 at 13:54 +0200, Piotr Szymaniak wrote:
> On Tue, Oct 23, 2012 at 01:26:35PM +0400, Vyacheslav Dubeyko wrote:
> > It is strange. Did you try to mount NILFS2 volume that is placed on
> > SD-card for the case of on another machine (Gentoo x86 with kernel
> > 3.6.2)?
> 
> Yes, all those messages are from this machine (it could be kernel 3.4.10
> or 3.6 or 3.6.1 at the beginning of this thread).
> 
> 
> > Could you try to mount volume's dump as loop device on machine (Gentoo
> > x86 with kernel 3.6.2)?
> 
> Now this is weird. I have a complete image of the SD-card but never
> tried to mount it. Now I did with:
> mount -t nilfs2 -o loop,offset=[offset to nilfs2] raspi.img /mount/point
> and it works.
> 
> I tried to mount this SD-card on the same machine (using card reader) and
> had the mentioned error.
> 
> Now I'm a bit confused. Made SD-card image without issues, SD-card
> refuses to mount, but the image works?
> 
> I will try to make another image and double check it.
> 
> What should I do if this works? mount the image, umount the image (that
> should fix it?) and copy image back to SD-card?
> 

I think that the issue is the concrete SD-card's issue. So, if you
simply dump out the image on another SD-card then, I hope, all will work
fine.

With the best regards,
Vyacheslav Dubeyko.

> 
> > Could you share strace output (strace mount <device> <mount-point>) for
> > the case of mount trying?
> 
> I will share the SD-card strace output later (if it still won't work,
> see above).
> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
