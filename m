From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
Date: Sun, 26 Mar 2023 21:51:57 +0900
Message-ID: <CAKFNMokp_mRP2mWTKBZZZ=QuiWWwVb+tDfhD6XrE4xcucSBq0A@mail.gmail.com>
References: <0000000000000d710705f63f014c@google.com> <6c1d39bc-b19b-becf-821e-8cc9db8b4167@I-love.SAKURA.ne.jp>
 <CAKFNMokJ0_n6y3Wrc87WfhKA02ay4dqP7R_4XnonqDCj_Tuqcg@mail.gmail.com>
 <1103c7b0-0e46-4a92-74ee-920bf9599a80@I-love.SAKURA.ne.jp> <85f48e7e-a1dc-69ac-4e28-7449036cc8b3@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679835134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=82K7b4UZGSbufNasMeAJ1MlSiuU4N9WB+LwOslC2/tg=;
        b=Olpmyt0wegSXXCZ7UsovSYO868k8YS187MZSZfH/CeuhcGyebTgAURtNJejzL07eb+
         2tAXPlN1ZcpwVblWK7XxM1I8l9rZX34C2frHeQ3DRz1Gh1lScteUhu+jii1eQklpUR8A
         EnaDW52JZ3iGBbBDyOxCHQjhOWmvtxNAlMhcXuZPBTAfmRwZ0AJmuCRjCERS2aPqNhwo
         9QRs6fHm+Iq3il4yXmZnwCBdu5eNBbs9aqx5Vu40FcbE57g8+YICgxSJSLzOBTZ/6Z+I
         LFgsH4gBMOf8sXKet/atQ55kVxp9NcH8M9x1JoSfCfFxvkMdLmkTdQ8tH85HefRd2bb8
         ekZg==
In-Reply-To: <85f48e7e-a1dc-69ac-4e28-7449036cc8b3-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Mar 26, 2023 at 7:27=E2=80=AFPM Tetsuo Handa wrote:
>
> nilfs_btree_assign_p() and nilfs_direct_assign_p() are not initializing
> "struct nilfs_binfo_dat"->bi_pad field, causing uninit-value reports
> when being passed to CRC function.
>
> Reported-by: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCf@public.gmane.org=
m>
> Link: https://syzkaller.appspot.com/bug?extid=3D048585f3f4227bb2b49b
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> ---
> Changes in v3:
>   Also fix nilfs_btree_assign_p().
>
> Changes in v2:
>   Use memset() for initialization, suggested by Ryusuke Konishi.
>
>  fs/nilfs2/btree.c  | 1 +
>  fs/nilfs2/direct.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 2681a449edc1..13592e82eaf6 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -2219,6 +2219,7 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *=
btree,
>         /* on-disk format */
>         binfo->bi_dat.bi_blkoff =3D cpu_to_le64(key);
>         binfo->bi_dat.bi_level =3D level;
> +       memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
>
>         return 0;
>  }
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index a35f2795b242..4c85914f2abc 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -314,6 +314,7 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *d=
irect,
>
>         binfo->bi_dat.bi_blkoff =3D cpu_to_le64(key);
>         binfo->bi_dat.bi_level =3D 0;
> +       memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
>
>         return 0;
>  }
> --
> 2.34.1

Thank you for your cooperation, Handa-san.

I'll send this upstream, adding a Reported-by tag of the preceding report.

Thanks,
Ryusuke Konishi
