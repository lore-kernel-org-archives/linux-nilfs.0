Received: from mail-yx2-f0.google.com (mail-yx2-f0.google.com [74.125.224.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF936F912
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 23:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403311; cv=none; b=gZTN1ZU6OgJV1uhRgP1r1+XaTs/S14tTYFJBrKShlX0vWoAimqg311oCCa9DaEd5//oztihyCR8OWhEAakBYl4GENftpsczgf3AqvRNi+fplzU3tKUPFLFXhF4okwK9PEYII1VvQoaTTwuwvmVKnoh8phou1YoL01fkFoU4b0ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403311; c=relaxed/simple;
	bh=FBrbufIW89lBQuXpw+ZdMhIeqRTfRU722Z+01IZyXFQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y7RUK5CADZpL0I56Il9nlqCCRyLwtyJNRAVK2ElbwrkLCvEqlzXKg6jxCiyAkurC497aQZhMv6bTng5H8aEaaKlok1C7cGUoN/g3F902eGCSxQSkVhAEAK4Iz5vDrCQiMUCjsWaMdcIqECl8dODCthxAEl79UqR6WsUGi+v2gMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=KMXTKa7D; arc=none smtp.client-ip=74.125.224.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="KMXTKa7D"
Received: by mail-yx2-f0.google.com with SMTP id 00721157ae682-81e7a64294cso4812867b3.1
        for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 16:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786403309; x=1787008109; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mdtz4Mve9gZWyg7/W/4j1az5CcZs4nMdS1zpm25kqRQ=;
        b=KMXTKa7DXG+IrCkrlSHP4lrnglw/xqxXc9J5cTHjQBUHaYop7mu2gMBfQqxf9NtkwS
         V+fePGB2iJoaP3y1X0Y9Hu/pZ6QR3doYZGHZ+95eh6Qu+ROF9WGr4KeASX782SIearLr
         BM8vkFmWARJbcQvABRMuK0n1JV0bwZNGWcpCWlt9x6NFf+CLV7ydO203m4ZoBl44jqXB
         WO8J8N1S8VP3OfqiLDPlIRD4ScpsJk4+53zXW5f9yelI1KGyQAX5ZUCyI3tc0TtrZgQM
         CgFjFVMj5rrmLGG69GHRZrucq06GgZjWIgwHPtgjWbRLol4NYm3FxAgKAMOG4r2zka+O
         P0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403309; x=1787008109;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mdtz4Mve9gZWyg7/W/4j1az5CcZs4nMdS1zpm25kqRQ=;
        b=d73i7Rnp8NUcRyQgssk1d0gkKmXPz1rj8jCt89ljo+PnYGRo/N+1tTU7IwcdfRnq3j
         q6M952xBOQYi8I4lUvbKUI0XwHUK/9kgiAl3ZXHKwPk6uzAd4enxzAd103li6jevUBoD
         +ePDK0eBv+yM4S9VRbU4Lf6L0olqt7Vveq9RIVWnerKqfsOSxs07Ogp76wfTG586tS1I
         IfI8vHI1gTPa/hiOMGS6kg6iqFPV7+BeS+lLCLU2fTxELfKYTBYIItHNVnbg+tQxW9v9
         bVGqgUrfkPoyrr0T0EeNbWM5l5W+bvjfcavIMMPwndn6sJ3I5OgSUNjyEXTBlZaZx/Gz
         YcBw==
X-Gm-Message-State: AOJu0YxB+96qZ5yfePhSw19A9nke9ukFkQXpWv9z5zOwWCDR7OdOuKd1
	GEbpefq1PEG86BVXVscT23O/o8CIieJQUnYbVDU+/zUfXeexDW/KZSKYg3c7Ev4Qhwc=
X-Gm-Gg: AR+sD132SFg9u5hjXvQhnWTV5abmIRQ6+Vqc426ce1qFqkCin4OZpdBA6neNUNO8EEw
	9Pi8H8VexI3SzVmdhO3JhUZ4Y53uRAu6mu95G+AB9/0hD//oxFJCnLdC1KVPsFHFQ12LHmAXkOv
	CPZiT8PLY0xPhZMnyyqHLczz6YWNutaEkjIpuknm1R1zJLr2zckJtCn7m52gI5hJi8dqxPwU4+e
	IEWSoxHMwFBLnfCoEpRl6r+l20aJNTHqfTAHwyo2hdxW6F93fZThaa7ClLJ07At/BGx6wQkf65Q
	ecobccx1wV0IazLpqVFJLE52bD30he6RIdKdjnC8iqQgdqNYfNK9aKYYxo0fSQN2S8GRAmQWfOR
	CeTNsoe+IeZIdGQTNzHIseM6MTsQUiz4/FeAxeYclmjzi3Avy+MfRFyuFckQVevaGwvDjdVad47
	x1J4ODYIDhWMaDQTXf8IKuosEgzZGMrbLbG8sVvZRdfngls3dRcalcqcUbDG4rOFDvI6GDWEzFy
	tI2VGwt6AXfpEMSVcWgNWBNJMHv3qSG+PsZBUW53/FHWu2sV+B89mp3oS3m6k0wW0Vj/GkVRPfG
	ZtpaPhMjWqUA3dM=
X-Received: by 2002:a05:690c:9992:b0:80b:bc16:8a2a with SMTP id 00721157ae682-8225e7d6b2bmr180882557b3.36.1786403308676;
        Mon, 10 Aug 2026 16:08:28 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:9c3:cf0:a72e:f469])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8268cc5131bsm47665657b3.13.2026.08.10.16.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:08:28 -0700 (PDT)
Message-ID: <e73c98b55247cf20a078933d7f3affdaf600ba1d.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: standardize the inode number type to u64
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>
Date: Mon, 10 Aug 2026 16:08:26 -0700
In-Reply-To: <20260810174857.74995-1-konishi.ryusuke@gmail.com>
References: <20260810174857.74995-1-konishi.ryusuke@gmail.com>
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

On Tue, 2026-08-11 at 02:48 +0900, Ryusuke Konishi wrote:
> Variables handling inode numbers - such as the 'i_ino' member of the
> inode structure - have been converted to 'u64' within the kernel to
> ensure consistency.=C2=A0 However, some parts of the nilfs2 implementatio=
n
> still use 'ino_t' or 'unsigned long' - both of which are
> architecture-dependent types - to handle inode numbers.
>=20
> Replace those remaining instances of 'ino_t' or 'unsigned long' with
> 'u64'.
>=20
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this for the next cycle.
>=20
> Following the treewide conversion of inode numbers to 64-bit, this
> cleans up the remaining architecture-dependent types in the nilfs2
> implementation, standardizing them to 'u64'.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/dir.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 +++++------
> =C2=A0fs/nilfs2/ifile.c=C2=A0=C2=A0=C2=A0 | 13 ++++++-------
> =C2=A0fs/nilfs2/ifile.h=C2=A0=C2=A0=C2=A0 | 10 ++++++----
> =C2=A0fs/nilfs2/inode.c=C2=A0=C2=A0=C2=A0 | 24 +++++++++++-------------
> =C2=A0fs/nilfs2/ioctl.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/nilfs2/namei.c=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++---
> =C2=A0fs/nilfs2/nilfs.h=C2=A0=C2=A0=C2=A0 | 15 +++++++--------
> =C2=A0fs/nilfs2/page.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 ++++-----
> =C2=A0fs/nilfs2/recovery.c |=C2=A0 4 ++--
> =C2=A0fs/nilfs2/segment.c=C2=A0 |=C2=A0 2 +-
> =C2=A010 files changed, 46 insertions(+), 50 deletions(-)
>=20
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 3653db5cdb65..8b53802b6ebd 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -169,17 +169,16 @@ static bool nilfs_check_folio(struct folio
> *folio, char *kaddr)
> =C2=A0	error =3D "disallowed inode number";
> =C2=A0bad_entry:
> =C2=A0	nilfs_error(sb,
> -		=C2=A0=C2=A0=C2=A0 "bad entry in directory #%llu: %s - offset=3D%lu,
> inode=3D%lu, rec_len=3D%zd, name_len=3D%d",
> +		=C2=A0=C2=A0=C2=A0 "bad entry in directory #%llu: %s - offset=3D%lu,
> inode=3D%llu, rec_len=3D%zd, name_len=3D%d",
> =C2=A0		=C2=A0=C2=A0=C2=A0 dir->i_ino, error, (folio->index << PAGE_SHIFT=
)
> + offs,
> -		=C2=A0=C2=A0=C2=A0 (unsigned long)le64_to_cpu(p->inode),
> -		=C2=A0=C2=A0=C2=A0 rec_len, p->name_len);
> +		=C2=A0=C2=A0=C2=A0 le64_to_cpu(p->inode), rec_len, p->name_len);
> =C2=A0	goto fail;
> =C2=A0Eend:
> =C2=A0	p =3D (struct nilfs_dir_entry *)(kaddr + offs);
> =C2=A0	nilfs_error(sb,
> -		=C2=A0=C2=A0=C2=A0 "entry in directory #%llu spans the page
> boundary offset=3D%lu, inode=3D%lu",
> +		=C2=A0=C2=A0=C2=A0 "entry in directory #%llu spans the page
> boundary offset=3D%lu, inode=3D%llu",
> =C2=A0		=C2=A0=C2=A0=C2=A0 dir->i_ino, (folio->index << PAGE_SHIFT) + off=
s,
> -		=C2=A0=C2=A0=C2=A0 (unsigned long)le64_to_cpu(p->inode));
> +		=C2=A0=C2=A0=C2=A0 le64_to_cpu(p->inode));
> =C2=A0fail:
> =C2=A0	return false;
> =C2=A0}
> @@ -387,7 +386,7 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode
> *dir, struct folio **foliop)
> =C2=A0	return NULL;
> =C2=A0}
> =C2=A0
> -int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr,
> ino_t *ino)
> +int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr,
> u64 *ino)
> =C2=A0{
> =C2=A0	struct nilfs_dir_entry *de;
> =C2=A0	struct folio *folio;
> diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
> index 99eb8a59009e..c99e1e6356ae 100644
> --- a/fs/nilfs2/ifile.c
> +++ b/fs/nilfs2/ifile.c
> @@ -49,7 +49,7 @@ static inline struct nilfs_ifile_info
> *NILFS_IFILE_I(struct inode *ifile)
> =C2=A0 * * %-ENOMEM	- Insufficient memory available.
> =C2=A0 * * %-ENOSPC	- No inode left.
> =C2=A0 */
> -int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
> +int nilfs_ifile_create_inode(struct inode *ifile, u64 *out_ino,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 struct buffer_head **out_bh)
> =C2=A0{
> =C2=A0	struct nilfs_palloc_req req;
> @@ -72,7 +72,7 @@ int nilfs_ifile_create_inode(struct inode *ifile,
> ino_t *out_ino,
> =C2=A0	nilfs_palloc_commit_alloc_entry(ifile, &req);
> =C2=A0	mark_buffer_dirty(req.pr_entry_bh);
> =C2=A0	nilfs_mdt_mark_dirty(ifile);
> -	*out_ino =3D (ino_t)req.pr_entry_nr;
> +	*out_ino =3D req.pr_entry_nr;
> =C2=A0	*out_bh =3D req.pr_entry_bh;
> =C2=A0	return 0;
> =C2=A0}
> @@ -88,7 +88,7 @@ int nilfs_ifile_create_inode(struct inode *ifile,
> ino_t *out_ino,
> =C2=A0 * * %-ENOENT	- Inode number unallocated.
> =C2=A0 * * %-ENOMEM	- Insufficient memory available.
> =C2=A0 */
> -int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
> +int nilfs_ifile_delete_inode(struct inode *ifile, u64 ino)
> =C2=A0{
> =C2=A0	struct nilfs_palloc_req req =3D {
> =C2=A0		.pr_entry_nr =3D ino, .pr_entry_bh =3D NULL
> @@ -123,21 +123,20 @@ int nilfs_ifile_delete_inode(struct inode
> *ifile, ino_t ino)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> -int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
> +int nilfs_ifile_get_inode_block(struct inode *ifile, u64 ino,
> =C2=A0				struct buffer_head **out_bh)
> =C2=A0{
> =C2=A0	struct super_block *sb =3D ifile->i_sb;
> =C2=A0	int err;
> =C2=A0
> =C2=A0	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
> -		nilfs_error(sb, "bad inode number: %lu", (unsigned
> long)ino);
> +		nilfs_error(sb, "bad inode number: %llu", ino);
> =C2=A0		return -EINVAL;
> =C2=A0	}
> =C2=A0
> =C2=A0	err =3D nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
> =C2=A0	if (unlikely(err))
> -		nilfs_warn(sb, "error %d reading inode: ino=3D%lu",
> -			=C2=A0=C2=A0 err, (unsigned long)ino);
> +		nilfs_warn(sb, "error %d reading inode: ino=3D%llu",
> err, ino);
> =C2=A0	return err;
> =C2=A0}
> =C2=A0
> diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
> index 5d116a566d9e..d38a46f5ae41 100644
> --- a/fs/nilfs2/ifile.h
> +++ b/fs/nilfs2/ifile.h
> @@ -19,7 +19,7 @@
> =C2=A0
> =C2=A0
> =C2=A0static inline struct nilfs_inode *
> -nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct
> buffer_head *ibh)
> +nilfs_ifile_map_inode(struct inode *ifile, u64 ino, struct
> buffer_head *ibh)
> =C2=A0{
> =C2=A0	size_t __offset_in_folio =3D nilfs_palloc_entry_offset(ifile,
> ino, ibh);
> =C2=A0
> @@ -31,9 +31,11 @@ static inline void nilfs_ifile_unmap_inode(struct
> nilfs_inode *raw_inode)
> =C2=A0	kunmap_local(raw_inode);
> =C2=A0}
> =C2=A0
> -int nilfs_ifile_create_inode(struct inode *, ino_t *, struct
> buffer_head **);
> -int nilfs_ifile_delete_inode(struct inode *, ino_t);
> -int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct
> buffer_head **);
> +int nilfs_ifile_create_inode(struct inode *ifile, u64 *out_ino,
> +			struct buffer_head **out_bh);
> +int nilfs_ifile_delete_inode(struct inode *ifile, u64 ino);
> +int nilfs_ifile_get_inode_block(struct inode *ifile, u64 ino,
> +				struct buffer_head **out_bh);
> =C2=A0
> =C2=A0int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
> =C2=A0
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 51f7e125a311..34e6096069ad 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -287,8 +287,7 @@ const struct address_space_operations
> nilfs_buffer_cache_aops =3D {
> =C2=A0};
> =C2=A0
> =C2=A0static int nilfs_insert_inode_locked(struct inode *inode,
> -				=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_root *root,
> -				=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long ino)
> +				struct nilfs_root *root, u64 ino)
> =C2=A0{
> =C2=A0	struct nilfs_iget_args args =3D {
> =C2=A0		.ino =3D ino, .root =3D root, .cno =3D 0, .type =3D
> NILFS_I_TYPE_NORMAL
> @@ -305,7 +304,7 @@ struct inode *nilfs_new_inode(struct inode *dir,
> umode_t mode)
> =C2=A0	struct nilfs_root *root;
> =C2=A0	struct buffer_head *bh;
> =C2=A0	int err =3D -ENOMEM;
> -	ino_t ino;
> +	u64 ino;
> =C2=A0
> =C2=A0	inode =3D new_inode(sb);
> =C2=A0	if (unlikely(!inode))
> @@ -443,7 +442,7 @@ int nilfs_read_inode_common(struct inode *inode,
> =C2=A0}
> =C2=A0
> =C2=A0static int __nilfs_read_inode(struct super_block *sb,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_root *root, unsigned long
> ino,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_root *root, u64 ino,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode)
> =C2=A0{
> =C2=A0	struct the_nilfs *nilfs =3D sb->s_fs_info;
> @@ -482,8 +481,8 @@ static int __nilfs_read_inode(struct super_block
> *sb,
> =C2=A0			huge_decode_dev(le64_to_cpu(raw_inode-
> >i_device_code)));
> =C2=A0	} else {
> =C2=A0		nilfs_error(sb,
> -			=C2=A0=C2=A0=C2=A0 "invalid file type bits in mode 0%o for
> inode %lu",
> -			=C2=A0=C2=A0=C2=A0 inode->i_mode, ino);
> +			"invalid file type bits in mode 0%o for
> inode %llu",
> +			inode->i_mode, ino);
> =C2=A0		err =3D -EIO;
> =C2=A0		goto failed_unmap;
> =C2=A0	}
> @@ -533,7 +532,7 @@ static int nilfs_iget_set(struct inode *inode,
> void *opaque)
> =C2=A0}
> =C2=A0
> =C2=A0struct inode *nilfs_ilookup(struct super_block *sb, struct
> nilfs_root *root,
> -			=C2=A0=C2=A0=C2=A0 unsigned long ino)
> +			=C2=A0=C2=A0=C2=A0 u64 ino)
> =C2=A0{
> =C2=A0	struct nilfs_iget_args args =3D {
> =C2=A0		.ino =3D ino, .root =3D root, .cno =3D 0, .type =3D
> NILFS_I_TYPE_NORMAL
> @@ -542,8 +541,8 @@ struct inode *nilfs_ilookup(struct super_block
> *sb, struct nilfs_root *root,
> =C2=A0	return ilookup5(sb, ino, nilfs_iget_test, &args);
> =C2=A0}
> =C2=A0
> -struct inode *nilfs_iget_locked(struct super_block *sb, struct
> nilfs_root *root,
> -				unsigned long ino)
> +struct inode *nilfs_iget_locked(struct super_block *sb,
> +				struct nilfs_root *root, u64 ino)
> =C2=A0{
> =C2=A0	struct nilfs_iget_args args =3D {
> =C2=A0		.ino =3D ino, .root =3D root, .cno =3D 0, .type =3D
> NILFS_I_TYPE_NORMAL
> @@ -553,7 +552,7 @@ struct inode *nilfs_iget_locked(struct
> super_block *sb, struct nilfs_root *root,
> =C2=A0}
> =C2=A0
> =C2=A0struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root
> *root,
> -			 unsigned long ino)
> +			 u64 ino)
> =C2=A0{
> =C2=A0	struct inode *inode;
> =C2=A0	int err;
> @@ -579,8 +578,7 @@ struct inode *nilfs_iget(struct super_block *sb,
> struct nilfs_root *root,
> =C2=A0	return inode;
> =C2=A0}
> =C2=A0
> -struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned
> long ino,
> -				__u64 cno)
> +struct inode *nilfs_iget_for_gc(struct super_block *sb, u64 ino,
> __u64 cno)
> =C2=A0{
> =C2=A0	struct nilfs_iget_args args =3D {
> =C2=A0		.ino =3D ino, .root =3D NULL, .cno =3D cno, .type =3D
> NILFS_I_TYPE_GC
> @@ -740,7 +738,7 @@ void nilfs_write_inode_common(struct inode
> *inode,
> =C2=A0
> =C2=A0void nilfs_update_inode(struct inode *inode, struct buffer_head
> *ibh, int flags)
> =C2=A0{
> -	ino_t ino =3D inode->i_ino;
> +	u64 ino =3D inode->i_ino;
> =C2=A0	struct nilfs_inode_info *ii =3D NILFS_I(inode);
> =C2=A0	struct inode *ifile =3D ii->i_root->ifile;
> =C2=A0	struct nilfs_inode *raw_inode;
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 0957316e58b8..01a04080ef70 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -612,7 +612,7 @@ static int nilfs_ioctl_move_blocks(struct
> super_block *sb,
> =C2=A0	struct nilfs_vdesc *vdesc;
> =C2=A0	struct buffer_head *bh, *n;
> =C2=A0	LIST_HEAD(buffers);
> -	ino_t ino;
> +	u64 ino;
> =C2=A0	__u64 cno;
> =C2=A0	int i, ret;
> =C2=A0
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index e2fe95de3d71..6a482da7c682 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -54,7 +54,7 @@ static struct dentry *
> =C2=A0nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int
> flags)
> =C2=A0{
> =C2=A0	struct inode *inode;
> -	ino_t ino;
> +	u64 ino;
> =C2=A0	int res;
> =C2=A0
> =C2=A0	if (dentry->d_name.len > NILFS_NAME_LEN)
> @@ -69,7 +69,7 @@ nilfs_lookup(struct inode *dir, struct dentry
> *dentry, unsigned int flags)
> =C2=A0		inode =3D nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root,
> ino);
> =C2=A0		if (inode =3D=3D ERR_PTR(-ESTALE)) {
> =C2=A0			nilfs_error(dir->i_sb,
> -					"deleted inode referenced:
> %lu", ino);
> +				"deleted inode referenced: %llu",
> ino);
> =C2=A0			return ERR_PTR(-EIO);
> =C2=A0		}
> =C2=A0	}
> @@ -463,7 +463,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
> =C2=A0 */
> =C2=A0static struct dentry *nilfs_get_parent(struct dentry *child)
> =C2=A0{
> -	ino_t ino;
> +	u64 ino;
> =C2=A0	int res;
> =C2=A0	struct nilfs_root *root;
> =C2=A0
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index b7e3d91b6243..4fc42d3787a4 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -144,7 +144,7 @@ enum {
> =C2=A0	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS &
> BIT(ino))))
> =C2=A0
> =C2=A0#define NILFS_PRIVATE_INODE(ino)
> ({					\
> -	ino_t __ino =3D
> (ino);						\
> +	u64 __ino =3D
> (ino);						\
> =C2=A0	((__ino) < NILFS_USER_INO && (__ino) !=3D NILFS_ROOT_INO
> &&	\
> =C2=A0	 (__ino) !=3D NILFS_SKETCH_INO); })
> =C2=A0
> @@ -255,7 +255,7 @@ static inline __u32 nilfs_mask_flags(umode_t
> mode, __u32 flags)
> =C2=A0
> =C2=A0/* dir.c */
> =C2=A0int nilfs_add_link(struct dentry *, struct inode *);
> -int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr,
> ino_t *ino);
> +int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr,
> u64 *ino);
> =C2=A0int nilfs_make_empty(struct inode *, struct inode *);
> =C2=A0struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const
> struct qstr *,
> =C2=A0		struct folio **);
> @@ -287,13 +287,12 @@ extern int nilfs_read_inode_common(struct inode
> *, struct nilfs_inode *);
> =C2=A0void nilfs_write_inode_common(struct inode *inode,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_inode *raw_inode);
> =C2=A0struct inode *nilfs_ilookup(struct super_block *sb, struct
> nilfs_root *root,
> -			=C2=A0=C2=A0=C2=A0 unsigned long ino);
> -struct inode *nilfs_iget_locked(struct super_block *sb, struct
> nilfs_root *root,
> -				unsigned long ino);
> +			=C2=A0=C2=A0=C2=A0 u64 ino);
> +struct inode *nilfs_iget_locked(struct super_block *sb,
> +				struct nilfs_root *root, u64 ino);
> =C2=A0struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root
> *root,
> -			 unsigned long ino);
> -extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long ino, __u64
> cno);
> +			 u64 ino);
> +struct inode *nilfs_iget_for_gc(struct super_block *sb, u64 ino,
> __u64 cno);
> =C2=A0int nilfs_attach_btree_node_cache(struct inode *inode);
> =C2=A0void nilfs_detach_btree_node_cache(struct inode *inode);
> =C2=A0struct inode *nilfs_iget_for_shadow(struct inode *inode);
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 1d00bce21c37..cf4f1c6798f5 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -154,7 +154,7 @@ void nilfs_folio_bug(struct folio *folio)
> =C2=A0{
> =C2=A0	struct buffer_head *bh, *head;
> =C2=A0	struct address_space *m;
> -	unsigned long ino;
> +	u64 ino;
> =C2=A0
> =C2=A0	if (unlikely(!folio)) {
> =C2=A0		printk(KERN_CRIT "NILFS_FOLIO_BUG(NULL)\n");
> @@ -164,10 +164,9 @@ void nilfs_folio_bug(struct folio *folio)
> =C2=A0	m =3D folio->mapping;
> =C2=A0	ino =3D m ? m->host->i_ino : 0;
> =C2=A0
> -	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=3D%d index#=3D%llu
> flags=3D0x%lx "
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mapping=3D%p ino=3D%lu\n",
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio, folio_ref_count(folio),
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long long)folio->index, =
folio->flags.f, m,
> ino);
> +	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=3D%d index#=3D%lu
> flags=3D0x%lx=C2=A0 mapping=3D%p ino=3D%llu\n",
> +		folio, folio_ref_count(folio), folio->index, folio-
> >flags.f,
> +		m, ino);
> =C2=A0
> =C2=A0	head =3D folio_buffers(folio);
> =C2=A0	if (head) {
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index 4d5a6aa5214c..45fb37215669 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -34,7 +34,7 @@ enum {
> =C2=A0
> =C2=A0/* work structure for recovery */
> =C2=A0struct nilfs_recovery_block {
> -	ino_t ino;		/*
> +	u64 ino;		/*
> =C2=A0				 * Inode number of the file that
> this block
> =C2=A0				 * belongs to
> =C2=A0				 */
> @@ -333,7 +333,7 @@ static int nilfs_scan_dsync_log(struct the_nilfs
> *nilfs, sector_t start_blocknr,
> =C2=A0	unsigned int offset;
> =C2=A0	u32 nfinfo, sumbytes;
> =C2=A0	sector_t blocknr;
> -	ino_t ino;
> +	u64 ino;
> =C2=A0	int err =3D -EIO;
> =C2=A0
> =C2=A0	nfinfo =3D le32_to_cpu(sum->ss_nfinfo);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 5896fdae5669..829573cb6131 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1610,7 +1610,7 @@ nilfs_segctor_update_payload_blocknr(struct
> nilfs_sc_info *sci,
> =C2=A0	struct nilfs_finfo *finfo =3D NULL;
> =C2=A0	union nilfs_binfo binfo;
> =C2=A0	struct buffer_head *bh, *bh_org;
> -	ino_t ino =3D 0;
> +	u64 ino =3D 0;
> =C2=A0	int err =3D 0;
> =C2=A0
> =C2=A0	if (!nfinfo)

Applied.

Thanks,
Slava.
