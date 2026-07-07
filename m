Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F63F34A3A5
	for <linux-nilfs@vger.kernel.org>; Tue,  7 Jul 2026 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783448224; cv=none; b=HoXAU1iswJQ4f1NPnHtU7MmzGUPXWhKZ7TNGWtr7x4RqRGpEp9rzQuAFkFZkCGxY0WbaPvlqxbyl25dOgsYDHx/BcJXsTV0LrZmXlZOlzEZkLCjEaTteMcRL28xJjvOWsEcpPUEuwMMBYZsG4K6Di4YcKH9NXet8eHAxqc7D/uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783448224; c=relaxed/simple;
	bh=+vE8sG5vzGmxNJHJJe74cQxy4eeW6CZA9gGOv0jCFHk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pH7xGG6A8rZ5kD+hsmBK30bPnFBfKGusPJHl3IFkDRwIoUr59yc54Bc+PS2hbmn6aENB4ozmd4C1RJCSmdPa2QXiGS+nx+PWoblvfLn+D5CXsNdJEAAklaiU8OeVAfDPONnXhKZ09Iu7cWtYMmPj46xOQ2n/zroCJAYorY45Glo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=QuI1kXoi; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="QuI1kXoi"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-667923d86a7so949881d50.0
        for <linux-nilfs@vger.kernel.org>; Tue, 07 Jul 2026 11:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1783448222; x=1784053022; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tgd6DP/f8WRKoMYHIMDMoVk2ypOgfZ+LVWFYMFl9PMc=;
        b=QuI1kXoiz7RTnlwnf/HumZ/HGncAySXEGNy2Xw0RQoeUuVtPdIzTWXUFYQkFDD04hd
         Tapfy7wLWvlQ4ruiQcEIDkOFKBuNJnPv9k9Dl2EzRjAtBm4Tlx3k0VVsWOToAZMG/DNG
         7MHTbQg2f7FsW1Ksb24s43YNVfO8Dfz1rxRAVGEerGgKKkMID3/bK8TmxW8N1iaQJ60j
         LnNX5X8HvdZX6FwNx+G33MFgSkfpXqU44OHhCVRnsIdwH+7PrspKuNubp05OCRkSz1ot
         HcX1Cz2dgNNkqBB0YxqS9VdXgH2TPjZs8tRSneM51g65rvlsXcqCyFCRFRbc3tZzxa98
         u0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783448222; x=1784053022;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgd6DP/f8WRKoMYHIMDMoVk2ypOgfZ+LVWFYMFl9PMc=;
        b=ERGXW1Iti0TdsAjxgCyy08BuaWjg8xumf8SwAyWwSlUjxG2RT4SrAshrVfofs5C7se
         XcurVAOIGVOUdrX0+sGLFkCw4/GiHQk4ZXYVHguBVaLYs7xgjdmp9HBPq40Nf7Bs8IB6
         B/4+TTySSvS7sjCnMlArfg35Lg+F2H5Y5AX0gA5vl6OaJZsKdisa8DGypNjvE8JVDnB/
         d9qwztEbJM4OYNnUf5JIfFdkz7SZswnbUsHpsrdU1asyrwbiquDugKIzNqgeToeMOwR4
         HhnTUsfZ6e++ZSX+wynHcnK1KjBI7WA3aHZaTe90NE/ocWcFVA1zuV1BGHsJXfYUUFQ8
         vZfQ==
X-Gm-Message-State: AOJu0Ywj3nEGRFpimsI4+0+pSoA52hafxkBDtEVYc5oKVNiegOhr9/Kj
	ZNba+EsLQLadPNtui/clW2sEuHY6DdaiebqrS5SeaUE1uxe+drjjdbl1pDN74CioM3k=
X-Gm-Gg: AfdE7ckiOZomooUVeJQNbF8by6k/X0SDqNLCsqaUdFov1zHMrxfLTmLnqDcCT6gMNs1
	hjV6LpY/KODALpiZ97qCoHYZm/mpo5Mw3/fgz2BOdqLAQ9HG0r8r7NrYvg+yQSudtRjV6RGBmCi
	UP/snaJcCToIOoLfKg5U3WtCYrv2D2r+LCe8pLRt4qxj9Y35Z8UJ+trwwoUvo7yN7w/QcR3HIRB
	wP1g25Y+320//QX1GEetFO7GhQ0PmFEt1QWy8iKOCxBzsNt8cx4tFB10iAL/Puc6LRCB9MINzm9
	l+Lk4DjKoh3K+7dhW8mq8145Tt9M63RgPmtUzFS6hVaz54Xcfxlb4Eqw9/Y0RCYx2+2+Z9bNNY7
	GrA6Sf4h5845OfnrbmYppY8owXKKstwqBohAvMZgKv/f9Dk7i2eLcQNIqEdomtKnz7dFDDhMHba
	NkqqVXAvj3Tx3imhsfbhNhPtStkBPm/JcM7yJJ5YC9rfG38K9U8uX4k34Hx21ONMzl0Lq0mWQKj
	gzgnLHHCr5GU0gbXBF7WH/Ju4bvB4mMMJtWvCz1F22msA==
X-Received: by 2002:a05:690e:14c8:b0:665:1d25:ff6f with SMTP id 956f58d0204a3-6678901227dmr2885295d50.48.1783448217467;
        Tue, 07 Jul 2026 11:16:57 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:daa5:7e29:8095:10b2])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6678775d505sm1193806d50.1.2026.07.07.11.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 11:16:56 -0700 (PDT)
Message-ID: <78e848eda9e7adfd3a5110ac39e0e675727e1cee.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: handle corrupted checkpoint count gracefully
 during deletion
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, Igor Putko <igorpetindev@gmail.com>
Date: Tue, 07 Jul 2026 11:16:55 -0700
In-Reply-To: <20260707080019.21550-1-konishi.ryusuke@gmail.com>
References: <20260707080019.21550-1-konishi.ryusuke@gmail.com>
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

On Tue, 2026-07-07 at 16:59 +0900, Ryusuke Konishi wrote:
> From: Igor Putko <igorpetindev@gmail.com>
>=20
> Syzkaller reported a kernel warning in
> nilfs_cpfile_delete_checkpoints()
> due to a corrupted checkpoint count on the storage medium where
> le32_to_cpu(cp->cp_checkpoints_count) is less than the number of
> checkpoints being deleted.
> Triggering a WARN_ON() for disk image corruption is suboptimal. Fix
> this by returning -EIO and reporting a filesystem error via
> nilfs_error() instead of interrupting execution with a kernel
> warning.
>=20
> Reported-by: syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D79b815da3aec0a6a4d02
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>
> Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls
> triggerable from ioctl")
> Cc: <stable+noautosel@kernel.org> # Warning suppression primarily;
> will request backport individually if needed
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this for the next cycle.
>=20
> This fixes a kernel warning and a missed inconsistency check that
> could
> occur with file system images containing corrupted checkpoint
> metadata.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/cpfile.c | 20 ++++++++++++++++----
> =C2=A01 file changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
> index 4bbdc832d7f2..d3349fa58abe 100644
> --- a/fs/nilfs2/cpfile.c
> +++ b/fs/nilfs2/cpfile.c
> @@ -81,18 +81,26 @@ nilfs_cpfile_block_add_valid_checkpoints(const
> struct inode *cpfile,
> =C2=A0	return count;
> =C2=A0}
> =C2=A0
> -static unsigned int
> +static int
> =C2=A0nilfs_cpfile_block_sub_valid_checkpoints(const struct inode *cpfile=
,
> =C2=A0					 struct buffer_head *bh,
> =C2=A0					 unsigned int n)
> =C2=A0{
> =C2=A0	struct nilfs_checkpoint *cp;
> -	unsigned int count;
> +	unsigned int checkpoints_count;
> +	int count;
> =C2=A0
> =C2=A0	cp =3D kmap_local_folio(bh->b_folio,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset_in_folio(bh->b_folio, bh-
> >b_data));
> -	WARN_ON(le32_to_cpu(cp->cp_checkpoints_count) < n);
> -	count =3D le32_to_cpu(cp->cp_checkpoints_count) - n;
> +	checkpoints_count =3D le32_to_cpu(cp->cp_checkpoints_count);
> +	if (unlikely(checkpoints_count < n)) {
> +		nilfs_error(cpfile->i_sb,
> +			=C2=A0=C2=A0=C2=A0 "deleted checkpoints count %u exceeds
> block count %u",
> +			=C2=A0=C2=A0=C2=A0 n, checkpoints_count);
> +		kunmap_local(cp);
> +		return -EIO;
> +	}
> +	count =3D checkpoints_count - n;
> =C2=A0	cp->cp_checkpoints_count =3D cpu_to_le32(count);
> =C2=A0	kunmap_local(cp);
> =C2=A0	return count;
> @@ -522,6 +530,10 @@ int nilfs_cpfile_delete_checkpoints(struct inode
> *cpfile,
> =C2=A0		count =3D
> nilfs_cpfile_block_sub_valid_checkpoints(cpfile, cp_bh,
> =C2=A0							=09
> nicps);
> =C2=A0		brelse(cp_bh);
> +		if (unlikely(count < 0)) {
> +			ret =3D count;
> +			break;
> +		}
> =C2=A0		if (count)
> =C2=A0			continue;
> =C2=A0

Applied.

Thanks,
Slava.
