Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FDE36403B
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773788463; cv=pass; b=ZiXUqCKQY0e2qO0+cbfWTKEHL3TQs8tpxvArU9A6926OSYrIqBBCqn4Cl3hB3f/JxzgCCOnXDIuMHW5tf75MtEHxrL7ZV4KJkoZiOxJCo6wsAvbZjmVfnz7wH63QxJ6QaN9xBPhhh5ktjNHEKclexQe6w6aUcDjDgrWrK66P50I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773788463; c=relaxed/simple;
	bh=EYc2Y4Nw0XYHeAGea3UiFtpjY7mHllWS9pVm0J5Uejg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9Y/i80jQQQOV/amijQe2lTyr5W740kkbhFbQDLNFNnhah22NHTZ0yz0w8zNBDQvwH1zzCLmYGeF5ECSmLAGjGezhcWH9b7s00sM99HfGhMqwdrTUkVQCxCEFfax9qc6+Snzk2l4FpEzMGEr4i1NCg5dofTEI1GCYONQTLIzOjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hcYTvtBu; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hcYTvtBu"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59e4a04f059so6258506e87.2
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 16:01:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773788460; cv=none;
        d=google.com; s=arc-20240605;
        b=XQhQPAE2Q9Fpe5XJt3hHwcQNwlrSfRSGpWM2xONDkJGEu7aiOjJ9kGgchQdYNiiTyl
         KjIkP5zP5tJsXY2ICNOCAnpgMEBCPty/AHzw4KK32RxErj5XT2+WhpV7eFuHNYr3g1qi
         2tRNcMg2SdzemWmxYtV4RVoLkwnirmGLFY+s3lDCw2X+Wc0Uk8U1wxq/n16emVlmeP9x
         RTXOxIWIsX4DrJFFi/nC02fYaKLxEWrjIXQSK0ErvVhxhT7Bl9NQepvhn6f4BFVj7Qop
         MwV04qbgxilRUQvyB6/y9yM1sHWZn7ECeXDBjYlS9M+f1t+NHrTdhSIMWYw4bo/+wfqX
         Yf0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9leD/3IqGQg3W6KSr0bSsHp8z7FR+wqsk4DukewL3UY=;
        fh=lwTGiLHhvyV7zw6SDgTh4X6dhTSlPV7Q85jdTOzUnIo=;
        b=RCWhkg6v05XbfdxEKcEDu0+Det/93xoOHwVI8kI87o+VNGCgGDmOehDv6dcXvtSzcx
         7SimIPIVudBzCN5QTui0irBprTLI8m99xGODtriZ5nNUIbHpZgjKaF1HyY2+rtFPoyRV
         UXG9+aO1cuVua8l5D6XeyZYj7APyyO2cXCwF/cBJtKokfb11cr9tLvFSUjevI0unXBCd
         qRJsE3NUuHDjOZJVfF54MGya5X0VgrOwTYf3/jw1KSHHNAEIXNYZ21V5dRzsGL1D81Pb
         V8kMIDkPiI/EaaEV7OeKWDgJ2MoO4ch/aEmiKM9mKWiSGpMR2H1onV9k2tDMkVYdpdnZ
         HJMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773788460; x=1774393260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9leD/3IqGQg3W6KSr0bSsHp8z7FR+wqsk4DukewL3UY=;
        b=hcYTvtBu7NVcjKYLyFUmdiVB7H1s4bLHbliNbreX/6iwP7j9KxYk/33PMurpJN/Sqy
         JRUBy6FlTcaJBGG+KtHx8AKTU5LwVl1Dk7w2f/HvbA8QBMZiWtE6sidTxaFFzjFzbfii
         0+2VjtJF0ftLtdYCFkEojanS3clW+Bbj9Q64SkwUrpI0CkXZ3V+XGlL067QIy/r6gzat
         Lh1awWvubCfM/V/Y4lx1opPYu8WNHHbcmcrnHjQEnoFwpo1xcrr6GdE1/bbv24VLXPwd
         cfdgJrsgZz2tVBO71Brg2jesruerWdnwpzRPxoihkY75gIjUEH4uLAbhGDqLzUetmoXA
         dgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788460; x=1774393260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9leD/3IqGQg3W6KSr0bSsHp8z7FR+wqsk4DukewL3UY=;
        b=MwKeKOQykiH+ASLCmp/wkrDU0GVlWpyF+Y+i6wS371Nnh/J1XtOoh3F6vReG/5f/k2
         URbKf6po42wq+IHLlPTxlM+McjkYFn1p59io7QaLAedHEyjF8Bc4SlEJOTxIWILXDZ2Y
         zziirM8VIHC0Fsf60IHXBaaPQ//6jX4WgByl/2w0yYM7UvpsAn1ycve3Kdmk7ej6dUZj
         wNszeE/KbX3gZWxIDPj4LJsaV7ehFk4yeLHZOq/dN1ai6oYb7yaTXs/xsq4oNZrf+dNT
         jebFi48tBkObp06nWSUsE6Y6B92ISxEwFOJmu/eOBAYH0XEkJPZil8h+Oh3bJpf2QbJQ
         oyIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKIJdva5s2dcYpTqZucgekSegCEqRhJKOQ5ggy+Y6JtNK/N2fxKEZK4TyC+VJ59ans4Fql6aCCrGD1gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk2Hqluwe9b1ak2SGDzVHYGAgJ4hFZ4+ClGBh5V4c69nANFfjU
	AD4h1NlBopnUI5mO3sE7BFOPrm5PCEz91GVyPS1Ip8+Tf/4yxrcBiFSJyELvUTWiFgSMMpTq1Rt
	tRXluJ9I2qfrz7v5uTllbOd1khYcTFtM=
X-Gm-Gg: ATEYQzx1Nhej2Mh+nw4ymmhelHA2QdNn9yENmfqpa2J0BkevmZSb84RsDvUeHhezM+U
	080izWyXYzSpeA/tcw8HG2WgfeVxC/pdXbUFj5at36RLZ1V8zoaeVcwF4DkFHhzxNoxQ4p+LjEe
	FEqn/wcUJb/fKg+2UzUNcN52/Y5sZpJWKs+tuzucTQt6VjvH5kRK9ZyIEWv5050N12tHAysqjMJ
	qjaF8LP95MGSLQH39wOR8UEQqKZbIMG0o6bHlUak2dlLdsHsV4xDKjp3V21CaBFAo4zr/+ZGLek
	kZUeK2Xq
X-Received: by 2002:ac2:4ecf:0:b0:5a1:3a0f:f2e3 with SMTP id
 2adb3069b0e04-5a2796adeccmr348229e87.23.1773788459256; Tue, 17 Mar 2026
 16:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_5E9ECE1B9E4B941B182565BAC2BB48336408@qq.com>
 <20260317151506.881298-1-kartikey406@gmail.com> <CAKFNMonq5CyQPWB6FeDT04LQ_rkL-KLDx7oQjBqThRH09FRgMA@mail.gmail.com>
In-Reply-To: <CAKFNMonq5CyQPWB6FeDT04LQ_rkL-KLDx7oQjBqThRH09FRgMA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 18 Mar 2026 08:00:42 +0900
X-Gm-Features: AaiRm53VdRIomOzK1N_7ShY1Aa0Lu7E_hxabEQpmqvfQOGl-xKdvX0l2ZDu-wXk
Message-ID: <CAKFNMomDpMC7VrWzoLEm_5wGzjV5v82tQCWtRy3oif1Q-=9dPg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of
 members is too small
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: eadavis@qq.com, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	slava@dubeyko.com, syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 1:51=E2=80=AFAM Ryusuke Konishi wrote:
>
> Hi Deepanshu and Edward,
>
> On Wed, Mar 18, 2026 at 12:15=E2=80=AFAM Deepanshu Kartikey wrote:
> >
> > Hi Edward,
> >
> > On Mon, 17 Mar 2026, Edward Adam Davis wrote:
> >
> > > The value of argv0.v_nmembs passed from userspace is 0. This prevents
> > > nilfs_iget_for_gc() from being called to initialize the gcinode durin=
g
> > > the execution of nilfs_ioctl_move_blocks(). Consequently, this trigge=
rs
> > > a null-ptr-deref involving ii->i_assoc_inode within the subsequent ca=
ll
> > > sequence: nilfs_clean_segments()->nilfs_mdt_save_to_shadow_map() [1].
> >
> > This analysis is incorrect. The null-ptr-deref is not caused by
> > nilfs_iget_for_gc() not being called. The real problem is that
> > ns_dat->i_assoc_inode (the DAT inode's btree node cache) is never
> > initialized at mount time.
> >
> > > A check for argv[0].v_nmembs has been added to nilfs_clean_segments()
> > > to prevent this potential null-ptr-deref of ii->i_assoc_inode.
> >
> > This fixes the symptom but not the root cause. Also note that in
> > the original syzkaller reproducer:
> >
> >     argv[0].v_nmembs =3D 0xd =3D 13 > 0
> >
> > Your check would NOT prevent the crash with the original reproducer.
> >
> > The correct fix is to initialize the btnode cache eagerly in
> > nilfs_dat_read() at mount time, since i_assoc_inode is only
> > initialized lazily during btree operations. When
> > NILFS_IOCTL_CLEAN_SEGMENTS is called before any btree operation
> > has occurred, i_assoc_inode is NULL.
> >
> > I have already submitted this fix and syzbot confirmed it as fixed:
> >
> > https://lore.kernel.org/all/20260317090109.878401-1-kartikey406@gmail.c=
om/T/
> >
> > Regards,
> > Deepanshu Kartikey
>
> Deepanshu's suggestion seems close to the answer, but I think there's
> a slight leap in the root cause analysis.
>
> When nilfs_dat_read() is in a b-tree configuration, it normally calls
> nilfs_attach_btree_node_cache() via nilfs_read_inode_common() ->
> nilfs_bmap_read() -> nilfs_btree_init().
>
> Therefore, the problem seems to be one of the following two:
> (1) nilfs_mdt_save_to_shadow_map(), called from a GC ioctl specifying
> the dat, calls nilfs_copy_dirty_pages() assuming a b-tree node cache
> exists, regardless of whether the DAT is direct mapping or b-tree
> mapping.
> (The DAT mapping method switching is not considered.)
>
> (2) The DAT is in b-tree mapping mode, but nilfs_btree_init() is not
> being called because the i_mode of the DAT inode is corrupt.
>
> Both appear to be potential bugs, but their fixes are different.
> Have you determined which of these is causing this bug?
>
> Regards,
> Ryusuke Konishi

Okay, I'll do a few more checks to make sure it's alright, but I'm
going to pick Deepanshu's fix as the solution to this problem.

The reason is that pre-allocating the b-tree node cache inode to
i_assoc_inode, as nilfs_iget_for_shadow() does for shadow mapping, has
no side effects and seems like a comprehensive stabilization method
that covers both potential issues.

The nilfs_btree_node_cache() method, which detaches the b-tree node
cache inode, is currently only called from nilfs_clear_inode(), and
once allocated, it doesn't degrade regardless of whether the inode
uses direct mapping or b-tree mapping.  Therefore, the approach of
pre-allocating the b-tree node cache inode is safe.

And also, this isn't overkill.  The DAT file typically grows very
quickly, so it almost always uses b-tree mapping (which is why this
hasn't been found before).  I think it's a good fix.

Thanks,
Ryusuke Konishi
