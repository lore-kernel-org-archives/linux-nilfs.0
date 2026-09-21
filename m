Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFA030D404
	for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 02:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789958443; cv=pass; b=MPdRmc8D7N5WLlAqJWHvdA9HVnJAovsl4/JLGhyd9fZvpe+jcNwC8UqHz012IZwszkKh1hToVs/m7hfgd7i45cFEwktrbbepYNKLL82d7r/afrEGZ52FavcRBdQz0tJ0/3KvSZ4UXhMQsUVip1Z92bEG5X9c65x8hlb8Ambwhfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789958443; c=relaxed/simple;
	bh=r0lMY85eMIHeoh8egNHglUJN84MYKmBr3KsQMfE0pow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjCZnRiLSdqIipehsquxT+u6EsJHsMScufoWXbDChg6KnQii2GDCu0Y/0DWBwozYRqv3gMU1wC/3pnfymNHfEOYjYeXDLsuQQAwoyFWtPo/NCDkmksiUM+NZnOCtCbGlsNuqudODH2ksuAWDJFUiHvDq+8W2O7whbeYj9EHTm9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMGyJlUp; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMGyJlUp"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f13d77so2829184e87.0
        for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 19:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789958439; cv=none;
        d=google.com; s=arc-20260327;
        b=oBCm20Wu3PCDJysf/uTErLcGM5PEeM72BUeew5FaHeo8OHGkN/s8+U2vNsdvEsC98e
         R+upI7fh3Q8tMO9rlzSu1XrsBxVSHT0nVQrJ6m/1PbiK5YPnt6wSso4A0WtZgUCIr1hc
         r39yeOIa6Pt62IdDikusLFXwvvSdFE18ZXXe+sCaknqJEAVHfQYqf0ki9YYHWniyyWi+
         XcBbcO57LAaBzgWHSB9sSCG9L+8fXuS2SG296RPyK9bdWVOPLqoWHG3q2njbjxnZ+Ke8
         dqWjAHVu1hZUKNXzxZnefIuraQTUY13vMpgE2/ggjr5f460xAopZoYjXhS/BykIh5+9N
         dTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pr9PAR8DmSBE3nDlXpulltcxYTbXvY4o+9lPI3iO1fI=;
        fh=khpTngAyD4aT6fRcC3dKs/FMiIVwppqaehtf5ScQEmQ=;
        b=sYaIhpSWjlYN3BN+0rm81BC88lZ7pJ0ie+NuCRlNeNvXSLoQM0pGfjeNV34+gVH7WM
         OvkwvYNm8pjb44l9dMZ5U2FbBUmiOqdrpCPqWAYvQrxVtA/6fD7mvXUC117+tw/x0w14
         JpdpDhdtJjVhW6FP9w6Ij4+q09EDwTOh2G1cAYs8cH9wy435QRR7m4qFTrvcbcOgNHXR
         edPWklpDAAjsCaIWF/8yfu1ECI810nJXIrPBGKw7G6X7jE8v/TNDZxFxiJUqji2BZzG5
         B1LOsK6FcMfJQ1CDlb1ORxxkdMFFz6uEvdvbx1pBLTWSxegmHkuYIYTRckUeZOJ/F0Mm
         ZhgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789958439; x=1790563239; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pr9PAR8DmSBE3nDlXpulltcxYTbXvY4o+9lPI3iO1fI=;
        b=kMGyJlUpUWDpKTuxBu4cQO5oNxK2y4NcWziq4RenEzBYrRsK62+5Pin2UKyNB04NzZ
         RWH4rquMsPjIqVIRbO+n/UxcTyb/hA5cOb0ZwZc8S2+h4c2ycn5hIc0R3QZz8xKj4tzS
         uQt8ruICIKOTSVDWZi9EIqZCbWYoDet1YtBizKdrewejPzC6ym/gnbxMad6PwAIAiikC
         o5Qp38HEETNxktv6QtVUQ/Ar+X7PpY4E/gv8t8Hgre3IMz76LTIy6w7DoXnMn74XPk3U
         nXZxaOH8PNbJozI8SHgH5XZ26Ks4VCcWqvNvalUZSeailmJkBdlenOoZdA1TiI1qBcsr
         /bIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789958439; x=1790563239;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pr9PAR8DmSBE3nDlXpulltcxYTbXvY4o+9lPI3iO1fI=;
        b=MObSc32Jdiey/a9pFGirb6ERHp9ynAJwWovQfk1sgRvAU+M6MlfkSfHjD4eeX2vFXM
         krWbdxS0rxR3su48xRdiOxexJ3Aqg15qPw5fWR7gWOZjQ3Zon1rva5Lbz70yeWzzZDKA
         nBWsWXekkrPiEERDXNKB5Oq9LMQU6q9ZQoSyA1gF/AFndFULEJ+bgcAj3xPi70rY3TOV
         fQDS9M6AMOpQrDkYpbJQ7j6waQS1V99faLdm+mKMtyCS9GU/YShNuD0AayPmVhmg4FBS
         v1jaxQAu/0ENdah/GsG1qBfC4UAmW9Bf8lh5utwSbKOhUrmYqx1Vd1Ap/FcheT2HR/Tp
         1L/g==
X-Forwarded-Encrypted: i=1; AKwUvBwzG5QX26780wmCbf+AGBlKn2ezoX7kvXGfbxVQwN12l5roSv5L6PEOGB/9Nzk7ZJdS4hlJAkrMP99Sfg==@vger.kernel.org
X-Gm-Message-State: AFuF++mY6s5rSzzEzE4t1UrwXcO/dNkT3PXFsk2n4tW2vdU2TTBiYf7i
	0RkasRlboMbCoNKpu/zoecV3H7t9UJbKyhmUTTB2MX889XCMu2QqvbpQR4ay9pn+VJ5otcSPlEr
	igiIIkVRvGC4+PfoPCOL5vtHVzIYxmD4=
X-Gm-Gg: AYBFou2UAqhC03n8AhbxbP6Wn6u/X4YGLQmUbOt18bwDXZW5V+s1O847Js52Nz9oee5
	GkYDO90P23Nf7mp0Ct7oj3Bcx9gICWpBlk7c2IW8b4zRMdQPG687geUGe6FDUq9JZjqgQVBHGOp
	stq7pL2eE9p9NN0zVi0kFnCt63goNoXgQbrMxIxgXV6+z/OnBVZGSsteak77HDhaRNArgLghs/v
	UVsrPZm5i6mbmVsnqrh9jS5xWdGusP2WPcwW3qg2cit0n9Nr6R1CTGwyhpsmDQUGBf1Y1iTA5hy
	XUW2fltq159363MNni2IIUTXdM7nLPDRUDpQuyjKvDC7K+meD3QfREBu
X-Received: by 2002:a05:6512:3b1e:b0:5b8:b419:c8ad with SMTP id
 2adb3069b0e04-5b8c1805770mr2774802e87.17.1789958438818; Sun, 20 Sep 2026
 19:40:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com> <20260920205533.426028-2-southampton.jake.labelle@gmail.com>
In-Reply-To: <20260920205533.426028-2-southampton.jake.labelle@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 21 Sep 2026 11:40:22 +0900
X-Gm-Features: AcwNN1W35lpeDqMv3U-Yyg0opzxSl5XRY3s_jQlJ-i9QPqSfoe50w5gJMqWqJbw
Message-ID: <CAKFNMokWSpuZoRfp_jNcuzfs4V3ZY9o83nTV58YGqnj-zV_6mA@mail.gmail.com>
Subject: Re: [PATCH 1/2] nilfs2: reject non-regular inodes in dsync recovery
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 5:55=E2=80=AFAM Jake Labelle wrote:
>
> During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
> inode designated by fi_ino of a dsync log without checking its type.
> If a corrupted image designates a special inode (e.g. a device node)
> there, the inode's embedded bmap was never initialized:
> __nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
> directories and symlinks.  The subsequent nilfs_get_block() then
> dereferences the uninitialized bmap->b_ops and jumps through it,
> crashing the kernel or worse.
>
> Only regular files have data blocks to recover; reject anything else
> before touching its block mapping.
>
> Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
> Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
> Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
> ---
>  fs/nilfs2/recovery.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index 45fb37215..baa9507cb 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -540,6 +540,19 @@ static int nilfs_recover_dsync_blocks(struct the_nil=
fs *nilfs,
>                         goto failed_inode;
>                 }
>
> +               /*
> +                * Only regular files have data blocks and an initialized
> +                * bmap; a crafted image can reference a special inode he=
re,
> +                * whose i_bmap_data was never set up by __nilfs_read_ino=
de().
> +                */
> +               if (!S_ISREG(inode->i_mode)) {
> +                       nilfs_warn(sb,
> +                                  "%s: ino=3D%lu is not a regular file",
> +                                  __func__, (unsigned long)rb->ino);
> +                       err =3D -EIO;
> +                       goto failed_inode;
> +               }
> +

Hi Jake

Thanks for submitting the patch.

In nilfs2, regular files are not the only inode types that have data
blocks and bmap; directories and symbolic links also have them.

Also, since dsync logs are checked with CRCs, this condition should
almost never fail under normal operation, so please wrap it with
unlikely() or !likely().

Therefore, please update the conditional check as follows:

    if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
                  S_ISLNK(inode->i_mode))) {

The comment stating that only regular files have data blocks should
also be corrected accordingly.

In addition, please update the warning message to reflect that other
valid types are allowed - for example, something concise like:

    nilfs_warn(sb, "%s: invalid inode type (ino=3D%lu, mode=3D0%o)",
                __func__, (unsigned long)rb->ino, inode->i_mode);

(Strictly speaking, the latest type of rb->ino is u64, and type
conversion for the inode number is missing in this function, but
keeping it as is here is convenient for backporting.)

Additionally, please return -EINVAL instead of -EIO.  Since
nilfs_recover_dsync_blocks() is called as part of the mount process,
we use -EINVAL for filesystem format errors detected during mount to
conform to the mount system call specification.

Thanks,
Ryusuke Konishi

>                 pos =3D rb->blkoff << inode->i_blkbits;
>                 err =3D block_write_begin(inode->i_mapping, pos, blocksiz=
e,
>                                         &folio, nilfs_get_block);
> --
> 2.43.0
>
