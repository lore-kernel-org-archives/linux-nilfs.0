From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: make splice write available again
Date: Sun, 24 Jan 2021 00:12:06 +0900
Message-ID: <CAKFNMo=oenxiKHcHOLFC0Zvd2kPfaTkkvQ+8t+tgk0PxqOVb7w@mail.gmail.com>
References: <YAwwjEuHpfeFDqNo@localhost.localdomain> <FR2P281MB0283D8B316988BB9F697BF3BB2BF0@FR2P281MB0283.DEUP281.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UU81y8dveKelR/fniJfeNc03EvT3KGTF4ErSDi7GL9M=;
        b=arlV8hvLpgLi2Y2mwgZSsCL/25k6ejP4m5oYu+yooqAfRLy+QDphrrh1lI1p0XtFST
         9PE5fzCDxWWklVOlbHLcjbLR0ctZ4iG2H93q8ZW1sIcuY4sC/9wKrtn9zVDBNFAka2q6
         TpOwhuLBg4EE93TDIVg8b19S0l030KBOyR5cN4YnK11/hbOL0T2ZaV4HdHCNhT7U3hsn
         muVP4QYD2eD1TObujQrBIUIC2A0jNrEsiuqaFMZ1tPbeujG4AKdt72ZbRGJOq+HoZdSn
         KBizwiYWkbhKSwmVYhTNtuBrGm+g2SMIm82fjT7X7X1+apUJPpIqN/XMlQvvaIB1OzIM
         p3ag==
In-Reply-To: <FR2P281MB0283D8B316988BB9F697BF3BB2BF0-0R0NmFYGjNp7RG94T+8yUSiYi8Yelr1yiGd9ebBGJoev3QGu/rdwKA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joachim.Henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

Thank you for quick patch submission.   It looks good at a glance.
I will check the details of the change and will try testing.

Thanks,
Ryusuke Konishi

On Sat, Jan 23, 2021 at 11:39 PM <Joachim.Henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org> wrote:
>
> Since 5.10, splice() or sendfile() to NILFS2 return EINVAL. This was
> probably caused by commit 36e2c7421f02 ("fs: don't allow splice
> read/write without explicit ops").
>
> This patch initializes the splice_write field in file_operations, like
> most file systems do, to restore the functionality.
>
> Signed-off-by: Joachim Henke <joachim.henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>
> ---
>  fs/nilfs2/file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 64bc81363c6cc..4c7a662047513 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -141,6 +141,7 @@ const struct file_operations nilfs_file_operations = {
>         /* .release     = nilfs_release_file, */
>         .fsync          = nilfs_sync_file,
>         .splice_read    = generic_file_splice_read,
> +       .splice_write   = iter_file_splice_write,
>  };
>
>  const struct inode_operations nilfs_file_inode_operations = {
