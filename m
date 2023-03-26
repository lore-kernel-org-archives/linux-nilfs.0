From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix incomplete initialization in nilfs_direct_assign_p()
Date: Sun, 26 Mar 2023 16:38:48 +0900
Message-ID: <CAKFNMokJ0_n6y3Wrc87WfhKA02ay4dqP7R_4XnonqDCj_Tuqcg@mail.gmail.com>
References: <0000000000000d710705f63f014c@google.com> <6c1d39bc-b19b-becf-821e-8cc9db8b4167@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679816345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1qkueFPEburKL4fcmEm1XFr6AUNk26OA4X3ROKq40A=;
        b=bIZeluxnQimqBzImm8//QWIaxoJyb+DG5Oo0XP5rHet5DfQDymuNgiHmHQYNI2OlnO
         Oc3PRzDvAn6iAx+dbAXvkDmIgZyzEr++WOlx0X6obYQx5GIudB7f75bvtNfvYF3K2Hf0
         K0FnWw7OZu8W+Co97kd34m6D7NyC442ntwSMfaS7MlxqjX+FjiyyRTJ1I0lTk0Ru7UpH
         kLnsHSB1r9Z88t5+ztIfowKzVkGVDIFyxnWZayzMEdLF+p8FsU+XBrGgyMfUrsSGiZfs
         Dj53+r9xPw2K8k33rm5e+o7h2GB7tRQkw9M1eUdiF1ieUcDi+A0kKTv37MkVsReJYK+6
         jebg==
In-Reply-To: <6c1d39bc-b19b-becf-821e-8cc9db8b4167-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Mar 26, 2023 at 3:32=E2=80=AFPM Tetsuo Handa wrote:
>
> syzbot is reporting uninit value at nilfs_add_checksums_on_logs() [1], fo=
r
> nilfs_direct_assign_p() from nilfs_direct_assign() from nilfs_bmap_assign=
()
> does not initialize "struct nilfs_binfo_dat"->bi_pad field.
>
> We need to initialize sizeof("union nilfs_binfo"->bi_dat) bytes if
> nilfs_write_dat_node_binfo() from nilfs_segctor_assign() copies it
> and nilfs_add_checksums_on_logs() passes it to CRC function.
>
> Reported-by: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCf@public.gmane.org=
m>
> Link: https://syzkaller.appspot.com/bug?extid=3D048585f3f4227bb2b49b [1]
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> ---
> I'm not sure whether this can fix the bug, for a reproducer is not yet
> available...
>
>  fs/nilfs2/direct.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index a35f2795b242..4358b4581ec4 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -313,7 +313,8 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *d=
irect,
>         nilfs_direct_set_ptr(direct, key, blocknr);
>
>         binfo->bi_dat.bi_blkoff =3D cpu_to_le64(key);
> -       binfo->bi_dat.bi_level =3D 0;

> +       /* initialize bi_pad field together while assigning bi_level fiel=
d */
> +       *(u64 *) &binfo->bi_dat.bi_level =3D (u64) 0;

Could you change this just to the initialization using bi_pad below?

     memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));

This is not efficient depending on the compiler, but I'd rather avoid
the non-intuitive initialization using the above cast and use a
straightforward initialization.

This does not eliminate the problem, but it does fix one, so I'll send
it upstream.

Thanks,
Ryusuke Konishi
