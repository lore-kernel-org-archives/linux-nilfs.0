From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 0/2] NILFS2: add omitted comments for structures
Date: Tue, 17 Jul 2012 13:02:46 +0900 (JST)
Message-ID: <20120717.130246.135807819.konishi.ryusuke@lab.ntt.co.jp>
References: <6BEB7CF8-EFA5-4559-9054-159807A2B067@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6BEB7CF8-EFA5-4559-9054-159807A2B067-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 16 Jul 2012 23:51:23 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> This patchset adds omitted comments for different structures in NILFS file system driver.

Thank you for these patches.  I'll take a look later.

> With the best regards,
> Vyacheslav Dubeyko.
> --
>  fs/nilfs2/alloc.h         |   12 +++++++-
>  fs/nilfs2/bmap.h          |    7 +++++
>  fs/nilfs2/btnode.h        |    8 +++++-
>  fs/nilfs2/dat.c           |    6 ++++
>  fs/nilfs2/export.h        |    8 +++++
>  fs/nilfs2/ifile.c         |    6 +++-
>  fs/nilfs2/inode.c         |    7 +++++
>  fs/nilfs2/mdt.h           |    7 +++++
>  fs/nilfs2/nilfs.h         |   15 ++++++++++-
>  fs/nilfs2/sufile.c        |    8 +++++-
>  fs/nilfs2/the_nilfs.h     |    1 -
>  include/linux/nilfs2_fs.h |   63 +++++++++++++++++++++++++++-----------------
>  12 files changed, 117 insertions(+), 31 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
