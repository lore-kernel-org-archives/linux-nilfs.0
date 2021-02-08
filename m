From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: make splice write available again
Date: Mon, 8 Feb 2021 20:50:01 +0900
Message-ID: <CAKFNMok_h7pDFmy-h3DALawpUkTK=diHBUAGGP5eRhpMY2EUQA@mail.gmail.com>
References: <1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hQUMprtetu+UvLxropQiA6dOXEkpGb4/+OXA3Y0o2E=;
        b=QKMeCXB1QLNt7s9DCwOXXLyDLXDCgN2X72vq5cR34jUvunGX4bpBduSNxPcjLmejcv
         TyToD8AWUPl5fClQUJKSlDNUKb/slnnTY8EzIMVN9ams4qqpOQS36XjPwYfq9PNPlJT9
         /TcnA9WJKPd5fIMdbAAWXFDP9QGKpNP4HHqcJZ30ni0nkN+SYbQgkCC1lCCfvXF7RoCE
         UVqxun7bYK26oO9LKR61Sc16rDewwgv8/l48ZH0o+sfkTrPzQaBJgreHmz6UIbXcLbTx
         TVn/Y8GclXvtgCRwxOVRkudEpCT0pX3WysvScSzGEDSD73ymGm1ja1lnMenp3ea8QX3W
         S6Uw==
In-Reply-To: <1612784101-14353-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please send this to upstream.  This fixes a regression of splice() on nilfs2.

Thanks,
Ryusuke Konishi

On Mon, Feb 8, 2021 at 8:35 PM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Joachim Henke <joachim.henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>
>
> Since 5.10, splice() or sendfile() to NILFS2 return EINVAL. This was
> caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
> without explicit ops").
>
> This patch initializes the splice_write field in file_operations, like
> most file systems do, to restore the functionality.
>
> Signed-off-by: Joachim Henke <joachim.henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.10+
> ---
>  fs/nilfs2/file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 64bc81363c6c..e1bd592ce700 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -141,6 +141,7 @@ static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
>         /* .release     = nilfs_release_file, */
>         .fsync          = nilfs_sync_file,
>         .splice_read    = generic_file_splice_read,
> +       .splice_write   = iter_file_splice_write,
>  };
>
>  const struct inode_operations nilfs_file_inode_operations = {
> --
> 1.8.3.1
>
