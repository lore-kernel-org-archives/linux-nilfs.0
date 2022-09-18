From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in kernfs_put_active
Date: Sun, 18 Sep 2022 19:19:01 +0900
Message-ID: <CAKFNMo=XjvQjoSo+N-MJGv5h4FPnjVm6bGaJm0QkO8GxjMNtTg@mail.gmail.com>
References: <00000000000095339805e8d6958e@google.com> <de81bf82-3ddf-4875-381d-e52949046b25@I-love.SAKURA.ne.jp>
 <f3b88739-148c-323c-2458-4b9d6bf9c592@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PTy2g9gMwuuuc0N3NJwfX+XF29AY4XkRQy1vR3LUZrU=;
        b=Yo2pJRKl/CGIzL3lppn5fWNXwRgwlgnKiTuPLtFOrVPaTBjHpWbRckNKv0TlID1KIH
         /XYfaXxqL4EAp9AeyrL52133nsiQRA7vtw2Ytzih/v3xECssowkHiVXkWY10LyGxRwtd
         ESvbj9Sis8BrwbMsqGH+MPjb30i8TlUyMnM4YfYyS8gcMhe+Oq/TcooXXdiP6Im6sgPy
         rIMracezU2cnI5SBKAzmO3X6c7ZZTxXGmVz907R8w1GgDvFYQNPAh9fvVby8/E2sbhIN
         /tfAunAPvfegkLF/Kpjq1Q5S08Y7oKlomcCxwLLiQzqTNNngU8f7fUgoK8+UkMAqYGRy
         MB6Q==
In-Reply-To: <f3b88739-148c-323c-2458-4b9d6bf9c592-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+258ad6d2cb6685e145bc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On Sun, Sep 18, 2022 at 3:26 PM Tetsuo Handa wrote:
> On 2022/09/18 0:50, Tetsuo Handa wrote:
> > I don't know whether crafted filesystem image is used is relevant to this problem.
> > But I think a bug is inside NILFS2 filesystem code.
>
> I confirmed that use of crafted filesystem image is irrelevant to this problem.
> You can reproduce this problem using fault injection patch
>
> ----------
> diff --git a/fs/inode.c b/fs/inode.c
> index ba1de23c13c1..dfde0cadd51e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -192,6 +192,10 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>         inode->i_wb_frn_history = 0;
>  #endif
>
> +       if (!strcmp(current->comm, "my_touch")) {
> +               inode->i_security = NULL;
> +               goto out;
> +       }
>         if (security_inode_alloc(inode))
>                 goto out;
>         spin_lock_init(&inode->i_lock);
> ----------
>
> and script which uses freshly created clean filesystem image.
>
> ----------
> cp -p /bin/touch my_touch
> dd if=/dev/zero of=nilfs.img bs=134221824 count=1
> mkfs.nilfs2 nilfs.img
> while date; do mount -o loop -t nilfs2 nilfs.img /mnt/; ./my_touch /mnt/file; umount -d /mnt/; done
> ----------
<snip>

Thank you for your help, Handa-san.

The first oops inserted by your injection patch is already reported by
[1], and the bug fix is queued in the for-next branch of vfs tree [2].
  Take a look at the patch titled "fs: fix UAF/GPF bug in
nilfs_mdt_destroy" in the
latest linux-next or vfs/for-next.

[1] https://lore.kernel.org/all/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/T/#u
 (report)
[2] https://lkml.kernel.org/r/20220816040859.659129-1-dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org
(vfs patch)

The correction was done for inode_init_always() instead of fixing
nilfs2.   Please refer to [3] for the background.

[3] https://lkml.kernel.org/r/20220815175114.23576-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
     (discussion of how to fix it.  The nilfs2 patch itself was withdrawn)

I confirmed that the patch [2] fixes the second oops as well.

I'm not sure if the patch [2] fixes the originally reported problem,
but it will be fixed if it's the same.

Thanks,
Ryusuke Konishi
