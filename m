From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: My NiLFS2 port to NetBSD: status update
Date: Wed, 05 Jun 2013 09:21:30 +0900 (JST)
Message-ID: <20130605.092130.52167382.konishi.ryusuke@lab.ntt.co.jp>
References: <20130604140257.GA713@diablo.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130604140257.GA713-HNv6YvNvQKMNqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Reinoud,
On Tue, 4 Jun 2013 16:02:57 +0200, Reinoud Zandijk wrote:
> Hi Ryusuke, hi folks,
> 
> it has been some time now that i worked on my NetBSD port of NiLFS2. A
> read-only version has been included in the NetBSD kernel for some two(?) years
> now. I then started on creating a writing version too but it got side tracked
> by various reasons like moving to a new house/home :)
> 
> I've picked up development, re-starting again, learning from earlier mistakes.
> Has anything fundemental changed in the last few months? I've taken in the
> changes for volume name, the 2nd superblock and such, but is there anything
> more?

I think no big changes are made in these days.  Most changes are bug
fixes, or problem fixes.

> As for the adoption of NiLFS2 in Linux, i've seen mixed responses in reviews.
> Most complain about the read/write speed. Since i dont have a reasonable test
> setup and my implementation is not writing yet, how are your thoughts about
> this? Is it a fundemental issue or is it more due to way its implemented?

Yes, it's not satifactory in performance at all, at least for our
NILFS2 implementation of Linux.  Both read and write speed should be
improved based on measurement.  Unfortunately, I have no time these
days to make effort on this.  As for performance, at least the
following tasks are still remaining.

- fast inode allocator
- fitrim support
- btree based directory imlementation
- revise gc algorithm
- fsync/osync optimization
- direct io (write) support
- improve pre-fetch
- lock free log write; the currrent segment constructor locks r/w
  semaphore during write, and successive write requests to page cache
  are blocked.
- etc

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
