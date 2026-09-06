Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01FD1DED5C
	for <linux-nilfs@vger.kernel.org>; Sun,  6 Sep 2026 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788713275; cv=pass; b=MDIP0DkKiAFa3IrNE3iKR2f8lrmOt7aQJfqTbJP7caH9HKFKL9BWU+WslrkFLsT1lbgIrEDHVFrbVQv8ZAVQvx50HpSbj2Qc3yePXmnWHxIJgoH1Pu8AkfHHmhxHKA2Xt6B2mpPwhtCQyl0o/jdrJEtnHgKWWmES+3sdlsFQssA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788713275; c=relaxed/simple;
	bh=l3V4BZmLThCIN1Yk5/P1kjYc7whyBn/YKIryGp6saPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qnezDcBFr0GfuMCX9e9mPPam6vyullV6wIsAOZ1MkT5mYT1mVRmctwScT5nP9qxyvaq31uTkkbtTC2Hj9k/DPBw3g9bBEIDSzj2ipc7P5WlclBqD5HERR7RA7IMAimjWnZauzMa4eK6irDA8Lry196rj/OMbPFTyC9pnZwHI9eI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ikmHiMhW; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ikmHiMhW"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so2601545e87.0
        for <linux-nilfs@vger.kernel.org>; Sun, 06 Sep 2026 09:47:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788713272; cv=none;
        d=google.com; s=arc-20260327;
        b=Ta7irZwClmqOQsmX770R9GL2VXtCkuwAzWUF0I1W6E+67FOCvmf1dbEoEBO5ua31c8
         QadKs24jVg6wWK8lbG5g+BIO/jA0pu8JnqJRYyx2Qtl5ju54ovPCGI+SmgKaFb6rAX88
         zIeB20J2SReSbJ+LinlsT/fq/27RpmeiSLjEa33iIZT12hY+y7GuTTLucgXnnRM6gCnu
         9IcstByCDP5NoUeDPSbVr8kdML7UrGkaTc+9rytv9WF0t91K5QucXILEAgf37EXrH3tO
         SEe5PH9o47RadLIuAnxgXfVZ6Zb4SfUoMPeSlqap9DlqJDRjw5SFCvqUeLts/oiHoXvM
         1MdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s2GXJKyoPlYijv97Bh7d7RJwvjwlDMdOwm7X6PLWuAg=;
        fh=vQikhUbI7D1tU8M9QvHn1dOjTgYsbZ7kke6aua61Ymo=;
        b=YXREdG771h6Jew/kP+o6CqEqab3R7lsx7OoL1RsLx8fA/RAQljfT4TEW4ufBW2prij
         1Bp8hPP4BdikcM7+DF5qqT6B0NOu0/P41/YJP1IMe2sTvOwE8uQs8fsk93c1yPtY7XRs
         rUh7rjkIdpgOpQu0VDX81MpXtzBDDIdCX71TSnI10Rx1mRNUaomM2dd+a2ngWi6siEKB
         r3XAsAkOdG1/8ny3OKrHI43UDkPnOU9YOGLFM6+ZuLR6igNsXU1U+yhJB88xu/U62UVd
         q6sCOOT0rrSc8K1jpzsqEhJqR/xoWrbaRBQGyHXK4BkJ5+s8SZZi10cvNW9MInGvy+X9
         JOdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788713272; x=1789318072; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s2GXJKyoPlYijv97Bh7d7RJwvjwlDMdOwm7X6PLWuAg=;
        b=ikmHiMhWFfQ/7OQ6yaWqStIJfiE1Ok6Ha9J0+DC88v8AuDk+YEBpW91AXJsnLOyoGM
         ALZJ0/dHTtJX6gr0SySMS7+UdxlpkSuRJpdk20Y0kwenP22VCj5cpJ7dOlrbBZjjmVhy
         rJOHJToADbH+qroUetQcrfuK5mKjNcsLwwQCdc6oddSgh83mkZZvJriglZ4Tr75i7h+d
         o9qT38CYDMQrUj94utuf4GdKLzVChG9XGmOm17ti7mr7vfx03Ucf6kTJQpoPF398MIlp
         X/8qatVeLEcsxY//pxXSN/lrOKfT+xg6PsIHHhLoLuA9+9jSnab7TGJD10ZrupZ9Iq5T
         R0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788713272; x=1789318072;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s2GXJKyoPlYijv97Bh7d7RJwvjwlDMdOwm7X6PLWuAg=;
        b=N3M6nl4BTzB7SSC9sEnUg5WyJPCdx5+PQbprCixbSDzMhJxMSAE9qPbV4oLuGi8XtS
         cjNopXfVwQoj3kGtDszVNtJm33iQpWvuyrCerUbfVlvzdS61QXnoOMm9JArLlaZXpU/F
         bQqgO7VofPcItwnFSBrRZGXVAP0ismeJ2quRJs+ysx77blIN6uLYXVmIaeK5kcBNLxWx
         FPotIbK080B542ae8NXZYPn8wIj+9y6iM+ROBh8fvnaSCrFQZgeyBcfrIzpHJegUPF3w
         3HJdG+USrp9JRCTwQHTPWW0OC0d1kxXeSUTGHA9CScus+NkjEzV70sLTQ7O9i4xdiFNf
         P7NQ==
X-Forwarded-Encrypted: i=1; AKwUvBxlr5+L2Ei6JAueMIcNIYyE2qNeATacdKkZbT8t/BPnv89dsBoRI1AsQTHWvcaODncidQP7qM//sADyUg==@vger.kernel.org
X-Gm-Message-State: AFuF++nz3WISJoz2Zoh/xDX/UkjNyvyhJU8BDz6pqp0856PlzRnLpGiL
	BSoRHkOzL7VSsnILH+oyU1+/Llbzx73jL/CHCFW5WQtF8zlCR6kl75s+sJCZAJpxfxb6QIwVcR8
	rR7fO2SvvZQ6YkaQpPaHCk3fzFhXn0ErHwucv
X-Gm-Gg: AYBFou30fUFsj0Ns9fIubCRGbFrmHTKPT4Ma4Eg+pfoWZq+BHlBwc/cUedDylUhlyRZ
	mqnwsuWMb0eADwTmh69VFeZBsVmvMjn8gkDsK/ZUN//fip5svin/PlsZJzB1S9K/BmapQnV9h7w
	HV2CA7S3mODW3qglBQeIVHLifRjqkCYI5emmhadW+s+SlDm45hPDMzRh+OjIGSK+v9Nno2ARGoA
	dwOIUd4LNMacQ1xbphOK8cYsclYI0MJmcrl19evHC8qzyWRQdtBTtqezLF5CFl1X5OCAiv5zkJJ
	2cZ3LdXBlbKkrPFLhxQ7j9gM/H/C36cn+tP0o5/z48HR
X-Received: by 2002:a05:6512:1316:b0:5b4:4c28:2249 with SMTP id
 2adb3069b0e04-5b616f3b49emr5398685e87.24.1788713271266; Sun, 06 Sep 2026
 09:47:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260905-nilfs2-dead-code-cleanup-v1-1-348ed97b2443@gmail.com>
In-Reply-To: <20260905-nilfs2-dead-code-cleanup-v1-1-348ed97b2443@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 7 Sep 2026 01:47:35 +0900
X-Gm-Features: AcwNN1VNMsgeBM618g6Z0E8XZ7jqULlbC0NVBIyAQZiVqHNkgA2LwvhbKq7ihKk
Message-ID: <CAKFNMo=4VdyB2OovP5hsQejFd-zf=5BMvvMMBTRjQCYPPtzdYA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: remove '#if 0' code blocks
To: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 5, 2026 at 1:49=E2=80=AFPM Joshua Crofts wrote:
>
> There are two instances of '#if 0' code blocks that are dead code.
> Remove these code blocks.
>
> Additionally, remove unnecessary brackets around a single-statement
> if per checkpatch rules.
>
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> ---
> Stumbled upon these blocks when grepping the kernel for #if 0. Not sure
> if they are actually used for debugging; if so, I have no issues with
> the patch being dropped.
>
> Thanks!

Joshua Crofts, thank you for proposing this patch.

I agree that it is appropriate to remove the dead code in both locations.

These sections are not for debugging purposes; rather, they both
relate to features that were never implemented.

Regarding the ACL-related dead code, it can be properly implemented
when the feature is actually added; therefore, removing it is fine
(and indeed preferable, as it reduces the tree-wide maintenance burden
in the interim).

The dead code related to mount counts stems from a legacy feature
designed for periodic full checks upon mounting.
However, mandating a heavy, full-filesystem check simply because a
certain number of mounts has been reached is outdated; in an era where
large-capacity storage is the norm, such a process compromises
availability.
While fsck itself remains necessary, periodic health checks should be
handled via alternative online methods.

I have just one point regarding the ACL dead code removal: in
nilfs_new_inode() within "inode.c", there are lines that are merely
commented out rather than being enclosed in "#if 0" (shown below).

        /* ii->i_file_acl =3D 0; */
        /* ii->i_dir_acl =3D 0; */

Could you please revise your patch to remove these lines as well?

Once you have made these changes, I will accept the patch.

Thanks,
Ryusuke Konishi


> ---
>  fs/nilfs2/inode.c | 5 -----
>  fs/nilfs2/super.c | 8 ++------
>  2 files changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..c5b0e9f272b7 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -422,11 +422,6 @@ int nilfs_read_inode_common(struct inode *inode,
>
>         inode->i_blocks =3D le64_to_cpu(raw_inode->i_blocks);
>         ii->i_flags =3D le32_to_cpu(raw_inode->i_flags);
> -#if 0
> -       ii->i_file_acl =3D le32_to_cpu(raw_inode->i_file_acl);
> -       ii->i_dir_acl =3D S_ISREG(inode->i_mode) ?
> -               0 : le32_to_cpu(raw_inode->i_dir_acl);
> -#endif
>         ii->i_dir_start_lookup =3D 0;
>         inode->i_generation =3D le32_to_cpu(raw_inode->i_generation);
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb80c..89fa6faa34d2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -824,13 +824,9 @@ static int nilfs_setup_super(struct super_block *sb,=
 int is_mount)
>         max_mnt_count =3D le16_to_cpu(sbp[0]->s_max_mnt_count);
>         mnt_count =3D le16_to_cpu(sbp[0]->s_mnt_count);
>
> -       if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
> +       if (nilfs->ns_mount_state & NILFS_ERROR_FS)
>                 nilfs_warn(sb, "mounting fs with errors");
> -#if 0
> -       } else if (max_mnt_count >=3D 0 && mnt_count >=3D max_mnt_count) =
{
> -               nilfs_warn(sb, "maximal mount count reached");
> -#endif
> -       }
> +
>         if (!max_mnt_count)
>                 sbp[0]->s_max_mnt_count =3D cpu_to_le16(NILFS_DFL_MAX_MNT=
_COUNT);
>
>
> ---
> base-commit: 4d7d9486c04d917265f64c55bd23b2cc4fe7749c
> change-id: 20260905-nilfs2-dead-code-cleanup-cefbe2773172
>
> Best regards,
> --
> Kind regards,
> Joshua Crofts
>
