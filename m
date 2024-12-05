Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4DF14884D;
	Thu,  5 Dec 2024 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733414685; cv=none; b=JQQwJfnxI3QepAawdHhKrK+tePTGw8liyIMEUpBrm+82b+aze/o7hpKrwJKx2/Fwn2rNdfHYFhzyo/HDiFcMrF6PHMAsOuAQtgNJy6iT56EFn5rBJw79k70rwXtaokBWisVF779dvLdCFUhS3ZFdZv76dVP57vIRVOXkQT4yCn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733414685; c=relaxed/simple;
	bh=YHK3kKLjzVP79C2eoD6TLuj78hekZcfaS61KggCuwew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ho6feFJE9pKjQm16YzR8Xll+OAyuk8fBAZ2b7D9PFvBnNbIYnFd5GLzjmgcTJbW5/Wg530mEYsGwzSIegGaCOGvcV6CDhg0q+Sf3hwiaOF50K/dEl0uHhRVkx3pHSNh4ojsONoagqvvcpVEt1+pC4OlXE+bUcYHa6HoN0f2Kktk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLXjyeoU; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLXjyeoU"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53dd668c5easo1243305e87.1;
        Thu, 05 Dec 2024 08:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733414681; x=1734019481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aplLEwE6s73w0ScTt444QefNPlu1pqn7RShhjA/fjrg=;
        b=DLXjyeoUcy4PgCs1NJnA6G5uH6VHm8nnBr9c+2MrXPV/ov8XqReLAPq+55/VxwLK1E
         g9XKSAKSr3/yJUDvpZY8nHJouo2sEIyJGxFbiy3NHJWuwbGltoAjI4P69nOKwbwjwkxW
         alp737PPFnOWdkt7pzKErybvczgMARVPrPks0M1cEIdULinkyOyuYEQyxQqywaWEMaTX
         HH5bhtfOOa1FRufbI4U9R9LRmnZUvktcIoeHdHPlBQUEJYGZuQuXETD838guHQ4qtfmH
         tiLp4GZ6HdrYzLl2/PVojODH7+2NCY8l1zLk9ZiLrIWt2jhJDQ9uZ7GpU5byW0RiVReP
         00oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733414681; x=1734019481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aplLEwE6s73w0ScTt444QefNPlu1pqn7RShhjA/fjrg=;
        b=d4OPp+0cesnTBbCWP3LDvmFoCHiMA+vLbFC6xFOFyxv75Wuw9ksbHx6woWmz1H5ohT
         raowU6YQFkhacGPjjCqw0wJcTE2yVS8tOvLcMTPl8fQcoV7LVPdwHSMSPw1Lo2TKRGKz
         cBvHZo3xZ2GXcD3tCjuwioZCsjdsJsWm9eI3IKvAf3xrhjyylDNVxI3bAhHbtGxaO/Lt
         XSd42fFkqpxqUk3uC+cX4uuSu+QbbqcBHYK6BDGYyYjJvKwyBZ2FcrSsnJC/SJ2MAAh6
         vkuwmMCcddG3Wn6TN9EQW+kcR0p9pgBx+7vmbbQS4ThRRjf39+46l89Fuk9O6NFUZH5R
         BkhA==
X-Forwarded-Encrypted: i=1; AJvYcCVOHRPjc3v5Ypt35YyP/HEv48dKf142UGtV/OwYVSXzHbRQVFNDlcgaVwoXbePB94qbg8oHF91grEF7TDA=@vger.kernel.org, AJvYcCXvohO/eXFbifryO+IvJve9eZacxM9IDo7CnzSxw/uoCA8FjuRPVFmy6KfEx0sjwVNjt2Rhl5QrePBR4p0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2m6GpoHCWpKKZ/oX9DR4O0jyF9wrNpHnayATpttqZt41vBiSo
	BKfQlMoPXt9Z4MVpExJ+2UI5WsqS03Ey5WJlgzY72tLuBec85QDpvTKa0CFbx54rudYtRGqXQOm
	qWTiRCkHYQTUwzg+OtrdCv4LRtcw=
X-Gm-Gg: ASbGncvdjp2ll1Q9J4HtFuj6ejBafYnR+REmmONEL9dEnV2B7vlQ2aMbs0toFCLAsQ8
	QN+5zn2g/g7zNJp/42hzkhRDsW5bmA9iM/cIhe5wsRPQh4fGS45w85eV1ck+gjbMq9w==
X-Google-Smtp-Source: AGHT+IGveNvzUyE3o6rOiLwcrN5usTCvm7p9QbWkgisEgqAXYLWXCo6uvne4KOfWtBwIWwksUnx2ErSqyH20ekdZ9aU=
X-Received: by 2002:a05:6512:3082:b0:53e:1f5c:7196 with SMTP id
 2adb3069b0e04-53e216f755dmr1389991e87.2.1733414679538; Thu, 05 Dec 2024
 08:04:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <673e20ae.050a0220.3c9d61.0163.GAE@google.com> <tencent_F4C3B4644C977CF77226C95362E373897105@qq.com>
In-Reply-To: <tencent_F4C3B4644C977CF77226C95362E373897105@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 6 Dec 2024 01:04:23 +0900
Message-ID: <CAKFNMomAScDK6OBUn=+46=VRZCQMvipWtetX8SMVuLkHpVGvdg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: drop the inode which has been removed
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 9:26=E2=80=AFPM Edward Adam Davis wrote:
>
> syzbot reported a WARNING in nilfs_rmdir. [1]
>
> The inode is used twice by the same task to unmount and remove directorie=
s
> ".nilfs" and "file0", it trigger warning in nilfs_rmdir.
>
> Avoid to this issue, check i_size and i_nlink in nilfs_iget(), if they ar=
e
> both 0, it means that this inode has been removed, and iput is executed t=
o
> reclaim it.
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
> Reported-and-tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail=
.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9260555647a5132edd48
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/nilfs2/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index cf9ba481ae37..254a5e46f8ea 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -544,8 +544,15 @@ struct inode *nilfs_iget(struct super_block *sb, str=
uct nilfs_root *root,
>         inode =3D nilfs_iget_locked(sb, root, ino);
>         if (unlikely(!inode))
>                 return ERR_PTR(-ENOMEM);
> -       if (!(inode->i_state & I_NEW))
> +
> +       if (!(inode->i_state & I_NEW)) {
> +               if (!inode->i_size && !inode->i_nlink) {
> +                       make_bad_inode(inode);
> +                       iput(inode);
> +                       return ERR_PTR(-EIO);
> +               }
>                 return inode;
> +       }
>
>         err =3D __nilfs_read_inode(sb, root, ino, inode);
>         if (unlikely(err)) {
> --
> 2.47.0

Thank you Edward.

This fix seems good except for the i_size check, but I think we need
to look into what's going on a bit more.

I was unable to work for a while due to machine trouble, so I'd like
to know if you have made any progress on your investigation.

First, is this caused by a corrupted filesystem image? Or is it that
the directories or files with the same inode number were generated
during the namespace operations (due to a timing issue or something),
and could this problem occur even if the original filesystem image is
normal?

When I mounted the mount_0 image as read-only, the filesystem looked
normal without such inode duplication.

At least, nilfs_read_inode_common(), which reads inodes from block
devices, is implemented to return an error with -ESTALE if i_nlink =3D=3D
0.  So it seems that nilfs_iget() picked up this inode with i_nlilnk
=3D=3D 0 because it hit an inode being deleted in the inode cache.  Why is
that happening?

Also, why do you put the i_size check as an AND condition?
i_size is independent of i_nlink and the inode lifecycles.  If i_size
is also broken, this check will not work properly.
If something is not working and you have included it as a workaround,
I would like to know about it.

Thanks,
Ryusuke Konishi
