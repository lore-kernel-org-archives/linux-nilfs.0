Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A113C1969
	for <linux-nilfs@vger.kernel.org>; Thu,  2 Jul 2026 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033767; cv=none; b=fB1sFwlkcRtUz2zK8tQpNDnz+BhhXglwKbhiFVIfYG9Nnf1Ke72i9lE5oV+n9u22xPyPaZIc+nzVnJU6RzwBCi85ysFOCVZO/0WbBhI2gCXlyo0WuY1gtfJkYsFPes/dE06H2rqKeBZ3UiulhcR3uf4sX1e50W9X2ED9fmj778s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033767; c=relaxed/simple;
	bh=nSgwGDculaqxSEvjtcX0M7NNEF3oo+kHiMJBaoh5EMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ugMGT6RiNZnyQp+QTB4OawW5qMiGx50l/14b7nxL/0jnWrqhViNEKa1DfsBLA4M5unb8go363CZ1bA7aJ835rCKwt0jhKufEwXSexiHFFSSUt/NMOuExSngGGgBRqFg5ndLpsZc2qmFy+r3OsJu+jxigRGCWGJnM8guFYoVMUz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=dJs/sRxp; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="dJs/sRxp"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c96bfabc8d4so1120818a12.3
        for <linux-nilfs@vger.kernel.org>; Thu, 02 Jul 2026 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1783033765; x=1783638565; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IdKDozNoRhbqtifQf4vSGqBzSZFMxWhUTDxhxkpxnCQ=;
        b=dJs/sRxpvmFS1kVwSuSdFQalD6ASViajzA18Dp2R0hmAUGgvvnPzwVnoVMwuG+THBW
         2N3MXuy2GZXdvcxuiRzGd3aspUPoPODIAFi06BfwLYSchTRf8Xu2pMwcC0gALZ5j68Qn
         hDSJOV2WGAjI/CEPWxrnqaL8fSuG9gsVdXKsIyxDxeRYLswnb/lpuDgthGLYOd6Lstnc
         njMKRvIQOZP3ncubAgS5sWgRpXqYtFl++ni83UYVEicl1WW54sFmmT+zAK3FFhFhE7ZL
         FAaQ7h8ADT8/OJJjvLkox7HFAxgBl4q/eePl96qQANHt5Qbx8uajeQBKEZsUwRlvYN1n
         wOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783033765; x=1783638565;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IdKDozNoRhbqtifQf4vSGqBzSZFMxWhUTDxhxkpxnCQ=;
        b=ilruMgzwwmWeAduv9mFJbFmFcccNwhniYXvBdqP9AmEPwQz9OG5GwPaChgjHAePlSa
         ei0R6CX91YjVFtm4hxvs1C80D/hnwZGItH+dUomCOp77hiIgLT4XE4zYBs1laShCLF0h
         JgQZdR4M1b7wx0wnwqPad3H1ccUGkeE8rPvzXDp2h8m4zJhMbMZg1cVkcZOHEBwig1Ji
         NyTwOP2TLQJr9GuDaoEF1APMtw6pCKlYqURYEpKQXEkOCQcU6LnVJlW5cXLGZCMuXZGJ
         VdN1ocXOXHKZXdaxDt8sv0IiR00bMzBYHh1eHFc2YXBJSPG2v1ycZLRkWymh7unSpKCD
         w4DA==
X-Gm-Message-State: AOJu0YyPONyOI9al7nL/joBsQ00e3xyZ3ooBFAFBm22HNUFnLOsSVtyf
	CHRNnr+oIyhsgFYkTPRzcBIq9HLdwMDjk+eLt2vs0HvxXORBqN7Jwb0vXqONAftwZAk=
X-Gm-Gg: AfdE7cnGnwiXaTN0Im+ws4TraPBkorR+FaGfr+TrgRAh2MXRgesNVQ6Zp6gJ1rzMfb5
	vTmR2RsE2kEez/qpB2ziq7ov7ziL7WcX1Wz2dA1vAFHODXht0uArfeaZ0bIPSGms7PVDM2jPpgP
	CPl7fIar9sJD9pm+/lkEm8YeRhg915GJbAPri4xOXHBgUgczCy8tNs5xmkpYDsoKajsFg2ioU9K
	HjHxXJRpj69OtI9+981+d+6A/i+271jSW2xAkkYVCnvEEn7W/XAP5GorwInes6Q5plXeM10ECCs
	I+tT+hKDQzIt2HD5SvBHYFR2iaBFXSq9rAnmH5m3KswWWiLOHTAnrzTwQv5joYbbX66Cm5VAa+D
	FK62OyWR+QntrVUclbymMLKkuOuYZa/xehDpTTsIHQqBxsl22NgIt1IFno4lHERShZ61nv8fMxz
	oEqPjcO5j/BV3pMm5DIxoR14sk8+LQmUV17ZBasNT4HqL0aatzoE99KbykX/g0s+ypQJG3ewGKp
	W074VWX3h8i3xTTT/WTSlyNc+V+uMPbHYelmjzXKkxBzM6sTImorR1oJCgHRWp5hoGXryeb3Y1E
	G/aQRGE=
X-Received: by 2002:a05:6a21:a517:b0:3bf:6c07:b2f0 with SMTP id adf61e73a8af0-3bff4303b09mr8149687637.51.1783033764939;
        Thu, 02 Jul 2026 16:09:24 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7ef188sm13001922c88.2.2026.07.02.16.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 16:09:24 -0700 (PDT)
Message-ID: <3fd92e0979538d5b36fdfb37d30583268b6fbf74.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: reject invalid block index in GC ioctl
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, wuyankun <wuyankun@uniontech.com>
Date: Thu, 02 Jul 2026 16:09:22 -0700
In-Reply-To: <20260702161045.27555-1-konishi.ryusuke@gmail.com>
References: <20260702161045.27555-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-03 at 01:07 +0900, Ryusuke Konishi wrote:
> Syzbot reported list corruption caused by a double list_add_tail()
> call on
> bh->b_assoc_buffers within nilfs_lookup_dirty_data_buffers().
>=20
> Analysis revealed that the root cause was the insertion of a
> page/folio
> with a page index of ULONG_MAX into the page cache via the GC ioctl.
> filemap_get_folios_tag(), called by
> nilfs_lookup_dirty_data_buffers(),
> repeatedly detects a dirty folio with a page index of ULONG_MAX due
> to
> index wrap-around, leading to duplicate processing of dirty buffers.
>=20
> As a preparatory step, the GC ioctl loads the page/folio of the block
> to
> be moved during GC and inserts it into the page cache based on
> information
> in the nilfs_vdesc structure passed as an argument.=C2=A0 Normally, this
> does
> not cause issues because the user-space GC library configures the
> nilfs_vdesc structure properly.=C2=A0 However, since there is no range
> check on
> the parameters determining the page index, a request with
> artificially
> crafted parameters -- such as those generated by Syzbot -- can result
> in a
> page/folio being inserted with a page index of ULONG_MAX, triggering
> the
> above problem.
>=20
> This resolves the issue by checking the ranges of 'vd_offset' and
> 'vd_vblocknr' in the nilfs_vdesc structure that determine the page
> index,
> thereby preventing the invalid page/folio insertions.
>=20
> Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc37bed40868932d790e9
> Fixes: 7942b919f732 ("nilfs2: ioctl operations")
> Cc: wuyankun <wuyankun@uniontech.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this one.
>=20
> This fixes the list corruption issue recently detected by syzbot,
> that
> can occur when out-of-range values are intentionally passed to
> certain
> GC ioctl parameters.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/ioctl.c | 20 ++++++++++++++++++--
> =C2=A01 file changed, 18 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b73f2c5d10f0..0957316e58b8 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -527,6 +527,7 @@ static int nilfs_ioctl_get_bdescs(struct inode
> *inode, struct file *filp,
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> =C2=A0 * * %-EEXIST	- Block conflict detected.
> + * * %-EINVAL	- Invalid virtual block descriptor.
> =C2=A0 * * %-EIO	- I/O error.
> =C2=A0 * * %-ENOENT	- Requested block doesn't exist.
> =C2=A0 * * %-ENOMEM	- Insufficient memory available.
> @@ -536,15 +537,30 @@ static int nilfs_ioctl_move_inode_block(struct
> inode *inode,
> =C2=A0					struct list_head *buffers)
> =C2=A0{
> =C2=A0	struct buffer_head *bh;
> +	__u64 limit_blkidx =3D (__u64)inode->i_sb->s_maxbytes >>
> inode->i_blkbits;
> =C2=A0	int ret;
> =C2=A0
> -	if (vdesc->vd_flags =3D=3D 0)
> +	/*
> +	 * vblocknr 0 is reserved as an invalid pointer.=C2=A0 Also,
> limit_blkidx
> +	 * ensures that the page index converted from vd_vblocknr
> never
> +	 * overflows the page cache limit and respects the
> architecture's bmap
> +	 * key width.
> +	 */
> +	if (unlikely(vdesc->vd_vblocknr =3D=3D 0 ||
> +			vdesc->vd_vblocknr >=3D limit_blkidx))
> +		return -EINVAL;
> +
> +	if (vdesc->vd_flags =3D=3D 0) {
> +		if (unlikely(vdesc->vd_offset >=3D limit_blkidx))
> +			return -EINVAL;
> +
> =C2=A0		ret =3D nilfs_gccache_submit_read_data(
> =C2=A0			inode, vdesc->vd_offset, vdesc->vd_blocknr,
> =C2=A0			vdesc->vd_vblocknr, &bh);
> -	else
> +	} else {
> =C2=A0		ret =3D nilfs_gccache_submit_read_node(
> =C2=A0			inode, vdesc->vd_blocknr, vdesc-
> >vd_vblocknr, &bh);
> +	}
> =C2=A0
> =C2=A0	if (unlikely(ret < 0)) {
> =C2=A0		if (ret =3D=3D -ENOENT)

Applied.

Thanks,
Slava.
