Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F494E4C40
	for <linux-nilfs@vger.kernel.org>; Thu, 17 Sep 2026 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673760; cv=none; b=MIvBuXTcs+Wab9xtJVn/UL5Cydd8qOGM5nHDnY/NjxbbfFmDaFdixqVpOQ4fDH4syypN2ASQ1Z0p2a0wWcn/Pvbfymk/hYH1YzbqkIjQiGNf4ZemTRJqOW9ee8uNWO1LTtU62YgYrIPTnEPW8gPE70qDvNm13NSSi4Q3x2SyQHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673760; c=relaxed/simple;
	bh=buFnI56HHAS/TkagVLY6Gn+e6OsIvLfRAuTzojxHwa4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W82ybII9qcpViExC54YiG1gQMlNXnl0irOVl+oRzI/Wu9ABerfKysIB393s9m3amSAKtKK5z+DHUAjkN7FzL7CVbvr4jHfnhYK0mAcHAEYm79gp4hCzljw0gBtyfD38IuBEQE5iN3HUUiCzNeRfyTO+ewdRdOlIvcY7dVPAdGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=cZp54U48; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="cZp54U48"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d440939e3so9314987b3.0
        for <linux-nilfs@vger.kernel.org>; Thu, 17 Sep 2026 12:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789673757; x=1790278557; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=buFnI56HHAS/TkagVLY6Gn+e6OsIvLfRAuTzojxHwa4=;
        b=cZp54U48kAakYAkal5Oxjzo1PZy2KVS/H93n0+pyGjnPP/zf2wldX/ZkBYXpSZt6AW
         6HMIdd0syvh9e9+34AfZNsKTY/e7Fn2A3MdKBhFTqii6iYGr4ERORcTlzyTP0SnjNEst
         mUqmm5qQ8Qh61APBwWgFOJoK7bbI+oEiwgQFA5lhD0XUcUxsDk+JXg9YPwnr+pyGyPEf
         wC+IYs4heN2nHF3iCUkK36VPjB+7TLl/cqMMjPcoW42Qvw4yAHwnYqqVBrsG1d40hSO/
         q8sZanx8FTbcx8zPeL7Uzie1JS2J+gHKvyCbmDcjAUfh8pELBNmfyx0jcd8vMiAsY8//
         vPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673757; x=1790278557;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=buFnI56HHAS/TkagVLY6Gn+e6OsIvLfRAuTzojxHwa4=;
        b=kmT1mNuIzqmk/kZ5QS1e1DWX5zcfQsyGA6x8v5Oz52XmdFry1tD9YhxAR3a5uqTX39
         v/osF9eb38HF0nh7f5SnEQ/FfgL+iGb7+80qjSR8t01hhEzTS2z8TSf7ZpvqqHo/YiRP
         V0T83R1iYpIV2N3RnumRRbbTDFbgj8DO9dlaJKbtFmfrcComaQKlSFsCAd1+0Jd3VBVQ
         SzJHrQFByiPRn9JE3EYbPlA1JGG1rgFZ2naa4xGJhWnNB4gnU/RUfkfw3fZ6JXESmlvI
         ezZQF1WabVogpxtSvrtm5zB6FGpfBukaDtnADr00bFFO4x3yzCoaWrKCbX2xbkvQGIej
         zpaw==
X-Forwarded-Encrypted: i=1; AKwUvBxon8VBHaZ4z7d/sEY7dIOztuJB9SIgIXNbjrtzsg3kVQe86FO7jCHSd/+g+b0ZcyPSdODAiNfeRidk/Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nlUiO9B9TSBxftpfiz/b6cjS1P8kqCratYs4rVtidxfg+Tacou
	oUuxETlUCDh8NzZJbA+FZd6TePeTsIz6Zz2DpJ2z3B4vPHxEMHzxLFlXmfH2XO9uVnU=
X-Gm-Gg: AYBFou0lmC3qQLw9Epi/xXI85qxv4wQ68s4zEbcHmFo08cAV/nVCHbCpvDWQ3ZFOYiz
	4yR4pabZCNG/ULNKNaoPH9WkkxWYayqRdS3W2aw4kNRuFqQ8Iaeq3xxK2HHcuhRjkKjVHWhce+8
	fYzfCCwc4twDL1bFYVMK88XlycgBfRUWuE3LZEIj+doran/6/kiRZx0gqAVavqxZZndr/fOFO+p
	sWAdSZygNYnqNPH6icm0Gzj3NPMTyaK4+0agJ8ybe8FoJP8yDf5abvk6aecwDi+AdT78QmS0+tM
	/vQVNlTxyZgMM/CDvDjeeEPSHTWXxvtqelFW+mXznZKLIQvUHfNJwviXgRysGvSJQe3S3icaDmu
	u/NvZTE6B5is76cf/msmw4ARg2Q0C8xE0VlxefetPkbvPBr/1jvh8tlPh+bub8jr8/K4pa8y9fu
	bsCMdUv7dr0Yh/HTj0ec/dgyA39ONgbUsKRxt2ru9DbEKhTENI6ZaiXVsl5knb63RhT9qYMssDl
	XtB7HcDZ2sl6g25svtQRktiAfghPnB1xBJV38DlVvnFcgSocUS90aYNS2N3908owhouV+0bobOL
	VPte5N9V59RNA5oeiePP4VXIGOUP7zBA5IcEbK4WAeaEwfcfwnwoUBGuOC2UIqPg
X-Received: by 2002:a05:690c:60c4:b0:870:107b:6359 with SMTP id 00721157ae682-897311cb726mr579697b3.15.1789673756865;
        Thu, 17 Sep 2026 12:35:56 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:b801:b375:5db3:9ec3? ([2600:1700:6476:1430:b801:b375:5db3:9ec3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-896c948db95sm2794047b3.13.2026.09.17.12.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:35:55 -0700 (PDT)
Message-ID: <ee4a4f8cb0cad602a520161f4c9cbb1beac81d58.camel@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: validate segment number in
 nilfs_sufile_get_suinfo()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 17 Sep 2026 12:35:53 -0700
In-Reply-To: <CAKFNMo=Lsaci5bY+G8A-C_FdD3Rhais4eANUdz8rHL7e-auHvw@mail.gmail.com>
References: <20260915195223.3331909-1-qwe.aldo@gmail.com>
	 <8eef80c6c8d21e863c5a3721b1ae681fc4ccf54f.camel@dubeyko.com>
	 <CAKFNMok804k_g2CHXfrn0LaOY38r8FtMnAk1kRc3YeZ=omCoag@mail.gmail.com>
	 <CAKFNMo=Lsaci5bY+G8A-C_FdD3Rhais4eANUdz8rHL7e-auHvw@mail.gmail.com>
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

On Fri, 2026-09-18 at 01:05 +0900, Ryusuke Konishi wrote:
> On Fri, Sep 18, 2026 at 12:46=E2=80=AFAM Ryusuke Konishi=C2=A0 wrote:
> >=20
> > On Thu, Sep 17, 2026 at 4:06=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >=20
> > > On Tue, 2026-09-15 at 16:52 -0300, Aldo Ariel Panzardo wrote:
> > > > nilfs_sufile_get_suinfo() subtracts the caller-provided segment
> > > > number
> > > > from the total number of segments without first checking its
> > > > range.
> > > > If
> > > > the requested number is greater than the total, the unsigned
> > > > subtraction
> > > > wraps and the function may process segment numbers outside the
> > > > filesystem.
> > > >=20
> > > > Cache the total while holding the metadata semaphore and return
> > > > no
> > > > entries
> > > > when the starting segment number is at or beyond the end.
> > > >=20
> > > > Fixes: 6c98cd4ecb0a ("nilfs2: segment usage file")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> > > > ---
> > > > =C2=A0fs/nilfs2/sufile.c | 10 +++++++---
> > > > =C2=A01 file changed, 7 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> > > > index eceedca026..573646c5f7 100644
> > > > --- a/fs/nilfs2/sufile.c
> > > > +++ b/fs/nilfs2/sufile.c
> > > > @@ -870,10 +870,14 @@ ssize_t nilfs_sufile_get_suinfo(struct
> > > > inode
> > > > *sufile, __u64 segnum, void *buf,
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_read(&NILFS_MDT(sufile)->mi_sem=
);
> > > >=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 nsegs =3D nilfs_sufile_get_nsegments(sufi=
le);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 if (segnum >=3D nsegs) {
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ret =3D 0;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > > +
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 segusages_per_block =3D
> > > > nilfs_sufile_segment_usages_per_block(sufile);
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 nsegs =3D min_t(unsigned long,
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_sufile_get_nsegments(sufil=
e) -
> > > > segnum,
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nsi);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 nsegs =3D min_t(unsigned long, nsegs - se=
gnum, nsi);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < nsegs; i +=3D n, s=
egnum +=3D n) {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 n =3D min_t(unsigned long,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se=
gusages_per_block -
> > >=20
> > > Looks good to me.
> > >=20
> > > Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> > >=20
> > > Thanks,
> > > Slava.
> >=20
> > Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >=20
> > Hi Viacheslav,
> >=20
> > Please take this directly.
> >=20
> > I also agree that this change makes sense, and my local test
> > results
> > are as expected.
> >=20
> > However, please drop the 'Cc: stable' tag since it does not cause
> > any
> > fatal issues at the moment.
> > If a real-world problem is found or reported, I think it would be
> > fine
> > to request a manual backport then.
> >=20
> > While acquiring information on out-of-range segments due to
> > wrap-around is indeed possible, sufile is also a metadata
> > management
> > file.
> > When accessing out-of-range areas, it simply hits as a hole block
> > and
> > returns empty data.
> >=20
> > Neither memory overrun in user space or kernel space, nor
> > out-of-bounds block device access or information leaks will occur.
> >=20
> > Well-behaved userland tools read segment information based on the
> > statistics obtained via nilfs_get_sustat(), so no problem will
> > occur
> > (the difference in behavior was visually indistinguishable).
> >=20
> > Therefore, I modified the nilfs-utils to perform ill-behaved calls
> > and
> > tested it.
> > Although out-of-range non-existent segments were displayed as empty
> > data, no critical issue that compromises kernel stability occurred.
> >=20
> > At present, it does not appear to meet the basic criteria for
> > stable
> > backporting, so when backporting, we need to be able to organize
> > and
> > demonstrate the reasoning why it is necessary.
> >=20
> > Thanks,
> > Ryusuke Konishi
>=20
> Hi Viacheslav,
>=20
> To follow up on my previous email regarding the stable tag: since the
> patch includes a Fixes tag, simply dropping 'Cc: stable' will not
> prevent automatic pickup by AUTOSEL.
>=20
> To strictly prevent automatic backporting while keeping it tracked,
> please replace the tag with the following instead of dropping it
> entirely:
>=20
> Cc: stable+noautosel@kernel.org=C2=A0# Non-fatal bug fix; defer backport
> until a real issue is reported
>=20

Applied with exchanged CC.

Thanks,
Slava.
