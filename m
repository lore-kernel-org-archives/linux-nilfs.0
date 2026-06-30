Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C476D3A7F5D
	for <linux-nilfs@vger.kernel.org>; Tue, 30 Jun 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782842130; cv=pass; b=IsAwzbh5aL/SlnDP5HMA4WGqRpKViiAGIMlzHRe6DImUCUi5T9ovaNRocXqVlrbtvJerx7IzhPVa/M+yS1dATYOuUzUAuT+MB8ZProHO5D8/lk4132VBMSwmB950xOIMdIbWvZXjiMGDk74HtCRWbzle8IzAQf22bHoYMw0lvY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782842130; c=relaxed/simple;
	bh=AyRO/lONH8BiEDNHKn1k3ompalGmq2VAhyFbrfxZi1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uNP0ZeBcC9CLhQNTBcV62AIoowVXoyp88STAQEMq7ZjF4tFJ7gaJm9g9sYNQNkik7mNG4dLkE+8uY9z1TlLOV/b9HFBJjxncFvGueBvX8X7hozDcJtX1YShL6gOQT2rZm0AphUNCSj+2U+gkjffHTd9wSgXHTwUOYRck0kugT9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcILZr7R; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcILZr7R"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aeb36ed873so2566034e87.0
        for <linux-nilfs@vger.kernel.org>; Tue, 30 Jun 2026 10:55:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782842127; cv=none;
        d=google.com; s=arc-20260327;
        b=Luux11cND8FM13uBLqbBvHssYzzBbVETNoVG/uAcQRmL1DJYE+b/cY/rVnwmH86daJ
         CulHRpxdAe4UIvNgLEQvl99LmTC/YRKYA3IYqPrVxltdJg91Yky2ZMfYOfX5ViW6Jf6m
         5wzMzTrTEUoQ/itLQvvzD5yLiVG5u79fo39jMkazWOI9Kt1sL6LRaFBo64c7mYQBlEOL
         zBNbxkdRnUduxQvIZpRifsomh8S/L9ux1f5VZESs8RM8FdzsUmkOGZdKYP0ZKFeSpZnI
         UFGrFosXsIOk/dQv3wp1DUp5vFRRkDcm/HJW6ISHLDU7Ejd0w3JSdJ0Y4HVyJrZ9MFCI
         mHSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=515+MJ+8IC4z7UNVkSsWcC3mRDCoApFe/CGK//p7GnI=;
        fh=Rtt/XHD5OgwSmWYjE86zSXbit5xz1QXYMu2HcwpsIhs=;
        b=Tx9flaPwVBQZDZvHD9oEA+ICxejhFUEmbQbvsCMRnPu9iTcRTDR05PKDZcDg5HlZGj
         9T2BDBG0x3XMt5Z9xR+o5vSM/xf8LjSISzE4hIunk0+kM/2uNxVbSuda4Sl0kriyOAGt
         aP8TLl3yHDg855Ev++iQgOd09VXxTlxZRvUO5Qx8HmYbf4gtfTvkcDQYOjcJL5PNfEoX
         WKQEuI6XBAR2wI8YWx40bQQrFEkzlB/wKCFmV94UWkkNiaPczfrrsddm9wai5Mtc4Ooe
         kTTUaoeda2z4QYMH06w3jEVgugSb5ziRnAMyTiVlcHhCzi1S22XHrDosyfZA7LTO9jrb
         rutQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782842127; x=1783446927; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=515+MJ+8IC4z7UNVkSsWcC3mRDCoApFe/CGK//p7GnI=;
        b=UcILZr7R3QUD9qCgM9INz481hFwegSXz5Jm43Q0LMfJeK3o6XBg9Is1SeFawV2LxsS
         J8ad2F+txs5TuR3TcsPZ5wyqhWb5Vd843eV2Pm8TSpI2sLrasacruEHjA+cJhE7lL6tw
         ZCp0MaBgx5gEvNGRX5SxnHcvLjl9889Wib+WO5Liw11aJqKyjtfy42KNCWXUlBxoifGu
         dH1CtqdDu3DeQtEHXp6xXzIetHSnNke5uJQ6uWOJdPkWegs0AKWtVyBhmhoC+cIb1yFw
         56lgogIbjDbGGthYpr7hnf1A7Wi9NAhtbGC6avjgY14LZbeaV0GPuOVoq09EpHSXLBlY
         Aicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782842127; x=1783446927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=515+MJ+8IC4z7UNVkSsWcC3mRDCoApFe/CGK//p7GnI=;
        b=QVOSocpAZoX1+6vcUyWT6qHEnO1EbbIuzqQtM31Imlhh5mAjzQZpoyRBalV5BebYae
         MDLO+vbsIqOyFYAUR7703iqcHyb5DsxdCuKqglabh/HvPZUc6j4+NS+p3Qhu8G7Osgzs
         1jCoGsv6F6GpGTq1hfLdgguBvrHmGT0F7BibQOGpTOFgMR6ReJE1XYpmkxnU4JBlgRw5
         UoB8ekKOv2itCkXm2U/uN3hfqI9Eav+nb7qlWzg0rl/nEgTP7M00V9E9rXfaA77UqKdz
         UOJiYMC71FDpBSlR+izsFVvM/x/Z/BPfwT7HnZLC9bwRAwb16O2xW2GWDaUWMRZjWKuT
         Yl3w==
X-Forwarded-Encrypted: i=1; AHgh+RrFyMyAcAhx8m3r7MfOueyKz16S7RPDKEEAlRUH9dteIgxWM4Y64l3dj5bzAryGgwlU/hKnH+tbcMBqLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqHNsHrBrdEuKJjiAcjZoQGL2UpLlSyWhhhaqMwDeqaXBomOj4
	qKW0KSgWhCMQUVQtPNbj34gM8ElaRkp3JpawQQc5Pmvwn1CrW3TpFCl4LhodBW0AYbEGoizN+un
	naH2ngXjfVnT0XN3FqJDbQBHJQrN2ainbSeQv
X-Gm-Gg: AfdE7clfohNVgGwCa+HNjIUt4obZ1ClchoTz88D/JXCt4IRRohmYM/+FUcCPJnJWvZQ
	kPTpDny/ksH8lwADqSZS7iSst5eZYuKcV8Rju32DpDinb8JPWFlmY+05QZQDglZ7PlkLQdh7V9S
	VXYKkP7BOauZMWemvBDmsYcc9LqJfs2i5VEjw+lvpd86JL44CFPtRJ87/oJ8lSAvBSv0DRcKe4y
	qOqa8bZSMv1GOP0eyFX+vdC4sKeWoMToDs6xdzhKglL48HxgXVfh2pZ8sUWkEB0qqk0RHd6cg==
X-Received: by 2002:a05:6512:3504:b0:5ae:a49f:fdae with SMTP id
 2adb3069b0e04-5aebdbb7878mr1109528e87.50.1782842126549; Tue, 30 Jun 2026
 10:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625052639.241024-1-wuyankun@uniontech.com> <CAKFNMokkDqSYUzNkmvztUHx9U3YWPOdYmJ-9xkkQMnutN6H-ug@mail.gmail.com>
In-Reply-To: <CAKFNMokkDqSYUzNkmvztUHx9U3YWPOdYmJ-9xkkQMnutN6H-ug@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 1 Jul 2026 02:55:10 +0900
X-Gm-Features: AVVi8CeTfnf_yzspXNkkWwPh0gUxGRpSVe_Abd2QSs_t3qTR0PCWF7pr8HnNd0I
Message-ID: <CAKFNMonk0BDe3PcNdu7ZvSitO1U1TFEvj9mLXAdBK96fCnBScQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: prevent double insertion of b_assoc_buffers in
 dirty buffer lookup
To: wuyankun <wuyankun@uniontech.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Wuyankun,

On Thu, Jun 25, 2026 at 7:43=E2=80=AFPM Ryusuke Konishi wrote:
>
> On Thu, Jun 25, 2026 at 2:27=E2=80=AFPM wuyankun  wrote:
> >
> > syzbot reported list corruption caused by double list_add_tail() on
> > bh->b_assoc_buffers in nilfs_lookup_dirty_data_buffers().
> >
> > A buffer_head can still be dirty and not under async write while alread=
y
> > linked on another association list. Add list state checks before enqueu=
eing
> > in both data and node dirty buffer scanners to avoid re-adding already
> > linked nodes.
> >
> > Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3Dc37bed40868932d790e9
> > Signed-off-by: wuyankun <wuyankun@uniontech.com>
> > ---
> >  fs/nilfs2/segment.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 1491a4d4b1e1..09202d155903 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
> > @@ -741,6 +741,8 @@ static size_t nilfs_lookup_dirty_data_buffers(struc=
t inode *inode,
> >                 do {
> >                         if (!buffer_dirty(bh) || buffer_async_write(bh)=
)
> >                                 continue;
> > +                       if (!list_empty(&bh->b_assoc_buffers))
> > +                               continue;
> >                         get_bh(bh);
> >                         list_add_tail(&bh->b_assoc_buffers, listp);
> >                         ndirties++;
> > @@ -779,7 +781,8 @@ static void nilfs_lookup_dirty_node_buffers(struct =
inode *inode,
> >                         bh =3D head =3D folio_buffers(fbatch.folios[i])=
;
> >                         do {
> >                                 if (buffer_dirty(bh) &&
> > -                                               !buffer_async_write(bh)=
) {
> > +                                               !buffer_async_write(bh)=
 &&
> > +                                               list_empty(&bh->b_assoc=
_buffers)) {
> >                                         get_bh(bh);
> >                                         list_add_tail(&bh->b_assoc_buff=
ers,
> >                                                       listp);
> > --
> > 2.20.1
> >
>
> Thank you for the patch.
>
> This patch adds a fix to forcibly avoid double registration of a
> buffer head to the list at the list manipulation level.
>
> However, we need to clarify why that happened in the first place, and
> what caused the state inconsistency that led to this double
> registration.
>
> The search routine for dirty buffers performs a gang lookup for dirty
> folios, registering them to the list in ascending order of their
> offsets in the page cache.
>
> Furthermore, the construction and destruction of this list take place
> inside the log writer, which operates exclusively. Whether the write
> succeeds or fails, the list is released by nilfs_release_buffers()
> (called via nilfs_destroy_logs()). Therefore, double registration
> normally does not occur, meaning there must be an oversight somewhere.
>
> As this issue arises from calls made via the GC ioctl
> (nilfs_ioctl_clean_segments()), the underlying implementation flaw
> likely lies there.
>
> Since it seems reproducible with the syzbot reproducer, I will also
> trace what is happening to verify if this fix direction is
> appropriate.

Regarding the cause of this issue, the page index of the folio
containing the problematic buffer head was 18446744073709551615 (=3D
ULONG_MAX on 64-bit architectures).
As a result, filemap_get_folios_tag(), called from
nilfs_lookup_dirty_data_buffers(), repeatedly finds the folio at index
ULONG_MAX, causing the duplicate processing of dirty buffers.

The root cause is that a page/folio with an index of ULONG_MAX has
been inserted into the page cache via the GC ioctl.

Specifically, nilfs_ioctl_move_blocks() processes the blocks to be
moved by GC based on the nilfs_vdesc structures passed as ioctl
arguments, reads them into the page cache via
nilfs_ioctl_move_inode_block(), and marks them dirty.

At this point, there is no range check for vdesc->vd_offset, which
determines the page index.
Consequently, the artificial request generated by syzbot causes a
folio to be inserted at the ULONG_MAX page index.

Therefore, the fix should not be to hide the issue by introducing a
duplicate check for the buffer list in
nilfs_lookup_dirty_data_buffers().  Instead, please define a local
variable in nilfs_ioctl_move_inode_block():

__u64 limit_offset =3D (__u64)inode->i_sb->s_maxbytes >> inode->i_blkbits;

and insert an error check just before calling
nilfs_gccache_submit_read_data() when vd_flags =3D=3D 0, returning -EINVAL
if vd_offset is greater than or equal to this limit_offset.

This will resolve the syzbot issue, but a similar check will likely be
required for nilfs_gccache_submit_read_node(), which is called when
vd_flags !=3D 0.  If that part is not obvious, it might be better to
separate it.

I will hand this back to you for now, but I can also take over
creating the fix patch myself, so please let me know if you would like
me to do so.

Thanks,
Ryusuke Konishi
