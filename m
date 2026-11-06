Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992497;
	b=WL0YsmE5Bmb3mCvyorOLhwKkwY74lC62VSkfaygbRPXQpXnPVZPm4nFxYuRPcTfnIkf5
	 3Jv1i8GDbFmijR3498HupXOhPNpx4AuKJSugUcZ7lcsutcLFslH/GCOUFKyVqv3xUMe+k
	 PG+BPwChwy4WGMewRyqkg/1GwJympd95b+1Wlilbfm9dFt3qXRPuAbQPSE6KQ5CJt2Uin
	 ocOOIzmg26J2pQ7+yfDKmAd8BJJyyr5uFZBpb/w9lbbIvZ2/iLuultGXEtKBL6bPnCohH
	 DGXx/+HojUabB+LrNtwoJ3GeoACENv83/Hw2IJLc00divdtRD4d7SaOuvJ+64SKszPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TUzpFp4FxjFPXnbt/mj7prgh86s090n+q7yYLo+O0rs=;
	b=HcQMKIysNqwmzn3jCKworSLiojB7YIGZNg4vIKGQfsSlGTUGPGU0821HIRumYCkdaEN3
	 ZtrZUz+96RskZMXpYeQX4he/SkOBZrkbbDnaq5KnIuN8pX0FaBmRKIMQn1iqRENM62ZPM
	 Z4EMLr53GYIP7RRecDmXQdVYiJM8SOaoibXEgH7B+hkkyffhRKuN62YwkdJIR8IpI1yD3
	 zb/ZOeRS7CS1Y2bsZf7D2e28pqDFyWvpYS3BCQLTxZJjELkG5vcZ/3fLSddINhBY7p8YW
	 IhVZAZum8+IqazInpSBzhACmkgc/VVT5N1TW4rCrVpvaQPcXus9cu10LdlooAa7jIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VzNLvvZx;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353F0606A329
	for <linux-nilfs@vger.kernel.org>; Fri,  6 Nov 2026 19:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 353F0606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VzNLvvZx
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b31fc13124so7723217b3.3
        for <linux-nilfs@vger.kernel.org>; Fri, 06 Nov 2026 11:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1793992495; x=1794597295; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TUzpFp4FxjFPXnbt/mj7prgh86s090n+q7yYLo+O0rs=;
        b=VzNLvvZxdFdEaWAumHopn01pvu4gLIbgkobV3IiiF/wQuWlBo2JukHYd8kyFj/gkbb
         C2IWy2blFOl9AM00pEedS10AVUj5m7u2nJWDv9rEGdG7KI6w2ZrMlYqC8aA5qfrVXpQN
         SYYUg33eZ4AhQ3RGOE3SbMx6r6lMduKUiJ/NZrHp2nLN9+NEbC+SlKJs+mmcw2LYSZ49
         X/uH9/oYAR840+SkwlAi8OC+aNFsPBQweULDBxV6iEStQs4gSMBdh3lyCylVPWKN3m93
         Y/FinQwlpYzVkujERgJ5SnN+ayqlbNBXLlrjvO+v+iy68Tj5ZdpJZpOuFhEejQu+LTRX
         QnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793992495; x=1794597295;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TUzpFp4FxjFPXnbt/mj7prgh86s090n+q7yYLo+O0rs=;
        b=L+Tu74Ogix50/fcPWWZ4xw7aZcUe/a6nRMNMQHuVf6nx9TBcFvjkrKz7oQoPVipeoW
         ErL/oOK91JpRrCW2zShyyD2wZtio0ApN2HAa2eLJYMh01UFR40lE8gGys9p5t+M4dtRP
         T+Mpo5yaMxSpcelRfAx4sSMbk59hNK4Xr2wnAmzxB+eyjwnuOV3Rh89oB0KRsoHBOak2
         bavpiL7zdZWLyzh6wLQRGO6fjWoXo5dZgTQ1/NmZLcV0ExlnVI/+GQ9DfKqF2wPE25wZ
         z7AMChsB3C3nS1Iir0BfMivdn1+vt0MevSTORtrh4gVEAOgVxl/YWWgkHhVplCEqKtnl
         yjWw==
X-Gm-Message-State: APuU4Z86XH8CS/ed/6V89rWaCr7sNHRVEO//YFhb6tYhA8mHcHABFK2W
	RiuDM0VWdy0FMPrEY8m8G70aTXqOdhw6TShAqvCrM8wynpecI9qQWcWyT8beEPgcrqw=
X-Gm-Gg: AYBFou0OTfsqbmAYUQ84zK75S4Lu5FPJC6q3MAaH6+F1QUr0oiRJbpl3HlT+djt7ebk
	qLlG4hSjoy8U4tS2962lpuoTzqPpnu4Wv50EVvXljMPEiKvk5SkkiEVX6O/WFOJsP+8CIvGUlyn
	TrL8Ga51qvZEQeaZkZZb3UpX7azaMS888gJyZv5TB2D/Ji3k+TzLY3S5M/qSsWBZRI9kQnWyk5a
	veMcn78TQMaO/ivLrSB7FB3VWiosWFp2cnJGtN4L88CME2ieync2Br3X0ndkLFIIh0+sp2jo4de
	GLeqYmpF7ZbtR9R+JGrOvdxOmvlwFhhDFYmuH6QPZPLPFSjRpOwZelX736LtwEGz8tQxwfVY08P
	KKuXG7y0tPpI/8G2Vh+5T888YpS9F93Q7FE/m5Dd7JymT2p7jNPp33W6VzkSfdqoauXRqxmyA54
	Zv5jza0RRgndTHZz4GAbCmwNVM20TrImmCAi2ZXG3RB2OflpZw7qk4dNx08vhCJwm0h7+Cx3Q2l
	tXPqPg4C8ZYVl2n6277dJNpzTUf+4gwFqS8iEUTUIht9z7Kbtvh86bvZEEi/VVx9JskUv/p2pAF
	A7PKwu7pAsxiraCdqJ7KeemJFRN+0fXxMv1iGjkn4F31w28RLvRrqMoS+2/kByUhn9GKHa97FGk
	NP0mEq4Mi44BVry1EE6AuFHPaGYS0Jq2zfV6UzR6O5c7R7yuhmII2xacySPkjOM+238qhCpRzjH
	yPoUbikCpscF1JYJScFdw=
X-Received: by 2002:a05:690c:6d84:b0:8b0:9def:97ff with SMTP id 00721157ae682-8b341ad0acfmr23276797b3.46.1793992495103;
        Fri, 06 Nov 2026 11:14:55 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:4fdf:1e0a:3c1c:195f? ([2600:1700:6476:1430:4fdf:1e0a:3c1c:195f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f82348asm25742047b3.29.2026.11.06.11.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 11:14:54 -0800 (PST)
Message-ID: <50d25011adf37dfe961992d314b52b1791235f67.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: zero-fill post-EOF data on mmap write and size
 extension
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Vyacheslav Kovalevsky
	 <slava.kovalevskiy.2014@gmail.com>
Date: Fri, 06 Nov 2026 11:14:53 -0800
In-Reply-To: <20261106164847.71814-1-konishi.ryusuke@gmail.com>
References: <20261106164847.71814-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sat, 2026-11-07 at 01:45 +0900, Ryusuke Konishi wrote:
> When a file is mapped via mmap, writes beyond the EOF within the same
> page are permitted in memory.=C2=A0 However, POSIX requires that these
> modified portions beyond EOF must never be written to disk and must
> be
> zeroed if the file size is subsequently extended.
>=20
> In nilfs_setattr(), size changes trigger truncate_setsize(), which
> calls
> pagecache_isize_extended() upon size extension.=C2=A0 However, this VFS
> helper
> does nothing when the page size is equal to the block size, when the
> extension stays within the same block, or when no block exists beyond
> the
> old EOF within the page, skipping the zeroing of the post-EOF region.
> The filesystem is therefore responsible for zeroing the post-EOF
> range in
> such cases.=C2=A0 However, the current implementation of nilfs_truncate()
> operates based on the updated i_size, leaving the post-EOF region of
> the
> mapped page unzeroed.
>=20
> Fix this issue by handling size extension and contraction separately
> in
> nilfs_setattr().=C2=A0 When expanding a file, call block_truncate_page()
> with
> the old EOF position to zero the boundary block data beyond the
> original
> EOF, unless the old size is aligned to a block boundary, without
> truncating the bmap.=C2=A0 When shrinking a file, invoke nilfs_truncate()
> as
> before to release blocks beyond the new EOF and zero the boundary
> block.
> Propagate the error code from block_truncate_page() or
> nilfs_truncate()
> to nilfs_setattr() for proper error handling.
>=20
> Additionally, move operations specific to explicit size modifications
> (permission and file type checks, timestamp updates, and sync flag
> handling) from nilfs_truncate() to nilfs_setattr().=C2=A0 This avoids
> executing them in the error recovery path of nilfs_write_failed() and
> ensures invalid size changes are rejected prior to calling
> truncate_setsize().
>=20
> Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
> Closes:
> https://lore.kernel.org/all/47d7da4a-5029-4c56-a5ac-3e4c526cc569@gmail.co=
m
> Fixes: 05fe58fdc10d ("nilfs2: inode operations")
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this fix for the next cycle.
>=20
> This addresses a POSIX compliance issue with mmap where extending a
> file leaves dirty data written beyond the original EOF unzeroed in
> the
> boundary block.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/inode.c | 78 ++++++++++++++++++++++++++++++++++++++------=
-
> --
> =C2=A0fs/nilfs2/nilfs.h |=C2=A0 1 -
> =C2=A02 files changed, 63 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index a99a69e9f91b..6ddef3ab0c19 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -39,6 +39,7 @@ struct nilfs_iget_args {
> =C2=A0};
> =C2=A0
> =C2=A0static int nilfs_iget_test(struct inode *inode, void *opaque);
> +static int nilfs_truncate(struct inode *inode);
> =C2=A0
> =C2=A0void nilfs_inode_add_blocks(struct inode *inode, int n)
> =C2=A0{
> @@ -771,38 +772,35 @@ static void nilfs_truncate_bmap(struct
> nilfs_inode_info *ii,
> =C2=A0		=C2=A0=C2=A0 ret, ii->vfs_inode.i_ino);
> =C2=A0}
> =C2=A0
> -void nilfs_truncate(struct inode *inode)
> +static int nilfs_truncate(struct inode *inode)
> =C2=A0{
> =C2=A0	unsigned long blkoff;
> =C2=A0	unsigned int blocksize;
> =C2=A0	struct nilfs_transaction_info ti;
> =C2=A0	struct super_block *sb =3D inode->i_sb;
> =C2=A0	struct nilfs_inode_info *ii =3D NILFS_I(inode);
> +	int err;
> =C2=A0
> =C2=A0	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
> -		return;
> -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -		return;
> +		return -EINVAL;
> =C2=A0
> =C2=A0	blocksize =3D sb->s_blocksize;
> =C2=A0	blkoff =3D (inode->i_size + blocksize - 1) >> sb-
> >s_blocksize_bits;
> =C2=A0	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
> =C2=A0
> -	block_truncate_page(inode->i_mapping, inode->i_size,
> nilfs_get_block);
> +	err =3D block_truncate_page(inode->i_mapping, inode->i_size,
> +				nilfs_get_block);
> +	if (unlikely(err)) {
> +		nilfs_transaction_abort(sb);
> +		return err;
> +	}
> =C2=A0
> =C2=A0	nilfs_truncate_bmap(ii, blkoff);
> =C2=A0
> -	inode_set_mtime_to_ts(inode,
> inode_set_ctime_current(inode));
> -	if (IS_SYNC(inode))
> -		nilfs_set_transaction_flag(NILFS_TI_SYNC);
> -
> =C2=A0	nilfs_mark_inode_dirty(inode);
> =C2=A0	nilfs_set_file_dirty(inode, 0);
> =C2=A0	nilfs_transaction_commit(sb);
> -	/*
> -	 * May construct a logical segment and may fail in sync
> mode.
> -	 * But truncate has no return value.
> -	 */
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0static void nilfs_clear_inode(struct inode *inode)
> @@ -884,6 +882,7 @@ int nilfs_setattr(const struct mnt_idmap *idmap,
> struct dentry *dentry,
> =C2=A0	struct nilfs_transaction_info ti;
> =C2=A0	struct inode *inode =3D d_inode(dentry);
> =C2=A0	struct super_block *sb =3D inode->i_sb;
> +	loff_t oldsize;
> =C2=A0	int err;
> =C2=A0
> =C2=A0	err =3D setattr_prepare(&nop_mnt_idmap, dentry, iattr);
> @@ -895,10 +894,59 @@ int nilfs_setattr(const struct mnt_idmap
> *idmap, struct dentry *dentry,
> =C2=A0		return err;
> =C2=A0
> =C2=A0	if ((iattr->ia_valid & ATTR_SIZE) &&
> -	=C2=A0=C2=A0=C2=A0 iattr->ia_size !=3D i_size_read(inode)) {
> +		iattr->ia_size !=3D (oldsize =3D i_size_read(inode))) {
> +
> +		if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
> +			err =3D -EPERM;
> +			goto out_err;
> +		}
> +
> +		/*
> +		 * Reject non-regular files explicitly.=C2=A0 While
> standard VFS
> +		 * entry points (e.g. vfs_truncate) enforce S_ISREG,
> the caller
> +		 * notify_change() can be invoked directly by
> stackable
> +		 * filesystems, etc.
> +		 */
> +		if (!likely(S_ISREG(inode->i_mode))) {
> +			err =3D -EINVAL;
> +			goto out_err;
> +		}
> +
> =C2=A0		inode_dio_wait(inode);
> +
> +		/*
> +		 * truncate_setsize() updates i_size and, upon size
> extension,
> +		 * zero-fills post-EOF page data if a block exists
> beyond the
> +		 * old EOF in the page.
> +		 */
> =C2=A0		truncate_setsize(inode, iattr->ia_size);
> -		nilfs_truncate(inode);
> +
> +		if (iattr->ia_size < oldsize) {
> +			/*
> +			 * Zero the post-EOF portion of the boundary
> block
> +			 * (if exists) and truncate blocks beyond
> the new EOF.
> +			 */
> +			err =3D nilfs_truncate(inode);
> +		} else if (oldsize & (sb->s_blocksize - 1)) {
> +			/*
> +			 * Zero the unaligned post-EOF portion of
> the boundary
> +			 * block, which VFS skips when the extension
> stays
> +			 * within the same block or no block exists
> beyond
> +			 * the old EOF in the page.
> +			 */
> +			err =3D block_truncate_page(inode->i_mapping,
> oldsize,
> +						nilfs_get_block);
> +			if (likely(!err))
> +				nilfs_set_file_dirty(inode, 1);
> +		}
> +		if (unlikely(err)) {
> +			i_size_write(inode, oldsize);
> +			goto out_err;
> +		}
> +
> +		inode_set_mtime_to_ts(inode,
> inode_set_ctime_current(inode));
> +		if (IS_SYNC(inode))
> +			nilfs_set_transaction_flag(NILFS_TI_SYNC);
> =C2=A0	}
> =C2=A0
> =C2=A0	setattr_copy(&nop_mnt_idmap, inode, iattr);
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 28d35b2fa7f7..40dd42133dc6 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -297,7 +297,6 @@ int nilfs_attach_btree_node_cache(struct inode
> *inode);
> =C2=A0void nilfs_detach_btree_node_cache(struct inode *inode);
> =C2=A0struct inode *nilfs_iget_for_shadow(struct inode *inode);
> =C2=A0extern void nilfs_update_inode(struct inode *, struct buffer_head *=
,
> int);
> -extern void nilfs_truncate(struct inode *);
> =C2=A0extern void nilfs_evict_inode(struct inode *);
> =C2=A0extern int nilfs_setattr(const struct mnt_idmap *, struct dentry *,
> =C2=A0			 struct iattr *);

Applied.

Thanks,
Slava.
