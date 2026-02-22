Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE7019D074
	for <linux-nilfs@vger.kernel.org>; Sun, 22 Feb 2026 13:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771765487; cv=pass; b=hmeT9kV3xdfiRqvrBQF/66O7I2f6DmZzfAeKYDBQqNIJV6+h83VM5D35Az0w0ufcQYCWAr42fjel6BsoG+5ZJlt+hIIlY74ILS0E02g7TaLHjTH5T1pwQNzLco3J8ouwUNmZhDXCslSXYyl+oPz0azkYYKdq59AOXqzh2lYOxh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771765487; c=relaxed/simple;
	bh=wzavAJtFMITE11EgT2T9Iol8jqSCW877tZGeIUp5zq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nQ1mMKngOS6Y9KwZwUjHCmknM90NycfPkKE3eE/+7beO1YJgZ5ZS40aFrFH/m60ImYJ3+CYL/EqbEg7P+b/bsINorzUMUEaG7Unpn84Nq+Rq9+OFIm/ARwW17kMrtaudZpcxl78KU4lxaPp5TAQWLwep3Aiqj4KJDDrzfJRcEl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nhV9pt/K; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhV9pt/K"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59e60925251so3566507e87.3
        for <linux-nilfs@vger.kernel.org>; Sun, 22 Feb 2026 05:04:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771765484; cv=none;
        d=google.com; s=arc-20240605;
        b=Aa9yzoXi2g0Gm+Wc6r65c6MJRDOeIAg7KnR9UpuhuJcg3PDxOYSgiT2Cv4BmhlZ5Ko
         z6qZJl7AH1ITkqZl3DLOi772qob+QZQSLHnk8K7JKqwCVvuL0Mnk1YUzccPveFRuC15U
         hvubo73Jr8uCE493tq2eafqHH2YPv3nJxLuvkb8MjF/0XRPl5IcGP14cbCgqPyIIK7k0
         56SIkRCGIvKM8IWRmNGuw0PPMA41VbGn1I+KXvgWa7Js2CjAwV6Yymxe79sLY9CIgEeZ
         nKk6A7mXmz7Na2S2q7MHoS2SNkL9+fuFN+g4MkWs8SSOr1Qkj8VrNVw/XkVC+3iyVv5a
         lQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vGebb9dGghImNMDylLRoWiqUlrCoGXa5eAe9GL+X/iQ=;
        fh=lrDu+KrSFfRcVN16M73gsraoRq3Lg6Q73JcKYkmRzVE=;
        b=lyK575E3EOKyzNmcVWL+k0aCkfmAwM968t7+TEB3r431X+UjuMgY8EE9fY/L+l/LeR
         X6cfy/hVgqg4Vw1YH/9fnNCu5UzCfFOZVpZ8RgFcNPAJp69uHw85/QMW8BuoLEr55Z2c
         tJcnnPkPvmpCXh3GLDxMeBHXcjtjRfDkvbso/PJvhBaMo1J2Z6RasHtGirxZcKPnh3OW
         ipW5op1VdAIQ9oo+hxCLV0SyMn8kAAidlwMbQQU2/KhI53aTVYi+ZZ8vgXbkS3U8pxr0
         EZBlPRT2WRGgvLvGZJ4ASvAe0uokVqG9NEibFz4p4BRa0Z3Ubqhdym6EGDeeX2cKRgYg
         QEPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771765484; x=1772370284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGebb9dGghImNMDylLRoWiqUlrCoGXa5eAe9GL+X/iQ=;
        b=nhV9pt/KwpevXqespmJDV2exVmh+wJSsqQgFmAxZ66xEjkVj52dv/2n4U/0j1Pjz9Y
         YlP5mN2YwyTzkJS9WEIYYxl9x/WOz9EORpxa6JataDyYElnwGq/aJfw6Ld0xw84Z+CXX
         wvV2rixHWS5/N3PRN7J2WenQw2+uERnPAJLO/AuEW3IHS2Wzepku+fbesy79d/HF7ehf
         ayWGYNAS4AFQsXRCIrUTkywnie9q6GvDizShCVqkDyd+n6Bsry1twE+jX9TMEAzP4HKR
         63eC7lZUB4jJf+I7dM05d/O7boQ31/J+7flm60/R/I5Uyn/5UXSc8gb0LXe3uXKfyzu9
         dedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771765484; x=1772370284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vGebb9dGghImNMDylLRoWiqUlrCoGXa5eAe9GL+X/iQ=;
        b=lWXwCEwvNBstKF01SrR2hA7PFy0fbIoOAZWSM0A0i3LCaL3Y0tb8+36eXHYtlzX3Pu
         /qb21vP9YMyL11X5d6UrffOzQBNBvdMP9AqlPz54vkC8souKr99yYX20cKmMjTHLIN6w
         eHvEdPSKTZT6eKagvjtwCd4urMHkFLyuXt7a0vIb9a4zpFF6kLdrI29n1JM6UeMhuO38
         XG3nVAL+ZJQfsw2nKbtxtOTRj9lVDucoZv79PQp7i3BqYzLTPzL9ytW6s+U5mIrHTaDe
         XaDPLEGqsl7caSp4brQ+392/QjRZAjOfw5LOJtne30EMJqHumuuXzT0UNvxqQDHDrtq7
         z6HA==
X-Gm-Message-State: AOJu0Yy1AjxjFezuAfIYSoc+AhlkIfuaNZ9rR37SX8tke10PJ/9x+2OX
	VnLOz3ZI7EfbVTIAdvEngplrpd4aOGNj4R2bXtlL4beWfnWKE73JuP39L6+LsZB1f9/yhozENgJ
	uVA1mJMk6gE4wwjWLjQT/KhUDPT/6w8YB29OO
X-Gm-Gg: AZuq6aIvKj2gzXpkEDM68TmeGvEKjuCtycg8EiEAKPbgW9FtS85+cVIqzsyTLva/TPf
	x4nefMchKWG0MhKoSWa4LTZRy7/6T9baKsBJdOdYwCq+GMejmRwEeUm+D2MmZ8z1SLiqI82teGB
	O+OXbboIa/IoDQO7gVo4Vo6CLwUuMC4ZhEyr9IHhzsxJTvvLB1uU9vtKGdnW9W4TJCRDmqNgNu3
	QQG7smpgPdrk7lt4TnNHmAXXY3KBojyo+TosD8VJRB21LngVI6A2NNVj0D6Y2S3QdkscvTUpVsV
	kQpp1yvl
X-Received: by 2002:a05:6512:3e1d:b0:59e:6bbd:1b6c with SMTP id
 2adb3069b0e04-5a0ed883480mr1907081e87.20.1771765483703; Sun, 22 Feb 2026
 05:04:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219204343.70117-1-slava@dubeyko.com>
In-Reply-To: <20260219204343.70117-1-slava@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 22 Feb 2026 22:04:27 +0900
X-Gm-Features: AaiRm504UaGh65hge3j5nO9EMa9bniRQUKBpHPaSypuEh0VEnlggqBHPm58R2oA
Message-ID: <CAKFNMom3S_E1NGcaodYPe0qNxGA9uEoLBLHZZQU=52PC=FWQ_w@mail.gmail.com>
Subject: Re: [RFC PATCH] nilfs2: introduce atime support
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Fri, Feb 20, 2026 at 5:44=E2=80=AFAM Viacheslav Dubeyko wrote:
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
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> ---
>  fs/nilfs2/Kconfig                  |  2 +-
>  fs/nilfs2/inode.c                  | 18 ++++++++++++++----
>  fs/nilfs2/nilfs.h                  |  8 ++------
>  fs/nilfs2/segment.c                |  2 --
>  fs/nilfs2/super.c                  |  5 -----
>  include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
>  6 files changed, 21 insertions(+), 22 deletions(-)

I'd like to comment on the proposed patch.
First, this patch abruptly switches the default behavior from noatime
to atime.  It also doesn't consider compatibility with older kernel
implementations.

The lack of atime is not a bug but a specification constraint, so
regardless of the performance impact of atime, this discontinuity
should be avoided for filesystems.

Therefore, as a general request, I would like to ask that you create a
new NILFS_FEATURE_COMPAT_RO_ATIME read-only compat flag for legacy
implementations so that noatime behavior is maintained, and that atime
support be enabled only when this flag is set.
(I would like to add the ro-compat flag for atime support to be set in
mkfs.nilfs2 or nilfs-tune, with the goal of making it the default in
the future.)

There is a place to define compat flags in nilfs2_ondisk.h, so please
add it there.
It would be preferable to have a separate patch for
NILFS_FEATURE_COMPAT_RO_ATIME so that the change can be applied to
userland tools, but it is also fine to include it in one patch.

I'll add my comments inline below.

>
> diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
> index 7dae168e346e..28de0967745c 100644
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
> index 51bde45d5865..a6fcd8133501 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -395,8 +395,8 @@ void nilfs_set_inode_flags(struct inode *inode)
>                 new_fl |=3D S_NOATIME;
>         if (flags & FS_DIRSYNC_FL)
>                 new_fl |=3D S_DIRSYNC;
> -       inode_set_flags(inode, new_fl, S_SYNC | S_APPEND | S_IMMUTABLE |
> -                       S_NOATIME | S_DIRSYNC);
> +       inode_set_flags(inode, new_fl,
> +                       S_SYNC | S_APPEND | S_IMMUTABLE | S_DIRSYNC);
>  }
>

This change is incorrect.
The third argument (mask) of inode_set_flags() is a bitmask to clear
before conditionally setting inode flags.
S_NOATIME should not be removed from this.

>  int nilfs_read_inode_common(struct inode *inode,
> @@ -410,12 +410,13 @@ int nilfs_read_inode_common(struct inode *inode,
>         i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>         set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>         inode->i_size =3D le64_to_cpu(raw_inode->i_size);
> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
> +       inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
> +                       le32_to_cpu(raw_inode->i_atime_nsec));

Instead of rewriting this, switch these depending on the state of the
atime ro-compat flag mentioned first.

>         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>                         le32_to_cpu(raw_inode->i_ctime_nsec));
>         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
>                         le32_to_cpu(raw_inode->i_mtime_nsec));
> +
>         if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode=
))
>                 return -EIO; /* this inode is for metadata and corrupted =
*/
>         if (inode->i_nlink =3D=3D 0)
> @@ -723,8 +724,10 @@ void nilfs_write_inode_common(struct inode *inode,
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

This looks OK (doesn't break compatibility for older kernels) since
the new fields are never used before.

> @@ -929,6 +932,13 @@ int nilfs_setattr(struct mnt_idmap *idmap, struct de=
ntry *dentry,
>                 nilfs_truncate(inode);
>         }
>
> +       if (iattr->ia_valid & ATTR_ATIME)
> +               inode_set_atime_to_ts(inode, iattr->ia_atime);
> +       if (iattr->ia_valid & ATTR_MTIME)
> +               inode_set_mtime_to_ts(inode, iattr->ia_mtime);
> +       if (iattr->ia_valid & ATTR_CTIME)
> +               inode_set_ctime_to_ts(inode, iattr->ia_ctime);
> +
>         setattr_copy(&nop_mnt_idmap, inode, iattr);
>         mark_inode_dirty(inode);

Why do you need to add this?

setattr_copy() performs a similar, conditional timestamp update process.
Shouldn't we leave it to that behavior?

>
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index b7e3d91b6243..c78a06883490 100644
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
> @@ -234,12 +232,10 @@ static inline int nilfs_init_acl(struct inode *inod=
e, struct inode *dir)
>  }
>  #endif
>
> -#define NILFS_ATIME_DISABLE
> -
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define NILFS_FL_INHERITED                                             \
>         (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |          \
> -        FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL | FS_NOATIME_FL |\
> +        FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL |                \
>          FS_COMPRBLK_FL | FS_NOCOMP_FL | FS_NOTAIL_FL | FS_DIRSYNC_FL)

Do not remove this either.
FS_NOATIME_FL (the flag set by chattr +A) is a flag independent of
mount options and is intended to be disabled for specific files
individually.  In introducing atime, this flag should be kept, as
inheritance is the standard behavior.

>
>  /* Mask out flags that are inappropriate for the given type of inode. */
> @@ -250,7 +246,7 @@ static inline __u32 nilfs_mask_flags(umode_t mode, __=
u32 flags)
>         else if (S_ISREG(mode))
>                 return flags & ~(FS_DIRSYNC_FL | FS_TOPDIR_FL);
>         else
> -               return flags & (FS_NODUMP_FL | FS_NOATIME_FL);
> +               return flags & FS_NODUMP_FL;
>  }

nilfs_mask_flags() is responsible for dropping inappropriate flags
depending on the inode type.
It is standard practice to allow the FS_NOATIME_FL and FS_NODUMP_FL
flags to avoid inode updates when accessing special files.
Therefore, in the above case, do not remove FS_NOATIME_FL, but maintain it.

>
>  /* dir.c */
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index deee16bc9d4e..fae3274e354b 100644
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
> index badc2cbc895e..824d71cbbd8d 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -867,11 +867,6 @@ int nilfs_store_magic(struct super_block *sb,
>
>         sb->s_magic =3D le16_to_cpu(sbp->s_magic);
>
> -       /* FS independent flags */
> -#ifdef NILFS_ATIME_DISABLE
> -       sb->s_flags |=3D SB_NOATIME;
> -#endif
> -

It is OK to remove the NILFS_ATIME_DISABLE macro.
However, if the NILFS_FEATURE_COMPAT_RO_ATIME flag is not set in the
superblock, please continue to set SB_NOATIME as before.

Regards,
Ryusuke Konishi

>         nilfs->ns_resuid =3D le16_to_cpu(sbp->s_def_resuid);
>         nilfs->ns_resgid =3D le16_to_cpu(sbp->s_def_resgid);
>         nilfs->ns_interval =3D le32_to_cpu(sbp->s_c_interval);
> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilf=
s2_ondisk.h
> index b3442b16ff6a..26a1ef28bc66 100644
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
> 2.43.0
>
