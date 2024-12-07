Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170BB14900B;
	Sat,  7 Dec 2024 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733593789; cv=none; b=N+CRQSH07f6CQCNVZpIaEdJ8tWkP+RAIhfy6RCUvDb4hVDrdAJa8NZm0hISxshIqpHO5/n/jVGc4AVfMw2lJJ4YkXXG3bHknhIg+FWVgXYWRZTfrou9v0lskzCaCDft/hxYiti4JCNbHP5GPVmTelCTTp12D/c5Us0lQZ9nKWSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733593789; c=relaxed/simple;
	bh=m4XxgyGCbzZYn+4MWhX9Gr/cRrrvmzHHIWrMol7OOXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFZ376Po6vemp0WSCEPzmZIM01QFRVmBHMty1v5D0nvYYD1nSI1LTEZwQifxUJPGd3TJG6JYKdP+2jZZ8EqLwgNIBm1B7a1Df4iX4TVWyG7EvT+nHXrQooKLqFvFncqcKoWimTUQ4NglejZtZ0L69xAERuhVBS9Eqp+wrTNU3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgNvfIXu; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgNvfIXu"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53ff1f7caaeso369525e87.0;
        Sat, 07 Dec 2024 09:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733593785; x=1734198585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7aUh1R+qRNuj5Nn+VJoeEL8hWkozQq8dYIs+dg2x4A=;
        b=AgNvfIXu/bps97b0aPTk6ZPRh8BQ/8tLFVcj0ch2bo1irq8mwu2FJLKVfrIJaH7chY
         emkni/VrLvDy0hj5ezjxKBhJjwCVCAgf8FbLcKsfdj9A3ItaL+PtbbnSB93x2GWPubFO
         zpkLDtBnI9y4spmbTL9ywA9kzx2XImqRE66vx/pkTc6wQJRuy5BVJtOt0qw+1QhlYyHR
         ncDK07GrlHtgP3+REHtgmjFUtgBCG3XiJe0TEQA/Ymy2JOs+5P6xc3fT3GGhrkK3ijpl
         6dbiz2fVeTNp4YNHkIHbQwtHelRwzAw9z5jB22kodOnROj/jT6h+P1foJGu/d2wQebtb
         5N9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733593785; x=1734198585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7aUh1R+qRNuj5Nn+VJoeEL8hWkozQq8dYIs+dg2x4A=;
        b=BfCEY0194uYAtQgg9sui/22CZG1T5COQIzvtEXoAZnSLJmjM9Z1hPFUBAON3duNFva
         yEiFj7ukEbGjxcoDDpiOzWveZSIPRRW9Vd42QdCj1AtPvOIn/PXA4fM4L+V2h+Myhmqq
         oH4KkMGPJWujseW+yP+Iahij/inAP+WVwINlwzihcY8KacEdQpGlYc+I7T7hnWJNMKiH
         /IznqH1OYAAPgVEMUD6unYl4hr+hD4rBG82ItPwjt+ISoFmJAXJ+J6QboBkxvKSxoyWA
         qb8dSFuarDiSmkJmMOx1tloauXrL4IxRYgCWtGEI3fw7pRGF+lJtBTtCsI/hib4TzqEM
         1ViA==
X-Forwarded-Encrypted: i=1; AJvYcCUTqjyogUSLpLE14SvWGQ0PfW7VI+uSlUwHqM9bQoSyVK3es1kY6adzy6FULZmop/8O+foIm/4JwKjZwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGHXYRZprbKlqPjBtbnvUjH5gJ5urk5iGmUB4WfAvbaJBtNUcT
	i8YLP4+eHuL66keqlnaFM+hMX6Z3ZxTAqelE4Qbf6eL7xzMa8XVYJkrN6dCqxMt56nDphmVnztg
	qapzsoSVpmmXxTtLWDdzG953adyY=
X-Gm-Gg: ASbGncu6cDADJkRqZQ/kzhqWsbavSedCRDbIPYzj2DX+E3L+7S34TB8vBsZKDbGKxrA
	fuX1FHqmslPWLV0uo3spMPc44m22ws/vaFr5oglKhwMVV1z//gZwSroYEcuWMGirQ6w==
X-Google-Smtp-Source: AGHT+IEX8mIKBoQ/x4/LofdclX7VkOKz5bZu5N7Z5q7eZQuCKP3sOSMF2mxeE3BVDdDAot1CrAmIYiJmHCuP/4ketfA=
X-Received: by 2002:a05:6512:104d:b0:53e:14f7:4945 with SMTP id
 2adb3069b0e04-53e2c2c2ef8mr2104133e87.27.1733593784815; Sat, 07 Dec 2024
 09:49:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMomAScDK6OBUn=+46=VRZCQMvipWtetX8SMVuLkHpVGvdg@mail.gmail.com>
 <tencent_C97469775766D83D6D366E966236D24AB409@qq.com>
In-Reply-To: <tencent_C97469775766D83D6D366E966236D24AB409@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 8 Dec 2024 02:49:28 +0900
Message-ID: <CAKFNMono7BGpLOOjF1TcUpj7GM=x-aATHUv+fCXTs6=WVhYMUw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: drop the inode which has been removed
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 10:14=E2=80=AFPM Edward Adam Davis wrote:
>
> On Fri, 6 Dec 2024 01:04:23 +0900, Ryusuke Konishi wrote:
> > > syzbot reported a WARNING in nilfs_rmdir. [1]
> > >
> > > The inode is used twice by the same task to unmount and remove direct=
ories
> > > ".nilfs" and "file0", it trigger warning in nilfs_rmdir.
> > >
> > > Avoid to this issue, check i_size and i_nlink in nilfs_iget(), if the=
y are
> > > both 0, it means that this inode has been removed, and iput is execut=
ed to
> > > reclaim it.
> > >
> > > [1]
> > > WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/=
inode.c:407
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 5824 Comm: syz-executor223 Not tainted 6.12.0-syzk=
aller-12113-gbcc8eda6d349 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 09/13/2024
> > > RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
> > > Code: bb 70 07 00 00 be 08 00 00 00 e8 57 0b e6 ff f0 48 ff 83 70 07 =
00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 9d 4c 7e ff 90 <0f> 0b 90 e=
b 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
> > > RSP: 0018:ffffc900037f7c70 EFLAGS: 00010293
> > > RAX: ffffffff822124a3 RBX: 1ffff1100e7ae034 RCX: ffff88807cf53c00
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > RBP: 0000000000000000 R08: ffffffff82212423 R09: 1ffff1100f8ba8ee
> > > R10: dffffc0000000000 R11: ffffed100f8ba8ef R12: ffff888073d701a0
> > > R13: 1ffff1100e79f5c4 R14: ffff888073d70158 R15: dffffc0000000000
> > > FS:  0000555558d1e480(0000) GS:ffff8880b8700000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000555558d37878 CR3: 000000007d920000 CR4: 00000000003526f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
> > >  vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
> > >  do_rmdir+0x3b5/0x580 fs/namei.c:4453
> > >  __do_sys_rmdir fs/namei.c:4472 [inline]
> > >  __se_sys_rmdir fs/namei.c:4470 [inline]
> > >  __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
> > >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > Reported-and-tested-by: syzbot+9260555647a5132edd48@syzkaller.appspot=
mail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D9260555647a5132edd4=
8
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > >  fs/nilfs2/inode.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > > index cf9ba481ae37..254a5e46f8ea 100644
> > > --- a/fs/nilfs2/inode.c
> > > +++ b/fs/nilfs2/inode.c
> > > @@ -544,8 +544,15 @@ struct inode *nilfs_iget(struct super_block *sb,=
 struct nilfs_root *root,
> > >         inode =3D nilfs_iget_locked(sb, root, ino);
> > >         if (unlikely(!inode))
> > >                 return ERR_PTR(-ENOMEM);
> > > -       if (!(inode->i_state & I_NEW))
> > > +
> > > +       if (!(inode->i_state & I_NEW)) {
> > > +               if (!inode->i_size && !inode->i_nlink) {
> > > +                       make_bad_inode(inode);
> > > +                       iput(inode);
> > > +                       return ERR_PTR(-EIO);
> > > +               }
> > >                 return inode;
> > > +       }
> > >
> > >         err =3D __nilfs_read_inode(sb, root, ino, inode);
> > >         if (unlikely(err)) {
> > > --
> > > 2.47.0
> >
> > Thank you Edward.
> >
> > This fix seems good except for the i_size check, but I think we need
> > to look into what's going on a bit more.
> >
> > I was unable to work for a while due to machine trouble, so I'd like
> > to know if you have made any progress on your investigation.
> >
> > First, is this caused by a corrupted filesystem image? Or is it that
> > the directories or files with the same inode number were generated
> > during the namespace operations (due to a timing issue or something),
> > and could this problem occur even if the original filesystem image is
> > normal?
> According to the log when I reproduced the problem, I analyzed that the
> problem occurred like this:
>
>                 CPU0                                    CPU1
>                 =3D=3D=3D=3D                                    =3D=3D=3D=
=3D
>                 nilfs_mkdir      // file0
>                 nilfs_new_inode  // ino is 11
>                 mount            // mount file0
>                                                         umount       // .=
nilfs, ino is 11
>                                                         nilfs_rmdir  // i=
no is 11, i_size =3D 0, i_nlink =3D 0
>                                                         umount       // f=
ile0, ino is 11
>                                                         nilfs_rmdir  // i=
no 11, i_size =3D 0, i_nlink =3D 0, trigger warning
>

Thank you for explaining the situation.  I understand what's going on.

In the end, going back to my question, this is caused by file system corrup=
tion.
Because the inode bitmap is corrupted, an inode with an inode number
that should exist as a ".nilfs" file was reassigned by nilfs_mkdir for
"file0", causing an inode duplication during execution.
And this causes an underflow of i_nlink in rmdir operations.

After considering the issue, I came to the conclusion that although
there is an approach that strengthens checks for bitmap
inconsistencies and inode type inconsistencies to detect errors in
advance, these approaches are difficult to fundamentally solve.

This is caused by a corrupted inode bitmap, but checking is difficult
in the first place when there are multiple directories with the same
inode number in the name space.

Therefore, the appropriate solution is to either check for i_nlink
underflow during rmdir, or to detect i_nlink =3D=3D 0 in the call path of
nilfs_lookup() --> nilfs_iget(), and I think the latter approach is
better, as you have chosen.

> >
> > When I mounted the mount_0 image as read-only, the filesystem looked
> > normal without such inode duplication.
> >
> > At least, nilfs_read_inode_common(), which reads inodes from block
> > devices, is implemented to return an error with -ESTALE if i_nlink =3D=
=3D
> > 0.  So it seems that nilfs_iget() picked up this inode with i_nlilnk
> > =3D=3D 0 because it hit an inode being deleted in the inode cache.  Why=
 is
> > that happening?
> Are you talking about the following call trace?
> If so, then because the value of inode->i_state is I_DIRTY (set in nilfs_=
mkdir)
> it will not enter __nilfs_read_inode().
>
> nilfs_iget()->
>   __nilfs_read_inode()->
>     nilfs_read_inode_common()

Yes, in this case __nifls_read_inode() is not called.  As mentioned
above, the conclusion is that i_nlink abnormalities can occur in other
FS corruption patterns such as inode bitmap corruption and directory
inconsistency.

> >
> > Also, why do you put the i_size check as an AND condition?
> i_size will set to 0 in nilfs_rmdir(), so check it too.
> > i_size is independent of i_nlink and the inode lifecycles.  If i_size
> > is also broken, this check will not work properly.
> > If something is not working and you have included it as a workaround,
> > I would like to know about it.

To fix the problem, please modify the patch as follows:

(1) In nilfs_iget(), if the inode without I_NEW obtained by
nilfs_iget_locked() has i_nlink =3D=3D 0, call iput() and return
ERR_PTR(-ESTALE).  Do not call make_bad_inode(). Also do not check for
i_size =3D=3D 0 (it is not a good idea to check this to identify the case
of rmdir).

(2) In nilfs_lookup(), if the return value of nilfs_iget() is
ERR_PTR(-ESTALE), output a message with nilfs_error() indicating that
file system corruption has been detected , and returns ERR_PTR(-EIO).
Please refer to ext2_lookup() for the concrete implementation.

The reason for not calling make_bad_inode() is to prevent interference
from the side when i_nlink is set to 0 and nilfs_evict() is trying to
delete the inode. The VFS layer guarantees that inode acquisition and
evict are mutually exclusive, but it is possible to grab it before
evict(), and the result of interference in that case is unpredictable.
Instead, as mentioned above, I think it is safer to call nilfs_error()
at the nilfs_lookup() level, where namespace operations are involved.

Also, could you please explain in the commit log that inode
duplication has occurred due to file system corruption (in this case,
inode bitmap corruption), and that when inode duplication occurs due
to file system inconsistencies like this, a link count underflow can
occur during an rmdir operation, so that a link count check is
necessary at runtime?

Thank you in advance.

Ryusuke Konishi
