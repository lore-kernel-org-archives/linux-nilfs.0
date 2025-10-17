Received: from server57.webgo24.de (server57.webgo24.de [185.30.32.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3AD32ABD6
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Oct 2025 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.30.32.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710321; cv=none; b=QQyfTsseH78TfJA2hRka1XeKDiAzXMINWzXGyCWQTcWMVIiMFcV8KGRIWJWSofgVXO5VPDs+VLjLJemgdEVkc92T1bPOauEyRYz6f+M209nMhYC/bZcVQ8RVzeGy/4JdoChX8q7GFvtLGR0ZYMvATVXMcEB2qZC4YiNKWwQOi7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710321; c=relaxed/simple;
	bh=2nNbNyLDPDl+N/9DpKEN1BAu29odLBsOiSvS2kMuoQ4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=InsTfWB/UkAni62J687NGkhBC83mVN7ViGvALCZbR32ruBb/nHyxRQiwC0A2nrFjfCZrHY73dS6CmG7LhQifIcA6NOXDbBu5o1sL1qv5vGzuf8Dgz1GsnG918dacV1GI10nH7iOUHYdDeSulOeeM0GyIPR+q545MYkIqYEhSW2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de; spf=pass smtp.mailfrom=gmerlin.de; arc=none smtp.client-ip=185.30.32.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmerlin.de
Received: from merari.gmerlin.de (unknown [195.52.48.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by server57.webgo24.de (Postfix) with ESMTPSA id DBA0356A4012
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Oct 2025 16:06:25 +0200 (CEST)
Received: from localhost (merari.gmerlin.de [local])
	by merari.gmerlin.de (OpenSMTPD) with ESMTPA id 270f3e7e
	for <linux-nilfs@vger.kernel.org>;
	Fri, 17 Oct 2025 14:06:25 +0000 (UTC)
Date: Fri, 17 Oct 2025 16:06:22 +0200
From: Christopher Zimmermann <christopher@gmerlin.de>
To: linux-nilfs@vger.kernel.org
Subject: nilfs_readdir: bad page in #
Message-ID: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E7OpTHJodMsynwlS"
Content-Disposition: inline


--E7OpTHJodMsynwlS
Content-Type: text/plain; protected-headers=v1; charset=utf-8;
	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Oct 2025 16:06:22 +0200
From: Christopher Zimmermann <christopher@gmerlin.de>
To: linux-nilfs@vger.kernel.org
Subject: nilfs_readdir: bad page in #

Hi,

this is what I saw today:

Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS version 2 loaded
Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord start=
ing. Construction interval =3D 5 seconds, CP frequency < 30 seconds
Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: start
Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: pause (clean check)
Oct 17 15:05:45 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_readdir: bad page in #235406
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:30 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:30 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:34 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:34 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:40 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:40 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:42 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:42 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
Oct 17 15:10:49 merari.gmerlin.de nilfs_cleanerd[715]: shutdown
Oct 17 15:10:52 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed unpro=
cessed dirty file(s) when detaching log writer

[reboot]

Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS version 2 loaded
Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting unche=
cked fs
Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery compl=
ete
Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord start=
ing. Construction interval =3D 5 seconds, CP frequency < 30 seconds
Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs wi=
th errors
Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: start
Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: pause (clean check)
Oct 17 15:51:11 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_readdir: bad page in #488967
Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:05 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:05 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:08 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:08 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:12 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:12 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:12 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:12 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:14 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:14 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:16 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:18 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
Oct 17 15:53:20 merari.gmerlin.de nilfs_cleanerd[704]: shutdown
Oct 17 15:53:20 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed unpro=
cessed dirty file(s) when detaching log writer

[reboot]

Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS version 2 loaded
Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting unche=
cked fs
Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery compl=
ete
Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord start=
ing. Construction interval =3D 5 seconds, CP frequency < 30 seconds
Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs wi=
th errors
Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: start
Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: pause (clean=20
check)

Both, inode 257 and inode 258 were ~/.xsession-errors.old

What to think of "mounting fs with errors"?
Especially since there is no fsck?


Christopher

--E7OpTHJodMsynwlS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTx1sLGWPXQ3Lw7C6mL4mz1Ey5T2QUCaPJNXgAKCRCL4mz1Ey5T
2eLCAPkBAd3UGQJNbfoKgc+PANFZgxNMmr3EWJEed2NZLzs/iQEA8RTZ45jjjvsZ
Un8C2wUsHkALvE28bu5YyiTmvSjPKAM=
=6ibe
-----END PGP SIGNATURE-----

--E7OpTHJodMsynwlS--
