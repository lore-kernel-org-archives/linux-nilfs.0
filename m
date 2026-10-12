Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FE1425898
	for <linux-nilfs@vger.kernel.org>; Mon, 12 Oct 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791844489; cv=none; b=FDfD57yCmErB4+4NLShsGgPXFPJthFIUKVcCuapvR5/jKfRdkHq54VuvnhwZ+1ULDH1124hXcUDjek03pkNBjtSSlgYHURAI53JBADo0lb4dNxrK8uhrq/CCYhX87exQSlXNJRz4QJeM+mHGf9FrW5T1GDIURgqBJijYar/O7E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791844489; c=relaxed/simple;
	bh=J2HTAotR7tV6EhRt0H4zRc9Ubr6pAv1DK5kmv6KCXxc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FNk+geLBtf7Gdo7JEP8Tz+VvEku2YlZz8u63FJNEdfdJ3fGXhDM8KgYVwhaGLkjiOuULoRApD2ff9mcePRJGD7i+6xlNMNccIJPyzO7LuAm1M+6TmY7TsEqYEI6ZuUgNVfbSaUXLh7K6HxWTgOnETAzXBPkDO8QZ3UeQSqRFRpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=ww+NGN8s; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="ww+NGN8s"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b0a921ee46so9991457b3.2
        for <linux-nilfs@vger.kernel.org>; Mon, 12 Oct 2026 15:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1791844487; x=1792449287; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=71EqnmdUFPL0oyce+6aQMAYEr0rHGu143nkPC8VddIM=;
        b=ww+NGN8socQfljOHR4VrazNZV3TFB7mIUSpAJpIPDAbWjzSW0cM3Q3Vwp8XBDJ90gv
         4k3faVhoUjWcT4wcqqQg3xY9JvNCFtnfPeJUaRercCCNSno5H+DVK+4MjZ1CTruXCoUg
         VLr6sI+XbHXsQyKVCfWCmLC4JVjnFM/XnPIGMHsFuD9+TQAJAzJLh0F7FiUVhK5cNBhr
         iKDLxyBZjgoe8IevQfxpIJ8s3hxoxX0rF7374YDHjrcamaA/Hk3hf/F/rZqBbwauIpXE
         8WUcJyDJ2ZyHsfbGA5T5tUzOr6C2Z9wqWOK6Nr89hSUCADkDHUDqnDE22XgJfuCzwNH3
         vw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844487; x=1792449287;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=71EqnmdUFPL0oyce+6aQMAYEr0rHGu143nkPC8VddIM=;
        b=cf/8oGPcPtwhJX8oICE/FLznoMDoY08v1USm5hg+bENrX9r1fyVpATF8huU9g4fiiB
         bL/jyyYu6DdblLHPTj2xDXhJj7W0pDTIi8sQzjbo5CqvHA6B7Azl3r6EartO17NUFkBd
         iYbjQuT4WlQrY7lJv689LnVKM+q4pUL6Fv+97W8fsbUOEglFb0VtwUkhX4kuPkB4SIr6
         y2ndxW61nSdQjvwKh45xZM412V9Ha4/lIqX6hejabeYMjs0zRHuxR7eEqiza8G7v1yFg
         3M/XlbHEk97szs+InN5bNtGqVV3cLTsBgyvqgaTXQY6UR4gE4ze9W5+DtzkdlEbE4Fmt
         Bryg==
X-Forwarded-Encrypted: i=1; AKwUvBz6DEFrj81wX5EkJ/j6X0RW6voJSbP7mnODJF4ZpQzwIyJ778QDzSt925xI4ymXlpqYjT+ht/fq9jT3Ew==@vger.kernel.org
X-Gm-Message-State: AFq9FYLM91u+x96qGHBoExQ32f7jDLunffFk9DAEE18qKbdCaunSbqFV
	jmMZRuuvIccQDYm7++Bs0MIr/vC5p8333u9TSEoNB1RAr19nO78NtArVjy9eHRxG1yo=
X-Gm-Gg: AYBFou3IRH6q40DSdc2DtnamegU8D5di+GhUOd2dpXgKNiuxLp+H88eYlUNN4cJvA3P
	oRoGzGcZj2cg6RVlXSrNsCFndm4nwsSYqOUd7SwXTjqFtfAS9DhY2ECN9SsjfrSM1lKWcJcFbaM
	Hqwyy4zaLqFO4k7mC1Q8RJUXeNh+OLbZTvFVLymiNjgOPaei9eCk8uujE5FIDeeEgdRQqkOl4Qn
	IUR7JpbsQeYeS8wjgmQAY3TN/xuannPYiAd0VY37wzPoh82i4otFlrlvRhkVXEMve9VJ7xJVh+F
	ybKkRHaWZ7inV8zVyDmO7grZYC7M1e3eY3RXLajETjYn/CYu7b5WEYWytZKwEf5ehwBNbjTaNiz
	n7bsFP2yt44QC2tOSz8sGzdvRbloc9JZPHdzDdHcTsn0T/SjlMHXXjd3rCIg1SKu4F1jtS2Su27
	BBBteJJECLNuJWSKsxAZQLkQpFaD+wm6RKyvMzsjQ9fhWFVr7OotjAax9nUAAj1wpUONhfAZkvv
	K36P7jb8Z5hKXfG4cx3+/DM0DqOgnGDD8PJ+lvVkRVMkNyYkymPvVHfos5kSXIKj/tABTQu0bnD
	n5ny5GB/ylpAvWe6nMoAwpX6LBPmK+Rs
X-Received: by 2002:a05:690c:7108:b0:8b0:4f12:d36f with SMTP id 00721157ae682-8b07ed609b7mr36562257b3.52.1791844487244;
        Mon, 12 Oct 2026 15:34:47 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430::48? ([2600:1700:6476:1430::48])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b0ab2e8d0fsm9306077b3.22.2026.10.12.15.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 15:34:46 -0700 (PDT)
Message-ID: <2e7d65d349c6691697f02f98f733a651ce3aa116.camel@dubeyko.com>
Subject: Re: [Jfs-discussion] [PATCH RFC 10/28] hfsplus: don't set SB_RDONLY
 when creating the attributes tree
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.com>
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, ntfs@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, 	ecryptfs@vger.kernel.org,
 gfs2@lists.linux.dev, exfat@lists.linux.dev, 	linux-efi@vger.kernel.org,
 linux-mtd@lists.infradead.org, Al Viro	 <viro@zeniv.linux.org.uk>,
 linux-fsdevel@vger.kernel.org, 	linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Date: Mon, 12 Oct 2026 15:34:42 -0700
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-10-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
	 <20261012-work-fs-sb_rdonly-v1-10-60743a3dc326@kernel.org>
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

On Mon, 2026-10-12 at 12:20 +0200, Christian Brauner via Jfs-discussion
wrote:
> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree
> doesn't
> mark the header node as used. That's fine while mounting where the
> mounter holds sb->s_umount. But hfsplus_create_attributes_file()
> calls
> it too when the first extended attribute gets set on a filesystem
> that
> doesn't have an attributes file yet. That runs on the live filesystem
> without s_umount and a filesystem must not change SB_RDONLY behind
> the
> VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created
> itself, with the header node marked as used. So there's nothing to
> check there. Only do the check while the filesystem is being mounted.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfsplus/btree.c | 7 ++++++-
> =C2=A01 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
> index 2ea8cd5658e1..967c457d843d 100644
> --- a/fs/hfsplus/btree.c
> +++ b/fs/hfsplus/btree.c
> @@ -385,7 +385,12 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	if (IS_ERR(node))
> =C2=A0		goto free_inode;
> =C2=A0
> -	if (!hfs_bmap_test_bit(node, 0)) {
> +	/*
> +	 * Only a mount may set SB_RDONLY, later that needs
> s_umount. After the
> +	 * mount this only opens the attributes tree that
> +	 * hfsplus_create_attributes_file() just created with the
> bit set.
> +	 */
> +	if (!(sb->s_flags & SB_BORN) && !hfs_bmap_test_bit(node, 0))
> {
> =C2=A0		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> =C2=A0				sb->s_id, hfs_btree_name(id), id);
> =C2=A0		pr_warn("Run fsck.hfsplus to repair.\n");

Yes, we can do this. But, maybe, we need to move this check:

	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
	if (IS_ERR(node))
		goto free_inode;

	if (!hfs_bmap_test_bit(node, 0)) {
		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
bitmap corruption detected, forcing read-only.\n",
				sb->s_id, hfs_btree_name(id), id);
		pr_warn("Run fsck.hfsplus to repair.\n");
		sb->s_flags |=3D SB_RDONLY;
	}

	hfs_bnode_put(node);

into hfsplus_fill_super(). Because, then main point of this check
namely check the b-trees during mount. If we create Attributes File
during setting a first xattr, then map record is always valid. It
sounds to me like more clean solution. What do you think?

Thanks,
Slava.
