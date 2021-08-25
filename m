From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: use refcount_dec_and_lock() to fix potential UAF
Date: Wed, 25 Aug 2021 11:47:56 +0900
Message-ID: <CAKFNMokz-rQsR8-XH+k-c-=GZszkf4DYk1dA3fsWvasT9zMqEA@mail.gmail.com>
References: <1629859428-5906-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJp2E9OwwxI977I3kKRlxPn5ABslKa7GmHyTOVcgaBg=;
        b=R+Y7MdXNHywssS0JS6aE5GvxlQq4ciNztCdfZ+HzjPt4OPV6/LcBvKiro7u5NGNPGo
         krOZg8VOL+mML+7QRysJdqzBU3XWqy1SvAdU/Oghaz23yNmApOtpegTcuQ18VINrwnz1
         f6RD9cyauGq3J7SJyTLTWR3zzYqLZBwMGLWnBJ41gLSiTEEdXZ0I7FDduNVxgVargBdM
         OkV8sDJ7Fi9cgeoFhLbjMmWeeKQP6B2D/hp2qoHkEm0wAtiOPnqZCUvLkWbweri/ruHW
         pERQ2bjSEbSyIlA0xgmdweVriRP2jvFpvvct9R1Iexu3Lo6G8V0yMDaxZ7KpuGtPn5sQ
         d9iA==
In-Reply-To: <1629859428-5906-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please queue this patch additionally for the next merge window.

Thanks,
Ryusuke Konishi

On Wed, Aug 25, 2021 at 11:43 AM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> When the refcount is decreased to 0, the resource reclamation branch is
> entered. Before CPU0 reaches the race point (1), CPU1 may obtain the
> spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root().
> Although CPU1 will call refcount_inc() to increase the refcount, it is
> obviously too late. CPU0 will release 'root' directly, CPU1 then accesses
> 'root' and triggers UAF.
>
> Use refcount_dec_and_lock() to ensure that both the operations of decrease
> refcount to 0 and link deletion are lock protected eliminates this risk.
>
>      CPU0                      CPU1
> nilfs_put_root():
>                             <-------- (1)
> spin_lock(&nilfs->ns_cptree_lock);
> rb_erase(&root->rb_node, &nilfs->ns_cptree);
> spin_unlock(&nilfs->ns_cptree_lock);
>
> kfree(root);
>                             <-------- use-after-free
>
> ========================================================================
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 2 PID: 9476 at lib/refcount.c:28 \
> refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
> Modules linked in:
> CPU: 2 PID: 9476 Comm: syz-executor.0 Not tainted 5.10.45-rc1+ #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
> RIP: 0010:refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
> ... ...
> Call Trace:
>  __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>  refcount_dec_and_test include/linux/refcount.h:333 [inline]
>  nilfs_put_root+0xc1/0xd0 fs/nilfs2/the_nilfs.c:795
>  nilfs_segctor_destroy fs/nilfs2/segment.c:2749 [inline]
>  nilfs_detach_log_writer+0x3fa/0x570 fs/nilfs2/segment.c:2812
>  nilfs_put_super+0x2f/0xf0 fs/nilfs2/super.c:467
>  generic_shutdown_super+0xcd/0x1f0 fs/super.c:464
>  kill_block_super+0x4a/0x90 fs/super.c:1446
>  deactivate_locked_super+0x6a/0xb0 fs/super.c:335
>  deactivate_super+0x85/0x90 fs/super.c:366
>  cleanup_mnt+0x277/0x2e0 fs/namespace.c:1118
>  __cleanup_mnt+0x15/0x20 fs/namespace.c:1125
>  task_work_run+0x8e/0x110 kernel/task_work.c:151
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
>  exit_to_user_mode_prepare+0x13c/0x170 kernel/entry/common.c:191
>  syscall_exit_to_user_mode+0x16/0x30 kernel/entry/common.c:266
>  do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> There is no reproduction program, and the above is only theoretical
> analysis.
>
> Fixes: ba65ae4729bf ("nilfs2: add checkpoint tree to nilfs object")
> Link: https://lkml.kernel.org/r/20210723012317.4146-1-thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> Signed-off-by: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/the_nilfs.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 8b7b01a380ce..c8bfc01da5d7 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -792,14 +792,13 @@ struct nilfs_root *
>
>  void nilfs_put_root(struct nilfs_root *root)
>  {
> -       if (refcount_dec_and_test(&root->count)) {
> -               struct the_nilfs *nilfs = root->nilfs;
> +       struct the_nilfs *nilfs = root->nilfs;
>
> -               nilfs_sysfs_delete_snapshot_group(root);
> -
> -               spin_lock(&nilfs->ns_cptree_lock);
> +       if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
>                 rb_erase(&root->rb_node, &nilfs->ns_cptree);
>                 spin_unlock(&nilfs->ns_cptree_lock);
> +
> +               nilfs_sysfs_delete_snapshot_group(root);
>                 iput(root->ifile);
>
>                 kfree(root);
> --
> 1.8.3.1
>
