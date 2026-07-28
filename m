Received: from mail-yx2-f2.google.com (mail-yx2-f2.google.com [74.125.224.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E221ABC9
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785283024; cv=none; b=rXZOlMF3MbWLcP+FxXWgrXZwxbJP4aCas2imKs7jNpEl1eOf1wceyGkXxh8fKu7XpP1JZgwN9AoeYfrObkB4WRv2exG2XKLR+zxIewJnS2VS3I06rbmf+rcY4EjpLiW3ipN6fUfNw8eT7WDYlVQpSymXXBZjfnPuCdb42IKjo1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785283024; c=relaxed/simple;
	bh=8naspTudp50xj0goy0S849XPvZ79RoJ4z+jOViVzzAk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VlTqCX/x5ttibGVAYEXek7zw4fHKnb8gsT5/mVKA/yVxtTyHjvl9Glc02qHPDQe5JppJT9VcP+lvxnK3oHxh3jGce43wUCEsCoVgUl0jetEqKvpClNJ4sG/DtJwu1et5n2xYmKoPwRHCJjeIX4pvqQchQGO10ZOq/a7bd+/oNyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=qqYEcBGv; arc=none smtp.client-ip=74.125.224.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="qqYEcBGv"
Received: by mail-yx2-f2.google.com with SMTP id 00721157ae682-81f48ae80feso2579997b3.0
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785283021; x=1785887821; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=32wKGwvjwqfLOfIf5NfxbpKtE655uaW4tNdfVjx28Qk=;
        b=qqYEcBGv5sLus500zX2AnDTuQvmhPkqtOLdzytbL7x3JyF0xBFoLg9pBXbP5rrlUfr
         3NhHP0w+qJM143AlUOINbm6tabe1yIwsMNVZ5x+Cukow2YNg/uO8V/REMquCpeW43YEs
         +FlOucPGCnu0HuAJKPbvYXKjJW2Ipkqq54t3QIwK4+mNA5GCsnjmNoGUyfo9+PWHg9nP
         X/EnaDRox3KJ9n6RlJRu3EmM//dyVIVC2A4A8bRaDIbnl7wd7bWPPfRfp7RQErLdv1kW
         aiKNneIrp4xvYlAZyVsSv5UbxX57+UxU7aUFGW+IRrt9MHch+xNj21fuQwcxnXzdA4FT
         Qmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785283021; x=1785887821;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=32wKGwvjwqfLOfIf5NfxbpKtE655uaW4tNdfVjx28Qk=;
        b=K/6q72N81bcz6pkypkLucyijxPTq3YPYp4V3XTwcYZV+oaqm2S+DT7pWgneMAOBFZG
         SKDnLMgy+yzCs+XXjRJEp35D+LC7o6IiRWdFHVwECAIRvMbjqgTz7DoCUagnzfcIWNEx
         qRzysGYJud0Yh7vfxPUmonSt7TMEgclNwV7ka0bvKk5kSfOxSIrZMlJRsWqg7XohC+xF
         oKOwDxJUc6yBT7rp5fk3U2w1dLTpT7bXH/oafZ5T5CHEv1Psm4P3hcDvySiRGz2yoZdW
         +m/+N8qYIlCMfppLJKUua/ng91poQD3NyD5l68k22E/pQ2KaHNV5FFSdTgNG2xQSW2VW
         VZAQ==
X-Gm-Message-State: AOJu0Yxh4S7XGXQLBiNEnVX+W9O5bCzgbZSfTV/vE6pz/Dya4CvkHEG6
	vHfJ2MjHurUH+AtP7PHL1495elqlw6ooowxD1Uh3/B/btV9qLITJn8jU2sVC168fQV5v9SMKKyo
	8ZCyVtkR0bs8iC+M=
X-Gm-Gg: AR+sD122vfoHJCfWYdqmvp0Aw6voyA8dJTbLE/0f+AJtoBlTatFqyQvomWV3ZYBP/x8
	qStvubhdwokNLpyQfpzwpuVoogNgvQVkS5fEEeI8I23DjN49LrCs8cpVC9xXGixXWe+8X6RZ43J
	1zC4wne2Uam4nxIk9opnX3s1F/5vd8cZRSoidQ+/DcikhDNZG+djbVi7JXzv6uF9RmhfWGIj57N
	LtjxG+uzmqSMNF3C9nwKsol7tB0M6hi8DUzTivTHKIdGordQfpHBvUP6F8yX//Th4CiPFX64GlL
	pAxMGcg+OGeIPeT89AvcOhUqQjClmJnlLeObKf1PqOnRLKQty3siriApPucKTGyX+WAYbarWmil
	TrXtIesayBfFE8ZSitFkRf+rtEZtPNFGdPawLh3QbI0wIxxN3o6vFCPXSZqpJkkqjLUGg8Pug/e
	Nmf5rOeZD8Gz8fq76KvAN/amhNr0uRekGtmjrTxaZ0dXQqwx90OJJFwtz+KwYVfzmlPIQbjsq40
	P6UH6jmo9bRAOhJdRsOu+YU+6RTAGrQuHx5Fc+ZnZgRUiVenoqSqp18KDoRbF1biJ6eDG+oyXbK
	ZGE5dsv//t5c5R0PRE6jc2hWJ0MEm6IMo2WwNRjUgUrr2hMzoEZfihA=
X-Received: by 2002:a05:690c:3681:b0:81e:d8ec:d855 with SMTP id 00721157ae682-81f9936c55dmr20768427b3.62.1785283021318;
        Tue, 28 Jul 2026 16:57:01 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fa27592e9sm8541417b3.8.2026.07.28.16.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:57:00 -0700 (PDT)
Message-ID: <66ad542bb23dbc1798b7c69f7912bf86cb79c8f7.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty
 state mismatch
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Tue, 28 Jul 2026 16:56:59 -0700
In-Reply-To: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
References: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
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

On Mon, 2026-07-20 at 23:16 +0900, Ryusuke Konishi wrote:
> Syzbot reported a kernel BUG triggered within
> nilfs_copy_dirty_pages(),
> which copies dirty DAT file folios/pages to its shadow page cache.=C2=A0
> The
> BUG occurs when a retrieved dirty folio/page unexpectedly loses its
> 'dirty' status.
>=20
> This issue arises because, since the commit referenced below, the
> 'dirty'
> flag of a folio/page can be cleared asynchronously after the
> filesystem
> detects metadata corruption and transitions to read-only mode.
>=20
> Resolve the issue by returning an -EROFS error if the filesystem has
> transitioned to read-only mode.=C2=A0 Also change the behavior to issue a
> kernel warning only once instead of triggering a kernel BUG when this
> unexpected 'dirty' state is detected while the filesystem is not in
> read-only mode.
>=20
> Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8baf9a79a3ffc6271cb6
> Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread
> after remount in RO mode because of driver's internal error or
> metadata corruption")
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Viacheslav, please apply this for the next cycle.
>=20
> This fixes an issue reported by syzbot where a kernel BUG could be
> triggered depending on timing after filesystem corruption is
> detected.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/page.c | 17 +++++++++++++++--
> =C2=A01 file changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index a9d8aa65416f..1d00bce21c37 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -243,6 +243,7 @@ static void nilfs_copy_folio(struct folio *dst,
> struct folio *src,
> =C2=A0int nilfs_copy_dirty_pages(struct address_space *dmap,
> =C2=A0			=C2=A0=C2=A0 struct address_space *smap)
> =C2=A0{
> +	struct inode *smap_inode =3D smap->host;
> =C2=A0	struct folio_batch fbatch;
> =C2=A0	unsigned int i;
> =C2=A0	pgoff_t index =3D 0;
> @@ -258,8 +259,19 @@ int nilfs_copy_dirty_pages(struct address_space
> *dmap,
> =C2=A0		struct folio *folio =3D fbatch.folios[i], *dfolio;
> =C2=A0
> =C2=A0		folio_lock(folio);
> -		if (unlikely(!folio_test_dirty(folio)))
> -			NILFS_FOLIO_BUG(folio, "inconsistent dirty
> state");
> +		if (unlikely(!folio_test_dirty(folio))) {
> +			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
> +					"inconsistent dirty
> state\n"))
> +				goto unlock_folio;
> +
> +			/*
> +			 * If the filesystem has been forced to
> read-only
> +			 * due to metadata corruption.
> +			 */
> +			folio_unlock(folio);
> +			err =3D -EROFS;
> +			break;
> +		}
> =C2=A0
> =C2=A0		dfolio =3D filemap_grab_folio(dmap, folio->index);
> =C2=A0		if (IS_ERR(dfolio)) {
> @@ -277,6 +289,7 @@ int nilfs_copy_dirty_pages(struct address_space
> *dmap,
> =C2=A0
> =C2=A0		folio_unlock(dfolio);
> =C2=A0		folio_put(dfolio);
> +unlock_folio:
> =C2=A0		folio_unlock(folio);
> =C2=A0	}
> =C2=A0	folio_batch_release(&fbatch);

Applied.

Thanks,
Slava.
