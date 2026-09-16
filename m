Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160C4E431D
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602087; cv=pass; b=oFI2tiCZf3mnhTCn4xLVzkwxxKjYvWqR19iSJ7FB4x+NPQ/tclROlHp4qHqHN/+Ol7u6MLZjegRREVddDwcJXSfcL+GFifSoo4p+28VcTW3YBxV91DF3CNa0f4P2pwB+f+DsY+VY40pGJTCYRXiOB/fuOQWpJHvBg6Ui8U1cfoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602087; c=relaxed/simple;
	bh=1LxjWDo3K7VCL7gDGH0cthwiFiqLk1Eaqa8VO6ht6og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KC21dp7ent0z02wY7uiTmHzua2KX2MO/xXvKWZ8xycQS+Hcsy2sES+53cD9YlwcvPgVZbce22D/cAJHWhNjqMdXNDXhw4LiPyd1ZKpXGwVyTBUayLVTOpry4y9APwM1xawnWQZmxpzRqaxAvrEs//xPsuuouiW95+/fM1CLQCgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eo0E5GFs; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eo0E5GFs"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f15d00so160187e87.2
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 16:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789602083; cv=none;
        d=google.com; s=arc-20260327;
        b=MH32pbxpJYGck1bGoDASPrv4l6BUt+q9Kpp1xNn5IEUWAdGG4dsj2sNmdnD7hjL5AK
         SElFs8Ogx8WxMUVeXbO3DIOdB2QBQIESibFMaXGXlv3fwcdADto/pOc016XGTFAJWnfa
         k6DQqZghqJ2BXQTy0prjVAABVVQ/4UqxD3XRuO1hcnw5Ij2hJ98gDzVyFJ2fNc2rCfij
         bdU2Y3QxDn1gM4j6CZBMcLWoV3UxZDGWAaEBLxCCMeCCaU71Kppfatn2/6FL1oM0oAP8
         sYqVeYGunIYn9l0sUJV3V4e+j7LN1rY1dLzKfAhkCdwhlXhVdacTywlZ6oQa1SV4uC/T
         FKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K6foAMbhIdhC+B/cxDyuacn/iRP7J/fBEWq3/+nYnxQ=;
        fh=0DJAVCZkeKSosrKGLT40V02pEhRq4Q3s2hfu8TVr0Ro=;
        b=PwHzFIoGpAN6gxymKhzeaXrT9x2sgypTHEGVeca47nbDTugBqg4ctqcuWVxpzzEXuX
         0dvjSOdNELGpZAE6S/FWoYzdE4OpoOU4ET7ei4jWM+qEfL0NcOpqBZOTroHtzkK9IAxK
         XY/wjXQSmxYg8Es/aE9RAIormhpM22KRmEEcFC4R2QXnSlEZvCdNloTTTF1ok5IfSi09
         FqiDAwLJh4g722Elu0xueKcOu2ocMSNgMYIyxlRKeUoVrm526YgpHRZJEM/3n9fnCi9N
         9uviL1f4n8JYzs2lEMZdsTcgS1Va3lMJ3Azy4hn+63hKpP40zEa1tCRvcwgzjGZtXckA
         uDmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789602083; x=1790206883; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K6foAMbhIdhC+B/cxDyuacn/iRP7J/fBEWq3/+nYnxQ=;
        b=Eo0E5GFs0HfOnck9SZ+aG0o3h22H+UG5pRLcGgYmnBJ3reFdJM2/5eX6rFuFuwI1H7
         JXhiYHEvD+2U9SUJGGf6H5nQpUPu9BrZNOeflpNC/E/M18VY3BC8dabb5gjGJdXXOFSK
         5IC+2LE+JIdBWdv591rQTbm7OWg6exTIWkTwRFENudQvfTTJ2JxEGFjxeCnzy5cgnwD8
         /16hCQ6x1W6k0hcOsuE69GcJlkDwJYUbT+LS6cixs87Bz49MXQUsI5u1JGlz4bcq+lRu
         JLCr5TKBaoq9ilRq+UR0ZPVtkuNS9+g2zczXbCdYCJJ6RWDqauszq1znMFETotfd4vzf
         gfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789602083; x=1790206883;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K6foAMbhIdhC+B/cxDyuacn/iRP7J/fBEWq3/+nYnxQ=;
        b=RZ8PhqtWZ7rR14gk23fB5xxgUe32XYOljW2+LlWp1hf8q9IC1l8+j76fxcTlns5eta
         DKcJYsmD22R2d3Kd1QEcIpBpIX9c4tIVbjao1TRYfwYe2tqqd6vfb+tgnmQKZVyuYDeY
         pbRrD+s9fkzT6votwUFwFIDQYbPAFNCzVIwFlmrSUL9Qtx5i/VXrVHn4EPPnNHebDzZP
         lAls4x+abJr3Jrfzdo3QTY4CGMbNZMEt7ZD/2Gc89Db+PyFQoYMoW4WnLYSjdZSEimfE
         spgWL2PXx5d8cEDBxsO15VfkuFiEsHGDhKQQqgvyT0ZUfOgGmw6DiPzfJZtZoQsmOkr5
         37hw==
X-Forwarded-Encrypted: i=1; AKwUvBxOK5kEbEPI4GxgD6HCoys1qKtwr4TaxtIH8R8bvtOhF6XoO4t1zvZHmv/LyAoVVkM4hcKH+icXBIlp5g==@vger.kernel.org
X-Gm-Message-State: AFuF++kUxdUPslax+SEdSbG94QmyT06v9UQrgrBsiXI65CW2Eaw2wwMM
	VfRd7WOsP/sCtDbizeCW65k9Ex4uTJX8vvAhjY+7KyPb2HgPBxBnWcB0pcTuDKvLUa1D4aDa3kO
	CzXUQzV/I9Ewla0o8Ih/xWDZcljFbSSg=
X-Gm-Gg: AYBFou3xsd9GnEcdVFvVuEJSKfOBL3zIA42r0v4qnHIbQhjn1kGyVjGeBgJy0VD9ibP
	YXpk0A0pMjEBV82UXI28I+wsMp5EPi0FEkv7TmqDDvNVBHr2IlaAfCctDJonVs0csHE40NmRdbZ
	J6Cy2noWtEysemSbl+zAvtbT7qMaFA7/qY5zm4PxLeP53fUjSKRdH7ZFSDSzizNSeD4lM9FBRCY
	aQE6NPgXr1APz14mVAtGzREzlR5+xh6iW6aI11TtP0tgZBTfMRt2M8DsQk7WD0rMnMoxeWEMFBJ
	GKdXPGDNYMMUyNs0lh5LQNYQMPmv0alD8q0e2uU3v+X1NXjTHM7ovrYV
X-Received: by 2002:a05:6512:114a:b0:5b5:e2f1:e6f9 with SMTP id
 2adb3069b0e04-5b8b6605fbamr1241196e87.11.1789602082498; Wed, 16 Sep 2026
 16:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902112121.2125383-1-r772577952@gmail.com>
 <CANypQFbTTggAnGvdw_O7zxxZ1JNY5_eUBBBPxTW4aW2dqYxQ4Q@mail.gmail.com> <a4c590020db13f0cc023cf9faeeb08c174b56085.camel@dubeyko.com>
In-Reply-To: <a4c590020db13f0cc023cf9faeeb08c174b56085.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 17 Sep 2026 08:41:05 +0900
X-Gm-Features: AcwNN1V7kzewufKyT3CFmpeIipG_tZDzPvsT451y2cXfRSPqsMNBn2Hp4RxorfI
Message-ID: <CAKFNMonukK6oDWD6azZ35K0z-kHcmp=0ja6vLoQaXi=JyywBhg@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: force clear dirty state when restoring from
 the shadow map
To: Jiaming Zhang <r772577952@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 6:12=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Mon, 2026-09-14 at 14:33 +0800, Jiaming Zhang wrote:
> > Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=882=
=E6=97=A5=E5=91=A8=E4=B8=89 19:21=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > When garbage collection fails, nilfs2 rolls the DAT metadata file's
> > > page
> > > cache back to a shadow copy taken before GC started.
> > > nilfs_clear_dirty_pages() drops the dirty state of the folios in
> > > the DAT
> > > cache, then nilfs_copy_back_pages() overwrites them with the saved
> > > contents and warns if one is still dirty:
> > >
> > >         /* overwrite existing folio in the destination cache */
> > >         WARN_ON(folio_test_dirty(dfolio));
> > >
> > > nilfs_clear_dirty_pages() used to clear the dirty state
> > > unconditionally,
> > > which is safe here because the rollback runs with the log writer
> > > stopped, so nothing else can dirty the cache while it runs.  The
> > > same
> > > helper is also used when writeback finds dirty folios after the
> > > filesystem has degraded to read-only, where it does run
> > > concurrently
> > > with the log writer, so commit ca76bb226bf4 ("nilfs2: do not force
> > > clear
> > > folio if buffer is referenced") made nilfs_clear_folio_dirty() skip
> > > a
> > > folio if any of its buffer heads is busy.  The rollback caller
> > > shares
> > > that helper, so its clearing step can now return with a folio still
> > > dirty.
> > >
> > > A DAT folio can hold a busy buffer head without anyone modifying
> > > the
> > > folio: nilfs_mdt_read_block() submits read-ahead for the blocks
> > > following the one it was asked for and waits only for the first, so
> > > the
> > > read-ahead buffers are still locked when it returns.  With a block
> > > size
> > > smaller than the page size, a locked read-ahead buffer can share a
> > > folio
> > > with a block that GC dirtied and keep the whole folio dirty past
> > > the
> > > clearing step.
> > >
> > > Add a force flag to nilfs_clear_dirty_pages() and
> > > nilfs_clear_folio_dirty() that skips the busy buffer check, and set
> > > it
> > > in the two calls from nilfs_mdt_restore_from_shadow_map().  The
> > > read-only fallback callers keep passing false, so that commit still
> > > protects them and the WARN_ON() is left alone.
> > >
> > > Fixes: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is
> > > referenced")
> > > Closes:
> > > https://lore.kernel.org/lkml/CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoA=
i_V5yY0dTtg@mail.gmail.com/
> > > Cc: stable@vger.kernel.org
> > > Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> > > Assisted-by: Claude Code:claude-opus-5
> > > Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> > > ---
> > > Changes in v2:
> > > - Keep the WARN_ON() in nilfs_copy_back_pages() untouched.
> > > - Add a bool force argument to nilfs_clear_dirty_pages() and
> > >   nilfs_clear_folio_dirty(), and set it to true in the two calls
> > > from
> > >   nilfs_mdt_restore_from_shadow_map().
> > >
> > > v1:
> > > https://lore.kernel.org/lkml/20260901134430.1292467-1-r772577952@gmai=
l.com/
> > >
> > >  fs/nilfs2/inode.c |  2 +-
> > >  fs/nilfs2/mdt.c   |  6 +++---
> > >  fs/nilfs2/page.c  | 50 +++++++++++++++++++++++++++----------------
> > > ----
> > >  fs/nilfs2/page.h  |  4 ++--
> > >  4 files changed, 35 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > > index 34e6096069ad..64437aed8390 100644
> > > --- a/fs/nilfs2/inode.c
> > > +++ b/fs/nilfs2/inode.c
> > > @@ -163,7 +163,7 @@ static int nilfs_writepages(struct
> > > address_space *mapping,
> > >         int err =3D 0;
> > >
> > >         if (sb_rdonly(inode->i_sb)) {
> > > -               nilfs_clear_dirty_pages(mapping);
> > > +               nilfs_clear_dirty_pages(mapping, false);
> > >                 return -EROFS;
> > >         }
> > >
> > > diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> > > index 2a435349fd21..b50c88b65183 100644
> > > --- a/fs/nilfs2/mdt.c
> > > +++ b/fs/nilfs2/mdt.c
> > > @@ -405,7 +405,7 @@ static int nilfs_mdt_write_folio(struct folio
> > > *folio,
> > >                  * have dirty folios that try to be flushed in
> > > background.
> > >                  * So, here we simply discard this dirty folio.
> > >                  */
> > > -               nilfs_clear_folio_dirty(folio);
> > > +               nilfs_clear_folio_dirty(folio, false);
> > >                 folio_unlock(folio);
> > >                 return -EROFS;
> > >         }
> > > @@ -648,10 +648,10 @@ void nilfs_mdt_restore_from_shadow_map(struct
> > > inode *inode)
> > >         if (mi->mi_palloc_cache)
> > >                 nilfs_palloc_clear_cache(inode);
> > >
> > > -       nilfs_clear_dirty_pages(inode->i_mapping);
> > > +       nilfs_clear_dirty_pages(inode->i_mapping, true);
> > >         nilfs_copy_back_pages(inode->i_mapping, shadow->inode-
> > > >i_mapping);
> > >
> > > -       nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
> > > +       nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping,
> > > true);
> > >         nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
> > >                               NILFS_I(shadow->inode)-
> > > >i_assoc_inode->i_mapping);
> > >
> > > diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> > > index cf4f1c6798f5..857926da9f21 100644
> > > --- a/fs/nilfs2/page.c
> > > +++ b/fs/nilfs2/page.c
> > > @@ -369,8 +369,9 @@ void nilfs_copy_back_pages(struct address_space
> > > *dmap,
> > >  /**
> > >   * nilfs_clear_dirty_pages - discard dirty pages in address space
> > >   * @mapping: address space with dirty pages for discarding
> > > + * @force: whether to clear the dirty state regardless of busy
> > > buffer heads
> > >   */
> > > -void nilfs_clear_dirty_pages(struct address_space *mapping)
> > > +void nilfs_clear_dirty_pages(struct address_space *mapping, bool
> > > force)
> > >  {
> > >         struct folio_batch fbatch;
> > >         unsigned int i;
> > > @@ -391,7 +392,7 @@ void nilfs_clear_dirty_pages(struct
> > > address_space *mapping)
> > >                          * was acquired.  Skip processing in that
> > > case.
> > >                          */
> > >                         if (likely(folio->mapping =3D=3D mapping))
> > > -                               nilfs_clear_folio_dirty(folio);
> > > +                               nilfs_clear_folio_dirty(folio,
> > > force);
> > >
> > >                         folio_unlock(folio);
> > >                 }
> > > @@ -403,13 +404,16 @@ void nilfs_clear_dirty_pages(struct
> > > address_space *mapping)
> > >  /**
> > >   * nilfs_clear_folio_dirty - discard dirty folio
> > >   * @folio: dirty folio that will be discarded
> > > + * @force: whether to clear the states regardless of busy buffer
> > > heads
> > >   *
> > >   * nilfs_clear_folio_dirty() clears working states including dirty
> > > state for
> > > - * the folio and its buffers.  If the folio has buffers, clear
> > > only if it is
> > > - * confirmed that none of the buffer heads are busy (none have
> > > valid
> > > - * references and none are locked).
> > > + * the folio and its buffers.  If the folio has buffers and force
> > > is false,
> > > + * clear only if it is confirmed that none of the buffer heads are
> > > busy (none
> > > + * have valid references and none are locked).  If force is true,
> > > the states
> > > + * are cleared unconditionally, the caller should guarantee that
> > > the folio is
> > > + * not being modified concurrently.
> > >   */
> > > -void nilfs_clear_folio_dirty(struct folio *folio)
> > > +void nilfs_clear_folio_dirty(struct folio *folio, bool force)
> > >  {
> > >         struct buffer_head *bh, *head;
> > >
> > > @@ -422,24 +426,28 @@ void nilfs_clear_folio_dirty(struct folio
> > > *folio)
> > >                          BIT(BH_Async_Write) |
> > > BIT(BH_NILFS_Volatile) |
> > >                          BIT(BH_NILFS_Checked) |
> > > BIT(BH_NILFS_Redirected) |
> > >                          BIT(BH_Delay));
> > > -               bool busy, invalidated =3D false;
> > > +
> > > +               if (!force) {
> > > +                       bool busy, invalidated =3D false;
> > >
> > >  recheck_buffers:
> > > -               busy =3D false;
> > > -               bh =3D head;
> > > -               do {
> > > -                       if (atomic_read(&bh->b_count) |
> > > buffer_locked(bh)) {
> > > -                               busy =3D true;
> > > -                               break;
> > > +                       busy =3D false;
> > > +                       bh =3D head;
> > > +                       do {
> > > +                               if (atomic_read(&bh->b_count) |
> > > +                                   buffer_locked(bh)) {
> > > +                                       busy =3D true;
> > > +                                       break;
> > > +                               }
> > > +                       } while (bh =3D bh->b_this_page, bh !=3D head=
);
> > > +
> > > +                       if (busy) {
> > > +                               if (invalidated)
> > > +                                       return;
> > > +                               invalidate_bh_lrus();
> > > +                               invalidated =3D true;
> > > +                               goto recheck_buffers;
> > >                         }
> > > -               } while (bh =3D bh->b_this_page, bh !=3D head);
> > > -
> > > -               if (busy) {
> > > -                       if (invalidated)
> > > -                               return;
> > > -                       invalidate_bh_lrus();
> > > -                       invalidated =3D true;
> > > -                       goto recheck_buffers;
> > >                 }
> > >
> > >                 bh =3D head;
> > > diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> > > index 136cd1c143c9..c3ba3468af5c 100644
> > > --- a/fs/nilfs2/page.h
> > > +++ b/fs/nilfs2/page.h
> > > @@ -41,8 +41,8 @@ void nilfs_folio_bug(struct folio *);
> > >
> > >  int nilfs_copy_dirty_pages(struct address_space *, struct
> > > address_space *);
> > >  void nilfs_copy_back_pages(struct address_space *, struct
> > > address_space *);
> > > -void nilfs_clear_folio_dirty(struct folio *folio);
> > > -void nilfs_clear_dirty_pages(struct address_space *mapping);
> > > +void nilfs_clear_folio_dirty(struct folio *folio, bool force);
> > > +void nilfs_clear_dirty_pages(struct address_space *mapping, bool
> > > force);
> > >  unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
> > >                 unsigned int from, unsigned int to);
> > >  unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
> > > --
> > > 2.43.0
> > >
> >
> > Friendly ping, please tell me if any further changes is needed.
>
> As far as I know, Ryusuke is traveling right now. Please, expect some
> delay with the review. I don't see any issues with the patch.
>
> Thanks,
> Slava.

Jiaming, my apologies.

For some reason, recent emails addressed to me weren't showing up in
my inbox. (I just realized the v2 patch had been posted.)

I will review it, so please bear with me for a moment.

Thanks,
Ryusuke Konishi
