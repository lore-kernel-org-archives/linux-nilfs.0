From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: implement calculation of free inodes count
Date: Mon, 6 May 2013 23:07:38 +0900
Message-ID: <CAKFNMo=mnO=kTVWySGLYTC1o8A3uavEo6VhtthgT_kJhN+0Zfg@mail.gmail.com>
References: <1367586746.5050.4.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=tJ7YtHiP7G4aiar5jokA536qpZzlPzEDC9f+HDCGt44=;
        b=ou80JW7QgtpRvAm3MrVee3VtuGHomLIb/4t5jzOKV6j6aPqh5PyD/DFiTgM0oy4++z
         tlgDIRePciZry2bHDL1BoE4F+SjI50Vq093DhTUniau1uyC4ybvYgrJj7r7ZdwG0F+9L
         9EvkndxNctPu+AOJgtGNDPOaSyVTMe7GnuuqT8CG+ZrXn8c0kwfYH9nvvn2sUM3ted8n
         M+n9RvQz+fwtMxR1RXF5mYvibMoFDI1uyGIG+LzNkBsMdFbdUGeLQE3uQ7SeM4f+HZ9l
         GTragCvIbp6iToy3mFWAbdGpUnEq0K/SBwbVpRk4nviNzF/FpWsIeFWiK1pKZOmOXrjZ
         Jw4w==
In-Reply-To: <1367586746.5050.4.camel-dzAnj6fV1RxGeWtTaGDT1UEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Vyacheslav,

2013/5/3 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: implement calculation of free inodes count
>
> Currently, NILFS2 returns 0 as free inodes count (f_ffree) and current used inodes count as total file nodes in file system (f_files):
>
> df -i
> Filesystem      Inodes  IUsed   IFree IUse% Mounted on
> /dev/loop0           2      2       0  100% /mnt/nilfs2
>
> This patch implements real calculation of free inodes count. First of all, it is calculated total file nodes in file system as (desc_blocks_count * groups_per_desc_block * entries_per_group). Then, it is calculated free inodes count as difference the total file nodes and used inodes count. As a result, we have such output for NILFS2:
>
> df -i
> Filesystem       Inodes   IUsed    IFree IUse% Mounted on
> /dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2
>
> Reported-by: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

I agree to use count of descriptor blocks of ifile to
calculate the approximate value of the total file nodes.

Here are my comments on the patch:

(1) Consider using nilfs_bmap_last_key()  instead of repeating read
     of descriptor blocks to decide new desc_blocks count.
     The current logic may incur many device read accesses
     even if it is updated in a stepwise fashion with
     NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count.

(2) Do not use __statfs_word type for local variables or arguments of
     functions.  I think an integer type such as u64 should be used
     instead.

(3) Consider moving the main part of nilfs_count_free_inodes()
     function to alloc.c, for example, as a function like:

     int nilfs_palloc_count_max_entries(struct inode *inode, u64 nentries,
                                                        u64 *nmaxentries);

     Then, nilfs_palloc_groups_per_desc_block() and
     nilfs_palloc_groups_count() do not need to be moved,
     and nilfs_root argument becomes eliminable from the routine
     added to ifile.c.

(4) Please consider the name convention of functions in ifile.c.
     The ifile.c includes routines related to ifile inode,
     and all its functions have the same name convention (i.e.
     nilfs_ifile_xxxx() ).

(5) nilfs_count_free_inodes() may return -ERANGE.
     (It's OK if inode_count is given as an argument of the function.)
     But, nilfs_statfs() should not return -ERANGE as-is.

     In that case, I think nilfs_statfs() should output a warning
     message and ignore the error code.

Regards,
Ryusuke Konishi

>
> ---
>  fs/nilfs2/alloc.c |   36 ++++++++------------------
>  fs/nilfs2/alloc.h |   24 ++++++++++++++++++
>  fs/nilfs2/ifile.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/ifile.h |    4 +++
>  fs/nilfs2/mdt.h   |    2 ++
>  fs/nilfs2/super.c |    9 +++++--
>  6 files changed, 120 insertions(+), 28 deletions(-)
>
> diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
> index eed4d7b..6c61ae9 100644
> --- a/fs/nilfs2/alloc.c
> +++ b/fs/nilfs2/alloc.c
> @@ -30,29 +30,6 @@
>  #include "mdt.h"
>  #include "alloc.h"
>
> -
> -/**
> - * nilfs_palloc_groups_per_desc_block - get the number of groups that a group
> - *                                     descriptor block can maintain
> - * @inode: inode of metadata file using this allocator
> - */
> -static inline unsigned long
> -nilfs_palloc_groups_per_desc_block(const struct inode *inode)
> -{
> -       return (1UL << inode->i_blkbits) /
> -               sizeof(struct nilfs_palloc_group_desc);
> -}
> -
> -/**
> - * nilfs_palloc_groups_count - get maximum number of groups
> - * @inode: inode of metadata file using this allocator
> - */
> -static inline unsigned long
> -nilfs_palloc_groups_count(const struct inode *inode)
> -{
> -       return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
> -}
> -
>  /**
>   * nilfs_palloc_init_blockgroup - initialize private variables for allocator
>   * @inode: inode of metadata file using this allocator
> @@ -80,6 +57,13 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
>                 mi->mi_blocks_per_group + 1;
>                 /* Number of blocks per descriptor including the
>                    descriptor block */
> +       atomic_set(&mi->mi_desc_blocks_count, 1);
> +               /*
> +                * The field mi_desc_blocks_count is used for
> +                * storing knowledge about current count of
> +                * desciptor blocks. Initially, it is initialized
> +                * by one.
> +                */
>         return 0;
>  }
>
> @@ -246,9 +230,9 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
>   * @create: create flag
>   * @bhp: pointer to store the resultant buffer head
>   */
> -static int nilfs_palloc_get_desc_block(struct inode *inode,
> -                                      unsigned long group,
> -                                      int create, struct buffer_head **bhp)
> +int nilfs_palloc_get_desc_block(struct inode *inode,
> +                               unsigned long group,
> +                               int create, struct buffer_head **bhp)
>  {
>         struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
>
> diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
> index fb72381..073b571 100644
> --- a/fs/nilfs2/alloc.h
> +++ b/fs/nilfs2/alloc.h
> @@ -30,6 +30,28 @@
>  #include <linux/fs.h>
>
>  /**
> + * nilfs_palloc_groups_count - get maximum number of groups
> + * @inode: inode of metadata file using this allocator
> + */
> +static inline unsigned long
> +nilfs_palloc_groups_count(const struct inode *inode)
> +{
> +       return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
> +}
> +
> +/**
> + * nilfs_palloc_groups_per_desc_block - get the number of groups that a group
> + *                                     descriptor block can maintain
> + * @inode: inode of metadata file using this allocator
> + */
> +static inline unsigned long
> +nilfs_palloc_groups_per_desc_block(const struct inode *inode)
> +{
> +       return (1UL << inode->i_blkbits) /
> +               sizeof(struct nilfs_palloc_group_desc);
> +}
> +
> +/**
>   * nilfs_palloc_entries_per_group - get the number of entries per group
>   * @inode: inode of metadata file using this allocator
>   *
> @@ -45,6 +67,8 @@ nilfs_palloc_entries_per_group(const struct inode *inode)
>  int nilfs_palloc_init_blockgroup(struct inode *, unsigned);
>  int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
>                                  struct buffer_head **);
> +int nilfs_palloc_get_desc_block(struct inode *, unsigned long, int,
> +                               struct buffer_head **);
>  void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
>                                    const struct buffer_head *, void *);
>
> diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
> index d8e65bd..4f25549 100644
> --- a/fs/nilfs2/ifile.c
> +++ b/fs/nilfs2/ifile.c
> @@ -160,6 +160,79 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
>  }
>
>  /**
> + * nilfs_count_free_inodes - calculate free inodes count
> + * @root: root object
> + * @nmaxinodes: current maximum of available inodes count [out]
> + * @nfreeinodes: free inodes count [out]
> + */
> +int nilfs_count_free_inodes(struct nilfs_root *root,
> +                               __statfs_word *nmaxinodes,
> +                               __statfs_word *nfreeinodes)
> +{
> +       struct inode *ifile;
> +       struct buffer_head *desc_bh;
> +       unsigned long groups_per_desc_block, entries_per_group;
> +       unsigned long entries_per_desc_block;
> +       unsigned long ngroups;
> +       unsigned int desc_blocks;
> +       __statfs_word nused, nmax;
> +       unsigned long i;
> +       int err = 0;
> +
> +       BUG_ON(!root || !nfreeinodes || !nmaxinodes);
> +
> +       ifile = root->ifile;
> +       *nmaxinodes = 0;
> +       *nfreeinodes = 0;
> +
> +       ngroups = nilfs_palloc_groups_count(ifile);
> +       groups_per_desc_block = nilfs_palloc_groups_per_desc_block(ifile);
> +       entries_per_group = nilfs_palloc_entries_per_group(ifile);
> +       nused = atomic_read(&root->inodes_count);
> +       entries_per_desc_block = groups_per_desc_block * entries_per_group;
> +       desc_blocks =
> +               atomic_read(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count);
> +       nmax = desc_blocks * entries_per_desc_block;
> +
> +       if (nused >= nmax) {
> +               for (i = groups_per_desc_block * (unsigned long)desc_blocks;
> +                               i < ngroups;
> +                                       i += groups_per_desc_block) {
> +
> +                       err = nilfs_palloc_get_desc_block(ifile, i, 0,
> +                                                               &desc_bh);
> +                       if (err)
> +                               break;
> +                       else
> +                               desc_blocks++;
> +
> +                       brelse(desc_bh);
> +               }
> +
> +               nmax = entries_per_desc_block * desc_blocks;
> +
> +               if (nused == nmax) {
> +                       desc_blocks++;
> +                       if ((desc_blocks * groups_per_desc_block) < ngroups)
> +                               nmax += entries_per_desc_block;
> +                       else
> +                               desc_blocks--;
> +               }
> +
> +               atomic_set(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count,
> +                               desc_blocks);
> +
> +               if (nused > nmax)
> +                       return err ? err : -ERANGE;
> +       }
> +
> +       *nmaxinodes = nmax;
> +       *nfreeinodes = nmax - nused;
> +
> +       return 0;
> +}
> +
> +/**
>   * nilfs_ifile_read - read or get ifile inode
>   * @sb: super block instance
>   * @root: root object
> diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
> index 59b6f2b..57a8564 100644
> --- a/fs/nilfs2/ifile.h
> +++ b/fs/nilfs2/ifile.h
> @@ -27,6 +27,7 @@
>
>  #include <linux/fs.h>
>  #include <linux/buffer_head.h>
> +#include <linux/statfs.h>
>  #include <linux/nilfs2_fs.h>
>  #include "mdt.h"
>  #include "alloc.h"
> @@ -49,6 +50,9 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
>  int nilfs_ifile_delete_inode(struct inode *, ino_t);
>  int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
>
> +int nilfs_count_free_inodes(struct nilfs_root *,
> +                           __statfs_word *, __statfs_word *);
> +
>  int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
>                      size_t inode_size, struct nilfs_inode *raw_inode,
>                      struct inode **inodep);
> diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
> index ab172e8..c01b6fb 100644
> --- a/fs/nilfs2/mdt.h
> +++ b/fs/nilfs2/mdt.h
> @@ -53,6 +53,7 @@ struct nilfs_shadow_map {
>   * @mi_shadow: shadow of bmap and page caches
>   * @mi_blocks_per_group: number of blocks in a group
>   * @mi_blocks_per_desc_block: number of blocks per descriptor block
> + * @mi_desc_blocks_count: number of descriptor blocks
>   */
>  struct nilfs_mdt_info {
>         struct rw_semaphore     mi_sem;
> @@ -64,6 +65,7 @@ struct nilfs_mdt_info {
>         struct nilfs_shadow_map *mi_shadow;
>         unsigned long           mi_blocks_per_group;
>         unsigned long           mi_blocks_per_desc_block;
> +       atomic_t                mi_desc_blocks_count;
>  };
>
>  static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index c7d1f9f..548676b 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -609,6 +609,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>         unsigned long overhead;
>         unsigned long nrsvblocks;
>         sector_t nfreeblocks;
> +       __statfs_word nmaxinodes, nfreeinodes;
>         int err;
>
>         /*
> @@ -633,14 +634,18 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>         if (unlikely(err))
>                 return err;
>
> +       err = nilfs_count_free_inodes(root, &nmaxinodes, &nfreeinodes);
> +       if (unlikely(err))
> +               return err;
> +
>         buf->f_type = NILFS_SUPER_MAGIC;
>         buf->f_bsize = sb->s_blocksize;
>         buf->f_blocks = blocks - overhead;
>         buf->f_bfree = nfreeblocks;
>         buf->f_bavail = (buf->f_bfree >= nrsvblocks) ?
>                 (buf->f_bfree - nrsvblocks) : 0;
> -       buf->f_files = atomic_read(&root->inodes_count);
> -       buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
> +       buf->f_files = nmaxinodes;
> +       buf->f_ffree = nfreeinodes;
>         buf->f_namelen = NILFS_NAME_LEN;
>         buf->f_fsid.val[0] = (u32)id;
>         buf->f_fsid.val[1] = (u32)(id >> 32);
> --
> 1.7.9.5
>
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
