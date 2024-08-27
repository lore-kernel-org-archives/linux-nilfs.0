Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01EE132132
	for <linux-nilfs@vger.kernel.org>; Tue, 27 Aug 2024 19:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724786850; cv=none; b=QSLZwQ/CJTXzAwuJEi+cH50WdElA4XB4ENZAurwL0OLGriAMJbh1qYzwPXDRqm71huCg07RQ+qZIK86pt+YVZnQjbbP4D1SAsGvUu+uZPLZ6S5csiTp2Q4D8dTpCmVTEsFyrg/DodAGlvqri6HNdNnmUvFC8/9N7VW+xH1VjtfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724786850; c=relaxed/simple;
	bh=JocmPOsRvDtYRBIcq0rcEaYIH6P5FWR8FiebtiTLFy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=drWj2+JY2Wygx4Ckqz+zSTALUYYXVSI2EvhUpZdb5v2YiJ387dJgponkFxgvOvZ8Jednu9Pjlbgfie3N3FWw7O12J2rQyZGCOTWAtHBIqLZXIC3OffpfZk2uZZbmUXn81D0QyGhPszBvUVMSMEPbiqwjReSWYGtiu+zXscQNSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJDkFtd2; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJDkFtd2"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53436e04447so4989646e87.1
        for <linux-nilfs@vger.kernel.org>; Tue, 27 Aug 2024 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724786847; x=1725391647; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WeY+auq1Y2SLN2koyWFfxwNXVw8UTIGWorT9ZSKbaiI=;
        b=YJDkFtd2awPzIHFUVszVn1mzsaMRLimANN1WmBDr2wmN7+up4FiOqmcvV32BbyDVix
         Emt4B64clZB5FjAsrOpl/GlRybfhHNS+EnKbV5HEN81OT5r8RszG3EFQBjXjSyNuOfIy
         d4XnDV2LD1cCkXonm3rq8fwL41uXdyzuUZuE8Q/0bAgBjxcrN+Sz96hg4lSGi3jQMMEz
         o5fUGolGwaSEzof+CKGe2F+utaaENJzQmB63u5XHn0zn/UhJIPdhzL8filYki0baddXZ
         pWoNLnVKOKooD3wdaloibpZ8vHPI/JSN/68gzGQz0l7/8fw53zUxdbzFutKLqImZwSkW
         suxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724786847; x=1725391647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WeY+auq1Y2SLN2koyWFfxwNXVw8UTIGWorT9ZSKbaiI=;
        b=n5hIgOTFdcH8MzJ2Vrpl8ZywvJprkkNulXo5EKQJOsJDRFsUtk9KJzaoeFMaCfIWq3
         FEFJsiC6ylLjAWah3s+Cx1Ik1dVdRN9lSNfm/A1wqtddLu3Iw1Zxu9LkO8MDsZOS3lOE
         Yq4/tZWV2qmZTtS9fj8rJl1hQwn0EViiC6OcMFbyP0DizMS3eiZvpStli2HUMELAVfxn
         CYWNU4EvMe4/KR++/QvAQw6LDWkROoFStdNDaPw6TtPA2OuBWyc+yj67uVW2cf6zGDpj
         Kr4RAOLMADTT/HKnKFrbBlRe/hz+Ysuk5l3cz4ABhPWLWTbt5OneRXwfArrXy6BXC0i0
         +zeg==
X-Gm-Message-State: AOJu0YzdJeGtAh9UfrILLcMZw/clKwB7FCglfWRsPqTT7Ta6v9p7cqx6
	MnTosLrx0CRWbiMUB1tI+YbX4KM3zuBEL35Co6dALrp1nVnyQ19pIyrcx3Y/nWaxBxa9M1X0pkv
	Ad9Zk7UsiNhgfmI0podyuUEDiyssMEvQM
X-Google-Smtp-Source: AGHT+IFTaUpUpxQAm0s9U3rdn60oMLVhzslCNCKpymjkbTheAlEGa7Ti8Ul1VShwCDAlLSRXLScvY320ySDtXxQh5I8=
X-Received: by 2002:a05:6512:3082:b0:52f:441:bdd6 with SMTP id
 2adb3069b0e04-53454f9a1c6mr95653e87.0.1724786846164; Tue, 27 Aug 2024
 12:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719091725.1877001-1-lihongbo22@huawei.com>
 <CAKFNMome8sJQ6z391GVYCAG0rgbnnwyVAUJVdCnNWmRjtgakxw@mail.gmail.com> <11f2a7dc-bf2e-4018-ae1f-55a065433d33@huawei.com>
In-Reply-To: <11f2a7dc-bf2e-4018-ae1f-55a065433d33@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 28 Aug 2024 04:27:09 +0900
Message-ID: <CAKFNMomN96gJ0EGK_qJMXxqc+ibyOOsiiBzUoV-Qir1rd43HWA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: support ->tmpfile()
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 10:29=E2=80=AFPM Hongbo Li wrote:
>
>
>
> On 2024/7/20 1:36, Ryusuke Konishi wrote:
> > On Fri, Jul 19, 2024 at 6:12=E2=80=AFPM Hongbo Li wrote:
> >>
> >> Add function nilfs2_tmpfile to support O_TMPFILE file creation.
> >>
> >> tmpfile testcases(generic/(004,389,509,530,531) except
> >> generic/389,530 (need acl and shutdown supported) now run/pass.
> >>
> >> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> >> ---
> >>   fs/nilfs2/namei.c | 31 +++++++++++++++++++++++++++++++
> >>   1 file changed, 31 insertions(+)
> >>
> >> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> >> index c950139db6ef..a36667d7a5e8 100644
> >> --- a/fs/nilfs2/namei.c
> >> +++ b/fs/nilfs2/namei.c
> >> @@ -125,6 +125,36 @@ nilfs_mknod(struct mnt_idmap *idmap, struct inode=
 *dir,
> >>          return err;
> >>   }
> >>
> >> +static int nilfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> >> +                       struct file *file, umode_t mode)
> >> +{
> >> +       struct inode *inode;
> >> +       struct nilfs_transaction_info ti;
> >> +       int err;
> >> +
> >> +       err =3D nilfs_transaction_begin(dir->i_sb, &ti, 1);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       inode =3D nilfs_new_inode(dir, mode);
> >> +       err =3D PTR_ERR(inode);
> >> +       if (!IS_ERR(inode)) {
> >> +               inode->i_op =3D &nilfs_file_inode_operations;
> >> +               inode->i_fop =3D &nilfs_file_operations;
> >> +               inode->i_mapping->a_ops =3D &nilfs_aops;
> >> +               nilfs_mark_inode_dirty(inode);
> >> +               d_tmpfile(file, inode);
> >> +               unlock_new_inode(inode);
> >> +               err =3D 0;
> >> +       }
> >> +       if (!err)
> >> +               err =3D nilfs_transaction_commit(dir->i_sb);
> >> +       else
> >> +               nilfs_transaction_abort(dir->i_sb);
> >> +
> >> +       return finish_open_simple(file, err);
> >> +}
> >> +
> >>   static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
> >>                           struct dentry *dentry, const char *symname)
> >>   {
> >> @@ -544,6 +574,7 @@ const struct inode_operations nilfs_dir_inode_oper=
ations =3D {
> >>          .mkdir          =3D nilfs_mkdir,
> >>          .rmdir          =3D nilfs_rmdir,
> >>          .mknod          =3D nilfs_mknod,
> >> +       .tmpfile        =3D nilfs_tmpfile,
> >>          .rename         =3D nilfs_rename,
> >>          .setattr        =3D nilfs_setattr,
> >>          .permission     =3D nilfs_permission,
> >> --
> >> 2.34.1
> >>
> >
> > Hi Hongbo,
> >
> > Thank you for the patch suggestion.
> >
> > As for the O_TMPFILE support, with this implementation, when the file
> > system crashes in an unclean way, the inodes generated in the ifile
> > metadata file by nilfs_new_inode() are not released and remain
> > orphaned.
>
> Doesn't the nilfs transaction ensure this kind of consistency?
>

The nilfs transaction is to gurantee the consistency of metadata
state, but unfortunately it does not guarantee that an inode with link
count 0 will continue to exist.  A different mechanism is needed.

For normal files, when the link count falls to 0 and iput() is
executed, nilfs_evict_inode(), which evicts the inode, simultaneously
releases the inode on the bitmap and the data and b-tree blocks.

A mechanism is needed to allow files with link count =3D=3D 0 to survive
across checkpoints.

Strictly speaking, there is a problem with the current NILFS2
implementation; if a checkpoint is created between the time the inode
is removed from the namespace and the time the final iput() is called,
and the machine uncleanly goes down at that time,the inode becomes an
orphan inode and its blocks are not released.

Therefore, I think that an additional mechanism to maintain orphan
inodes is needed in any way.  If that can be done, the rest of your
tmpfile implementation seems to be usable almost as is, so how about
holding off until then?

I thought that it would be better for me to implement this mechanism
myself, because it would be difficult to implement correctly without a
thorough understanding of the lifecycle management and coherency of
NILFS2 metadata.

More importantly, since NILFS2 has not kept up with the implementation
of the wide range of functions available in today's file systems, I
would appreciate your help in implementing those additional functions
(for example, functions related to attributes such as encryption and
compression, or other minor features).

> >
> > I think that this problem needs to be solved first.
> >
> > If you could propose a mechanism to repair orphaned inodes at mount
> > time, I would like to apply it.
> > Is that possible?
> >
> > For example,
> >
> > A method of constructing an on-disk chain list of inodes that starts
> > from the latest checkpoint of cpfile, or a reserved inode (inode
> > number 0, etc.) of ifile, registering them there, and releasing them
> > during recovery at mount time.
> >
> > Alternatively, a less efficient method would be to perform a full scan
> > of ifile metadata when recovery occurs at mount time,
> > and release those whose link count does not match the inode bitmap.
>

> Thanks for your detailed explanation. If we scan the orphaned inodes at
> mount time, this may increase the time for mounting (unless scanning in
> background).

A scan only needs to be performed if the file system was not unmounted
cleanly, so it is not necessary to do it every time, but considering
scalability, I now think it would be better to be able to properly
manage orphan inodes, as mentioned above.

Thanks,
Ryusuke Konishi

>
> Thanks,
> Hongbo
>
> >
> > If we actually implement it, I think we need to discuss the method to
> > be determined.
> >
> > This issue takes priority, but I would like to make another comment
> > about the implementation of your proposal:
>
> Thanks for your
> >
> > The call to nilfs_mark_inode_dirty() involves copying the on-memory
> > inode data to the ifile, so it must be done after the on-memory inode
> > update is complete.  Therefore, move it after the call to d_tmpfile().
> > (we need to check if this swap actually works without side effects).
> >
> > Also, the function name in the changelog is a type for "nilfs_tmpfile".
> >
> > That's all for now.
> >
> > Thanks,
> > Ryusuke Konishi


Ryusuke Konishi
