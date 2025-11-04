Received: from server57.webgo24.de (server57.webgo24.de [185.30.32.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FD2F693F
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.30.32.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265185; cv=none; b=EXOdLX34qjnL7YSnWw267QAfOXGxZd3BGxMRX8fl7TQ/ffd/prEu7NtmXmgd4SEAJmKeSyXfCemRRnM5O+NFhyMDewsoFkmy7SpQD7eyDvq/tzanBS15vS354arztiGO02uakzbcYKgKmEDIPJ63B88/Iuy56YBuxg3zUjMwqb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265185; c=relaxed/simple;
	bh=ztzinYm+Uj7/jA09Y/bQCp/3lfezC1tBlQBE3sQk3K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY24rXzffddwMPyk+gIjl+rM8ZHGMMP7Rj/31Sy/BJS4PTI1l1koyx6XsGdqYHpQPRv7//zUVc6OUSOwYGD8oytdnia7leYc08gI3XTSuP5hGT74OoLe6oQNhkFTZpnAYCQvQyVWBqoq/akUqMmpNx8PuEfFlFYjtTtCAsqxhF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de; spf=pass smtp.mailfrom=gmerlin.de; dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b=rEmKXQYP; arc=none smtp.client-ip=185.30.32.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b="rEmKXQYP"
Received: from merari.gmerlin.de (unknown [195.52.48.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by server57.webgo24.de (Postfix) with ESMTPSA id D4ACE56A15F3;
	Tue,  4 Nov 2025 15:00:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmerlin.de; s=dkim;
	t=1762264850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZpOtjAa6Ip+CA5BarTm0Cka9wTdqTDpIBkqIDDCJGIc=;
	b=rEmKXQYPbjy2CuaM/SdtnYVQMloz7AcuKThQ4HKDixbozcahMbN2WZKW2fwskGrFWklVfZ
	f12JrNpmhpHKCqSaDzvkp+WWA+1w1FoNYi2CwnVI7bWZNvwPnX62W/fBCw8UyOsWH9D+1q
	RqSIVi8Ue8nX/7nN89OgevcTr8V46YelgHBMfx0LaBlQQ9c8oM47KeIBZA4Da3I3MsRGUb
	YHpUcyGyqXNht64Onx7QKjqPQthDXBQ2xWaZPcs5dLWIsHUBe4a6FKmOkiPCxRQmDmhdbb
	lAyDFRKBQrnZU2yJsvYIVAtP8eXApfYi1/uXJrr3DtjEhexx5XXIHkNgVDmTCA==
Received: from localhost (merari.gmerlin.de [local])
	by merari.gmerlin.de (OpenSMTPD) with ESMTPA id fe89a480;
	Tue, 4 Nov 2025 14:00:49 +0000 (UTC)
Date: Tue, 4 Nov 2025 15:00:45 +0100
From: Christopher Zimmermann <christopher@gmerlin.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #
Message-ID: <aQoHEXBY9tusAkQ9@merari.gmerlin.de>
References: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
 <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="67msEfiM2bQdPACy"
Content-Disposition: inline
In-Reply-To: <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>


--67msEfiM2bQdPACy
Content-Type: text/plain; protected-headers=v1; charset=utf-8;
	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 4 Nov 2025 15:00:45 +0100
From: Christopher Zimmermann <christopher@gmerlin.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #

On Sat, Oct 18, 2025 at 08:04:28PM +0900, Ryusuke Konishi wrote:
>On Sat, Oct 18, 2025 at 7:01=E2=80=AFAM Christopher Zimmermann wrote:
>>
>> Hi,
>>
>> this is what I saw today:
>>
>> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS version 2 loaded
>> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord st=
arting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
>> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: start
>> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: pause (clean chec=
k)
>> Oct 17 15:05:45 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_readdir: bad page in #235406
>> Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
>...
>> Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
>> Oct 17 15:10:49 merari.gmerlin.de nilfs_cleanerd[715]: shutdown
>> Oct 17 15:10:52 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed un=
processed dirty file(s) when detaching log writer
>>
>> [reboot]
>>
>> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS version 2 loaded
>> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting un=
checked fs
>> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery co=
mplete
>> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord st=
arting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
>> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs=
 with errors
>> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: start
>> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: pause (clean chec=
k)
>> Oct 17 15:51:11 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_readdir: bad page in #488967
>> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
>...
>> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
>> Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5)=
: nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
>> Oct 17 15:53:20 merari.gmerlin.de nilfs_cleanerd[704]: shutdown
>> Oct 17 15:53:20 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed un=
processed dirty file(s) when detaching log writer
>>
>> [reboot]
>>
>> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS version 2 loaded
>> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting un=
checked fs
>> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery co=
mplete
>> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord st=
arting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
>> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs=
 with errors
>> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: start
>> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: pause (clean
>> check)
>>
>> Both, inode 257 and inode 258 were ~/.xsession-errors.old
>>
>> What to think of "mounting fs with errors"?
>> Especially since there is no fsck?
>
>For reference, I would like to ask under what circumstances did this=20
>occur?

It occured running debian trixie kernel 6.12.48+deb13-amd64

/home was on a nilfs2 filesystem:
/dev/nvme0n1p5 on /home type nilfs2 (rw,noatime,nodiratime,discard)

>If this happens easily, I am concerned that there may be a new regression.

Now I had some weeks without the issue re-occuring. Now it happened=20
again (after formatting the fs and restoring from backup a few weeks=20
ago) :-(

Nov 04 14:31:01 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_readdir: bad page in #170719
Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): n=
ilfs_bmap_lookup_contig: broken bmap (inode number=3D259)

want to take a wild guess which file had inode 259 at the time of the=20
error? - ~/.xsession-error again.

>The error message suggests a corrupted btree, which is causing the
>directory read to fail.
>
>I'm also concerned about the problem with .xsession-errors, a file
>that seems to have a short lifespan and involves rename.
>
>For reference, what version of your kernel are you using?

6.12.48+deb13-amd64

--67msEfiM2bQdPACy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTx1sLGWPXQ3Lw7C6mL4mz1Ey5T2QUCaQoHDgAKCRCL4mz1Ey5T
2eV1AP4wso+D5swdmroBA244A1aHYE/m2GjrncEFVRKlA+cEQQD/blhXG3/A2f6+
bEwKVlJdgLjwTbmHp0FSrdM3Lj4klA0=
=l0Da
-----END PGP SIGNATURE-----

--67msEfiM2bQdPACy--
