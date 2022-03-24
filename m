From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] fs: Fix some kernel-doc comments
Date: Thu, 24 Mar 2022 11:07:51 +0900
Message-ID: <CAKFNMonU7Ov9v7_WB6x+fMae4N+AWbtzTDzts4M-s7iG0tqS+w@mail.gmail.com>
References: <20220324002959.48592-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MWzf/zP0aSYuHjZ45euTh/n7opZg/N8+Hh/usuT9m8=;
        b=aR8cFt4Z4t8heY8CccVQowH/VgUecLt043+tnFwlGTUknj1pP/fmKiTGHhLX5xxqoT
         xSFhNvxwGQLETEy0vBED6vF5i/c74fh4zgpw63Y+XBV5o+QuXkh4O4gmyOlxWb9HQbvu
         fQPIutk2w93ZXxQaGsa5PwD5djOte2QvTS9bf+RcnFu/jSqNc0hxwYmfL1CwpkiKSyUW
         01CNX9VwcezL6ITkJbqBGk6Re9zjlEHwgCIhrBIMrJ6bmmU4OJS6/IvkpE7h0zY/FNKo
         0A6DJ2txlZa3U5bZVYI8vwn6k5QnRgeGloLE0Oq+FHxDB7h9zFN3UBVhihXeQtex+opw
         ABOA==
In-Reply-To: <20220324002959.48592-1-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hi Yang,

On Thu, Mar 24, 2022 at 9:30 AM Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> The description of @flags in nilfs_dirty_inode() kernel-doc
> comment is missing, and some functions had kernel-doc that
> used a hash instead of a colon to separate the parameter
> name from the one line description.
>
> Fix them to remove some warnings found by running scripts/kernel-doc,
> which is caused by using 'make W=1'.
>
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'inode' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'blkoff' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'bh_result'
> not described in 'nilfs_get_block'
> fs/nilfs2/inode.c:73: warning: Function parameter or member 'create' not
> described in 'nilfs_get_block'
> fs/nilfs2/inode.c:145: warning: Function parameter or member 'file' not
> described in 'nilfs_readpage'
> fs/nilfs2/inode.c:145: warning: Function parameter or member 'page' not
> described in 'nilfs_readpage'
> fs/nilfs2/inode.c:968: warning: Function parameter or member 'flags' not
> described in 'nilfs_dirty_inode'
>
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  fs/nilfs2/inode.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 476a4a649f38..eb1ba17acb0b 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -59,10 +59,10 @@ void nilfs_inode_sub_blocks(struct inode *inode, int n)
>
>  /**
>   * nilfs_get_block() - get a file block on the filesystem (callback function)
> - * @inode - inode struct of the target file
> - * @blkoff - file block number
> - * @bh_result - buffer head to be mapped on
> - * @create - indicate whether allocating the block or not when it has not
> + * @inode: inode struct of the target file
> + * @blkoff: file block number
> + * @bh_result: buffer head to be mapped on
> + * @create: indicate whether allocating the block or not when it has not
>   *      been allocated yet.
>   *
>   * This function does not issue actual read request of the specified data
> @@ -138,8 +138,8 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
>  /**
>   * nilfs_readpage() - implement readpage() method of nilfs_aops {}
>   * address_space_operations.
> - * @file - file struct of the file to be read
> - * @page - the page to be read
> + * @file: file struct of the file to be read
> + * @page: the page to be read
>   */
>  static int nilfs_readpage(struct file *file, struct page *page)
>  {
> @@ -957,6 +957,8 @@ int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
>  /**
>   * nilfs_dirty_inode - reflect changes on given inode to an inode block.
>   * @inode: inode of the file to be registered.

> + * @flags: tell the filesystem if we just updated timestamp(I_DIRTY_SYNC)
> + *     or anything else

Thanks for the patch.
Could you please modify the description of the 'flags' argument ?

This flag is used in nilfs2 to determine if a data sync is enough or
metadata needs to be updated together.   "just updated timestamp" is assigned
to I_DIRTY_TIME in kernel, but the current nilfs2 implementation does not
distinguish this (i.e. lazytime is not supported).

How about "flags to determine the dirty state of the inode" as a generic
description of the argument ?
I think the detailed behavior should be written in the later function spec
part if we explain it.

Other than that, it looks good to me.

Thanks,
Ryusuke Konishi


>   *
>   * nilfs_dirty_inode() loads a inode block containing the specified
>   * @inode and copies data from a nilfs_inode to a corresponding inode
> --
> 2.20.1.7.g153144c
>
