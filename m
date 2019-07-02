From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 4/4] vfs: don't allow most setxattr to immutable files
Date: Tue, 2 Jul 2019 13:45:32 +0300
Message-ID: <CAOQ4uxizFXgSa4KzkwxmoPAvpiENg=y0=fsxEC1PkCX5J1ybag@mail.gmail.com>
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
 <156174690758.1557469.9258105121276292687.stgit@magnolia> <20190701154200.GK1404256@magnolia>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlidC+hQ/gD/8v9eleM4nXtfiap8zhCG0j5qbLCVw18=;
        b=kdVby+/PzZu5i6Y9UcQYatHEHHsEPhAQY+mjVHF6xlggt8o+nszbdHXCHfEBil5H5H
         UL+/28eYKfUAOv8AvNzRMQHWK/y4MABFSamQhRwNZH1hpEc5BUQCjqITvhev6DLWRzG3
         uOgpinFcBt7pSePpbwiWspS3cbj7dBXMod+4Z94YngJ+nIPc3qdhbsYftXAC3oBGhakE
         Bt+6iCjbrfqQEg0SzB1WdrzlyuHEb0JfhuYdop7KFU8fbo4QPvOCj4+Z+NVkWFYsg5RT
         IRHHoit1jxeDZWaJHULPmpdSPTutxwczS9nSE3h7MYk2MPhM/kHniCv9ovLGXWy3LfTv
         lmfQ==
In-Reply-To: <20190701154200.GK1404256@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: matthew.garrett@nebula.com, Chao Yu <yuchao0@huawei.com>, Theodore Tso <tytso@mit.edu>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@infradead.org>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel

On Mon, Jul 1, 2019 at 7:31 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> The chattr manpage has this to say about immutable files:
>
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
>
> However, we don't actually check the immutable flag in the setattr code,
> which means that we can update inode flags and project ids and extent
> size hints on supposedly immutable files.  Therefore, reject setflags
> and fssetxattr calls on an immutable file if the file is immutable and
> will remain that way.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: use memcmp instead of open coding a bunch of checks


Thanks,

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
>  fs/inode.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index cf07378e5731..31f694e405fe 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2214,6 +2214,14 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
>             !capable(CAP_LINUX_IMMUTABLE))
>                 return -EPERM;
>
> +       /*
> +        * We aren't allowed to change any other flags if the immutable flag is
> +        * already set and is not being unset.
> +        */
> +       if ((oldflags & FS_IMMUTABLE_FL) && (flags & FS_IMMUTABLE_FL) &&
> +           oldflags != flags)
> +               return -EPERM;
> +
>         /*
>          * Now that we're done checking the new flags, flush all pending IO and
>          * dirty mappings before setting S_IMMUTABLE on an inode via
> @@ -2284,6 +2292,15 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
>             !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
>                 return -EINVAL;
>
> +       /*
> +        * We aren't allowed to change any fields if the immutable flag is
> +        * already set and is not being unset.
> +        */
> +       if ((old_fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
> +           (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
> +           memcmp(fa, old_fa, offsetof(struct fsxattr, fsx_pad)))
> +               return -EPERM;
> +
>         /* Extent size hints of zero turn off the flags. */
>         if (fa->fsx_extsize == 0)
>                 fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
