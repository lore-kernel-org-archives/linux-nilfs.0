From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs-utils: add skeleton of fsck.nilfs2
Date: Wed, 25 Jul 2012 02:36:54 +0900 (JST)
Message-ID: <20120725.023654.213985185.konishi.ryusuke@lab.ntt.co.jp>
References: <9DBF030C-DB82-4D29-884C-4C036FEC996D@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9DBF030C-DB82-4D29-884C-4C036FEC996D-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 22 Jul 2012 19:13:01 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> This patch set adds skeleton of fsck.nilfs2 utility into nilfs-utils package. Currently, fsck.nilfs2 only try to check presence of primary and secondary superblocks. It checks magic signature in superblock.
> 
> With the best regards,
> Vyacheslav Dubeyko.

I'm planning to look this patchset weekend.

One question is about your plan for proceeding this task.

Implementing fsck looks a tough task since NILFS has history of data
and meta-data as well as the current file system structures, and correcting
filesystem looks to need log write in user-land, which is not yet realized.

So, taking a step-by-step approach seems essential.

In this sense, did you design the skelton, thinking of further steps?
If you have some strategy to accomplish this task, I'd like to hear
that.

My concern for this is avoiding rework of the future.

I'm very thankful for your challenges.

With regards,
Ryusuke Konishi

> --
>  configure.ac     |    3 ++-
>  sbin/Makefile.am |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
>  sbin/fsck/Makefile.am        |   13 ++
>  sbin/fsck/fsck_messages.c    |  254 ++++++++++++++++++++++++
>  sbin/fsck/fsck_messages.def  |   62 ++++++
>  sbin/fsck/fsck_messages.h    |  110 +++++++++++
>  sbin/fsck/fsck_nilfs2.c      |  379 +++++++++++++++++++++++++++++++++++
>  sbin/fsck/fsck_nilfs2.h      |   37 ++++
>  sbin/fsck/fsck_raw_ops.c     |  413 +++++++++++++++++++++++++++++++++++++++
>  sbin/fsck/fsck_raw_ops.h     |   46 +++++
>  sbin/fsck/nilfs_superblock.c |  445 ++++++++++++++++++++++++++++++++++++++++++
>  sbin/fsck/nilfs_superblock.h |   48 +++++
>  10 files changed, 1807 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
