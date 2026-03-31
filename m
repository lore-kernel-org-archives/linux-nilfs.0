Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0B53E9F60
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774980519; cv=none; b=h/TratqKK8KdL3t46WT8xxZs8j40EUg+OUhH1YFGjDn426VJKxVieawDkD2doazl53AfcSS2gEJouQP6HRQjKZ2hYjdkd6Ud21DUR6i0Nuue5QuU8+DAV2DlnunJConwtPiMLOm8HgzqJ0bxWBVe7yAugjP06RA3MBq4CDJK9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774980519; c=relaxed/simple;
	bh=1kD0roxkx1+TVNYYI9k7IMM/P/inOyXLGaIk+M5AVqE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aB+iBHzjeU9mIX5N7cxDrvhypeFUsNousOvcwUQ/get/lGr/bae9ese0zpdrL2XPCsTUT0MgSEmc0XaAvu7LQIk0qAZaGZ5LAaM9WNJF1arX82qT8429Au7sh3g/YI428Y1dQ6YkBcn99vDVFoVLM4eU+Y/D3IL7YnS7ZH4Zdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/OFc4zw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMPcVcYX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/OFc4zw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMPcVcYX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774980516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gc8jHqZGP3DLxPp9zRxMRoVIMkUBfZYmJnOTc8sLpsA=;
	b=W/OFc4zwNCShaaUAf+mmPO5DYcXUOtiis45StR4KlUEwFD4Tzc++BolLVzhPIQGZrfrDRX
	nfjJXs4GYLPCspN8j60VnEJkQofeGapBANILshtkwXPunpcg99zCwFqWLVshWw4huXs5+d
	/3YIotmd7H0vC5ILT92MyXzp1pIElas=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-v7oiOjJpPo-UPh8BegSU-g-1; Tue, 31 Mar 2026 14:08:35 -0400
X-MC-Unique: v7oiOjJpPo-UPh8BegSU-g-1
X-Mimecast-MFC-AGG-ID: v7oiOjJpPo-UPh8BegSU-g_1774980515
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-649deef077eso5538202d50.1
        for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 11:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774980515; x=1775585315; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gc8jHqZGP3DLxPp9zRxMRoVIMkUBfZYmJnOTc8sLpsA=;
        b=aMPcVcYX5PX9jhDH5nHFOhqGMuHmh/dvWaLT/O4wey34R6p/8czi4rDfUDgjjZy22g
         iI/YKDIxLyAfFcHmHE4bAHKfxd+WJ2e1kNuUQto08dPlQA7RIy1Pjkn1Vws/wvfSxcc3
         XKMAEJtlzh6L2O3EQKzjntcmIRMT0EfmK4qYiFfc9BzmA+2B0hWl33636nsBANf+rPM8
         oiT5mJgT1EpAJtDJBjKajOzIevDOho184SQ8fRhH3AFiFl9llt0Q2esMz5w0nGU67P64
         Ulm1KkWIUNw74p4PULnoKRX7no6rnKPUO2/QmeZIgiKKWXSJF+Ms1FItJXOsU/+2+Rfm
         uspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774980515; x=1775585315;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gc8jHqZGP3DLxPp9zRxMRoVIMkUBfZYmJnOTc8sLpsA=;
        b=AcTJtFQIVMLlMVX1aOuXXGyBj3sTGVHLijxvBpr3HOLXZIStiH51km8S9wnSlWIQyz
         XW/x1YsiVNcsKaW0OBLY+P7Yt3ONSwVvlMdEOYGFefqWFy8u2BjtF3ug8V+z1SGk4Cd/
         alotyV7ovBpq49YqCpmX9i+ifv0o1GgHwX/+dMDNnkVEYR3CF/+zYOH7r6MYb2If6drj
         WZh2pohusChnrjdaFJwoKmYlX2mKWmOfOSiw23RE93CYqP/fKYYDI4odMaJTfZFRfIni
         PAdoInfdmYnV4OA/aOBTkoywPuDA4dJCdvt2ugo0Lwz3IlyP6rHVZf8BG4HkTV2+yC7J
         jo/Q==
X-Gm-Message-State: AOJu0Yxh02oQucnJa7IV+47xgq1DsGwKRVHKmuwP6tS+l8vmxXWswGxK
	25S9ahkcBoMa1MdbwEIt453NWMNmrrEwrDa1UWC5j3mMvw4OBA352hXxg0g8hpPfkKO4T80Qmxc
	a1wqboFF0QiWAJRAFvyJiex7F1Xfspig81D37K7D5XDCefuu7ixVaTRJKbDCY5a59
X-Gm-Gg: ATEYQzyhEID/u1YivIeIgSfSdXobSqoDyQpfbKfJKwAalxazOI7dVSTQQP3vQ+UlmRb
	Xyshb7OIayuaFhAQfra0gOXQYdpD54xblCKwVuobNtt/BygRZKl6qXG5U31aj5ZhPxtAMXqEkV5
	6BzxSU3cZamqcIVFPBmPvdgcD1CF6QCrGjwmq9WojCeusYlgWkC79D6ihIMBTSnRhrMwgKRkN9y
	CPcek0EPzx/zWNcX2LHveRHw8ExeFzt+Y4bv6hs3qp57E8UPDJ+Ff8QOLQmw/Wad0z28hAErSQc
	WXQyMTNKM5uDqx/goYE88xTjVppd1mSWOEWyR1QtvwQAqFHGkcJz127AV2O5TXgh8S+WGoIC+/M
	v52qmzk7Ol/q6TUeZDRn7Ah4ZZjmxSHYQuieli4e2tXZ9cXLBo3Zz
X-Received: by 2002:a05:690c:6a0e:b0:79a:20a5:6f60 with SMTP id 00721157ae682-7a20fcd658emr4782737b3.14.1774980514632;
        Tue, 31 Mar 2026 11:08:34 -0700 (PDT)
X-Received: by 2002:a05:690c:6a0e:b0:79a:20a5:6f60 with SMTP id 00721157ae682-7a20fcd658emr4782307b3.14.1774980514083;
        Tue, 31 Mar 2026 11:08:34 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-650093288a1sm5926796d50.11.2026.03.31.11.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:08:33 -0700 (PDT)
Message-ID: <0f939206680b19e02ac5a5f11fe0f6c70afd6c06.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: reject zero bd_oblocknr in
 nilfs_ioctl_mark_blocks_dirty()
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	 <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML	
 <linux-kernel@vger.kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>,
  Junjie Cao <junjie.cao@linux.dev>
Date: Tue, 31 Mar 2026 11:08:32 -0700
In-Reply-To: <20260331175253.32329-1-konishi.ryusuke@gmail.com>
References: <20260331175253.32329-1-konishi.ryusuke@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Wed, 2026-04-01 at 02:52 +0900, Ryusuke Konishi wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>=20
> nilfs_ioctl_mark_blocks_dirty() uses bd_oblocknr to detect dead blocks
> by comparing it with the current block number bd_blocknr. If they differ,
> the block is considered dead and skipped.
>=20
> However, bd_oblocknr should never be 0 since block 0 typically stores the
> primary superblock and is never a valid GC target block. A corrupted ioct=
l
> request with bd_oblocknr set to 0 causes the comparison to incorrectly
> match when the lookup returns -ENOENT and sets bd_blocknr to 0, bypassing
> the dead block check and calling nilfs_bmap_mark() on a non-existent
> block. This causes nilfs_btree_do_lookup() to return -ENOENT, triggering
> the WARN_ON(ret =3D=3D -ENOENT).
>=20
> Fix this by rejecting ioctl requests with bd_oblocknr set to 0 at the
> beginning of each iteration.
>=20
> [ryusuke: slightly modified the commit message and comments for accuracy]
>=20
> Fixes: 7942b919f732 ("nilfs2: ioctl operations")
> Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D98a040252119df0506f8
> Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D466a45fcfb0562f5b9a0
> Cc: Junjie Cao <junjie.cao@linux.dev>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please add this to the queue for the next cycle.  This fixes assertion
> failures that can occur with broken GC ioctl calls recently discovered
> by syzbot.
>=20
> Thanks,
> Ryusuke Konishi
>=20
>  fs/nilfs2/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index e17b8da66491..e0a606643e87 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -736,6 +736,12 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_=
nilfs *nilfs,
>  	int ret, i;
> =20
>  	for (i =3D 0; i < nmembs; i++) {
> +		/*
> +		 * bd_oblocknr must never be 0 as block 0
> +		 * is never a valid GC target block
> +		 */
> +		if (unlikely(!bdescs[i].bd_oblocknr))
> +			return -EINVAL;
>  		/* XXX: use macro or inline func to check liveness */
>  		ret =3D nilfs_bmap_lookup_at_level(bmap,
>  						 bdescs[i].bd_offset,

Applied on for-next branch of NILFS2 git tree.

Thanks,
Slava.

