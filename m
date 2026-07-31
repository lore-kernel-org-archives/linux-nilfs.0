Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA51D2AD3F
	for <linux-nilfs@vger.kernel.org>; Fri, 31 Jul 2026 12:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499557; cv=pass; b=j4/hLnLp/vITDj1X++GqyouTtjYBKaKH+A7msvCFq68pX665NQX4SJ6K4j8krvxTn5SleU0A7ev8zk9HNxYXSC3LfCzO/yoic73hRjBssT9xcZxO9gSGxxI+17oTW6MEj+VCOnoBnGoQ9drwoYFT5UXYivp3kq3UVbJcuiSBkFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499557; c=relaxed/simple;
	bh=00Uo73paRbls22Pds1LN14XV2v0KiqrftI8JPGFaUrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuPTz/YQa6kr7xjZru5DXDgdrenfrVBcqQH/vcAlHKpnl3w2svqpEdI9KtKb7JikN33xLE4nt6mUTIkbL00SWvL2qklEmCadWr3+IOoY5jqIUM9mIXlZNLRLOB1PxNBvwf+6HTXqSdQck2fKa9dlLMuTxHfDYKFT4H9Ftaf7wj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJISKJfs; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJISKJfs"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a8e4c77eso874449e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 31 Jul 2026 05:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785499554; cv=none;
        d=google.com; s=arc-20260327;
        b=X0ahCMDtwkEynH2YiJCVFYUev1Prz1/egSEGfPYgodxZbVuONYLyE71PDvRJY6VI27
         6rKVnfOWgC1IEq4BIdEtJ7bj1AlUpsjZQ3gqWNLME1IvNL+Bswyd48cixRnkAsGrwHqa
         lLRpBNxzbYZ8TVLuIv/3niowz2L/eZGFxME4zeE4xD1zqSlaYbQgJhs7CX8/iqmeMAGo
         CSviLxOVf2f6uyP4uEQ0dGjVqeje3G20kL+2YJ8y6A9d0Y2eSWm7uNW9Yb9EdxkhYJJj
         N49YtT+Ds8arBOmyeeB9g/09dD/pEVVNaN36/onhprA45STLyaJEz1azNznhZunHUp04
         5Rcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mi1AZcfRnBJEv+mB/zH/d1aX486G6nKbiP0eFgMi6+Y=;
        fh=te4gt2HGuqtwiM7ISTDYoE3agZd2Dzoq1fg+zKtTJ5Q=;
        b=h36S61zP84hEkbz7ZwzzFEFNGxhdjz8h97y5U3qDJL9nMsx3yVf3nw2tUYuHayiJoM
         D2/QAsliMi1wGBDFk4B6FVqDhSv+q76agdb3fF68xi05ABHXC9/wIMYhNfOohl++osRh
         z9p9p7kogvPevnPT/AQmFINhx61yGnwY4BGd6vuLYn8Gz0P7HZmIfCs2LdeRlW+UTbaK
         znFwZQ5aYFUX7FNpRg69KC+sUq3glEw3+hAvRbKzAywfGfGrxMO4l396h7nPjq+JRj0T
         GGw9cB+mHF6bIHyWeoN2W058pjfrSU+JWysoorcohjn9Ze3AoC9f2x2uPhHIQUQQe0Uz
         tAng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785499554; x=1786104354; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mi1AZcfRnBJEv+mB/zH/d1aX486G6nKbiP0eFgMi6+Y=;
        b=mJISKJfs6WtT0kYBtO5Ze5G5uvCLUHwJLoeDTy1qHKgD4pZhgn5aVsSlLQoT8+3UHW
         Q0iDWGt6mscZHF9iGFVLwdub7w3pNNgHTuJUDI8ndZ9oGfJc6HINAJjXRLFmyADy9bo7
         4DflJOVpcwiOuCuYBajvB4LsMHWrByH53waXGOgpFYoT52zfdz3REKRHOr4zM6GREs3G
         ZgVPTUXt5R4ytS65qrQrMelLc5gB427M+b4mCYMhy4k6ZprHGS/ymseAMS2RuauG3XPq
         Gi1fnzv47kG6L492T1HZ5vGpY5ZxRYkkSruwK9ub7OoMLTMG02RfFrn2d1639RF56oY1
         IPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785499554; x=1786104354;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mi1AZcfRnBJEv+mB/zH/d1aX486G6nKbiP0eFgMi6+Y=;
        b=iOf6mss/eMrMmQNNDkDGvfzlkRVR9NcMrKOdtjwJPYaayXU7Pr+UEfUF9FAKkZZJpp
         mDtUeWEwFxmyX+TDOZjrqZ5mupdHxTaSbUzeuJSinFXpUPdcUE0zXyTeQTdtd/EjIdIS
         gFSh1otlwKPXD22gwa56K6H7eVwA01MtPLD0elcqAUShFQOiN5sU/EuARjEzTapX9g8t
         XVb0bdHv8wifWxxfVu45Lu39/nwAWcgexmbuQ8zt6ngemJJbsbQjf4/7vGC7X7/Mpzmd
         oQvfUZshWB1IVzwQnU4S8TCXg+vXjzsCxrNH4NtwzYE86uKhfmlqQL4GVIpfIlc31R4u
         EwAw==
X-Forwarded-Encrypted: i=1; AHgh+RqtfZNXKcW4mhBECHmwKOVZZ74YHsZx9XNbcC0Xte/ugfUqYzkcEBIB5a2EGKrzGjnYkyg0MI+xYE+Zvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZE/MqD7TYPvXAaxgy+DrKGecSYU5oryIjCNNvrQr2g4fxLHQW
	06JTHsK6+qGpHBUkiNbyTc62Z7K3khjpjx2GlQtzweZ9l/oD3V0FvI+K7cxF9D3vHQYBIZfnEvK
	cd4K2jdn6l2gkcmkgT0Fo/zf3O4u4HH8=
X-Gm-Gg: AR+sD13ieGZ5zAzWJ6cCRnSstxk9TYiA9ETBiXVos9+rKGvfdm0Agvk1HvWehOmDuhp
	pecOu0c/8tiUrZumFk4UtR+2A8AE2PvGZzZZX3iMpE7e/sfb4072P2gZoJ5FcYb2twXvh634AZn
	KrdrKaV38eycZ3HXBYKtwwd7NtO9BR5cHxJJxlM1BXsPxday3yeuPpv8xHTnTX5lNvtf0bnQpIk
	e4NWS/00c4CaMeONi8FCQgOsWWZj8//rSbwt21L5mxikKEHpFnE7lQsWFN12gPJ8HBIM35xI6aL
	lEY3rrpF0pXdmXz9f8fFiTaunib7LePK7I79LVRif8XfMQ==
X-Received: by 2002:ac2:4bc6:0:b0:5b1:5ad4:8374 with SMTP id
 2adb3069b0e04-5b2e201220amr470393e87.42.1785499553369; Fri, 31 Jul 2026
 05:05:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731083840.3643821-1-lilinmao@kylinos.cn>
In-Reply-To: <20260731083840.3643821-1-lilinmao@kylinos.cn>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 31 Jul 2026 21:05:35 +0900
X-Gm-Features: AUfX_mxz_XKmladNyAv_aL8UrG7KdKweUfJyAtSLmnC7rCRvYUZ1kSaaclXrbb8
Message-ID: <CAKFNMokGmCHO65JVxFwuETFiKE6k10xs4bqfdgu4Gkq1PS9iSg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix block-offset handling in iomap reads
To: Linmao Li <lilinmao@kylinos.cn>, Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 5:38=E2=80=AFPM Linmao Li wrote:
>
> nilfs_iomap_begin() looks up the filesystem block containing the requeste=
d
> offset and returns the physical address of that block.  However, it sets
> iomap->offset to the original, possibly sub-block, offset while leaving
> iomap->addr at the start of the physical block.
>
> iomap_sector() adds the difference between the I/O position and
> iomap->offset to iomap->addr.  For an O_DIRECT read at offset 512 on a
> filesystem with 4 KiB blocks, the two file offsets are equal and the I/O =
is
> therefore submitted at the start of the physical block instead of 512 byt=
es
> into it.  iomap direct I/O permits this alignment when the device logical
> block size is 512 bytes.
>
> Describe mapped and hole extents from the filesystem-block-aligned file
> offset.  This makes the physical and file offsets refer to the same byte.
> It also prevents a one-block hole mapping from extending into the followi=
ng
> block.
>
> Fixes: b924d8d4e54f ("nilfs2: switch O_DIRECT reads to iomap")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  fs/nilfs2/iomap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> index 3ae3bf6ed3686..e130ed63abd9a 100644
> --- a/fs/nilfs2/iomap.c
> +++ b/fs/nilfs2/iomap.c
> @@ -18,6 +18,7 @@ static int nilfs_iomap_begin(struct inode *inode, loff_=
t offset,
>         struct the_nilfs *nilfs =3D inode->i_sb->s_fs_info;
>         struct nilfs_inode_info *ii =3D NILFS_I(inode);
>         sector_t blkoff =3D offset >> inode->i_blkbits;
> +       loff_t iomap_offset =3D (loff_t)blkoff << inode->i_blkbits;
>         unsigned int maxblocks;
>         __u64 blknum =3D 0;
>         int ret;
> @@ -50,15 +51,15 @@ static int nilfs_iomap_begin(struct inode *inode, lof=
f_t offset,
>         if (ret =3D=3D -ENOENT) {
>                 iomap->type =3D IOMAP_HOLE;
>                 iomap->addr =3D IOMAP_NULL_ADDR;
> -               iomap->offset =3D offset;
> -               iomap->length =3D min_t(loff_t, length, i_blocksize(inode=
));
> +               iomap->offset =3D iomap_offset;
> +               iomap->length =3D i_blocksize(inode);
>                 return 0;
>         } else if (ret < 0)
>                 return ret;
>
>         iomap->bdev =3D inode->i_sb->s_bdev;
> -       iomap->offset =3D offset;
> -       iomap->length =3D min_t(loff_t, length, (loff_t)ret << inode->i_b=
lkbits);
> +       iomap->offset =3D iomap_offset;
> +       iomap->length =3D (loff_t)ret << inode->i_blkbits;
>         iomap->addr =3D (loff_t)blknum << inode->i_blkbits;
>         iomap->type =3D IOMAP_MAPPED;
>         iomap->flags =3D IOMAP_F_MERGED;
>
> base-commit: d5c57d9bf03516d625521cd6cf5acfd93e3e63c7
> --
> 2.25.1

Hi Linmao,

Since the O_DIRECT iomap conversion patch series is currently under
review and subject to revision, please post your finding as comments
on the original patch thread in the future, rather than sending a
standalone patch with a premature Fixes tag.

Hi Viacheslav,
I believe the point being made is that a misalignment occurs because
iomap->addr is adjusted to the block boundary, whereas iomap->offset
is not.  Could you take a look at his points ?

Thanks,
Ryusuke Konishi
