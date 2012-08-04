From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs-diff
Date: Sat, 04 Aug 2012 10:47:31 +0900 (JST)
Message-ID: <20120804.104731.153851435.konishi.ryusuke@lab.ntt.co.jp>
References: <1344026705.21631.8.camel@acer.fritz.box>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344026705.21631.8.camel-y7UOyazmsHdwFLYp8hBm2A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mark Reiche <mark.reiche-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 03 Aug 2012 22:45:05 +0200, Mark Reiche wrote:
> Hi list,
> 
> I started using nilfs as root file system and I am really impressed and
> excited.
> 
> Now I'd like to find out the differences (i.e. changed files) between
> certain checkpoints. I found an older mail on the old mailing list
> ("[PATCH 0/9] exprimental API to extract changes between two
> checkpoints"), however, the links and git archive referenced there
> appear to be dead.

Sorry for the inconvenience.

Git trees of the nilfs project are now served on github.  Related
patchsets are available on the following places:

nilfs-diff:

   git://github.com/konis/nilfs-utils.git (diff branch)

diff API:

   git://github.com/konis/nilfs2.git (diffapi branch)


> It also appears that this "experimental API" never made it into the
> mainstream over the course of the last year :-(

This patchset is still immature.  Unfortunately, I became very busy
after having published this work and couldn't continue the
development.

As I wrote in the mail, this patchset has important limitations and
does not suit for practical use.  It doesn't support hard links (only
one parent inode number is recorded in an inode), and inode number of
parent inodes are truncated to 32-bit width from the original 64-bit
value when being stored to disk.  Yet, I don't have good answers for
these issues.

> So: Is there a way to find out what changed between the checkpoints?

If two checkpoints are mounted as snapshots, you can use the following
patch against diff command (as a workaround):

http://www.nilfs.org/pub/patch/diff-change-for-nilfs.patch


Regards,
Ryusuke Konishi
 
> Thanks,
> Mark Reiche
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
