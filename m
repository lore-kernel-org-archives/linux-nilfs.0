Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5D337A85A
	for <linux-nilfs@vger.kernel.org>; Tue,  1 Sep 2026 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788286393; cv=none; b=EbMgiBhOvGFrTFp7No0wfstQgJBwPHDKDb+/5Sk6lYYA6sDgCRGmKuT/6xKR1tIt0vLsW55IEnee6FBt4jTITk/v5dpGCOUyzRK0OUDm1dcRoqk3MUdMRHNdkrmNTpXWdw0V8kLVjNaktZItqQKYd1m2y7j2N59h6urWnJ6wZXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788286393; c=relaxed/simple;
	bh=PocB4P27jdGujQgIIueGuqZrjaFeukOWvQWH14eJ2ho=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PIDXCOnEl9UCt+Ijr5dn42WXegCjrywlC+Ob+NArYXmXoXtl9L3VHQUqNrLm+4cZgV+JhMcXch9q080SD+tH/yMa/vfASxtXrz/zw3YApybnz/A8SsKkop2m/1hoIo2WEntZ+3M/oZI8DKW9hG4fT0Wgn5PqXpsDBSuBjcrAbhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=ZNCNhJMC; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="ZNCNhJMC"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-861145fc841so3872497b3.3
        for <linux-nilfs@vger.kernel.org>; Tue, 01 Sep 2026 11:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1788286390; x=1788891190; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZyoyQfcFhkFa+qLmL5+6VXjoy/t7IJxmOM8cjoY61I8=;
        b=ZNCNhJMCy8wv66RfGrAzvtoUsC+BVnkn00JtDjlRo0qbZ7vYPc9zWeFkI6qABUgWcm
         tnz3lS2vTyRhe6U1Az0P+GXxjlHHK2HmzYJ7RA0JuSNO036f8215NOpyebPl3ba9PrzP
         1b8PCms0yhVF3sP7Inh9jCP3yyZZryzBwtiqnefYSq/XJ/jJVyc5loafh+JOoQcLpant
         oVIBeT3mKAsGM7aTTjPHzvTIWa0AEn+O6SSkb3TZhlemUeV78n9TV72hX1IVkcvXppAu
         CdVpuDpH7q9KafATQ81wCn8feLKwy3tbdn8EjoeGFnxngdOkLgHhU+wEbHNGaFiZrF2N
         Iilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286390; x=1788891190;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZyoyQfcFhkFa+qLmL5+6VXjoy/t7IJxmOM8cjoY61I8=;
        b=P0m3lmmXmE5bFglZuDeNvTckIGFN186HVstW9xIhic/wdZ6sXYQPRuH/htFCU1RXMk
         RBRdFLPENDg+ftdilWYVAjG5mXTQ4qIcwuWAd/fPmiX31IVwsg3OyjNEychUATeLHyF/
         3MLqcTuCp/FVBk9Y7/yMTHcVhjW3NOrREFl02LPVyPhaN44+cWGMhnwTOkk0k9x5ne2Y
         nfxtMsgpLwyyeThy459TjZ71JRHNIqRUmNFt2j1xk5ucC3Rm2KPSuW7oZGSAD2STTdMz
         ZwWwXm0LZwT4puFL/8VORiytJ2z8wvNVe9+Zx6Y9OoUCyorP7WvyzdxJsEIhV5NLgN2g
         CApQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKDL9Ipt/WSVaNV2Vm37AuH8OLnE87rnAMjtOrZ2pr7zkQroqGf5PSO+nIkn0Qb6qPK1fZpR2oDkMFCA==@vger.kernel.org
X-Gm-Message-State: AFuF++kxVUSG1IN5Uh84rtNp1maFzHGLXN8ZYs3D7spQtVpjQmZlKH2U
	DqnVypq48HG4HK5jJxV4HmbgxPeMtl7s4NExiTSldLEY8fE1D8RG6EfbR0xFV56OqYk=
X-Gm-Gg: AYBFou2gxP0cR4gr27Wz97sVcWmPv8fka0TSyin2+NaFcDQ+LswqZZaQ84hUVksPO0o
	b9ltAVLTLXLG0Rk10e7n3d7965cByQP10Yk1Lg52CwsVZJCAjAmQKnJtRD1QFmCuMDYHWNmHVth
	jk1Tn81rlu8RGVhK+4ZmgJhxSgp9s86Wud9l8gKPeFEH3cqxnURHNu/w3roh9w4DjHjHBzG6F/1
	5xDJ3ck1dyw+Mt9O+/ArB8sPsrtTIa8byUTkzTFmJTZ9WFs3lq/BmgztAVVEWmHqh/te86tYqIx
	0yjC5rOYKRPlj2W6psE8BroDqVrj2f7VsEpTUxEWNSsaaoNL1YYZaus919bHNdOGzVO3jEHIgoc
	raftzG4H7RDW7H70swADv8jCtjT4E2kWqeGQ58hb5k66K5Vmf/sa9crH4WRMXRWF0qBpryIl6rT
	/l760GWq0q62EzYjaCGDOSG6vgsmneiybcTjBJNCWsb9ypGgkQjA9KNO3XYaSdwdwa6IrGftnbx
	i1xrlAcmBZ1jQWTR5OLNaF9edc7bj8YNGDVeEYh5h8XxTXqzuhWN4BBEVFM5MSbwCKdV2QvwPhO
	Kzf9RVDSOPXbctXLDw==
X-Received: by 2002:a05:690c:12:b0:81f:2403:9e70 with SMTP id 00721157ae682-86874be3a5cmr43415917b3.19.1788286390284;
        Tue, 01 Sep 2026 11:13:10 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:bedd:8cbb:d030:f70c])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-867841e3cafsm38330727b3.24.2026.09.01.11.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 11:13:09 -0700 (PDT)
Message-ID: <8472de4405ebe1459a4177c25bd08c2bfcd1b6b2.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: clear folio dirty flag when copying back from
 the shadow map
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Jiaming Zhang <r772577952@gmail.com>, konishi.ryusuke@gmail.com, 
	linux-nilfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 01 Sep 2026 11:13:08 -0700
In-Reply-To: <20260901134430.1292467-1-r772577952@gmail.com>
References: <20260901134430.1292467-1-r772577952@gmail.com>
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

On Tue, 2026-09-01 at 21:44 +0800, Jiaming Zhang wrote:
> While garbage collection runs, nilfs2 keeps a shadow copy of the DAT
> metadata file's page cache so that it can roll the file back if GC
> fails.=C2=A0 The rollback has two steps: nilfs_clear_dirty_pages() drops
> the
> dirty state of the folios in the DAT cache, then
> nilfs_copy_back_pages()
> overwrites them with the saved contents.=C2=A0 The second step warns if i=
t
> still finds a dirty folio, because the first step is supposed to have
> cleared every one of them:
>=20
> 	/* overwrite existing folio in the destination cache */
> 	WARN_ON(folio_test_dirty(dfolio));
>=20
> Clearing has been best-effort since commit ca76bb226bf4 ("nilfs2: do
> not
> force clear folio if buffer is referenced"):
> nilfs_clear_folio_dirty()
> leaves a folio dirty if a buffer head under it is still busy.=C2=A0
> Reading
> metadata creates such buffers.=C2=A0 nilfs_mdt_read_block() submits
> read-ahead for the blocks following the one it was asked for and
> waits
> only for that one, so the read-ahead buffers are still locked when it
> returns.=C2=A0 When the block size is smaller than the page size, several
> metadata blocks share a folio, so a single folio can hold both a
> dirty
> block and a locked read-ahead buffer.=C2=A0 Such a folio survives the
> clearing step, and the copy-back warns on it.
>=20
> Use __nilfs_clear_folio_dirty() to clear the dirty flag of the
> destination folio before overwriting it, rather than making
> nilfs_clear_folio_dirty() force-clear busy buffer heads again.
>=20
> Fixes: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is
> referenced")
> Closes:
> https://lore.kernel.org/lkml/CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5=
yY0dTtg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
> =C2=A0fs/nilfs2/page.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index cf4f1c6798f5..b26d9c3bda6d 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -328,7 +328,8 @@ void nilfs_copy_back_pages(struct address_space
> *dmap,
> =C2=A0		dfolio =3D filemap_lock_folio(dmap, index);
> =C2=A0		if (!IS_ERR(dfolio)) {
> =C2=A0			/* overwrite existing folio in the
> destination cache */
> -			WARN_ON(folio_test_dirty(dfolio));
> +			if (unlikely(folio_test_dirty(dfolio)))
> +				__nilfs_clear_folio_dirty(dfolio);

Maybe, I am missing something. But the main point of this WARN() if we
have found that folio is dirty, then potentially we are trying to re-
write already modified data by already obsolete state. How can we
distinguish that folio has been survived the clearing step or it can be
somehow modified in the background? Even if it is survived the
clearing, then it sounds that something is wrong in another logic. What
do you think?

Thanks,
Slava.

> =C2=A0			nilfs_copy_folio(dfolio, folio, false);
> =C2=A0			folio_unlock(dfolio);
> =C2=A0			folio_put(dfolio);
