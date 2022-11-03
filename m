From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs: Avoid use-after-free caused by nilfs->ns_writer
Date: Fri, 4 Nov 2022 03:56:19 +0900
Message-ID: <CAKFNMonawKi4b4G1d3CfJ6-+NLFOqVkHzNOO_5DocAJxGnkz7A@mail.gmail.com>
References: <20221103141759.1836312-1-syoshida@redhat.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M8ZxHqehtSCexx7BuFI+vfJrqxKMqvMHNZW3sS2W088=;
        b=hzVuz5H1Uuyy09qJnT5S06m90RimROo1ozi4238CG0WyXBBA2ahhB0DALa4dpmelRB
         48BZQzxH3RpCyvXiIL9Bo3KXdgY1hiK2SSS2j//wwyJ1Tc90BZgXsg7Slqi00T6efCAs
         5mgn/lU1S1wkmZ8993YnKF2QbGB54EiwUUXKuKnQAdWVTFqMDhKVKWGAKVzXjMGyASto
         kKJC9470nqwB0l3e5TAmZUI+rMZ0yUIL8ML2Upaobi+xrb1W8AzEZM/LOtpJS7JnSwyI
         xZB5VQGZLRxijAeedTSvRPw9lwiqwVzNujzDTE44+HuNCxTSOK+Jgq0gDwUeCLZc+miY
         6ETA==
In-Reply-To: <20221103141759.1836312-1-syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Thu, Nov 3, 2022 at 11:18 PM Shigeru Yoshida wrote:
>
> syzbot reported use-after-free in nilfs_segctor_sync() [1].
>
> The use-after-free occurs with nilfs->ns_writer.  The scenario for the
> issue is as follows:
>
> Task1                                   Task2
> ----------------------------------------------------------------------
> nilfs_construct_segment
>   nilfs_segctor_sync
>     init_wait
>     init_waitqueue_entry
>     add_wait_queue
>     schedule
>                                         nilfs_detach_log_writer
>                                           nilfs_segctor_destroy
>                                             kfree
>     finish_wait
>       _raw_spin_lock_irqsave
>         __raw_spin_lock_irqsave
>           do_raw_spin_lock
>             debug_spin_lock_before  <-- use-after-free
>
> While Task1 is sleeping, nilfs->ns_writer is freed by Task2.  After
> Task1 waked up, Task1 accesses nilfs->ns_writer which is already
> freed.
>
> This patch fixes the issue by taking nilfs->ns_segctor_sem in
> nilfs_construct_segment() so that nilfs->ns_segctor_sem cannot be
> freed while nilfs_segctor_sync() is sleeping.
>
> Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b [1]
> Reported-by: syzbot+f816fa82f8783f7a02bb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> Signed-off-by: Shigeru Yoshida <syoshida-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nilfs2/segment.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index b4cebad21b48..d4f10d82664d 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2239,16 +2239,24 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
>  int nilfs_construct_segment(struct super_block *sb)
>  {
>         struct the_nilfs *nilfs = sb->s_fs_info;
> -       struct nilfs_sc_info *sci = nilfs->ns_writer;
> +       struct nilfs_sc_info *sci;
>         struct nilfs_transaction_info *ti;
> +       int ret;
>
> -       if (!sci)
> +       down_write(&nilfs->ns_segctor_sem);
> +       sci = nilfs->ns_writer;
> +       if (!sci) {
> +               up_write(&nilfs->ns_segctor_sem);
>                 return -EROFS;
> +       }
>
>         /* A call inside transactions causes a deadlock. */
>         BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
>
> -       return nilfs_segctor_sync(sci);
> +       ret = nilfs_segctor_sync(sci);
> +       up_write(&nilfs->ns_segctor_sem);
> +
> +       return ret;
>  }
>
>  /**
> --
> 2.37.3
>

Thank you for your help Yoshida-san.

Your analysis of the bug cause is quite correct.

However, this patch caused deadlock for tests with fsync() or mkcp
command (i.e. nilfs_ioctl_sync).
They both call nilfs_construct_segment().
The approach implemented in this patch may not avoid the deadlock regression.

I'd like to consider other approaches.
My current thoughts are either to stop detaching ns_writer on remount
which is the root cause of the UAF races, or to introduce a refcount
on struct nilfs_sc_info.

Regards,
Ryusuke Konishi
