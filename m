Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A5A3E8C46
	for <linux-nilfs@vger.kernel.org>; Tue,  6 Oct 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791306309; cv=none; b=ULpr+y/jyxuuO6AUMLXKick21zCmdrQpvh/xntiVpld0ndSMvSpFBddag4y3F1WkcqODpfqxZ9MBBQrqAF5uacTg0GtRmCyfIQB3dyDGIfSBrL50R7xoyNTotqkGyU846+qTv6ypKRAlQVFGT0lEX5BidPt5W2TmwUDZuybLlJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791306309; c=relaxed/simple;
	bh=CXrmyavGqEoXE0lp8Dy8kd1+uLfqcnxfNzihisBCqwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ai9oBa6BZH6KE8V7tN6f5R6pvphFjiZ66eO9Tw6xXMIxywpTiCEuHeyTH/syF8M69CCiUrBoNrVjFITY8V++UX3GXU/JO0qUiW3+5IZlVHC6rlpQyoUl5SG5PxV4ia3vwrFJL2tN4pzn3ZIKjHFIpXMbsyZ+jmP/RX9Gg4gOstU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=0OrwUB+/; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="0OrwUB+/"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-675617e81f9so1115776d50.3
        for <linux-nilfs@vger.kernel.org>; Tue, 06 Oct 2026 10:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1791306306; x=1791911106; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e0u4Wathsr+m6UibNOetzVnu+uLOjm5yqEiMG+7aZSA=;
        b=0OrwUB+/tbx1yrlKfberD/wOKkakwZsBmI9RIm6XZI/IXvs7pgxIS0TyUuvcE1Kd3b
         XQRrhrpL0zwcG+ddik5xWHSaW3W1VSvRj9yQHdHvFnXqkll+UbxRakMxqK9gAQsmI1zN
         NT39FfuCgR32O6GR9SXeUCEZdU66D6qh5+XyhddiOCB9k/B3k/ayxdPG2ZxBSM6jaFED
         ULMgZBeadvbqI/s+XOCtaeufdDXZ8ZqoqMfRRqxS6aEcSaYeeW1+roaVSm8P/ACpP0lK
         zJTj1gT8SNPj9jla0LslBHygCBFwAvhaX+gWA4/ptbFJMot0KifKU7xLnXRkthkxoovv
         BCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791306306; x=1791911106;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e0u4Wathsr+m6UibNOetzVnu+uLOjm5yqEiMG+7aZSA=;
        b=weiuN541YNvzFey+gENMiFBSMcyKJdKAQoO2mXSXbw9cWgko7hVITaErsHjJIRYV1F
         U0GlltWS7SNp2ePbGtpaJJGksC0wk41xs/M2o0tQlMSLAwSLKIJCQ40CS+5zWCMpjIFm
         VycGXqD25BEPTNuN/VxTB81ASQXxcBvb/uAbdFl3RFdSdO2C2SuoNOxkPI6UFMtpaw5P
         GsVY6PKKhWIchK0tgysODeYFMTSyuz+bWMWV6oxxnXMxOOAIIRHzBdyuAtc4T9QWxebo
         n2+4E55qGFFPoar3nicptQ7lLyufSWu110K/t8xJ0BwyK9APmrJv7kqelg8S3p9XT799
         fmEg==
X-Gm-Message-State: AFq9FYIqN7rIeT+nYDwE43R+1jo1hi+UafYgUTJ6gQaYh8LHxrCtE8CZ
	4CcD9JTlHnS7lEbnzy8HrBe6ce2uvWjo45Rg9vBFleA7LyY1fshdyw9CFqy0Z908qPg=
X-Gm-Gg: AYBFou3JcNFddK9RMCPgl+8SLc9Dsxbr7kx5vqTMPHTt1hvVDL4JVmssH/zM32wJfQx
	sYPzUF3o3W6f/TeXF5yOFhJqK2Hb7keehhdbUesmhu/WCn0Iini2JnAkwSRjd/rDK6oTKCAF8yR
	DEnhKBObd2kXPYY8vRc1o1LQwmb2aFJjkS+d4l5rhre3GcXxQwKF504jY+TUrBZ+jioolf93Wkd
	rPRPKuFHtMRm+b65teb8mhdDOu6ZGMRRsmTLoXp4xim98A7E7jtfs+Bj2FTk2R4iobzr3Q28uoq
	LfBfxR/Fz3BfjQ3LZCGsl5U80NVAcyIA4ZKAtcydlEf8MH/a8ZDYRYoaSkqgxkTQyGN/sSD9TZU
	oLrsp5ZhIN6brJZxaufBH1rowPwBQnq5eYk7I+kHfLvuJS7fkjqA3MpXZBnmW9LEsR7GktOqdnS
	2lsqig4pu5vm9/Dgzk6gInxhdvBMMS1n46722wIM6VuQooEsWSmoS1+IAWNYPslxLASACLRcE+/
	FF/dellFikoBjKaI2deQjxDVq7nOX4sGY+f8lXfkzjaM6U9WNMfhtbw4g2cMERrzoFuyExrr10/
	5+J45TLaoVQtVt2zj314g/3ls9eaziIsosSHHAkYe32qzbU7fk907kbpCgVg7Qi4
X-Received: by 2002:a05:690e:4892:10b0:677:f374:1764 with SMTP id 956f58d0204a3-678fce5c7f9mr813594d50.45.1791306306216;
        Tue, 06 Oct 2026 10:05:06 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:77a3:713a:7918:9ef4? ([2600:1700:6476:1430:77a3:713a:7918:9ef4])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1baf25bsm4823686d50.14.2026.10.06.10.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 10:05:04 -0700 (PDT)
Message-ID: <ddd05008d8007dbd56268d484d77c1e25260e6d6.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix link count underflow when removing
 corrupted directory
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Tue, 06 Oct 2026 10:05:02 -0700
In-Reply-To: <20261006090311.47123-1-konishi.ryusuke@gmail.com>
References: <20261006090311.47123-1-konishi.ryusuke@gmail.com>
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

On Tue, 2026-10-06 at 17:48 +0900, Ryusuke Konishi wrote:
> When removing an empty directory with a corrupted link count (e.g.,
> i_nlink is 1 due to filesystem corruption), nilfs_rmdir() calls
> drop_nlink() via nilfs_do_unlink() and then calls drop_nlink() again
> on the directory inode.=C2=A0 This second call causes an underflow of
> i_nlink, triggering a kernel WARNING in drop_nlink().
>=20
> Fix this issue by using clear_nlink() instead of drop_nlink() to
> finalize the link count reset for the target directory in
> nilfs_rmdir().
> Additionally, log a warning message when i_nlink is not 2 before
> removing an empty directory to notify about the link count
> inconsistency.
>=20
> Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc388db0347b7fc88fa7a
> Fixes: d25006523d0b ("nilfs2: pathname operations")
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this for the next cycle.
>=20
> This fixes a link count underflow during rmdir on a directory with a
> corrupted link count (an issue recently reported by syzbot).
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/namei.c | 8 +++++++-
> =C2=A01 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index e037e0c6e31a..d326bb1acb11 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -341,10 +341,16 @@ static int nilfs_rmdir(struct inode *dir,
> struct dentry *dentry)
> =C2=A0
> =C2=A0	err =3D -ENOTEMPTY;
> =C2=A0	if (nilfs_empty_dir(inode)) {
> +		if (unlikely(inode->i_nlink !=3D 2))
> +			nilfs_warn(dir->i_sb,
> +				"inconsistent empty directory link
> count %u (ino=3D%llu)",
> +				inode->i_nlink,
> +				(unsigned long long)inode->i_ino);
> +
> =C2=A0		err =3D nilfs_do_unlink(dir, dentry);
> =C2=A0		if (!err) {
> =C2=A0			inode->i_size =3D 0;
> -			drop_nlink(inode);
> +			clear_nlink(inode);
> =C2=A0			nilfs_mark_inode_dirty(inode);
> =C2=A0			drop_nlink(dir);
> =C2=A0			nilfs_mark_inode_dirty(dir);

Applied.

Thanks,
Slava.
