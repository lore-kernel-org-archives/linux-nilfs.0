Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4233A6F05
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 04:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213155; cv=pass; b=EJ42CeC5LvqX5B9LebyOeY7GLxLV6mM8Sb9MCsSaotqZgOrqL2VFl16Sped97ijptyKknq9yrJsAvhSW78mbvIlbTgyZr3G22ooVhChO2vvPJu0B1rDhqBlgwuC55tQWTU/uvKn+0rpHuldI84cjDlYOQ17cbPRs4vJGNm2hZSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213155; c=relaxed/simple;
	bh=1UkufzN6/HQktmucOUqc3rY+5btPzuxx+eE4g3cLiWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gga4gdamnB4JJ+5u3lENbegGepxer99fAoclcp/4ROU4H56JXKLcowZwxwDUkKdFhTlv5UPupJAcEryhFB0AzlM2KlywITz/6rNhz4oTZzXkxP6yybFAl2Tyj+Ovc3j+naBBnemLFFOMS6fvpH7EKa03nDMeDCAd7hho7UPMtl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmMC6gEK; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmMC6gEK"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aeb98460c6so3577516e87.2
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Jul 2026 21:32:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785213150; cv=none;
        d=google.com; s=arc-20260327;
        b=b8E0lMA8VwdVs+dA3Xpmg7lnpwdk8i2irF9IOu7PN54yA2+EgxfE82cdC8rj+fml+T
         i/8HPgz3uPBQJUNPh8xVTVSD9cEc+f6/vrk0wr5z0I2AFfIn80qpkYYaevWJUP1Ex6Mv
         BjgL9ItFAl0m7NljzCyxGbmBWLCmK23KZXtURn49I9nGCinDaCHPDNx3s8gMMHa5aNhe
         UKk6zzGwqQ9A5M5V2MQ7THooMKYq8kFD73XqyR+EcrQVXohzD4U61G98TIIEe0M2veKz
         iZyvzLGEyjOTmm4ePNMyUb4MlYO78rMtWBmQRdKikIRecWiMXOGc7Pr8d0OtKJNHc6Yi
         Oizw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1jdXMRFbiR+iapMOAzm62NakCWxCaZxTmnCQa4V1QoA=;
        fh=osC5/wRwiFZuEUP4OC2eJoUPEp1ndItrUMoWsP4V4hA=;
        b=KWRWMyz/yFwn3tuZmu63dhHywTcqOPUCYKatLnUZMhX2kfKn4jNESgHduA8oY62UAD
         fqDR3GsrxWKI2HZ6pXfsu4b6iptVHiNXhzo8wahbv4r0sYCaRv6A+Fihu2wOsByK9gIM
         FSc+O0ZrnzZWyLf5EJOlXZPEUZQ+NVany+wJR4iZUWbzDJYSIPdQGaFOjPW48IyXAhoZ
         NupkM57O9R1qafh4mFYFG9pSjNhi8ugZ41N4xSPxmWTx+HV3tcjKxhl0tGLx/FSfFrqy
         mF51XiUU6coPdrezMXWyzcdyq90aAA7PS/Bti5Ljt3OAbz2/sctNKPuLLR1rOu7JsVPh
         PSnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785213150; x=1785817950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1jdXMRFbiR+iapMOAzm62NakCWxCaZxTmnCQa4V1QoA=;
        b=UmMC6gEKJXKnSo9Lj/HWJ2vOi/6Su5yPoI/b+PsTfWs0Qn3R5IjJAKhE/tLy1qYopl
         FqJKXAW35p606cp9spxgjYdtk6zp3hA7GSjnNvRV2wDZacnakZeXkxL0hesMuDUPr5EK
         LonJqfz5St4O0dGgx2LEAiyIaJG0sxYpyZKaD2R32b1sQJmiX71q0BS+g6C9txJUA2u1
         rKaZag3oq3uxkfcJ3GX2go6rEJrViJ9NXBVyYbjwGWsPT9H1AEXUtnOHBHfrevI93rG+
         D/FhU4Qivhmt+g+WGR7yiQUIg6beHhf94sxdyCYZCgAV/uxsdy879U4es1+nOVB52Mqa
         z4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785213150; x=1785817950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jdXMRFbiR+iapMOAzm62NakCWxCaZxTmnCQa4V1QoA=;
        b=ZS9nhR3voKVM8XckRN21UF5xu/Nh+xfnacG08aNsCgKo0QUYh4eEHA+7a97i91fv/I
         E5uEVRy86aP7EMiV6dgXccADN5D/iUmGCpIKY52nFToPJU2DBdQrX0iFv8uDSO42ZU6h
         sq7cEPMv80blt8dIPePnjoj7m5qdiLp5eLIUnLka1q93Yk59oig0aaoi6K97qQ8Hd9iM
         DjSdMTNHs+sNb71SnvQrKZvIY73Bro9/pxK83KPQ095kUDGL0BwkZYtSmq8qWoUhv+yj
         URVXSyofO4jEc1G9aTUIaSLDi80/j3wR746THOgkfX4FAQSbgZnkusPy+HbxCpUeoiZl
         6rdw==
X-Gm-Message-State: AOJu0YyGgY/Z/IpXhm4sSnVE/2mBYPFDRut+OarpXs6qzjPjnh6xLZLO
	9GnAtod0snGJvN9H8SkoIjhzj9GnIVZXy2tU/B0pncL6+b6/dDUK1YT1CzymSUnQXO/QffDIewM
	RpSl/nFyPzidEIWAcGY1n5gtbNHi5xdA=
X-Gm-Gg: AR+sD13SChOl1cVhz0ig8PAFAdp/idgosE36CjiigO9UtcLFwvB0bbybFTngGw98PQl
	LnjR90zQ0cDDld4itroTYySgNzH9cV5dA10fuRcYQFLAh1Fof9qLV5XjwH1bnwbR95o+q4+sKFq
	UdMdmHmxsm6FBE7xXR1+LQUtgEyUvVlg6zNGrTeHGToM4HRoXufkTrf1Z2o7z+/LxbmjQqDH4EJ
	2HmUFXbk1JbnFuURgrs78PtzweFUVmml2phf3qZ550t3nh/ihq/JYAfqd+vl2K4KjFVq6pxFQ==
X-Received: by 2002:a05:6512:3b98:b0:5b1:5457:a930 with SMTP id
 2adb3069b0e04-5b2d0217aa6mr130420e87.16.1785213149636; Mon, 27 Jul 2026
 21:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
In-Reply-To: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 28 Jul 2026 13:32:13 +0900
X-Gm-Features: AUfX_mywGSjGVdTSfcKl54Dh93GDMDnt8o2-mjGNPiJ1P01p625c3LnGXoLrkFk
Message-ID: <CAKFNMonu620z87=b=+9Xwn44Zr9-CssQkn=mes5EqEc=iJUm0g@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty
 state mismatch
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 11:17=E2=80=AFPM Ryusuke Konishi wrote:
>
> Syzbot reported a kernel BUG triggered within nilfs_copy_dirty_pages(),
> which copies dirty DAT file folios/pages to its shadow page cache.  The
> BUG occurs when a retrieved dirty folio/page unexpectedly loses its
> 'dirty' status.
>
> This issue arises because, since the commit referenced below, the 'dirty'
> flag of a folio/page can be cleared asynchronously after the filesystem
> detects metadata corruption and transitions to read-only mode.
>
> Resolve the issue by returning an -EROFS error if the filesystem has
> transitioned to read-only mode.  Also change the behavior to issue a
> kernel warning only once instead of triggering a kernel BUG when this
> unexpected 'dirty' state is detected while the filesystem is not in
> read-only mode.
>
> Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8baf9a79a3ffc6271cb6
> Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after re=
mount in RO mode because of driver's internal error or metadata corruption"=
)
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Viacheslav, please apply this for the next cycle.
>
> This fixes an issue reported by syzbot where a kernel BUG could be
> triggered depending on timing after filesystem corruption is detected.
>
> Thanks,
> Ryusuke Konishi
>
>  fs/nilfs2/page.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index a9d8aa65416f..1d00bce21c37 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -243,6 +243,7 @@ static void nilfs_copy_folio(struct folio *dst, struc=
t folio *src,
>  int nilfs_copy_dirty_pages(struct address_space *dmap,
>                            struct address_space *smap)
>  {
> +       struct inode *smap_inode =3D smap->host;
>         struct folio_batch fbatch;
>         unsigned int i;
>         pgoff_t index =3D 0;
> @@ -258,8 +259,19 @@ int nilfs_copy_dirty_pages(struct address_space *dma=
p,
>                 struct folio *folio =3D fbatch.folios[i], *dfolio;
>
>                 folio_lock(folio);
> -               if (unlikely(!folio_test_dirty(folio)))
> -                       NILFS_FOLIO_BUG(folio, "inconsistent dirty state"=
);
> +               if (unlikely(!folio_test_dirty(folio))) {
> +                       if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
> +                                       "inconsistent dirty state\n"))
> +                               goto unlock_folio;
> +
> +                       /*
> +                        * If the filesystem has been forced to read-only
> +                        * due to metadata corruption.
> +                        */
> +                       folio_unlock(folio);
> +                       err =3D -EROFS;
> +                       break;
> +               }
>
>                 dfolio =3D filemap_grab_folio(dmap, folio->index);
>                 if (IS_ERR(dfolio)) {
> @@ -277,6 +289,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap=
,
>
>                 folio_unlock(dfolio);
>                 folio_put(dfolio);
> +unlock_folio:
>                 folio_unlock(folio);
>         }
>         folio_batch_release(&fbatch);
> --
> 2.43.0
>

Hi Viacheslav,

Sorry for the disturbance while you are busy.

Could you please pick up the following four pending patches -
including this one - for the next cycle at your convenience?
Excluding those already applied, these are the ones submitted by me or
requested for direct pick-up since the weekend before last:

- [PATCH] nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate
after truncation
- [PATCH v2] nilfs2: fix infinite loop in nilfs_clean_segments()
- [PATCH] nilfs2: prevent out-of-bounds read in super root block parsing
- [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismat=
ch

Thanks,
Ryusuke Konishi
