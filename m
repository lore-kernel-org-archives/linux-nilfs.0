Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE0B3DB332
	for <linux-nilfs@vger.kernel.org>; Wed,  2 Sep 2026 07:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335718; cv=pass; b=qqLitP7GQ6CC1+pQjGpy/xIRAPDp0sMvWMa90elJqjCAEJeT2h0LHZurWvReAql1Xur+juwfCD5PcUXQztKqus6JQXyFVUwH8ki/pqtQsigvInoTu8F7tc9bg853IVxiyDEZnsAngXB4WzU76Ud8uARY0zWNAlMiz46Emiz+9qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335718; c=relaxed/simple;
	bh=B496ZWE8lTS6e9XujVEQppvyzLhvQxrwFbtpSbh/IVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qbAmSBs3+tWQT4G/V6yc5nY0JvAjXw35Snh7/UkDjoraRCV7YOZtP7IbBoc90Ri6PItcNtV8MW1pnb8XPJZfz+DEn0qWb+fT5L1iwzjvSlm3lXYE1Yv0/C/6SdcKq4tQzqir4jtg8dEVJ0rnlbNf3Gb94YDzJd1H7pnSdK13884=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fq6BliAn; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fq6BliAn"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2533d83e3bso94990066b.2
        for <linux-nilfs@vger.kernel.org>; Wed, 02 Sep 2026 00:55:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788335715; cv=none;
        d=google.com; s=arc-20260327;
        b=rONiGtfF8zqLYbNoy8QAumyyKDhgEXZgGGdTg3Y7MdG1UCccNK+nk4Mb5TcTJ73tR0
         P+3tY4btnq+iJ24RgVcf3YsfugA20lu+nDxrW8v+rijZkqZz3i+t1xdkpt1y7oATs3nQ
         8UEnEV2vLoVcPSluiNI7oUnWXU3LK2M8RiGNiulP3a4ymMM7OsApJ+fS0j2FlG+iYgiX
         p0IofLztKGc9E8NQciuYzd10YUit8tvrt5oAWu9TBEfw2E7krQui4oGjnkxQfDjeqvIl
         0tEGdcVsiDgRaq+8fcsVmp0geuIA/rw0gGcGejny9LeLtrKbsQEEga4ETXg60rnZes5S
         9z3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i0TA8mNqju4M5C15rH1fVoSuW9TL+HQXP6xEiDU8GW8=;
        fh=38jom8mAZaoqLAJyLY18FLrpn0pRlCrK7fylDylguG0=;
        b=CUiowJHcVFfCm47dtyda4LEKMf7ryMe6QrbWZClb5eSwyaun+9Rz6b+lT44BNvUYX8
         Yj8EGgZsahq7s4xlTRy+F1vtfxwXl/HtWLLH820WFlIf88BtekKRSQA+wAtaAvoKyDfZ
         qvCQelnttUFMhylkRUQ8BlxViKwXV+RCohquVRyocM9tJz7HDZJRFzkVMCuezQWvrbnh
         i2C9m8opDcEupBKTgsqyEMiJvMLBDiJDK80CUsX0EvIabBc434B4N0wSKRRRDDA20xP1
         2cCVpc50uUlywLPWzrQJS97+aCOHvVJxRzItFSWZpTVEiDmB1+6DYx9H2Qnz+TzkO4jV
         gxGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788335715; x=1788940515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i0TA8mNqju4M5C15rH1fVoSuW9TL+HQXP6xEiDU8GW8=;
        b=Fq6BliAnb7jLIVrsoENBAbsEvSWYAix7pVxIYW6r1liBFmdJ7MqCkFHj7Kcuq0RPq1
         7LXsdWOMKl3pbsmJh+tgggsMeldwHPpNC/OMv40rdzSeNPWELDY81Uv2pMfacJFpYa+t
         qQ+acS669B9N7GMwfwsBfwxdXurK8bOZtl4xQsYgj9ygW6Z+A1ovw6dhMqO64nejXHdf
         Gh4pmjP/2n9fR7udTwljaFksZufhzOX83+Yr51SQJt02td6cqbcVXY/RLgUC2oyCW7Da
         hXSKQlfipcKR6pLDb5PpGZJFO0ANS/S/jxgREsPZ/x25SoIR/FRDtqFlgQRrr9QINBB3
         v+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788335715; x=1788940515;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0TA8mNqju4M5C15rH1fVoSuW9TL+HQXP6xEiDU8GW8=;
        b=Qbn/ev6U9mWZGNGlZ5mHBQCveGCWkm9X7eEbsZLcyvDjdUyZ0kmNzE/Yy+OTxAGfTw
         I/KAdwe/yyyFdQncvKXNq+lvssAq2zAyuRR9ODxg0p7olPKJJPjc8dMDjjcc8e02vvdo
         Yb/fLZMmcVRvXszFE2u7jcL+OLhafJ1gRr+V8ZPq4nsfVdJ517MiXi1ifan16/VCKqxN
         tt64rJUpG8+vYITWA5IQ/fcBRRke9teMcrMuCr1aGRxLlRSP5ZtR7l/AKJD3wBFCuXwV
         1TpRZ8+RNMRI8DhhHQDkkuclgKpndVOUK+o1THUxdoXv0J9jyk3h/hlRNUN0unn7XcDY
         r9VA==
X-Gm-Message-State: AFuF++kdZrvMmEKT5SNMtrxGEMpVvx5Zr5K3Avwc67/d2eKOszC9RNBc
	bdwjboTMEVLQegC3B1l6Ca3XZHJVp37nobHE/r7smfPCNrjOKDqT957kje47VX5uF11sUD/yO47
	PgDY33qkWz4j/E6ywfqHJPh1tk+5ptqg=
X-Gm-Gg: AYBFou1ialhDLIqYM9o/cYa82nn5bj2QmGgRozOYmBHJ/W8EIhnFDlDTdBcJOUn+q9x
	DHu+y7kKqgxHainJL+vUoEiKG+8aS3ZljMNbB36GavpT5NVFE9h1eUrhzTVCozaix85NQUWFoJi
	seGzvboO3SSjnRaQIOqNHvcj6PfGhVM1Y6+XnSi+N+STdtm1E/qt4FUtTFkdUAHHB0XS9MKQEzD
	gNygikAWGqel2okSwsiWfv6Uk1ocj68wglegjZm7nMESgL3hLyOkRvUdtTH12niVD1fYmkQQXU+
	f0THoeFh8EGViv4XNh4Ns9sYoeq+PiOvVl39nGASW8zVjQ==
X-Received: by 2002:a17:907:94c5:b0:c19:49ee:19b9 with SMTP id
 a640c23a62f3a-c25d54753c1mr143038366b.15.1788335714598; Wed, 02 Sep 2026
 00:55:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com>
 <CAKFNMo=GevQ+76gNdPvaQf4rP7=UbiPipRYj6BD3tCaSYj_hcQ@mail.gmail.com>
In-Reply-To: <CAKFNMo=GevQ+76gNdPvaQf4rP7=UbiPipRYj6BD3tCaSYj_hcQ@mail.gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Wed, 2 Sep 2026 15:54:31 +0800
X-Gm-Features: AcwNN1XM8oOzL5Q4z8g0EObHic-iVpGn799hzbqs-z-pxgjTcsYjf95sqfrUYjc
Message-ID: <CANypQFaUfeXU7S9N0PpJP343h1ibRxSJ27oJxhJ0Jd5ChpiDcw@mail.gmail.com>
Subject: Re: [Linux Kernel Bug] WARNING in nilfs_copy_back_pages
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ryusuke Konishi <konishi.ryusuke@gmail.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=
=881=E6=97=A5=E5=91=A8=E4=BA=8C 23:11=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Sep 1, 2026 at 9:58=E2=80=AFPM Jiaming Zhang wrote:
> >
> > Dear Linux kernel developers and maintainers,
> >
> > We are writing to report an issue discovered in the NILFS2 subsystem.  =
The
> > issue is reproducible on the latest version of linux (v7.3-rc1, commit
> > cee9395acd8043be0644b25c34bfa86623f2b935).  Below is the kernel report:
> >
> > NILFS (loop0): error -2 preparing GC: cannot delete virtual blocks from=
 DAT file
> > ------------[ cut here ]------------
> > folio_test_dirty(dfolio)
> > WARNING: fs/nilfs2/page.c:331 at nilfs_copy_back_pages+0x639/0x810
> > fs/nilfs2/page.c:331, CPU#0: syz-executor887/9521
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 9521 Comm: syz-executor887 Not tainted 7.3.0-rc1
> > #37 PREEMPT(full)
> > Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
> > 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > RIP: 0010:nilfs_copy_back_pages+0x639/0x810 fs/nilfs2/page.c:331
> > Code: 44 89 fe e8 39 8e 12 fe 45 84 f6 74 25 e8 9f 8a 12 fe 48 89 df
> > e8 67 9a 55 fe 4c 8b 7c 24 10 e9 e5 fe ff ff e8 88 8a 12 fe 90 <0f> 0b
> > 90 e9 1d fe ff ff e8 7a 8a 12 fe 4c 8b 7c 24 10 e9 c8 fe ff
> > RSP: 0018:ffffc9000854f4c0 EFLAGS: 00010293
> > RAX: ffffffff83a8e928 RBX: ffffea00013cf3c0 RCX: ffff888026619f80
> > RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
> > RBP: ffffc9000854f6e8 R08: ffffea00012db607 R09: 1ffffd400025b6c0
> > R10: dffffc0000000000 R11: fffff9400025b6c1 R12: ffffc9000854f548
> > R13: ffffea00012db600 R14: 0000000000000010 R15: 1ffffd4000279e79
> > FS:  000055558d08a380(0000) GS:ffff8880985d9000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055558d08aca0 CR3: 0000000044f02000 CR4: 0000000000752ef0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  nilfs_mdt_restore_from_shadow_map+0x127/0x260 fs/nilfs2/mdt.c:652
> >  nilfs_clean_segments+0xab8/0xba0 fs/nilfs2/segment.c:2552
> >  nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:938 [inline]
> >  nilfs_ioctl+0x242a/0x2590 fs/nilfs2/ioctl.c:1368
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
> >  do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fa00bf4d42d
> > Code: b3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffd36ab1678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fa00bf4d42d
> > RDX: 0000200000000300 RSI: 0000000040786e88 RDI: 0000000000000004
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffd36ab16c0
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd36ab169c
> > R13: 00007ffd36ab16e0 R14: 000000000000000c R15: 431bde82d7b634db
> >  </TASK>
> >
> > Following is the root cause analysis for this issue, note that the
> > analysis is performed with the assistance of LLM, but we try our best t=
o
> > ensure the accuracy.
> >
> > The WARNING triggers because a folio of the DAT metadata file is still
> > dirty where nilfs_copy_back_pages() expects a clean one.  That function
> > runs when garbage collection fails, which the reproducer causes by aski=
ng
> > it to free a virtual block number the DAT file does not map.  nilfs2 th=
en
> > restores the DAT page cache to a snapshot taken before the collection
> > started: it first clears the dirty state of the folios in that cache, t=
hen
> > copies the snapshot back over them, assuming the first step left nothin=
g
> > dirty.
> >
> > The clearing step can skip a folio.  Since commit ca76bb226bf4 ("nilfs2=
: do
> > not force clear folio if buffer is referenced") nilfs_clear_folio_dirty=
()
> > returns without clearing if any buffer head of the folio is busy, to av=
oid
> > clobbering the state of a buffer somebody else is using.  A buffer head=
 is
> > busy here: reading a metadata block goes through nilfs_mdt_read_block()=
,
> > which also submits read-ahead for the blocks that follow and waits only=
 for
> > the first.  When the block size is smaller than the page size, several
> > metadata blocks share one folio, so a locked read-ahead buffer can be
> > adjacent to a dirty buffer and keep the whole folio dirty.
> >
> > nilfs_copy_folio() then copies the snapshot over that folio and clears
> > BH_Dirty on all of its buffer heads, leaving the folio dirty with no di=
rty
> > buffer under it, which no later segment construction cleans up.  On a
> > kernel booted with panic_on_warn, the WARNING can lead to a system cras=
h.
> >
> > To fix this issue, the dirty flag of the destination folio should be
> > cleared before the folio is overwritten:
> >
> > diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> > index cf4f1c6798f5..b26d9c3bda6d 100644
> > --- a/fs/nilfs2/page.c
> > +++ b/fs/nilfs2/page.c
> > @@ -328,7 +328,8 @@ void nilfs_copy_back_pages(struct address_space *dm=
ap,
> >   dfolio =3D filemap_lock_folio(dmap, index);
> >   if (!IS_ERR(dfolio)) {
> >   /* overwrite existing folio in the destination cache */
> > - WARN_ON(folio_test_dirty(dfolio));
> > + if (unlikely(folio_test_dirty(dfolio)))
> > + __nilfs_clear_folio_dirty(dfolio);
> >   nilfs_copy_folio(dfolio, folio, false);
> >   folio_unlock(dfolio);
> >   folio_put(dfolio);
> >
> > After applying the above patch, the reproducer no longer triggers the i=
ssue
> > on our machine.  If this solution is acceptable, we are happy to submit=
 a
> > formal patch.
> >
> > The kernel console output, kernel config, syzkaller reproducer, and C
> > reproducer are available at google drive:
> > https://drive.google.com/drive/folders/1R6EqqLPh5vgylKRPvO2ji5Q8Tsf0x8Q=
Y?usp=3Dsharing
> >
> > Please let us know if any further information is required.
>
> Thanks for the report, Jiaming Zhang!
>
> I think the issue is that commit ca76bb226bf4 changed the expected
> behavior of nilfs_clear_dirty_pages(), which is called before
> nilfs_copy_back_pages().
>
> Originally, nilfs_clear_dirty_pages() was implemented for
> nilfs_mdt_restore_from_shadow_map() to restore the pre-GC state from
> the DAT shadow page cache. It was designed to forcefully clear dirty
> pages/folios in the DAT page cache, assuming complete synchronization
> with the log writer.
>
> However, over time, it started being called to resolve page/folio
> dirty states when the filesystem degrades to read-only during a
> page/folio writeback request.
>
> Since this page/folio dirty state clearing was asynchronous with the
> log writer, it caused unpredictable bugs in various places after the
> filesystem fell back to read-only. Commit ca76bb226bf4 is one of the
> essential workarounds introduced to avoid this.
>
> The root cause is that the same helper function is being used for
> calls with two entirely different premises. I believe the solution is
> to restore the original semantics of nilfs_clear_dirty_pages() only
> when it is called from nilfs_mdt_restore_from_shadow_map().
>
> Specifically, how about adding a bool force flag argument to
> nilfs_clear_dirty_pages() and nilfs_clear_folio_dirty(), and having
> the call from nilfs_mdt_restore_from_shadow_map() set this flag to
> clear the dirty state regardless of the buffer head's reference state,
> just like the original implementation?
>
> Would it be possible for you to propose a fix using this approach?

Thank you for the explanation! I agree that your proposal sounds more
reasonable. I will send v2 patch later, add a bool force argument on
nilfs_clear_dirty_pages() and nilfs_clear_folio_dirty(), it is only
set true on the two calls in nilfs_mdt_restore_from_shadow_map(), and
keep the WARN_ON().

>
> Alternatively, since their premises differ, we could separate the
> implementations entirely, but I expect that adding a boolean option to
> switch modes would be simpler.
>
> Adjusting the WARN_ON in nilfs_copy_back_pages() would break the
> original design (premise) and is therefore undesirable, in my view.
>
> Thanks,
> Ryusuke Konishi
>
> >
> > Best Regards,
> > Jiaming Zhang
