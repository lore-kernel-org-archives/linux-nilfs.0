Received: from server57.webgo24.de (server57.webgo24.de [185.30.32.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ACE2853F7
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.30.32.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762272267; cv=none; b=JEYiAf9FW+Dpu8ilDidB4+9iuULvwdpazisNKvAnqZazuXW550gkVKcofldPzdTGA6UXX4zRVhRG4mP/BE3Ky3nNQ8fBEmfuHBfQ8fyM3B5TYEBbz1NDebMcLwNYGntfkqIIkqqRcRW6QBLtGCzTOyIumG2tymolVreF9Ymvub4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762272267; c=relaxed/simple;
	bh=eDxeXm4eBrid2LsESyk9vHzSceiRI+AdKHGynqoCzTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbZECcFZV/eAUGBuz1lF3nXlp2vuHZtY3kxYo/GIcWJrdydu6d0POaV1cxvrzbNavXzsRTq/q9hzKSVqG7fSFsCZWRkTrL4wmWJ8sCcvykrvVkGTqneNJY2kdWcHihwKp7n7jIYRtC8jljeU0Nc7HHcq4ZIib03BVuca8od0o0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de; spf=pass smtp.mailfrom=gmerlin.de; dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b=qO7iokbe; arc=none smtp.client-ip=185.30.32.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b="qO7iokbe"
Received: from merari.gmerlin.de (unknown [195.52.48.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by server57.webgo24.de (Postfix) with ESMTPSA id 7C66A56A068C;
	Tue,  4 Nov 2025 17:04:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmerlin.de; s=dkim;
	t=1762272262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nUeQlnoFMesX0EUWMvPx6iE8+gp2azoy/ugOLn5rrHc=;
	b=qO7iokbewfIzGAiqn1X7eVsPI73w6ovz3TtGyNOyS3gZZBhZ7nDKR+d4bwYn/IQsNkp7zQ
	p9/5ElQe1w5diYvgh7QdmRYHif50vcRSqKMR948HjoFIlMf8r4f7QZYbWKEt6tnwowHv53
	bhPieT5PsWrZzk7B28uBbrNS/5/6KOJa4w3lrk7eE4zg7H/XOyC69KfOMwIcQVYzcBnbSw
	61Erx+d1ss7UhiwMecu4YRrtgRIulJDJz043t0I6NGElD3tY06SvIL+T5Xn+ztR1cbhmIe
	tWKEAEw9/hVprDpGzULXdEoWsXBqtBq8U6Tn+KSDTfWHlocQQCvI2SEQuCPovg==
Received: from localhost (merari.gmerlin.de [local])
	by merari.gmerlin.de (OpenSMTPD) with ESMTPA id 2294e363;
	Tue, 4 Nov 2025 16:04:21 +0000 (UTC)
Date: Tue, 4 Nov 2025 17:04:18 +0100
From: Christopher Zimmermann <christopher@gmerlin.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #
Message-ID: <aQokBe0xUtcitVnj@merari.gmerlin.de>
References: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
 <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
 <aQoHEXBY9tusAkQ9@merari.gmerlin.de>
 <CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PL1csfp8h61ckpWt"
Content-Disposition: inline
In-Reply-To: <CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>


--PL1csfp8h61ckpWt
Content-Type: text/plain; protected-headers=v1; charset=utf-8;
	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 4 Nov 2025 17:04:18 +0100
From: Christopher Zimmermann <christopher@gmerlin.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #

On Wed, Nov 05, 2025 at 12:28:54AM +0900, Ryusuke Konishi wrote:
>Based on what's happening with the .xsession-errors file, I guess that
>the problem is indeed occurring with files that are renamed or have a
>short lifespan.
>
>I'll try to create an environment that reproduces these conditions.

Not sure if this helps. Here are some more observations:

The nilfs_readdir: bad page in #170719 error was triggered by a
find ~/ -iname =E2=80=A6

The following
nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
errors were then triggered by running a backup (restic) or simply=20
reading ~/.xsession-errors. Some content of the broken=20
~/.xsession-errors could then still be read.

What I noticed now while killing processes preventing the unmounting of=20
the errored filesystem is that it is passed to many x-clients as=20
stdout/stderr fd:

COMMAND    PID     USER FD   TYPE DEVICE SIZE/OFF NODE NAME
herbstluf 1506 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
herbstluf 1506 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
dunst     1642 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
dunst     1642 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
conky     1643 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
conky     1643 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
nm-applet 1644 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
nm-applet 1644 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
blueman-a 1645 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
blueman-a 1645 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
firefox-e 1655 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
firefox-e 1655 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
crashhelp 1727 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
crashhelp 1727 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
blueman-t 1821 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
blueman-t 1821 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
polybar   2069 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
polybar   2069 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Socket    2087 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Socket    2087 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Privilege 2122 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Privilege 2122 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
RDD\x20Pr 2129 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
RDD\x20Pr 2129 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Isolated  2167 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Isolated  2167 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
WebExtens 2230 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
WebExtens 2230 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Utility   2317 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Utility   2317 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2449 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2449 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2525 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2525 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2559 madroach 1w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors
Web\x20Co 2559 madroach 2w   REG  259,5     3637   11 /home/madroach/.xsess=
ion-errors

Most content comes from herbstluftwm logging unbound keypresses, but=20
that's not a huge amount of logs. A typical .xsession-errors on that=20
machine has less than or a few hundred lines of content.

Logging the inode numbers reveals back-and-forth renameing of=20
=2Exsession-errors and .xsession-errors.old:


     11 -rw------- 1 madroach users 5,0K  4. Nov 16:50 .xsession-errors
126604 -rw------- 1 madroach users  11K  4. Nov 15:03 .xsession-errors.old

120042 -rw------- 1 madroach users 3,2K  4. Nov 16:51 .xsession-errors
     11 -rw------- 1 madroach users 5,5K  4. Nov 16:51 .xsession-errors.old

     11 -rw------- 1 madroach users 3,2K  4. Nov 16:54 .xsession-errors
120042 -rw------- 1 madroach users 4,4K  4. Nov 16:52 .xsession-errors.old

118708 -rw------- 1 madroach users 3,0K  4. Nov 16:55 .xsession-errors
     11 -rw------- 1 madroach users 4,2K  4. Nov 16:55 .xsession-errors.old


Thanks for you efforts,

Christopher

--PL1csfp8h61ckpWt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTx1sLGWPXQ3Lw7C6mL4mz1Ey5T2QUCaQokAgAKCRCL4mz1Ey5T
2bKeAP9MfQov2CPzrpHcpKIDIcg4EZS+9TSd85a0z6Y8RSiMwwEA8E2E+1bqAMmg
HVIyu6LQO+PvLyl5YNLNIh1GR5YoHAE=
=dXDe
-----END PGP SIGNATURE-----

--PL1csfp8h61ckpWt--
