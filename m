Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792905014;
	b=uB736o3IMn0seBpYtpSr3HLNYQuOj40WKMlndAW0xhl8xtmCr7qak0mxvO155fhyu3+v
	 jwdpRarg3xxqk7kSHdAopavLLlTopbq1A6j2jUTBUv+YS6bClmPAev7et7Xr1Ink0m61e
	 dZcxJtdDB3wibFoxsTM9bicbHN3zRSH6Sb2pJL8CpGUXrU4NDiHiS14Pe/Z0CzQkXgt92
	 HjjNtWJM0OQjiJx0AV0sxr5Ioy9BeQPvBN74WG3fsiXbugQ+p6KH6i47objFzVRAm5X5E
	 opvvlIkfLXMWNI8xlrOpVLhtAVTQoVHK6wchBc+IkITOfsZZd3VgqffwYlmN0htnvLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792905014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HBu58d/nzphOGmHjN4dORS9xjMRvnh1dVgAjVLD5Pf4=;
	b=JPy/8Sx51Dfh7NroNlZuEhyoRmD7DDmpEPsroq3+0Dqoy59rpQtwI6tS2B7UMwBywzgp
	 2e116fWt5TyRGbt8oZ9+DUSsEQ/UtFGnmuYx/+b+1TPRZPjNQIDGfeCAkznGTfoC0i6QJ
	 2DekwDb79oD7qYNG8S1wCjB5wOPf0dakC2cm+WAFOMhVTVT+FAyRXDuZKrdZz3zvY+Pim
	 o7JBoyhynAUh2sH5W2qFGVzqrXttk5TfDd/Ot5n+McuxMNpoXfHT2UQfn5QrjYGAGKzcL
	 w+03saUDIgi4dvM1rdGBXXyJhMQZy8UUQcvbQbuJ6jfsLKLCj/mrOmjxILtsP5jNAuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JVaEfrB2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD5606A321
	for <linux-nilfs@vger.kernel.org>; Sun, 25 Oct 2026 05:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98DD5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JVaEfrB2
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a215e64962so13113265e9.1
        for <linux-nilfs@vger.kernel.org>; Sat, 24 Oct 2026 22:10:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792905012; cv=none;
        d=google.com; s=arc-20260327;
        b=fB3v9Y+Q3sSd/qmXHN5dINpcDyhNVzeQCVAaVnvF/AihHXMOFNGWq0i6h//IoQI/Hh
         ysbT0rGQz52lzHbSBofOhoHMvAptKMpNOteQ4FCE/XNmJvOTNpwfAO4JdfRbv7gj4oi+
         d3r8oSo4rhBwmlNHq7f/JaA9tpyMD89rOyVCpZjHqJ3TX6vsIBSluJuBncBOwDWr72jn
         5lZAAjJwjW//Cr35vpz1p/ZCUvarjLePb3a9zB+V99I7TPSa/c1HhmT8Fhlug/HtzMdN
         8z/aB9BRmMJXLC2yO84shbXFglWy/v2u07jTAFJOtanrJgA8KHaBYLhuNYer6IpX+96i
         V4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HBu58d/nzphOGmHjN4dORS9xjMRvnh1dVgAjVLD5Pf4=;
        fh=JsDJIWjVC9cOTx/J3om7ox7d28m2Fp0hR7zXgQsOIhE=;
        b=l1X9M5qrS+g+ZVV8Piy+aEDYA1NnGQhP4MXVJkrR0qtfBJaxhnU5NOWhFsM/2CSIhD
         sd0wYRV4u4m9LGVW306f5GrRWbYtJ5BDWdrRMdmH7ux0JVMBxbrYpD9nnIzrW5kkKSse
         OwvJVGDa6QNkO8ZLnJfnu9yvvGU+V5QKNLBGANZyixFv70aWQb4p07PejJMIxVZVEjuw
         jmvR/ofkkQDa0JkX/SkcECGp5uLfOlzEi59tcvPuKND1a9YtQcPWdbS4nOd/SMjxM2SW
         WeU+yyZPSJLX6lFNTWskfArC93qqoGZ7lvQL46yGYs7TjOmvRoPS7VIdfpTJnyY8f3aP
         4ouQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792905012; x=1793509812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HBu58d/nzphOGmHjN4dORS9xjMRvnh1dVgAjVLD5Pf4=;
        b=JVaEfrB2xxoBtHukKtqAy+8Jy+eSnVoFK4qgjO7nP1um8XWL8y73B8xhdhVDYNuNKh
         OwZvduO4Kec9EBHNJSyHezWFAlCjHX0GZsqWINEZUYHbwzYHHA7YiaZiggfU9H7uXSM0
         LSK0AYoDQmRHuopOhQoDoF0J5m1IcTLf4I0r2AeckaCnhKBZgzxOuAN34NELpuplZfYV
         0/Pf2dySaJOi4cQoI+2ZUf/DGshs9KXdylAw3wsIbw45EAP2npfZv++FcfGu8FrrChMo
         DP2u/+j3bjtyMQaMKwvvXvUx4wM2d5b0b5ddf+mncmg6Xgex9jxRnnDWDBFYGYeVnwIh
         KPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792905012; x=1793509812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HBu58d/nzphOGmHjN4dORS9xjMRvnh1dVgAjVLD5Pf4=;
        b=xqjHrroyHuBmcfWF8I+A8am+/hTKN/AK5A2SNw+q58/TEc5C+6CYnC25f9rE/xfYlG
         I41tdtPacVMssdMTdOAjcbvM89RFBBLBlFNt2BVDWpuekDUzf3MfPN4VCqX7slN3cnYc
         ksiZLEL8Qp4X8bFWib2q4k2o9K51A+L/2ZRyy36kJsoRIJRJqaFcgygYavvMmeXoPdNb
         paJmun8hRJYFdu/d9MbHgYxAekQ5LyPyh0vjMnZ/LlHk3bQDDu6wS6Tmi54uSt27elJu
         bSa4dSLLL5frK6yk6kEXDtdz8q+thN8QyiQKY92mjHJ8VUGo57It1G1Hpf2ctzhq4iFt
         gPlA==
X-Gm-Message-State: AFq9FYI6pg2zcTwZq9QekL5XSvwp44g668r1bZdc1eC/TU+DEeR0Lq/G
	4H4XFCj0WyHrqYnHaNLNlFtyV39Nc3GOJ2N+E8dmbiNDolcn0tMEFf/W/uuK1ssL0WMgTMPz5i1
	zbDlM+RmkvwBgXP/BuWw8Ia4pG3J7PnQ=
X-Gm-Gg: AYBFou3lbPyCAX+1ZExzXYLk8CSZz7P64m2qkDWR4OwlEejxlEew/eo6OzB37xQBIJu
	AmLJDp85exnpywHflxFkLQOjHogt9tIMOp09ASsewns66iG9IRbs3Mrpg0AMkQWM2yyq2055GY6
	cyOGhq5WrrOdnehEE2PpCoPst7hwbqyraYkIgH5FJlJw7uyr4CZ+oDGKBduspq4T2wciTpcLeYx
	YXUalM0UZ85LX9ffKOw1TkjC/JQGECG3F802HKJIHdKRbzkVAycWUJtqhA3zXfLRny62i/uCk0t
	lOaz/Pz1AHb3f1mNHtGtULPkc6AZR5OTBEuLjgU1z5E/Xi/GOjAUfAdBUaJI6k+OZSFAeMjQMUh
	KM2khCSPDX0aD+EoP909UQSLJlORgIKrKTzc3rg==
X-Received: by 2002:a05:600c:1c1b:b0:4a2:1a:a116 with SMTP id
 5b1f17b1804b1-4a35aae5c48mr61744475e9.0.1792905011665; Sat, 24 Oct 2026
 22:10:11 -0700 (PDT)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <tencent_A1BD1C90A8E503B41B451E310527DC9E9F07@qq.com>
In-Reply-To: <tencent_A1BD1C90A8E503B41B451E310527DC9E9F07@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 25 Oct 2026 14:09:54 +0900
X-Gm-Features: AclHuK_A2MXDy4_SEpuDdwPhZhFdBlQm7jAg0kJCMnRGqH7HNhasGnICkUPtGPM
Message-ID: <CAKFNMokNhGtWE-uAmXBAXneuqwFZ9bP++jRexS+p3Xdbq8G+Zw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: add atime support
To: wangjianjian0@foxmail.com, slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 25, 2026 at 1:04=E2=80=AFPM wrote:
>
> From: Wang Jianjian <wangjianjian0@foxmail.com>
>
> This RFC patch added atime support for nilfs2. To keep disk inode
> layout, reuse {i_xattr, i_pad} as {i_atime, i_atime_nosec}. And remove
> SB_NOATIME from sb_flags.
>
> For now, the default behavior is relatime and other time mount
> options(such as noatime, lazytime,...) are not considered.
>
> Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
> ---
>  fs/nilfs2/inode.c                  | 6 ++++--
>  fs/nilfs2/nilfs.h                  | 2 --
>  fs/nilfs2/segment.c                | 3 ---
>  fs/nilfs2/super.c                  | 5 -----
>  include/uapi/linux/nilfs2_ondisk.h | 4 ++--
>  5 files changed, 6 insertions(+), 14 deletions(-)

Hi Wang Jianjian, (and Viacheslav)

A similar proposal was made in the following RFC patch [1].

[1] https://lore.kernel.org/all/20260219204343.70117-1-slava@dubeyko.com/

Since that patch is more comprehensive, I would prefer to proceed
based on Viacheslav's proposal.
Regarding atime support, we previously agreed to utilize the reserved
extended attribute field.
As I recall, the remaining tasks were determining the design for the
COMPAT flag in the superblock to ensure both forward and backward
compatibility, and addressing the necessary updates for nilfs-utils.

This has been on hold for more than half a year due to personal
circumstances on both Viacheslav's side and mine, but depending on his
availability, it might be time to start moving this forward soon.

However, since I am currently focused on analyzing a few issues and
preparing patches to fix them, and will be traveling over the next two
weeks due to family matters (which have required frequent travel this
year), I would appreciate it if we could resume detailed discussions
after 7.4-rc2 is released.

Thanks,
Ryusuke Konishi

>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..c04f6aea5dee 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -409,8 +409,8 @@ int nilfs_read_inode_common(struct inode *inode,
>         i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>         set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>         inode->i_size =3D le64_to_cpu(raw_inode->i_size);
> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
> +       inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
> +                       le32_to_cpu(raw_inode->i_atime_nsec));
>         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>                         le32_to_cpu(raw_inode->i_ctime_nsec));
>         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
> @@ -721,8 +721,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
> index 4fc42d3787a4..23e2624f13ac 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -234,8 +234,6 @@ static inline int nilfs_init_acl(struct inode *inode,=
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
> index 829573cb6131..3a9a66cc22e0 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -929,9 +929,6 @@ static void nilfs_write_root_mdt_inode(struct inode *=
inode,
>
>         nilfs_write_inode_common(inode, raw_inode);
>
> -       /* zero-fill unused portion of raw_inode */
> -       raw_inode->i_xattr =3D 0;
> -       raw_inode->i_pad =3D 0;
>         memset((void *)raw_inode + sizeof(*raw_inode), 0,
>                nilfs->ns_inode_size - sizeof(*raw_inode));
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb80c..75c068359b7c 100644
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
>         nilfs->ns_resuid =3D le16_to_cpu(sbp->s_def_resuid);
>         nilfs->ns_resgid =3D le16_to_cpu(sbp->s_def_resgid);
>         nilfs->ns_interval =3D le32_to_cpu(sbp->s_c_interval);
> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilf=
s2_ondisk.h
> index b3442b16ff6a..ed365ba4565f 100644
> --- a/include/uapi/linux/nilfs2_ondisk.h
> +++ b/include/uapi/linux/nilfs2_ondisk.h
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
>
> base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
> --
> 2.34.1
>
