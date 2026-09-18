Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0C3624AB
	for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 19:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760034; cv=none; b=rsUy31rzMsZg9pZMhFR8r1dHzAMI4AHLyII5aGMkofRzCsSPBcoUot7J2burY8uvLmayQ7JR0JLdomgDxrDTESzintMSSDecQGdDdqt8t0prpkNTqUFoBuhRKJOYIrIEIjGCGZ5x2z+z8G7t5Y0uOvEC10dl9nGD0pPCXQTes98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760034; c=relaxed/simple;
	bh=Li638ysKCUf5jQDWfKccqgmDHX97V/WyFaRHtRDPvFA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oozUzhclgSIMNGejE+vhMwAmEM9qdHzB90MtBz4CtGqVxmQn3uKVEPjMySSaM0ilwODHRJrGVYFdtcj6IQxkv/Hd2USRK2ujYTUCr+07nYVPh9AVguxJubVcBP/f+Uq1WAF8gCqPHJxD6Pi0tHPbw7mD8GG3GicP8pEAaeCC23o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=IcI05kSl; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="IcI05kSl"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb93aee5eso1241563d50.1
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 12:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789760028; x=1790364828; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Li638ysKCUf5jQDWfKccqgmDHX97V/WyFaRHtRDPvFA=;
        b=IcI05kSlVUZH67C28WdWfnYy3aclIwQEJyJs4s8cYRL60rPbvt/N+/rY/ui9Qq+YLN
         d+khf+IZ7M/Oq5C57BrKgPPRHj0gxG1U0ZvDUQmzfN/obrmFziJ9llLMh6phhwKXbBQO
         JTL2XrETuQwQtJyuYBmiIc/qQ02qv2gtQyRVzLmHwm1NezuNPBtnuRWmgXoJHjytqqUg
         onUQ44maqzt5FQ/F9B1qFGeUbQuuiFueYPf3wheA8QZPDi6hmCe2qqgEmDgfJJxA1/2/
         NwYLxx+2xdMvc7B8RW9egaivvkop47SiBnJak7jolLKfvD715KExSnp4DdMCb9Rjx9gO
         Bgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789760028; x=1790364828;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Li638ysKCUf5jQDWfKccqgmDHX97V/WyFaRHtRDPvFA=;
        b=pqpY16QSLQ4G77G3D8Wd8bbovE9zRid7PP3tDaynugcUV6Ob8HAg0cHT3mreZ9fbVF
         aWF5dASm9pmDWy6hEqy/GapMHwg0dgSJBW6Gf02CFlVtb7j7Q1VwdccBDkmM/mYpc2tC
         DN6tQu0lr0w2za9InClO02WxaeSO+9t0nqWQAL6f70P7MrEndiV/v8YFt6EFgMR3HBZ9
         rg5rgMUxhB64R20tN4VgTUe0Q7NW8BZD0o5ew2BJqz4B8+asUffHvObIyCxxGzjEpOJB
         N+CjUngwuDxSKx8Wyf0j2MXC2/+5y4rtmby7jGV22tAP2FxcL3Hk1KUnUtV+sU3YXciR
         b3DQ==
X-Forwarded-Encrypted: i=1; AKwUvBygQzxknNDptTmy0EUsPR7QIbwFEnOwWQVFYxaFB3bWJ9u9FjwSALCSssu1K4pLjkvBqv4OR6VhYdqj8A==@vger.kernel.org
X-Gm-Message-State: AFuF++m8/AfQ5yEFa4idZLQqT4uEXedoUpW0iOqW9OsSQajk2x5jxu68
	IDGtuPLz3ZH+AlWCKurPiGCX//qW5TvbsOSBSgquIxlsLdZqAediuZIcCFwJs+EByN94GhzjNmi
	tRm2Gm58=
X-Gm-Gg: AYBFou0GKe1pBhiveQIWg7MlqK1GQgTnKCVu6UFySDHrWpqUj/X0Gf1Z3g+Mxqnw+aB
	KGHKd1O6y8IYHSi1+kAreADyKShXWCOMhykNC9JzMxWcMz/CsGJWgwYrSz3ikMsN++CpxqQdwmp
	2IrXl+Ckqy0Gh1Mdkkodgw6uMF9f7Ah9B0wLLKDY+qwvu10ruYuEP12IOgAXHS7+trnS+Ho/4/p
	a4WY4G6WKdcBh/gNezlitC6pQnTUFyloxwmcm3yBWhAO1yXhw096Oat03yudMr4/1DNou0MVRwi
	IQLX7Gk2dOLu4fEM550sLkqnYcrH+byE6oSYzNO5dzofnOmJICkGf/nt6XLV5YQCAXJYt5rszPg
	Xq8Pan5G6NVjNj/qywbi0iOErGYoxxxtp8JUkb1i248PhL/tcVfixE/+DLMSG1zJqoRI5ItMbAa
	D3TRsYXlxaEkI0UiVvQS6YcYZ10Oetv8qkRag8krTQV9PNLttfiQRZkSuRDtljWImR+J4ZqILY3
	PEMN68OEsyGLyYJkEqt79IHmoukTn2CxN30wCdcSnyYzr37v3oiHIBrzzcu0fBiIDbTU683nJIx
	C6+2pbHUaJAC+oVtmLNhNhVT3OMGz49Tml30HcCr3Lt2qI7K9MfOKitRTXN4+i2I
X-Received: by 2002:a53:b118:0:b0:671:413b:7517 with SMTP id 956f58d0204a3-6717fda08b4mr986055d50.63.1789760028569;
        Fri, 18 Sep 2026 12:33:48 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:f1ff:bb02:6c7c:6979? ([2600:1700:6476:1430:f1ff:bb02:6c7c:6979])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672990a8b6dsm378505d50.7.2026.09.18.12.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 12:33:47 -0700 (PDT)
Message-ID: <e197037b70377be78b296380bcb31b8c3e8f8d74.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 18 Sep 2026 12:33:45 -0700
In-Reply-To: <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
	 <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
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

On Sat, 2026-09-19 at 00:44 +0900, Ryusuke Konishi wrote:
> On Tue, Sep 15, 2026 at 8:14=E2=80=AFPM Aldo Ariel Panzardo wrote:
> >=20
> > nilfs_scan_dsync_log() trusts the block counts in each on-disk file
> > information entry. If fi_ndatablk is greater than fi_nblocks, the
> > data
> > block loop can consume excessive summary entries and the later
> > subtraction
> > used to derive the number of node blocks underflows.
> >=20
> > Reject inconsistent file information entries before consuming their
> > block
> > information.
> >=20
> > Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> > ---
> > =C2=A0fs/nilfs2/recovery.c | 5 +++++
> > =C2=A01 file changed, 5 insertions(+)
> >=20
> > diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> > index 4d5a6aa521..6e4e0cf4cc 100644
> > --- a/fs/nilfs2/recovery.c
> > +++ b/fs/nilfs2/recovery.c
> > @@ -322,6 +322,7 @@ static void nilfs_skip_summary_info(struct
> > the_nilfs *nilfs,
> > =C2=A0 *
> > =C2=A0 * Return: 0 on success, or one of the following negative error
> > codes on
> > =C2=A0 * failure:
> > + * * %-EINVAL=C2=A0 - Invalid block counts in a file information entry=
.
> > =C2=A0 * * %-EIO=C2=A0=C2=A0=C2=A0=C2=A0 - I/O error.
> > =C2=A0 * * %-ENOMEM=C2=A0 - Insufficient memory available.
> > =C2=A0 */
> > @@ -359,6 +360,10 @@ static int nilfs_scan_dsync_log(struct
> > the_nilfs *nilfs, sector_t start_blocknr,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ino =3D le64_to_cpu(finfo->fi_ino);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nblocks =3D le32_to_cpu(finfo->fi_nblocks);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ndatablk =3D le32_to_cpu(finfo->fi_ndatablk);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ndatablk > nblocks) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -EI=
NVAL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nnodeblk =3D nblocks - ndatablk;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 while (ndatablk-- > 0) {
> > --
> > 2.43.0
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> Hi Viacheslav,
>=20
> Please apply this v1 patch instead of the v2 patch.
>=20
> This function is called as part of mount operations.=C2=A0 When format
> errors are detected during superblock reading or log scanning at
> mount
> time, returning -EINVAL rather than -EIO is in line with the mount
> system call behavior, so the v1 implementation is the correct one.

I missed that. Thanks for the explanation.

>=20
> Also, please replace the 'Cc: stable' tag with the following tag, as
> with the previous patch:
>=20
> Cc: stable+noautosel@kernel.org=C2=A0# Non-fatal bug fix; defer backport
> until a real issue is reported

Damn! I missed this request. I already pushed the commit. Are you OK
with that? :)

>=20
> I actually ran a test where a pseudo underflow of the nnodeblk
> variable occurred, but no issues that compromise system stability
> happened.
>=20
> Even if nnodeblk becomes a large value, long-duration block device
> scanning does not occur; it simply skips the position and abandons
> roll-forward recovery midway.=C2=A0 Since the mount normally succeeds, if
> anything, this silent failure is the issue.
>=20
> However, this is based on the assumption that the file system image
> was intentionally tampered with (anything goes) with root privileges,
> including log checksums.=C2=A0 Therefore, as long as it does not break th=
e
> system, I do not believe it meets the stable kernel rules for
> backporting.
>=20

Applied.

Thanks,
Slava.
