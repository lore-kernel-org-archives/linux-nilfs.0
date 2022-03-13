From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: nilfs: WARNING: CPU: 2 PID: 1510 at
 include/linux/backing-dev.h:269 __folio_mark_dirty+0x31d/0x3b0
Date: Sat, 12 Mar 2022 22:23:51 -0800
Message-ID: <20220312222351.89844f74d3cf10212f308caf@linux-foundation.org>
References: <9a20b33d-b38f-b4a2-4742-c1eb5b8e4d6c@redhat.com>
        <YivTnPMUpvX8ivpj@casper.infradead.org>
        <CAKFNMonQtBe=pjrUuACqzKL36RTWmvoULwzD9NCP7PET8B73bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647152632;
        bh=r5ve3QQqDztmWSyNqt57pEYrCXV23g3Xex3BHLDSgQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W9tERT6YvLQm6gvnCZbmJtXcLrBMD4jj5tWre40pwg48xvw0Bd7Ioe/L9XpA76+4N
         aDH/1GZidcyjB1POUFkZ6ChGABFbkE2wqJCNwNwrFRQnCtX829mj2zX9YRiGcpYn0O
         LonVH573IL59gJhV6OXdmdoGZpSgOgV+1fRSt78U=
In-Reply-To: <CAKFNMonQtBe=pjrUuACqzKL36RTWmvoULwzD9NCP7PET8B73bQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sun, 13 Mar 2022 15:09:27 +0900 Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi Matthew, and Andrew,
> 
> On Sat, Mar 12, 2022 at 7:56 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Fri, Mar 11, 2022 at 08:43:57PM +0100, David Hildenbrand wrote:
> > > Hi,
> > >
> > > playing with swapfiles on random file systems, I stumbled over the
> > > following nilfs issue (and reproduced it on latest greatest
> > > linux/master -- v5.17-rc7+). I did not try finding out when this
> > > was introduced and I did not run into this issue on other file
> > > systems I tried.
> >
> > It's a known bug in NILFS, and I think yours is the fifth report
> > of it dating back eight months.
> 
> The root cause of this issue is that NILFS uses two page caches
> per inode, one for data blocks and another for b-tree node blocks.
> 
> Even though __folio_end_writeback(), __folio_start_writeback(), and
> __folio_mark_dirty() acquire lock for mapping->i_pages,
> inode_to_wb(inode) inside them performs lockdep test for the former one
> (i.e. inode->i_mapping->i_pages.xa_lock).
> 
> So, mark_buffer_dirty(), end_page_writeback(), and set_page_writeback()
> for pages in the latter NILFS specific page cache hit the LOCKDEP warning.
> 
> I tried to find a way to  resolve this, but have no good idea so far.

If things are set up appropriately, inode_to_wb() should be able to
test inode->i_mapping->host->i_mapping->i_pages.xa_lock and get the
desired result.

At least, that's the case with blockdevs.  I don't know if nilfs2 sets
things up that way.

