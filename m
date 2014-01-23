From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Thu, 23 Jan 2014 11:25:12 +0100
Message-ID: <52E0EE08.3040703@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <52E05863.90604@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E05863.90604-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michael,

On 2014-01-23 00:46, Michael L. Semon wrote:
> Not having your super-secret test suite or disk space to run it, I 
> went the other direction, using the commonly available fs_mark utility 
> to make many tiny writes with 16 threads.  My initial opinion is that 
> your new GC code fixes some obvious lag when a filesystem is populated 
> and nilfs_cleanerd starts to do its work.  

Thanks for testing my code. It is not a super-secret test suite :), it's
just a few 100 lines of crappy C code I am embarrassed to publish.
Thanks for pointing out fs_mark, I didn't know it. From what I can see
it seems to be the perfect tool to test the GC. I will repeat my
measurements with fs_mark over the weekend.

> However, for reasons of code 
> or simple mathematics, the file system hits end-of-space a bit earlier 
> than does the unpatched code.  I'll have to build some kernels, live 
> with the system, and otherwise generate lots of checkpoints to know if 
> this is a problem.  IOW, I need to find out for myself if I need to 
> make a slightly larger filesystem to do the same things using a patched 
> NILFS2.

Maybe my default values are a bit too high. 256 blocks are about 1 MB
with 4k blocks. So if you use the current default settings, you could
potentially loose 1/8 of your free space.

By the way "blocks" is not a very good unit for the threshold in the
config file anyway. If am thinking of changing it to "% of a segment",
which would be independent of the block size and a lot more intuitive.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
