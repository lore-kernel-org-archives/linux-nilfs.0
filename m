From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000048
Date: Sat, 10 Mar 2012 12:08:25 +0900 (JST)
Message-ID: <20120310.120825.140145245.ryusuke@osrg.net>
References: <CAMRzUtwpZQ_ZmZoGzOA0wkmTVQKVJRwA7OB3X_ktRXPj9MJoXA@mail.gmail.com>
	<20120306.235404.52180631.ryusuke@osrg.net>
	<CAMRzUtyoYPzCYhqaxughGOBWr_iUcFyOx5p1eBYJRa19xq8Xgg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMRzUtyoYPzCYhqaxughGOBWr_iUcFyOx5p1eBYJRa19xq8Xgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slicky.dvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 7 Mar 2012 00:07:24 +0300, Slicky Devil wrote:
> On Tue, Mar 6, 2012 at 5:54 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > Hmmm.  Did you shrink the filesystem with nilfs-resize tool
> > before shrinking the partition ?
> >
> > This error (I/O error) also looks undesirable to me.
> 
> I couldn't shrink the filesystem, because I couldn't mount it because
> of the bug. The filesystem was large and I was in desparate need of
> some spare diskspace. At first, I was going to completely get rid of
> it, but then I thought you might want to have a look at the
> superblock, or some othe block, or whatever else to analyze the bug.
> Since the bug was some sort of initialization issue, I finally decided
> to keep the first 500 MB of the filesystem and reclaimed the rest of
> it (by shrinking the partition).
> 
> And all that had happened *before* I posted the bug report on this mailing list.
> 
> Luckily, when I tried to mount the "broken" filesystem today, the
> nilfs driver exposed the very same oops again. I applied your
> patch/recompiled the kernel and the oops disappeared.
> 
> So, no. I didn't use any nilfs-resize. And those IO error are pretty
> much expected to me.

Understood, thank you for letting me know the situation.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
