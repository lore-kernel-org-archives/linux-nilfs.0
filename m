Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC626A0D5
	for <linux-nilfs@vger.kernel.org>; Mon, 14 Sep 2026 06:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367629; cv=pass; b=ooF7kpfheJHiBNDKLpJ5dcUxoC/QZnzGt8ukom/RVv9XOmFBt53DhXFydcGg9MXJvHVcBgmf58OOoDQzEgi0u3E9OPQZpZaoDmvy8Sgd/lvEK6Tlbl69oTNOmID4BnEXse6whaYmAr85cfr9m00est4XQix2z+PfOUYzeivP9R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367629; c=relaxed/simple;
	bh=qVSQb5UUFlpMpFF0qmD+S8EfZnmOQhZUseo8tX+4a6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pGls20epTk15QERMjGpYmIL0wmwc3LrGcZiv3PEVbh8v19ZqH1Q5JducbPHkpjhYrhtRjVWPZ8j1Bh/fxdR6Ii0n1ynplJx4xFb7ox1WHNdEStJHiteDyp8c53k5KQ5LYed3sN3z4wQ+5rStZhg8I1pJ+Sj2NuiBb2kh7n1pOyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JK0H0Ff+; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JK0H0Ff+"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2940d16190so402910966b.3
        for <linux-nilfs@vger.kernel.org>; Sun, 13 Sep 2026 23:33:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789367625; cv=none;
        d=google.com; s=arc-20260327;
        b=MeD7CfMHfIB0aY1aiZJark8mUd7D1qq3Q3p2Am4hSyzRGicQk8QWruKie2SwL3drVr
         6F7etcbSlQrso9yHflDiBmkclkU82/L3fLxqS/6C1bpMPSSUqp9+/3S8zvrOpBafik5q
         2afaQx0HPJXLD765bwT+fhv+trCWCd1cqzEiT1AYudLdpTc7pDLqRM2cglsRWJ4yp9JE
         Q4TieCE8ljr1r0ywj93wK1V1QdP/8ra+6UhUJovl6JzUb5mNqQm307T7jvJf2tGY3Wij
         BUTaqtO9cu0vjkyp+PoS/cOj9x94wvLNfETg4kwUOg5aDeILPTXG6FbGqXqyZ/JeKGWJ
         UYAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L1bl/zgD2IYrG14tFUreeapLVdf9wP0XTfEPxuKsnHs=;
        fh=uJVOEPtp1fBsqNmDSRNylb65kU4x+6x5B/lduNecpAA=;
        b=rzTGE2fLCh+SmS+Zj1unXGKBjicvOsfEBSNQ2JasTnCwcaMyqoWI4lP000KWPXJpDY
         r1Hj8y9aNVRMcn5ldX/iMaL5SHq2zmMKYbREShEiPih5cup3XFeTj9ge0eq2ceBbT+51
         XOrIrdXhcq9RJ8DwfYG5qB0atdFi1uxyJ1w7193zlrqZKYYY5+PWf8IrgbfA0EUCsgBB
         Kd9OTHk0edtvt/Jxai72TTHc1H3slafHsZDge/54B1kClLtYNHZ2foSfR9tSs5i3qVRN
         UO1y73j331jXirWS5cWCAdUOB55ZXEInxRT3KsF+n9ASc6258f7s9y7o0qLLuoUgq/NQ
         hriQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789367625; x=1789972425; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L1bl/zgD2IYrG14tFUreeapLVdf9wP0XTfEPxuKsnHs=;
        b=JK0H0Ff+FyAQnZmfdGZDax2f7sDpxEi+EHJU8oXziFlzHW/vxw4YzGfZOlegD+AizZ
         KBpK1dR+xewxTndkOc5DUXOz7kHiXKZdfctyZUx9XKn+vsuiefBRIF440QyszywTuCO+
         R+BSyLF74m5EkXPKVrU1iG0EpcMDMc/ijKlIb6JIAz0Yhmo5ofma8dwcQ7vE7pQMsKtw
         cykBsjFbPEo8acMj2xqQj+/HEaQyNh6nrgPixlhfoH9Rpnh/4yrlwYpAHhhMCZA+VgZr
         +mP3KtXG3pNbI9DqsQjO8CPWQQ+Xvw0EXBtNGMVHMU2/ic88b/RGGVVbPwmrMKXCzXBh
         y89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789367625; x=1789972425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L1bl/zgD2IYrG14tFUreeapLVdf9wP0XTfEPxuKsnHs=;
        b=EUFFCWZOGTuPuwviXXLWuYjO6raQ6iMjMIQK9vx8LkP+8Lb5QfBdv+W4VvyHEf0yri
         FjRHOEllSqIP1Wruhy9VGjYhWvTgJ5l9hOoPtxg6hN8i7oII8sJQ4x5tClxDDGyTkcJs
         waCzpKuEjUdQGlT3MtIZufb8B+CiF1eViO8HfMrlIQ+Z984drZ8QfYdRT2meY+ip/33y
         nXYM+9wDG5JaYVD+UvSNvQs/srbyUjHgtd82n96U0LiajIbQQtVf8tNqPBSDFc3Dzr9Z
         rmMpYiAKvoDVNbECjRCZHiCo1wdvUwTt6UGYkGLS9nmnv6HITWs4zqgeLi7cAaVZLdgW
         TCTQ==
X-Forwarded-Encrypted: i=1; AKwUvByU2Z9LJcIeJfKFjg7UEAcAZlsWtnIDriYGZxB9m4+mqAOFMOKUnEYsNmkDMiY0/DdCW3zlY5JGfYofmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kmj5owxNxo8vTCYrh0V4/67/7Tp2LqndW3ImtXxeoiCPXbxZno
	vMed5v6DdGt9myjDpQBqSd85FFYTYjF3g3fXDUvqudPltv2HEoNY1J64Ff864VSVPKCS2BGiLaO
	VSZmi9mMh5wl9fZzUafoZ+B7xW87XljE=
X-Gm-Gg: AYBFou3aj8qFsoBvcAc1Xy4Rnh7we5h8KJLezMCeLs8PvzVj/dbqoCRPTgOQB27/HpQ
	nFwi5KmrmumemALe4Addr39ydcRvnOx6j5e+BAl0aRdVuktUeVa+M1db13HgRw1f137s9/YT5n5
	AC5RTGWJ8tRzONspTyCk764IXP3kya8TsuvFAUe9G/pctgysRg24aE8dIvMXPnHYqD9Vh0Ivg/7
	yWyth6WJR4IGplQoH5NfFIRA9/j0KZSZncmaztkwFfcWKxdHwjVqY6omzrgNBgDKmrcx5JjPzYI
	oVcSacfpwpQioiM9aYZczJG1kzzgA8Q24dP5ZGcsLTjadDfydqgaD5tX
X-Received: by 2002:a17:906:c141:b0:c25:8fdf:5d with SMTP id
 a640c23a62f3a-c29b86437f4mr74739566b.13.1789367624974; Sun, 13 Sep 2026
 23:33:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902112121.2125383-1-r772577952@gmail.com>
In-Reply-To: <20260902112121.2125383-1-r772577952@gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Mon, 14 Sep 2026 14:33:06 +0800
X-Gm-Features: AcwNN1V6HA7__x-qs1jz9zxjUs2k93iWNhWdQUddsFYjpV1H5xAynXB3NocEWPg
Message-ID: <CANypQFbTTggAnGvdw_O7zxxZ1JNY5_eUBBBPxTW4aW2dqYxQ4Q@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: force clear dirty state when restoring from
 the shadow map
To: konishi.ryusuke@gmail.com, linux-nilfs@vger.kernel.org, slava@dubeyko.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=B8=89 19:21=E5=86=99=E9=81=93=EF=BC=9A
>
> When garbage collection fails, nilfs2 rolls the DAT metadata file's page
> cache back to a shadow copy taken before GC started.
> nilfs_clear_dirty_pages() drops the dirty state of the folios in the DAT
> cache, then nilfs_copy_back_pages() overwrites them with the saved
> contents and warns if one is still dirty:
>
>         /* overwrite existing folio in the destination cache */
>         WARN_ON(folio_test_dirty(dfolio));
>
> nilfs_clear_dirty_pages() used to clear the dirty state unconditionally,
> which is safe here because the rollback runs with the log writer
> stopped, so nothing else can dirty the cache while it runs.  The same
> helper is also used when writeback finds dirty folios after the
> filesystem has degraded to read-only, where it does run concurrently
> with the log writer, so commit ca76bb226bf4 ("nilfs2: do not force clear
> folio if buffer is referenced") made nilfs_clear_folio_dirty() skip a
> folio if any of its buffer heads is busy.  The rollback caller shares
> that helper, so its clearing step can now return with a folio still
> dirty.
>
> A DAT folio can hold a busy buffer head without anyone modifying the
> folio: nilfs_mdt_read_block() submits read-ahead for the blocks
> following the one it was asked for and waits only for the first, so the
> read-ahead buffers are still locked when it returns.  With a block size
> smaller than the page size, a locked read-ahead buffer can share a folio
> with a block that GC dirtied and keep the whole folio dirty past the
> clearing step.
>
> Add a force flag to nilfs_clear_dirty_pages() and
> nilfs_clear_folio_dirty() that skips the busy buffer check, and set it
> in the two calls from nilfs_mdt_restore_from_shadow_map().  The
> read-only fallback callers keep passing false, so that commit still
> protects them and the WARN_ON() is left alone.
>
> Fixes: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is refer=
enced")
> Closes: https://lore.kernel.org/lkml/CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOe=
wQoAi_V5yY0dTtg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
> Changes in v2:
> - Keep the WARN_ON() in nilfs_copy_back_pages() untouched.
> - Add a bool force argument to nilfs_clear_dirty_pages() and
>   nilfs_clear_folio_dirty(), and set it to true in the two calls from
>   nilfs_mdt_restore_from_shadow_map().
>
> v1: https://lore.kernel.org/lkml/20260901134430.1292467-1-r772577952@gmai=
l.com/
>
>  fs/nilfs2/inode.c |  2 +-
>  fs/nilfs2/mdt.c   |  6 +++---
>  fs/nilfs2/page.c  | 50 +++++++++++++++++++++++++++--------------------
>  fs/nilfs2/page.h  |  4 ++--
>  4 files changed, 35 insertions(+), 27 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..64437aed8390 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -163,7 +163,7 @@ static int nilfs_writepages(struct address_space *map=
ping,
>         int err =3D 0;
>
>         if (sb_rdonly(inode->i_sb)) {
> -               nilfs_clear_dirty_pages(mapping);
> +               nilfs_clear_dirty_pages(mapping, false);
>                 return -EROFS;
>         }
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 2a435349fd21..b50c88b65183 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -405,7 +405,7 @@ static int nilfs_mdt_write_folio(struct folio *folio,
>                  * have dirty folios that try to be flushed in background=
.
>                  * So, here we simply discard this dirty folio.
>                  */
> -               nilfs_clear_folio_dirty(folio);
> +               nilfs_clear_folio_dirty(folio, false);
>                 folio_unlock(folio);
>                 return -EROFS;
>         }
> @@ -648,10 +648,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode=
 *inode)
>         if (mi->mi_palloc_cache)
>                 nilfs_palloc_clear_cache(inode);
>
> -       nilfs_clear_dirty_pages(inode->i_mapping);
> +       nilfs_clear_dirty_pages(inode->i_mapping, true);
>         nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping)=
;
>
> -       nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
> +       nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
>         nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
>                               NILFS_I(shadow->inode)->i_assoc_inode->i_ma=
pping);
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index cf4f1c6798f5..857926da9f21 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -369,8 +369,9 @@ void nilfs_copy_back_pages(struct address_space *dmap=
,
>  /**
>   * nilfs_clear_dirty_pages - discard dirty pages in address space
>   * @mapping: address space with dirty pages for discarding
> + * @force: whether to clear the dirty state regardless of busy buffer he=
ads
>   */
> -void nilfs_clear_dirty_pages(struct address_space *mapping)
> +void nilfs_clear_dirty_pages(struct address_space *mapping, bool force)
>  {
>         struct folio_batch fbatch;
>         unsigned int i;
> @@ -391,7 +392,7 @@ void nilfs_clear_dirty_pages(struct address_space *ma=
pping)
>                          * was acquired.  Skip processing in that case.
>                          */
>                         if (likely(folio->mapping =3D=3D mapping))
> -                               nilfs_clear_folio_dirty(folio);
> +                               nilfs_clear_folio_dirty(folio, force);
>
>                         folio_unlock(folio);
>                 }
> @@ -403,13 +404,16 @@ void nilfs_clear_dirty_pages(struct address_space *=
mapping)
>  /**
>   * nilfs_clear_folio_dirty - discard dirty folio
>   * @folio: dirty folio that will be discarded
> + * @force: whether to clear the states regardless of busy buffer heads
>   *
>   * nilfs_clear_folio_dirty() clears working states including dirty state=
 for
> - * the folio and its buffers.  If the folio has buffers, clear only if i=
t is
> - * confirmed that none of the buffer heads are busy (none have valid
> - * references and none are locked).
> + * the folio and its buffers.  If the folio has buffers and force is fal=
se,
> + * clear only if it is confirmed that none of the buffer heads are busy =
(none
> + * have valid references and none are locked).  If force is true, the st=
ates
> + * are cleared unconditionally, the caller should guarantee that the fol=
io is
> + * not being modified concurrently.
>   */
> -void nilfs_clear_folio_dirty(struct folio *folio)
> +void nilfs_clear_folio_dirty(struct folio *folio, bool force)
>  {
>         struct buffer_head *bh, *head;
>
> @@ -422,24 +426,28 @@ void nilfs_clear_folio_dirty(struct folio *folio)
>                          BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
>                          BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected)=
 |
>                          BIT(BH_Delay));
> -               bool busy, invalidated =3D false;
> +
> +               if (!force) {
> +                       bool busy, invalidated =3D false;
>
>  recheck_buffers:
> -               busy =3D false;
> -               bh =3D head;
> -               do {
> -                       if (atomic_read(&bh->b_count) | buffer_locked(bh)=
) {
> -                               busy =3D true;
> -                               break;
> +                       busy =3D false;
> +                       bh =3D head;
> +                       do {
> +                               if (atomic_read(&bh->b_count) |
> +                                   buffer_locked(bh)) {
> +                                       busy =3D true;
> +                                       break;
> +                               }
> +                       } while (bh =3D bh->b_this_page, bh !=3D head);
> +
> +                       if (busy) {
> +                               if (invalidated)
> +                                       return;
> +                               invalidate_bh_lrus();
> +                               invalidated =3D true;
> +                               goto recheck_buffers;
>                         }
> -               } while (bh =3D bh->b_this_page, bh !=3D head);
> -
> -               if (busy) {
> -                       if (invalidated)
> -                               return;
> -                       invalidate_bh_lrus();
> -                       invalidated =3D true;
> -                       goto recheck_buffers;
>                 }
>
>                 bh =3D head;
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index 136cd1c143c9..c3ba3468af5c 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -41,8 +41,8 @@ void nilfs_folio_bug(struct folio *);
>
>  int nilfs_copy_dirty_pages(struct address_space *, struct address_space =
*);
>  void nilfs_copy_back_pages(struct address_space *, struct address_space =
*);
> -void nilfs_clear_folio_dirty(struct folio *folio);
> -void nilfs_clear_dirty_pages(struct address_space *mapping);
> +void nilfs_clear_folio_dirty(struct folio *folio, bool force);
> +void nilfs_clear_dirty_pages(struct address_space *mapping, bool force);
>  unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
>                 unsigned int from, unsigned int to);
>  unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
> --
> 2.43.0
>

Friendly ping, please tell me if any further changes is needed.
