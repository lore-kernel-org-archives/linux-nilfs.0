Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03697BA4B;
	Sun,  8 Dec 2024 04:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733632776; cv=none; b=kUTOHISMvO0r+tbeuz0E566NimWAXt3nac0IcebdLTWovayrsje9IcX98sl9MB0GxWdyKjt3E/7AWyzYCPJYbZ6DISVy8p/5XtzySFonKsm2F3yPRqsWTzSEEXgPqz3E2EmiOsopBeTdv31PTjXNn+tMvjktlNv5Ha9ipWIW25s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733632776; c=relaxed/simple;
	bh=pkkzHq6er3jft3L8kNA49RK8jL7CCMKkFfUZBulzWLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NLUuYYj0RI24TBDyQjvI4JLsqjDWUAU28jC+A503IetQBXDiZW7cybZiUCY0qrZ13n9dfC5CkzQN6A8y8U+Dalte9n+xlzVJu1mlix0PQqdqIHsUWRij/BP7HLiPgxGGgyzuwreltmXUzE5r5lY+9hQK5jj6KivOT7wd3KFRHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EqSecl9h; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqSecl9h"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ffc1009a06so28186381fa.2;
        Sat, 07 Dec 2024 20:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733632773; x=1734237573; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDmA4E/w7Y1zlmTtPBdUx0AO+F4OE6eC+B0K2GmURIg=;
        b=EqSecl9htYSG7zbVrNYM6wDeovBsWXA7cV/dSiQvfjHGXMK+iA8Hv6nxww5h3SNgM9
         Rn49MbCUz/y5fkvWWGfAZJcdhu/BsD0ub1N+FseGebcPq+GhUhoov5agtw1xTirKmuMB
         t4Cf7VcTOR/6ELSYT/nTXNBnPwr5Pk31BiH7pi/rfZmTloDysyvR+Cao/z/E0oLq6pcp
         FYfJdkgkNvoUzRVLh7QcGGMBgwdST5omz5fjiQ0ys50QMbeaFcWq4a7fiUqRXK6D+yn3
         kKLQ6lZ2NXrAseCJW57bS8iWs/p9mQJ9X9xK21WQxWxKAcvT1lJFheJt1J1p7T+Q0BGS
         mVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733632773; x=1734237573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDmA4E/w7Y1zlmTtPBdUx0AO+F4OE6eC+B0K2GmURIg=;
        b=WsAFYN42Jc7QKzfG88GUg/unfT2FmQgnYOqIsmba8AFVStP8eUsojTMjPp/USZ5f1n
         gcwOLEZwy7jfbIZ6Kp0zHNCWaEvHFe2mVhnqdBaUZl8M1Ri9Nwn6GZKcxKbORdRaK59G
         k/sMy88Y/KIQb603mucgTnyBhuBnhaE7vdz9JB3syYMVwriWwLaJ/twZuenIivIFsN52
         UMJHt5jP7Ufw+FcWzPuaJ6PsU1Qo05oO7aiKwu9rKlsA/bXsBZoaTMyHwS/+WayiykeJ
         Olax89vcyPyxHNyLgKmAkzuQCDiSWWIn11eNBiYLZuou0gHwD7HgS2uJqCslyATxXxzR
         GObA==
X-Forwarded-Encrypted: i=1; AJvYcCVOuJ7iuLAOIrzYVaPhaxwSGmNvbnl1r0XC52SrLi+AlHOprIM1ZizFZGdn5C72pw0TX4vINB/UzQIReg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+32w5AHAjlEruIXEVT5ejKkzsVC3uxoDk/0C79zdXwWtNqWfd
	UWBOFl8haNFQkvWQqxlFiDUxYoItb6utZOCKOyj7jdJ0JMX+QmA7MOEdxZPxy+qo6B+0KcgIHfz
	yk9WNAOgh/+CBIoRhr68ko0UG+yY=
X-Gm-Gg: ASbGncsEB/Rwq8e6TxT71QN67e/1ff95OjqbHowwHhzBcRzGtAXYGxa8TupLW3lAiVT
	zlRKaD/TMw4ECuUShkvOYN3dUXJA/16UaZx4Nc1R5owu7RHwNvdEpD+iKQsMu05IysQ==
X-Google-Smtp-Source: AGHT+IECUaVU4zV83VhdiZTVoCAwk2dTu2ZTEAm1nhXbNLEnl9L8XmVPln1y96NovN6Jw0Hv9+KIXA2jbhkULqHHBk4=
X-Received: by 2002:a05:6512:1589:b0:540:17ac:b372 with SMTP id
 2adb3069b0e04-54017acb52cmr637150e87.30.1733632772848; Sat, 07 Dec 2024
 20:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMono7BGpLOOjF1TcUpj7GM=x-aATHUv+fCXTs6=WVhYMUw@mail.gmail.com>
 <tencent_B7D4EAEAED76CDAC79026EF02F4D6D5C950A@qq.com>
In-Reply-To: <tencent_B7D4EAEAED76CDAC79026EF02F4D6D5C950A@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 8 Dec 2024 13:39:16 +0900
Message-ID: <CAKFNMo=ck+c2NJHVOFszzT02ksF1a0KG9vA5zU+Woa7noLeFrA@mail.gmail.com>
Subject: Re: [PATCH V2] nilfs2: prevent use of deleted inode
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 8, 2024 at 12:24=E2=80=AFPM Edward Adam Davis wrote:
>
> syzbot reported a WARNING in nilfs_rmdir. [1]
>
> Because the inode bitmap is corrupted, an inode with an inode number
> that should exist as a ".nilfs" file was reassigned by nilfs_mkdir for
> "file0", causing an inode duplication during execution.
> And this causes an underflow of i_nlink in rmdir operations.
>
> Avoid to this issue, check i_nlink in nilfs_iget(), if it is 0, it means
> that this inode has been deleted, and iput is executed to reclaim it.
>
> [1]
> WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inod=
e.c:407
> Modules linked in:
> CPU: 1 UID: 0 PID: 5824 Comm: syz-executor223 Not tainted 6.12.0-syzkalle=
r-12113-gbcc8eda6d349 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 09/13/2024
> RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
> Code: bb 70 07 00 00 be 08 00 00 00 e8 57 0b e6 ff f0 48 ff 83 70 07 00 0=
0 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 9d 4c 7e ff 90 <0f> 0b 90 eb 83=
 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
> RSP: 0018:ffffc900037f7c70 EFLAGS: 00010293
> RAX: ffffffff822124a3 RBX: 1ffff1100e7ae034 RCX: ffff88807cf53c00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff82212423 R09: 1ffff1100f8ba8ee
> R10: dffffc0000000000 R11: ffffed100f8ba8ef R12: ffff888073d701a0
> R13: 1ffff1100e79f5c4 R14: ffff888073d70158 R15: dffffc0000000000
> FS:  0000555558d1e480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555558d37878 CR3: 000000007d920000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
>  vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
>  do_rmdir+0x3b5/0x580 fs/namei.c:4453
>  __do_sys_rmdir fs/namei.c:4472 [inline]
>  __se_sys_rmdir fs/namei.c:4470 [inline]
>  __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>

I'll make a few comments.

> Reported-and-tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail=
.com

First please separate "Reported-and-tested-by" into two tags.
Although it is still seen occasionally, it causes warnings for the
checkpatch script. (It has already been explicitly deprecated in some
subtrees, because it just complicates automatic tag extraction.)

> Closes: https://syzkaller.appspot.com/bug?extid=3D9260555647a5132edd48
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: Adjust the patch as suggested by Ryusuke Konishi
>
>  fs/nilfs2/inode.c | 8 +++++++-
>  fs/nilfs2/namei.c | 6 ++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index cf9ba481ae37..b7d4105f37bf 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -544,8 +544,14 @@ struct inode *nilfs_iget(struct super_block *sb, str=
uct nilfs_root *root,
>         inode =3D nilfs_iget_locked(sb, root, ino);
>         if (unlikely(!inode))
>                 return ERR_PTR(-ENOMEM);
> -       if (!(inode->i_state & I_NEW))
> +
> +       if (!(inode->i_state & I_NEW)) {
> +               if (!inode->i_nlink) {
> +                       iput(inode);
> +                       return ERR_PTR(-ESTALE);
> +               }
>                 return inode;
> +       }
>
>         err =3D __nilfs_read_inode(sb, root, ino, inode);
>         if (unlikely(err)) {
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 9b108052d9f7..7037f47c454f 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -67,6 +67,12 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry,=
 unsigned int flags)
>                 inode =3D NULL;
>         } else {
>                 inode =3D nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino=
);
> +               if (inode =3D=3D ERR_PTR(-ESTALE)) {

> +                       nilfs_error(dir->i_sb, __func__,
> +                                       "deleted inode referenced: %lu",
> +                                       (unsigned long) ino);

Unlink ext2_error(), nilfs_error() does not require __func__, to be
passed as an argument.
nilfs_error() is a wrapper macro for the actual error output function
__nilfs_error(), which hides __func__ there.
(I should have mentioned the difference, sorry.)

Another comment:  "ino" is of type "ino_t", which is of type "unsigned
long", so the typecast to "unsigned long" for the argument "ino" is
not necessary.
I don't know why the ext2 implementation does it, but even if this
patch is backported to stable trees, this typecast is not necessary.

Thanks,
Ryusuke Konishi

> +                       return ERR_PTR(-EIO);
> +               }
>         }
>
>         return d_splice_alias(inode, dentry);
> --
> 2.47.0
>
