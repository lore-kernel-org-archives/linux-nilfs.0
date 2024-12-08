Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560717E0;
	Sun,  8 Dec 2024 07:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733643331; cv=none; b=N2YX5FXNwYGFAFkdMAL/J0WXmu3vNcOx9Vv6ZOjvBzduORDXkZn/1ppc3Y/hknF2O3ZaMVEHVmsXP66Ab38VH76fwn+qCyLWvFnJB8HPt5QVBrUvTHhc9EzyAAJVZEfS1cRN7UICFv7KvkZTVsAyxp3eSdrafU6xCC5GbxQtGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733643331; c=relaxed/simple;
	bh=Hucn9bxfDGRTPJNGS47AluoMNQBuEYqLzddrXPpZ0xE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kC919GHS8zB3gKwPZkSaeH6ImEXOqCJhtsYPMSpX34ztvdZElGa08vwjdSihH9A2AYLgh3uC2eeIBAGWC+lYJtm2wdr2JgkmUoALFrAMDxb3QlGI1TB2hXedRQFt8uicI+XEw6YFRQOb68NfJ640RAuekHZuErGJFZQ40pJn/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cxSal/Zd; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxSal/Zd"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53f22fd6887so644525e87.2;
        Sat, 07 Dec 2024 23:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733643328; x=1734248128; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fY7qGesbibkcNu2KJVRQuqZ1WodotY0lFTcIg7AvUJA=;
        b=cxSal/ZdL+5Tyu82ANXCjldDfRO/ui211GMsnuG41Sob0k/jt1s3VGSYqc1TlbqhE7
         4hGHUUnpPclgxd2z2E9jg7F0+ztUEJdDPb1IbyeEGEFlSP3uBbKbm3USaEJzi405OsJ0
         cUvTEK22MioIJjyA1nCc/J/05GVyR5cOtp2wey8+OcUgqVd7PGpTj41wSGgJNCL8ORI9
         m9ZKLUxWebnzLkeV0sF22QcySkV16ljbxeTXxOmKZdxsjTNAO4G5avw8LyjM1ALnvvLe
         arDx9U79G0bNxZ3f+CdDYhyEmExMmQFpXUwwGz6Bx01qPCpd7ErW+FYB3YX7dmqJWd8w
         t/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733643328; x=1734248128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fY7qGesbibkcNu2KJVRQuqZ1WodotY0lFTcIg7AvUJA=;
        b=TxZ/yISCFTKtk5LpOxqJY4F+quwIHWxtnANCBv+br+upyCIPuebI38Zz9rIBNFE/kd
         m3byiqyAr6crrHJVR2WxzPEa8EM0+lNJQ6ciRBUVHG2qPssg4fUfJfiQfjPmWjhEgnAb
         HwBCz7LmuM+HBMTrZDq4TQvsouOmSy9nBdefFYvqI5Ah3/qEm987D3Y+/jLyQt+Wd14W
         hhGNc9XgtMJyQsgbBWa965MrgZTXq0EX2iBRCtif87o122gtAIbwQLE37mCWqFzu/b8F
         0AviwCcZXChCxrTJeeIKBN8vQUatCsH01yNJ4JkihumAdrO0hiSH5qGkwnZH0ydKq6lv
         OYOg==
X-Forwarded-Encrypted: i=1; AJvYcCXr6d8cwxEF/JruL9zTWBFiEvf9kjFXD232n74fBJ9PK96zz+YsmqlC34X1ACO8/kApgp8/Mw+Ihl+VZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKWiQi2Hqc67PmTd+9ypKhAbxJKpH6l5MMdWhXhx8nVLf/ZFPR
	Dw9yK5OV+ieDiRncU+hzIQ9h//9bdq9+fTvtyPlC3II+lWkT/GxhHo+4KF9rCNHGkyQJmRUjqv0
	GUOOos/iqUog9OctjQZSoahYxJ+jAr5O+
X-Gm-Gg: ASbGncslWTcNnXO6y+eQSGSZbA87RNwbSD7xWKjSNH1B1q17PFFRNvSfsfANt2nEXuv
	8lFdHyDKhaMChDrJvsaLnxhxlvunmcknmpqMeeAPGjq6wold18GBT44oUrJd1dDIl3A==
X-Google-Smtp-Source: AGHT+IF2QVRqqUOkkuM2pTorcVxWbBN0+TdDVa7I6sCf413vCKcGkrAMlZKR8kLbcuE6kjicxm0eYu99eQCMs/tA1KU=
X-Received: by 2002:a05:6512:3e15:b0:53e:38df:673d with SMTP id
 2adb3069b0e04-53e38df6949mr2905512e87.43.1733643327326; Sat, 07 Dec 2024
 23:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMo=ck+c2NJHVOFszzT02ksF1a0KG9vA5zU+Woa7noLeFrA@mail.gmail.com>
 <tencent_95592538BA04BB7933F79E351B014BE51B08@qq.com>
In-Reply-To: <tencent_95592538BA04BB7933F79E351B014BE51B08@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 8 Dec 2024 16:35:11 +0900
Message-ID: <CAKFNMo=KEwmuU1NUWY2u9ficfW+b1NwjkHJEST8sf6qvS-u=AQ@mail.gmail.com>
Subject: Re: [PATCH V3] nilfs2: prevent use of deleted inode
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 8, 2024 at 3:00=E2=80=AFPM Edward Adam Davis wrote:
>
> syzbot reported a WARNING in nilfs_rmdir. [1]
>
> Because the inode bitmap is corrupted, an inode with an inode number
> that should exist as a ".nilfs" file was reassigned by nilfs_mkdir for
> "file0", causing an inode duplication during execution.
> And this causes an underflow of i_nlink in rmdir operations.
>
> The inode is used twice by the same task to unmount and remove directorie=
s
> ".nilfs" and "file0", it trigger warning in nilfs_rmdir.
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
> Reported-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9260555647a5132edd48
> Tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: Adjust the patch as suggested by Ryusuke Konishi
> V2 -> V3: Modify the input parameters of nilfs_error and split Reported-a=
nd-tested_by
>
>  fs/nilfs2/inode.c | 8 +++++++-
>  fs/nilfs2/namei.c | 5 +++++
>  2 files changed, 12 insertions(+), 1 deletion(-)

Thank you for your help.  I'll adopt this and send it upstream after
running tests that include more than just the reproducer.

Thanks,
Ryusuke Konishi

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
> index 9b108052d9f7..1d836a5540f3 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -67,6 +67,11 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry,=
 unsigned int flags)
>                 inode =3D NULL;
>         } else {
>                 inode =3D nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino=
);
> +               if (inode =3D=3D ERR_PTR(-ESTALE)) {
> +                       nilfs_error(dir->i_sb,
> +                                       "deleted inode referenced: %lu", =
ino);
> +                       return ERR_PTR(-EIO);
> +               }
>         }
>
>         return d_splice_alias(inode, dentry);
> --
> 2.47.0
>
