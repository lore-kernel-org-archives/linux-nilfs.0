Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793946003;
	b=XxC3AecriI572cfYBie8ejnmPdqAps8LOgnj/aijMX7IZF7g17GkbSz0sXC8hGwAiea4
	 7k4yBE0AUzQPixeju1y/RsDNt088nrggeT0f6lKJY6gKXRj+yeCPvwA2hZhz7W9t1UeiP
	 cJVvmsv1NagIrxQf4hgD9tg5bbVMBdrmRGkXt+77EK1gXOOEpPQCS/wGZgFV1yr7zEii0
	 pm0tMiAGMUHllkuKm8ffg4iBW9W7HNOX+GtQWYFSp2cO9h9Ec9UhbMAOdazwKU9ee2ZiQ
	 l1CKjkmd1wIVee+scTjfe7rC7r3ZPvUqqlIjS+/LTHXv9C6sRqMbao05i7x/Y+qmzxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946003;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+gNW92e3w3E3BpmffjH49lg89h5q7itLgSJPEseGVaI=;
	b=yEKNn2yKOcBV9KtUejhniFD5PpFo4Nk8+i3O9CGqrECEm3O3XbOgwmZ+9TBA7E6RwMYY
	 cefy9EPlsBYY6ofqyrsfICvMdFPHwsV2Q7GZ1HVY5RWxhn2iDCfBt4cGrt6AZ9h5pZdZa
	 TNILPwnNxDkDWKTZj2jR0fQhSE13GlU1jeoPMlBmVpsR8V8KxFI+dAhgYsUGvq6K3Km1F
	 LgoVkQ9mm+KwgACtXeNBxsUR7qiuUQiKAkXPq1QHmjNkfvMN/TwKb2lrB6YL0CaprgeCn
	 iKhUgQnhvPgRJtTYbX6MXc+XqSA9Mqj7JXXP1jaewajEGM+0IUWCR5f7L+eqJsjGKeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MMvI3ck6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD19606A328
	for <linux-nilfs@vger.kernel.org>; Fri,  6 Nov 2026 06:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AD19606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MMvI3ck6
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso1695395e9.2
        for <linux-nilfs@vger.kernel.org>; Thu, 05 Nov 2026 22:20:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793946001; cv=none;
        d=google.com; s=arc-20260327;
        b=TdmUoDEjfgaPHavYTYTa8vwl1w8n5XlOHdEwqVOB9KBCG2ePbk3Ok+ZVq0St8YHkz3
         UzRQe17rOkunb1HSgIJVrP/805eMTvW06TMJcLbQTjpn6EPxDi1V/tKtli9wmFxQksUp
         hXmwdFmchO6TUHYXbGvksAGR/jbRrjooR0yCUfeLhNL5BqYQBR/IbJrVhGu7SE1bQouf
         bqNTk7ul3Pwn6mFDCa/f/FclxzPghzSUQzS0jeN03fukf94QPH9xSrpWDw+GrldmhPGi
         RvtXsGg6XVGvr5EXvC8XYEWmPfDlt40CxDBxWC8rUp53I8LUkRxw++AQDgEtDPoFqd90
         m2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+gNW92e3w3E3BpmffjH49lg89h5q7itLgSJPEseGVaI=;
        fh=uQBvq00WDLxLOwXN/yldkJputZoaJnnGMR1fP2WRKk4=;
        b=bnQ6D0wXBOf7F+xP3TQrY0SuG01bek8+37Jh0CrqE9SfT+ZyFLBngttqtohsm5dYSR
         NCxK41Yxa6rCjlnYl1DcuhVcBXRZzpThReJVRovDGa2BlORB3XTqAOzZKNUKz5yt151s
         d5AsszN6KnIgTk+F1JBvbFv33bkr7u2Nqc0jF5lhbJcDccSTNr2qcqG/DR1CJ5EQgdWy
         7IhswUYgqP75eZpJ7dPxZZOx95SvHu76QAALcTBF4qaUUuQixGwTC8xI9vSfULFPTFLp
         hvMbayx2h4qo2RL/05qVGvUmK5MhVlLpBM6VweFkkkbS1V3EibYmQb8YUEq0Xp8i8/ss
         DnRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793946001; x=1794550801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+gNW92e3w3E3BpmffjH49lg89h5q7itLgSJPEseGVaI=;
        b=MMvI3ck66zXeH5OYTZQ1uIfi4L1KpTivhV1P0JhAP46URL5wjU3TXIkTlx3CzsS4j7
         kJrcW7s4eJMjyJcuKT9IIJGhy+9RSg1Jq6Ijht1xUJ/g6lAOTNFRiktVKvlS5fdseqYk
         nB9PCYchESMjQECKmFqBixGIs/GludXvOVZmJNYows/PfCm3MvZzNyRN4ZolVG/211nl
         fGQl01YrmQCFkKLw/lK1aR1ld8fm2+2H7EPCfu4OPmcZu4HJXTD0Gx6moKzLyGyP/Xjh
         50JFdZc6aZ+t9vnKTku5D+SPxg/LVYWtzF4nEcTu7lu0iFgfMdyZNhmy98mG9W2dWH21
         VZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793946001; x=1794550801;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+gNW92e3w3E3BpmffjH49lg89h5q7itLgSJPEseGVaI=;
        b=LbCg5rEIIIbGGRINuCUXJe58mF46xtUQ8jepQfDDE6Z52LEOm/El6dc25bhc4Ha3lW
         yCTbEovPt1DwEfgsBb1zf8L3OmPRCubRo63Fi/p8SGO2cuja76PPd523L74qqeIfmFCe
         WxUv4IVCxKJn8dIyHG4DO/ZGtXGCRqj79JYyfbpXlham67csnDUqLFGiDs5Tta5TZ8YC
         sZaahzGycclP4xW8Qc5r4RXbfLSRXStFq0CMxazsH69XaQ4iJZNk2uTc+OHVOBgDYfg4
         1VOCS3IVVnzM55ARjfgztFvr2fXjIKGeMnCHwZ8Nae6X8uASKGg74XKEOHJ48ixNHKFG
         CpMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxe1OUgdgG8gPQH0GZ15TkXPXdKH8QyC4E9bH5X3S7ybCbrMCJfGrKyg+XX8Cu2v14YTd6xRKOHXLD3Uw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8rUSKTQh1dsn0SO7Qj0QMrVZueE1m/kSLD4rHGCxZUCcaHSru7
	Ck3ZfZj4V11FSOLM7Y1mC8UjB4okeM07tSfasr37Yy+a20BwfPi6abBcG0QdMzLd9VHnM05rWGF
	wQ3XLKe6QI4Jl2EcyopGv4sVQr6JqMCMXX58W
X-Gm-Gg: AYBFou1IqVfZ+PecnCktdKnkFM13DEiGXb/y4LEMXZSaoYQI5ZI+udoDTz68IwZsK8O
	kMTDjXpfGxGVct4lNCm3qj66iNOFwwZr8FdEj/nnSM4OoBTH1IFzhqC/LpZyAcx4c2dSAIr1Fa2
	oJtTH+MTfXTEpdVb4xq5Cn2HL/OZ2aMIGlhxZwZmlrzmQahOVNd+vzSaUsi8lW/w9+lV6UsO6Ih
	3mJApM4V/9blmGoWPmoK0//DpUKuCVlwrH96V+yX49Szye7w8qzp980Rs6BbtIx0yAPW/8wOXUR
	sek8F6zY/bEMVJueTb+YayOqFdE8dafy2OrNDoU+eUpl45hUw/16MQMQxLWO0Kr97Ezc5DWz6G7
	Ocx5qAWdKKjiGPiVKjeAlKHpK7dwxP2c4rmdW
X-Received: by 2002:a05:600c:4f4a:b0:4a1:e6c8:ff74 with SMTP id
 5b1f17b1804b1-4b6e0267f51mr19354975e9.29.1793946000553; Thu, 05 Nov 2026
 22:20:00 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102145708.18588-1-wangjianjian0@foxmail.com> <tencent_F07D82D02C87A0BD288288B53AC1F558ED0A@qq.com>
In-Reply-To: <tencent_F07D82D02C87A0BD288288B53AC1F558ED0A@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 6 Nov 2026 15:19:42 +0900
X-Gm-Features: AclHuK88b6uBrmev1ecGGuw-pZiAD3rPXOMpUu4jb966_sZm-VVq23SemFSo6AE
Message-ID: <CAKFNMon7puY2hjj5B1Tm5+N5gVzRQoG+6pCy91wjgsKtUxuuHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] nilfs2: introduce atime support
To: wangjianjian0@foxmail.com
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 11:57=E2=80=AFPM wrote:
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
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>

Hi Wang Jianjian,

Thank you for working on this and picking up Viacheslav's patch.
As I mentioned earlier, I am currently traveling, so please excuse any
delays in my response.

Before diving into the inline comments, I'd like to clarify the points
that need to be decided:

1. Which compat feature flag should be used? (COMPAT_RO or COMPAT)
2. Whether to implement the "0-fallback" mechanism for inode reads
(e.g., falling back to mtime if the read on-disk atime is 0).
3. Whether to also apply this switching mechanism to inode writes.
4. Whether to enable the ATIME compat feature by default in mkfs.nilfs2.
5. Whether nilfs-tune should allow transitions for the ATIME compat
feature in both directions (OFF -> ON and ON -> OFF), or only in one
direction (i.e., OFF -> ON).

My thoughts on these matters are as follows:

1. Which compat feature flag should be used?
I would prefer to use COMPAT_RO, as in your implementation.
Using COMPAT would lead to a confusing situation where, on older
kernels, the on-disk atime of existing inodes would not be updated,
while the atime for new inode blocks would be set to the epoch date
(0).

2. Whether to implement the "0-fallback" mechanism for inode reads.
I believe that the UNIX epoch itself is a meaningful timestamp, and I
would prefer to avoid introducing custom semantics at the file-system
level (i.e., I would prefer not to implement a "0-fallback").

On the other hand, if we do not implement a "0-fallback" -- relying
instead on either the mtime (as in your proposed implementation) or
the value from the new atime field -- then toggling the feature flag
via "nilfs-tune" could result in the atime appearing as the epoch for
existing files.

Unless a better approach can be found, I propose that we define this
behavior -- where the year 1970 might be exposed as a result of a user
(administrator) intentionally modifying the flag via "nilfs-tune" --
as "by design."

In conclusion, the current approach for the read path is acceptable.

3. Whether to also apply this switching mechanism to inode writes.
I believe we should NOT apply a switching mechanism for inode writes.
Writing the atime unconditionally seems to be better, as in your
proposed implementation.

If we do not allow nilfs-tune to transition the feature from ON to
OFF, this unconditional write causes no issues.

Even if we assume such a transition is allowed, the only drawback is a
lack of consistency in behavior when the feature is disabled: older
kernels would set the atime of newly allocated inode blocks to 0
(epoch date) and leave existing inodes un-updated, whereas new kernels
would continue recording atime regardless.

Other than this inconsistency in behavior when the ATIME feature is
removed, I do not see any compelling reason to actively introduce a
switching mechanism for writes.

4. Whether to enable the ATIME compat feature by default in mkfs.nilfs2
If we enable NILFS_FEATURE_COMPAT_RO_ATIME by default immediately,
users who update nilfs-utils on older kernels will suddenly lose the
ability to mount newly created filesystems in read-write mode.

To prevent this, I think we should NOT enable it by default at this
time (i.e., we should keep the default compat_array unchanged).
Instead, please only add the flag to ok_features in mkfs.c so that
users can explicitly specify it.  We will consider making it the
default after a sufficient transition period.

5. Whether nilfs-tune should allow transitions for the ATIME compat feature
Considering the overall implications, I believe we should either
prohibit the ON -> OFF transition entirely, or -- if we do allow it --
implement a safeguard in nilfs-tune.

Specifically, if a user attempts to disable the feature, the tool
should display a warning explaining the consequences (e.g., that newly
allocated inode blocks will have their atime set to the epoch date on
older kernels) and prompt the user with a confirmation (y/N), where
the default is 'N'.  Only if the user explicitly chooses 'y' or ('Y')
should the transition be executed.

The warnings should mention:

* When enabling (OFF -> ON): Existing files will expose the epoch date
(1970-01-01) as their atime.

* When disabling (ON -> OFF): Newly allocated inode blocks on older
kernels will have their atime set to the epoch date, causing
inconsistent behavior.

Below, I will list some additional minor comments and also will
include further comments inline.

(1) Regarding "Sob" (Signed-off-by) tags:
According to the guidelines, when building upon an existing patch to
add new functionality, a "Co-developed-by:" tag should be included
immediately before the "Signed-off-by:" tag of the original developer.
Therefore, how about using the following format?

Co-developed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>

(2) Regarding changes to nilfs-utils:
I have reviewed the changes, but for future submissions, please post
the patch set to the linux-nilfs mailing list for review, just as with
kernel changes; we do not accept pull requests there in principle.

I will not provide individual comments on the nilfs-utils commits this
time, but could you please revise the implementations of mkfs.nilfs2
and nilfs-tune based on the design policies outlined above?

For nilfs-tune, could you try implementing the interactive prompt
(y/N) approach if possible?
(If it is difficult to address in this patchset, we can always improve
it separately later.)

From here onwards, inline:

> ---
>  fs/nilfs2/Kconfig                  |  2 +-
>  fs/nilfs2/inode.c                  | 14 ++++++++++++--
>  fs/nilfs2/nilfs.h                  |  4 ----
>  fs/nilfs2/segment.c                |  2 --
>  fs/nilfs2/super.c                  |  9 ++++-----
>  include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
>  6 files changed, 21 insertions(+), 18 deletions(-)
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
> index 34e6096069ad..b77f32be65a8 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -401,20 +401,28 @@ void nilfs_set_inode_flags(struct inode *inode)
>  int nilfs_read_inode_common(struct inode *inode,
>                             struct nilfs_inode *raw_inode)
>  {
> +       struct the_nilfs *nilfs =3D inode->i_sb->s_fs_info;
>         struct nilfs_inode_info *ii =3D NILFS_I(inode);
> +       __u64 features;
>         int err;
>
> +       features =3D le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro);

nilfs->ns_sbp[0] may change outside of the mount path, making this
reference unsafe.
While ns_sem serves as the lock to protect it, acquiring this lock in
the current context risks a deadlock.

Therefore, please add __u64 fields -- ns_feature_compat,
ns_feature_compat_ro, and ns_feature_incompat -- to the the_nilfs
structure to store these values after byte-order conversion.  Ensure
they are copied (for instance, within nilfs_store_magic()) and then
use these stored values for checks in functions such as
nilfs_read_inode_common().

>         inode->i_mode =3D le16_to_cpu(raw_inode->i_mode);
>         i_uid_write(inode, le32_to_cpu(raw_inode->i_uid));
>         i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>         set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>         inode->i_size =3D le64_to_cpu(raw_inode->i_size);
> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
> +       if (features & NILFS_FEATURE_COMPAT_RO_ATIME)
> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
> +                               le32_to_cpu(raw_inode->i_atime_nsec));
> +       else
> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> +                               le32_to_cpu(raw_inode->i_mtime_nsec));
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
> @@ -721,8 +729,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
> index 4fc42d3787a4..80e54a7cc2e4 100644
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
> index 829573cb6131..f39271d32a2e 100644
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
> index 893a504cb80c..972be00c21be 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -864,13 +864,12 @@ int nilfs_store_magic(struct super_block *sb,
>                       struct nilfs_super_block *sbp)
>  {
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
> +       __u64 features;
>
>         sb->s_magic =3D le16_to_cpu(sbp->s_magic);
> -
> -       /* FS independent flags */
> -#ifdef NILFS_ATIME_DISABLE
> -       sb->s_flags |=3D SB_NOATIME;
> -#endif
> +       features =3D le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro);
> +       if ((features & NILFS_FEATURE_COMPAT_RO_ATIME) =3D=3D 0)
> +               sb->s_flags |=3D SB_NOATIME;

For the flag check here, please use:

    if (!(features & NILFS_FEATURE_COMPAT_RO_ATIME))

instead of comparing with 0.

That's all from me.  Apologies for the length.

Thanks,
Ryusuke Konishi

>
>         nilfs->ns_resuid =3D le16_to_cpu(sbp->s_def_resuid);
>         nilfs->ns_resgid =3D le16_to_cpu(sbp->s_def_resgid);
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
> 2.34.1
>
