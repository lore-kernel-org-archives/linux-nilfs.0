Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9463B777F
	for <linux-nilfs@vger.kernel.org>; Mon, 13 Jul 2026 22:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783982014; cv=none; b=rk3YMiDCv/6CSpUkXl0AkkPUJfUP+Didqwf6Ra5G++KrTY7Ypz/ZEPRzQLXxYxzVjlCIzLW81SmXlG1G2Ov8gQ8V369heRL9rUZsAfKxii487gGHANUeio2BNbq4t40N3fQ03oSuTtPHnkaVQozeZaFXUsSkTGR11Ybo2Q0oV30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783982014; c=relaxed/simple;
	bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p/1ZuFWrOLp3XDgktIfpJ6ajhg4WJ8WA/SxGvHD4Qz0W7K2ENrAPKPdpq3d5W9cQDsPzBTTVDWfWP+tBOvocPCX2dRGlo/uqAM5Gk3EChbmLpRMNJTRYjoViovDtV5CowCScdmvFEoz+6jl5WFs+9vm3JyMeAF3bt+qbcniRfgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=IAunUBnJ; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="IAunUBnJ"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6679d88abdcso514266d50.2
        for <linux-nilfs@vger.kernel.org>; Mon, 13 Jul 2026 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1783982012; x=1784586812; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
        b=IAunUBnJDxlah/Sv0Cf2p1sKnOrAm95WPlA74UitO2vjNNAZo5mjFM98pLXvmD01O8
         n5p6fOyuhAE5VJk2r6Dr2a05ppQxfqxvV9g9zwQL2u4+bPSNX2RgWfMcZn0oGyQdJmtX
         skjrHuWQHTphG00lWcGHl4+fbu1jWddKGUlLFkZOo/6DZhY3QPV0QkRiqAcXYZtGKtUf
         lZXH27817lCwtT34RQNMb210/076w0VpyqD4YlwpZBkJyw47X2peZcTV3wWtZmhqGjHU
         ww4cnK1UIbsnLMmZr/thAWu9yOjUCApjSv4nbigPhdF+byJYVa6VBL0va0Pwf/jxfxeJ
         GEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783982012; x=1784586812;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
        b=GEU/nn77Ck4JtQUkBYc45zJIYVCdOlN5rQ7AZifJLiCcC+nd6jmJs04LH1nzIhl3Uu
         OnedFurr0s2J+18mJC5Kl1b6GXfjbiR8r3i4u00wxhZVOVKd9f4qgTc3Ib5SWaVBencs
         99qlEVewOYekxNw2UZZGWZxP4YdkO6Gr37R7x81XNf/p4ciptW7huI8x4XzbC1l6DI9x
         iFLJWxjlAyFTOqnDvRVxv0vT9nqFs+dUWXu9hhyFrdF2aTiAM59GP2YhuzeLADqDsZkX
         0HvLd7LUPNG89UZqXWdJ7nK+jRH8xPiTu4rkPV73Q6HeF+wkLQTwBm2vQ+wV85WL0gek
         rhsA==
X-Forwarded-Encrypted: i=1; AHgh+RpveDp91psIT3aaQPvd4sF5byI//hbr8PTPLXo+/q/sqsy4SoKRFZvvFah9wuCaR3cBnFz1dTCWZjNWig==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ppyED6IcTT9WL12WdVwCJ6u15BZ1AJBaIAqcmqM/OSyDZtmf
	J0IpNtfgHaVZPA1/yNoND59bi9LG+fCxZ5nSBniP7++FQGyum0h0t8VVYsKoQ0Mp/O4=
X-Gm-Gg: AfdE7clc8yW4ZaItv2kx9JChrZymPr66+qMk7dYM9IKQk5JnKEZc9voZ718uFdH0Aoa
	Osxq8RugVppb0r6/xPhM+hprpED1Q1ijVE0a/oag39RvE9sYLlqdZZWG+JuPwt/al7l0tdcksWj
	ayzthcHlKSOyNpw9gOTNQc23iLWRPNBjDKgXRwEqgIySUZHpEo4Gd5uuTtSXP7a6aow4zQc94yX
	Emn5CyZKITX/uvLsA8AN7m+gYSv6ZDctQnt3t/99Gk+GzKaVsqPltwhz4O/rpO2XkTSDZrPG9vH
	FbKeBvPV6HS8mx6aZLgCMJPIzRaaVlrtK5Ik+NONlpWCoD+F+7jLvSQFdlC1gxMz4XcR+B9hEsJ
	KuVs6h1YJYnRHu2u596c9o2r23yScJgkEQVfRmo/x14sB7kooTbl/HRjFPD3RsJxHbW4lzb9Ut7
	Mb30cJJb04rv3sFnKqM4U242U6zmYcStk3bCrqCKZRKilS6u2t+Ipa4j7fbvUUnY93I8bFLaWeZ
	d1oVS8PZcHAA0wG0rKdSUscb5gJlvGBTcPUIWrxbpKX9A==
X-Received: by 2002:a05:690e:169b:b0:668:159:32d5 with SMTP id 956f58d0204a3-6680159343bmr1421801d50.87.1783982011683;
        Mon, 13 Jul 2026 15:33:31 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:e472:ff2d:20b0:742d])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-667877aaadesm14714239d50.7.2026.07.13.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 15:33:31 -0700 (PDT)
Message-ID: <af41e2dd178bbc4068317f1b9e09401cb49e7228.camel@dubeyko.com>
Subject: Re: removing the remaining blockdev_direct_IO users
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christoph Hellwig <hch@lst.de>
Cc: David Sterba <dsterba@suse.com>, OGAWA Hirofumi	
 <hirofumi@mail.parknet.co.jp>, John Paul Adrian Glaubitz	
 <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Dave
 Kleikamp	 <shaggy@kernel.org>, Jan Kara <jack@suse.com>, Mark Fasheh
 <mark@fasheh.com>,  Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Christian Brauner	 <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, 	jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, 	ocfs2-devel@lists.linux.dev
Date: Mon, 13 Jul 2026 15:33:29 -0700
In-Reply-To: <20260713095857.GB10501@lst.de>
References: <20260710050744.GA6720@lst.de>
	 <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com>
	 <20260713095857.GB10501@lst.de>
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

On Mon, 2026-07-13 at 11:58 +0200, Christoph Hellwig wrote:
> On Fri, Jul 10, 2026 at 09:51:09AM -0700, Viacheslav Dubeyko wrote:
> > On Fri, 2026-07-10 at 07:07 +0200, Christoph Hellwig wrote:
> > > Hi all,
> > >=20
> > > we have 7 users of blockdev_direct_IO and one of the lower-level
> > > __blockdev_direct_IO left, and I'd really like to get rid of
> > > them.
> > >=20
> > > The filesystems are affs, fat, hfs, hfsplus, jfs, nilfs2, udf and
> > > ocfs2,
> > > and you are the relevant maintainers.=C2=A0 In 7.2 exfat converted
> > > entirely
> > > to iomap, which would be a really good example for a "simple"
> > > file
> > > system.=C2=A0 Another options especially for the file systems
> > > supporting
> > > foreign formats would be to just drop direct I/O support and
> > > reduce
> > > the support burden.
> >=20
> > I like the idea. I think we can try to switch HFS/HFS+ and NILFS2
> > on
> > iomap approach. Do you have some initial patches for this? Which
> > particular commit(s) converted the exfat to iomap? It will be good
> > to
> > take a deeper look into this conversion to estimate the complexity
> > of
> > HFS/HFS+, NILFS2 modifications.
>=20
> Almost all commits in fs/exfat/ in 7.2-rc1, starting with
> 623f0aa1eca5c2a94ca1e4e5de719d062eac3b6c

OK. Thanks for sharing this. :) Let me take a look and spend some time
on this. I should have a time for checking commits during this week. I
hope so. :)

Thanks,
Slava.
