Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794767267;
	b=hlhraoz57TOmvX8bTx2ygssXwr4Qw9NUBSPVT5OE6df9GdNV9M/u2m0kZeEBLawhtL/d
	 zxh1Bbs0CgsnrlTmGd0EZmg2CI+c91uUnV5L+3KXKMn0P9MEiwGRlcRrADl13/KjH3beK
	 rjAjwAGlyea9fmPM9h5kgbyvXsBXIItn3t4AAfoNoMHpQqrPQgb3Kzjl+vn0xYoCrQ9zy
	 O4tAMMULYwqV9f2op+sxpebOP16bW4vZmQrnRm6F4MKFDCRsMNr+eOLFssxAPMz0fCI5J
	 9YKnqYkiyB+ooi3HVJxsk6Iyd8A/EY6J8g/XUvFOlOU6aHkyqKNl1Pe3YQDY//DCrVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Zros5y1SXIOOhEd6ceL43DJr0CTkY8vkv2eBVJsi+P8=;
	b=HfGjPiC8NP8jOanCbwyF1KMYYGe6+bQ707s09VLlYWvcPGvSxdkI5NOkfzVvDq4zHwYu
	 QhAp728Uk1nJh3RgcNSWWmJTXz/hkEezfpJt9lt2X1rMvbj9UsdwkuTQNkrcxNAB7mWRF
	 IabFrA8zrpdqlrHsZL6Jo+kfBSzU+uSKf6cmqy3xZ6bUrrtFFynRs+sFKrx/KpHnX79RP
	 Ll1Y0aCxZVRu7hI79qY8DRShWc38O/gvDvbVyljVNPe9anuEun+3E8lF69C3cbhOd9R44
	 g9fteP7FvhOkXyTsl5NyZFB4bzXzQbx1rtdGXO3OO/iVH6aQCcmVBKkBwNLdnp+xB4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJsFDELZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7B5606A31D
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 18:27:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE7B5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJsFDELZ
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so1339033f8f.3
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 10:27:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794767265; cv=none;
        d=google.com; s=arc-20260327;
        b=EY3+ODCItX4QbLPIyIKZOEx2uylU+w0RquO/eUevVVHD8f79aksg4CMF0zrWp+idjV
         tz5n1zjYC3/iIEsGvm8rtfOrUF8VjhD6gIXIXbQBO+VkxhjCy/4MlGxm1PvW3QaL1gUu
         CQlXXssY08FtClNEPImfTMBtKLg9LZgq68IqPLeGBPJwSKVeeVverh/dccaTrKWVqdMo
         aseA3LAePLdBOf3rdnnPfWgpasp7DARmh9o0k6q/y3AtXOsDHR0wWJBpNiqwHm64iy1x
         +lRYOr0la7RAlyJNzQZojOZ+ECdMYwZ9Slop5/EdgZ7KB2NqVeaYcfhh05lXVT3Rgh+q
         mtnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zros5y1SXIOOhEd6ceL43DJr0CTkY8vkv2eBVJsi+P8=;
        fh=rTLcmhuv0VzhSmF7BiKs7jXRkncyTpcJqQXGd/yuulA=;
        b=V9kPKjoM+qMvric9Im4OgY5qiMApW/Ltdnc8bcsHrOz99zzq07PsVq57MM01sz0gU1
         CDDuQbkqxU3NatGxdFPm0BVFgd6FAKBrND0s6gY5CH88vlnGleNUqqFcj0sFjHQQX7UQ
         OB24zoJeXV7WTZUHviC2i0RJHOzbAPd0oCwncw13Qy77ndF0xhAD+/hboibKZ6qVwA2j
         GBV3bm7EREUcAU7KUxy1cxhZ3+Al4r2IfPkI++K3nKyAkT6WLTxzAVMsCL1KnPjbillA
         vuihUOgpST+2t/4ykUbQXMn9Pn1j3H9n4b+GQfhWH9giomqSTRoxvWuAYj6hNuv8JpbW
         hCPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794767265; x=1795372065; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zros5y1SXIOOhEd6ceL43DJr0CTkY8vkv2eBVJsi+P8=;
        b=vJsFDELZtKUG0/5QH4JFnG+T1+0QoC6f9xwzVVDz4pXE3N1jRewLYuMKIcubFM8YpP
         XGS3U5OT/Sfmpg5Mv29LOnv8QPJmWPLEO1aGgQ3EdpLXMdqz9ByKbBcbhR2QTA4XRoTh
         2LAxelsyTad/B7kMfoQ8lNnLpM1x8tNeEjBdzkBWsK9oFoC/0ygcEawo0Xb4BmYO8CkS
         REiqLYA94RDqhKN/vKCgD8rET7Euq4JXTXCv/xnpXu9M4EbfdkNev4eOnRCXEf64MVhE
         toNVVA1g8xbKU3wWD9sQBnIaE31OAMRGjGVVK3+B7kBnyJjH8A3oWccWWY2L83BmpqYd
         le+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794767265; x=1795372065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zros5y1SXIOOhEd6ceL43DJr0CTkY8vkv2eBVJsi+P8=;
        b=FGaLA9sdCDmxZinvnMxq9DVt8nNBxxj2Yb3Lo3NgDYwNImuifhPXWICRpFnEiXoeta
         oHNltJOG570K2yXaUXaj7WNUKtnXIXImNknoXw0IJVa9Ucs8uoH4jdsvoBzs3wfAY219
         61k/MfkGlvRcXVRMSm5Eq89yZQV3Swtqmga5+oFhZblegSKc9u3UP3UqSJNJmgXDjufn
         0EHyNo6C9oLgInxEvHWKYbHYb53ukaF9Oscxm42gefhOoLXsvUcCyDdrbyA9Yx5csOnh
         zj0BQOP3K8DGUr4Lg7IlxvFIKCopojA9XtNaWsN2cxmG5Obs8eyz8FpQWs8nQHdq8Olt
         NDbw==
X-Forwarded-Encrypted: i=1; AL+hErG+Rpu3FDnVvt8m5uWd+CUIqeww0j1LKpnnRd/ZwLvG7/YG29icOWLBBfFcY9ilMo+fWK9xu4g7WOVeKA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8k05Ho2zLsDviU+iiZs7KZy6ZXylCSlY2QVOOfKF8sTLyZPCPY
	yGo/PE73WOGODoAbnUbAFybnq6JlSIkfol47QF06G2ZDafqbzh05tXV/49XY7PkCnyB/ZvkQ1X2
	JRTMMQ1WVt8mE+u9HmGlmCpJKppIaRAe+B6u7
X-Gm-Gg: AYBFou3IJrvln4nj1ieF9XpzklPTZMkjdfKIXQEbxpS0uJ1RTuiLofivFTZnshtGr6X
	e75TcNL5Mq25zxDyL52FkgFnL8tpECjPAgBIiuj3riqNeMlcwJAy0LETMt1Bky8a5oFzcILwtpq
	+bMQcmvCTavtEdV/3A31nytckKnQLa7XM/uEDI3UnlbXsqcj1KY0uh3ojEMsjpCwWBYdDPzHD/N
	wM6T5OuSUsaTqkAmGPverQEt1bmlGelAgJ12izxOPO/8kDiAYLfbkXRxHLL3B07RRfeug5usS/b
	+QzKjeui4mK1E6gkTyKFPlBvl1mo/96dGFhN2V/oQliHX+/qFIEkS6HjXlgo1WVrQJRwhAGOrJU
	aKMml9+vou9LLgyrVnU3678WN4KNanqb2w7xoSg0=
X-Received: by 2002:a05:600c:524d:b0:4bb:68b9:f615 with SMTP id
 5b1f17b1804b1-4bb68b9f88bmr79272425e9.17.1794767264926; Sun, 15 Nov 2026
 10:27:44 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115013328.123821-1-wangjianjian0@foxmail.com> <tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@qq.com>
In-Reply-To: <tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 16 Nov 2026 03:27:26 +0900
X-Gm-Features: AclHuK-YmmTE6MoL7eQ-3HFq0CmgdbDSOE_vr5SdLMuEym6WT6X0FdPPwxs8RW4
Message-ID: <CAKFNMo=YrOGtBLSaE=7YRcf97KCGGYkSEcy9P1W7mwT0rxq2Dg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: introduce atime support
To: Wang Jianjian <wangjianjian0@foxmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 10:33=E2=80=AFAM Wang Jianjian wrote:
>
> From: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Currently, NILFS2 doesn't support atime. And it is possible
> to see the evidence of it by running generic/003 test-case of
> xfstests suite:
>
> sudo ./check generic/003
> FSTYP -- nilfs2
> PLATFORM -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc1+ #10 SMP PREEMPT=
_DYNAMIC Fri Nov 28 20:48:25 PST 2025
> MKFS_OPTIONS -- /dev/loop51
> MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
>
> generic/003 35s ... - output mismatch (see xfstests-dev/results//generic/=
003.out.bad)
>
> This patch exchanges i_xattr on i_atime and i_pad
> on i_atime_nsec fields of struct nilfs_inode in
> the on-disk layout, removes all declarations that
> disabled atime support. Also, it modifies
> nilfs_read_inode_common(), nilfs_write_inode_common(),
> and nilfs_setattr() with the goal of proper atime
> support.
>
> sudo ./check generic/003
> FSTYP         -- nilfs2
> PLATFORM      -- Linux/x86_64 nilfs2-testing 6.19.0-rc1+ #8 SMP PREEMPT_D=
YNAMIC Tue Feb 17 16:21:59 PST 2026
> MKFS_OPTIONS  -- /dev/loop51
> MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
>
> generic/003  30s ...  34s
> Ran: generic/003
> Passed all 1 tests
>
> [1] https://github.com/nilfs-dev/nilfs2/issues/7
>
> Co-developed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>

Hi Wang Jianjian,

Thank you for the v2 patches.  The overall implementation looks good to me.

I applied the series to my local tree with minor fixes, including
adding the missing kernel-doc comments for the new members in
"struct the_nilfs" and adjusting the patch 1 subject.

Sorry for the confusion in my previous email -- since Viacheslav is
credited as the original patch Author, I will also update the
authorship tags on my end to attribute "Co-developed-by" to you
instead (per Documentation/process/submitting-patches.rst).

Once v7.4-rc3 is released, I will run tests on it and forward the
patches to Viacheslav.

As a follow-up cleanup, we can also update the remaining places to
reference the cached feature flags in the nilfs object directly
instead of reading from the superblock buffer.
However, since it would conflict with the ongoing VFS changes in the
next cycle, I will defer that cleanup until after the next merge
window closes.

Regarding nilfs-utils, I will refine the confirmation prompt messages
slightly on my end, and merge the series into master promptly once the
kernel patches are queued.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/Kconfig                  |  2 +-
>  fs/nilfs2/inode.c                  | 11 +++++++++--
>  fs/nilfs2/nilfs.h                  |  4 ----
>  fs/nilfs2/segment.c                |  2 --
>  fs/nilfs2/super.c                  |  8 +++-----
>  include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
>  6 files changed, 17 insertions(+), 18 deletions(-)
>
> diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
> index 0a5ace60e6ab..79b99c33af06 100644
> --- a/fs/nilfs2/Kconfig
> +++ b/fs/nilfs2/Kconfig
> @@ -20,7 +20,7 @@ config NILFS2_FS
>           snapshot is mountable as a read-only file system concurrently w=
ith
>           its writable mount, and this feature is convenient for online b=
ackup.
>
> -         Some features including atime, extended attributes, and POSIX A=
CLs,
> +         Some features including extended attributes, and POSIX ACLs,
>           are not supported yet.
>
>           To compile this file system support as a module, choose M here:=
 the
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index a99a69e9f91b..d91620f55629 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -386,6 +386,7 @@ void nilfs_set_inode_flags(struct inode *inode)
>  int nilfs_read_inode_common(struct inode *inode,
>                             struct nilfs_inode *raw_inode)
>  {
> +       struct the_nilfs *nilfs =3D inode->i_sb->s_fs_info;
>         struct nilfs_inode_info *ii =3D NILFS_I(inode);
>         int err;
>
> @@ -394,8 +395,12 @@ int nilfs_read_inode_common(struct inode *inode,
>         i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>         set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>         inode->i_size =3D le64_to_cpu(raw_inode->i_size);
> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
> +       if (nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME)
> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
> +                               le32_to_cpu(raw_inode->i_atime_nsec));
> +       else
> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> +                               le32_to_cpu(raw_inode->i_mtime_nsec));
>         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>                         le32_to_cpu(raw_inode->i_ctime_nsec));
>         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
> @@ -701,8 +706,10 @@ void nilfs_write_inode_common(struct inode *inode,
>         raw_inode->i_gid =3D cpu_to_le32(i_gid_read(inode));
>         raw_inode->i_links_count =3D cpu_to_le16(inode->i_nlink);
>         raw_inode->i_size =3D cpu_to_le64(inode->i_size);
> +       raw_inode->i_atime =3D cpu_to_le64(inode_get_atime_sec(inode));
>         raw_inode->i_ctime =3D cpu_to_le64(inode_get_ctime_sec(inode));
>         raw_inode->i_mtime =3D cpu_to_le64(inode_get_mtime_sec(inode));
> +       raw_inode->i_atime_nsec =3D cpu_to_le32(inode_get_atime_nsec(inod=
e));
>         raw_inode->i_ctime_nsec =3D cpu_to_le32(inode_get_ctime_nsec(inod=
e));
>         raw_inode->i_mtime_nsec =3D cpu_to_le32(inode_get_mtime_nsec(inod=
e));
>         raw_inode->i_blocks =3D cpu_to_le64(inode->i_blocks);
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 28d35b2fa7f7..81cc6552365e 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -27,7 +27,6 @@
>   * @i_state: dynamic state flags
>   * @i_bmap: pointer on i_bmap_data
>   * @i_bmap_data: raw block mapping
> - * @i_xattr: <TODO>
>   * @i_dir_start_lookup: page index of last successful search
>   * @i_cno: checkpoint number for GC inode
>   * @i_assoc_inode: associated inode (B-tree node cache holder or back po=
inter)
> @@ -43,7 +42,6 @@ struct nilfs_inode_info {
>         unsigned long  i_state;         /* Dynamic state flags */
>         struct nilfs_bmap *i_bmap;
>         struct nilfs_bmap i_bmap_data;
> -       __u64 i_xattr;  /* sector_t ??? */
>         __u32 i_dir_start_lookup;
>         __u64 i_cno;            /* check point number for GC inode */
>         struct inode *i_assoc_inode;
> @@ -234,8 +232,6 @@ static inline int nilfs_init_acl(struct inode *inode,=
 struct inode *dir)
>  }
>  #endif
>
> -#define NILFS_ATIME_DISABLE
> -
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define NILFS_FL_INHERITED                                             \
>         (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |          \
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index af0c3560444f..68b640a7aa5b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -930,8 +930,6 @@ static void nilfs_write_root_mdt_inode(struct inode *=
inode,
>         nilfs_write_inode_common(inode, raw_inode);
>
>         /* zero-fill unused portion of raw_inode */
> -       raw_inode->i_xattr =3D 0;
> -       raw_inode->i_pad =3D 0;
>         memset((void *)raw_inode + sizeof(*raw_inode), 0,
>                nilfs->ns_inode_size - sizeof(*raw_inode));
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index f92bcf1a9544..ddad1e4f55ce 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -863,11 +863,6 @@ int nilfs_store_magic(struct super_block *sb,
>
>         sb->s_magic =3D le16_to_cpu(sbp->s_magic);
>
> -       /* FS independent flags */
> -#ifdef NILFS_ATIME_DISABLE
> -       sb->s_flags |=3D SB_NOATIME;
> -#endif
> -
>         nilfs->ns_resuid =3D le16_to_cpu(sbp->s_def_resuid);
>         nilfs->ns_resgid =3D le16_to_cpu(sbp->s_def_resgid);
>         nilfs->ns_interval =3D le32_to_cpu(sbp->s_c_interval);
> @@ -876,6 +871,9 @@ int nilfs_store_magic(struct super_block *sb,
>         nilfs->ns_feature_compat_ro =3D le64_to_cpu(sbp->s_feature_compat=
_ro);
>         nilfs->ns_feature_incompat =3D le64_to_cpu(sbp->s_feature_incompa=
t);
>
> +       if (!(nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME=
))
> +               sb->s_flags |=3D SB_NOATIME;
> +
>         return 0;
>  }
>
> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilf=
s2_ondisk.h
> index 19587700c92c..e94593137adb 100644
> --- a/include/uapi/linux/nilfs2_ondisk.h
> +++ b/include/uapi/linux/nilfs2_ondisk.h
> @@ -47,9 +47,9 @@
>   * @i_links_count: links count
>   * @i_flags: file flags
>   * @i_bmap: block mapping
> - * @i_xattr: extended attributes
> + * @i_atime: access time (seconds)
>   * @i_generation: file generation (for NFS)
> - * @i_pad: padding
> + * @i_atime_nsec: access time (nano seconds)
>   */
>  struct nilfs_inode {
>         __le64  i_blocks;
> @@ -65,9 +65,9 @@ struct nilfs_inode {
>         __le32  i_flags;
>         __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
>  #define i_device_code  i_bmap[0]
> -       __le64  i_xattr;
> +       __le64  i_atime;
>         __le32  i_generation;
> -       __le32  i_pad;
> +       __le32  i_atime_nsec;
>  };
>
>  #define NILFS_MIN_INODE_SIZE           128
> --
> 2.47.3
>
