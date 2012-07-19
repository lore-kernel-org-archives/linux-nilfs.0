From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 0/2] NILFS2: add omitted comments for structures
Date: Thu, 19 Jul 2012 20:49:15 +0900 (JST)
Message-ID: <20120719.204915.179933295.konishi.ryusuke@lab.ntt.co.jp>
References: <1342692079.1982.6.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342692079.1982.6.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 19 Jul 2012 14:01:19 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> This patch set adds omitted comments for different structures in NILFS
> file system driver.
> 
> v1->v2
> nilfs2_fs.h
> * Correct comment for sui_nblocks field of nilfs_suinfo structure
> * Correct comment for v_index field of nilfs_argv structure
> * Correct comments for p_start and p_end fields of nilfs_period
> structure
> * Correct comments for vi_start and vi_end fields of nilfs_vinfo
> structure
> 
> btnode.h
> * Correct non-ascii characters in comments for nilfs_btnode_chkey_ctxt
> structure
> 
> the_nilfs.h
> * Delete "(Reserved)" from comment for blocks_count field of nilfs_root
> structure
> 
> With the best regards,
> Vyacheslav Dubeyko.

Thanks.

I will send these patches upstream with adjustments to make them
comply to kernel-doc/patch rules.

Regards,
Ryusuke Konishi

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
>  fs/nilfs2/the_nilfs.h     |    3 +-
>  include/linux/nilfs2_fs.h |   63
> +++++++++++++++++++++++++++-----------------
>  12 files changed, 118 insertions(+), 32 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
