Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8874F352F86
	for <linux-nilfs@vger.kernel.org>; Thu, 24 Sep 2026 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790274048; cv=none; b=KY2dXsO59XNZ58Aah5u3qdl2ViFtnMwQhbO1LJ6l+bMvAbW/5oasEuC/9zdrVnmKtRTDNQvsvCxLUBcncGaSVNc3C4gZtgvSdax5+prCYzDOrysztsCMr3ocRQJnhwIy04wRIrfdbrtzchCK7a+4AZ9hGnm0bw1/DVsMZyo3rKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790274048; c=relaxed/simple;
	bh=N1eKbuuNutpyxPSc7VRBvykLDhMhLYtgUA0eiR+gO2o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OeZMdP9FBAICRhUrPiTecAgbCBpmC3voKUh+XUjJXY4MUC916d4UmW/F8BgiY8EgqcoBiYOSH5ah7Xa6Q4UiYL2NXwQNu8gjuHOqyVbrkhB1MIJBWwgzuHZz+tyGGrNdp8sGCcmUQiwM6P4333MIifdhDs4QACdI9C6a9K/5zbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=AxXWLWGr; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="AxXWLWGr"
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-6740dd8b4b0so51533d50.2
        for <linux-nilfs@vger.kernel.org>; Thu, 24 Sep 2026 11:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1790274045; x=1790878845; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4ddGw+SxvwjLwG9r/atoe7LBsu7awTG97BNAfuxMXGI=;
        b=AxXWLWGrC+4vt8T/1hf5GOzrtYbSMoFtgCrwjxFcR9mGW8xwrNLCN8UKuAwPcBEB9c
         6i7mtFYN80ASdiZKRTZ590UU/0MHbZrnHup0Yreq9Qq5M3iB5OWtC8HJugEZaZnTlfCX
         EV7vnlny7XuvA8XKnlE5Eqo7C/qpJOIm/z1enGDHf5+3gea4cJhLl6Xeed1CRv69x32z
         +wMXRVUBMuRxDb8k7kjQsn2aZm6m8rE1b2/hsBGW8CjRuH01ff0KCu5JGpkvGBpMaNw8
         zS0xgUj0c5vtuGvpbodJXRy2TLh39nIen6v1u9tUoFGnUNWsHKvgy7zKOA6FCRiK/ScJ
         IEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790274045; x=1790878845;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4ddGw+SxvwjLwG9r/atoe7LBsu7awTG97BNAfuxMXGI=;
        b=TUaL8PrkR2Oe8aCp2dMXfplfsmdu4li2vVsnar/qaY5i7p4bZlM8t+VBDMyE6jDSRE
         PjOg11TTj6sHRSAxGh30xULx4wnVJV/FApuE1u7rcdTaZHkeOaBgMWGCi39KPL5hoDqu
         6ixO2DFeTtsUxcWm0LvWewgPdV75+MsDvAjNpaJi71VHkhKLjFaXapzl2Z+fo1Z31Kg2
         peAyoyjIrx9wk8qprwHUT50geE/Vl0Dfdt4TEmV9qiyXUVbE25w0CpF5qw9aAW/kOVLC
         6vkqUsd3jUL+dowxT1RMrhwpc04R0VD1U4zm7YiT3u0/loI5nik+vdvM8OHg0TbDh9Y0
         srXw==
X-Gm-Message-State: AFuF++kFSUIWg/GcUw5E5sGzKbptQOGeNqh5QmLAdMWt+fkbvuise2co
	EIf5fT+OP/P2jY+Z6mYplHiX/APKJ72QRTwjfNgfIeBRnv7n5dyN4zIaKc/Uo5vzVNA=
X-Gm-Gg: AYBFou3n66Rv0bWBiSK7BSzgwUjDQ5eeQlZFNEJss2DgRn51ifEHqoAwrZa/5Ld4Yz7
	D4OcUx2Te7mQY2giQngaM7YiBW6/F6Vzq7TfuTCeC/pv2ZegUseqjkeQJsIWd/Pq9ia1gckDQTY
	AvzH67PRrLPc1O7eMlwjKSE4qAXf9mCXAe1Y5fnWKmbaGJgDCU9a1An5gmDry/f36RC72MVlzxz
	pvEotB93sFekY8rIRwiY5jwDt9I1Youx98XnISaER6XkFLQPgDqKFfW5Um/2yNhPAB6qimwsNrs
	fp35Zb8M4Jb7VMzr9xOC9pTE063mH69sNr/KOBvF2Jc0cybRpONT3kiKvumrlf2/KJj9QlWxniL
	8m8Lnn9NTDhWA0DNvP7mNY+MVZxhr6jvcS8fzZBGzHHuUGsG84qdTfXAZC71UjXxx396LG38n+N
	h2PLZydAXDIAzhj8Np5DgQNeB2uUzkC/8HJeVTXOzJuxl1NcYOT90M1eETSNGFegI2gr/ojc5Ih
	BYWYfkZTFuOIdFMoK9F6QVokJ2+QvH0HWK6zi8Sj6tc1sFsHg4S5WewrCFZWsAovXObUXffV+g2
	kE0qsgmwJDFg6wDEjVjSKQin14k6CF5wreLhUW+ahyAIfR0/mf2CKRFH7Dt78rk9
X-Received: by 2002:a05:690e:dc2:b0:672:f1e7:d232 with SMTP id 956f58d0204a3-672f1e807a4mr1788819d50.26.1790274045311;
        Thu, 24 Sep 2026 11:20:45 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:4935:3bd4:e0b7:fd95? ([2600:1700:6476:1430:4935:3bd4:e0b7:fd95])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672d9089322sm2428882d50.21.2026.09.24.11.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 11:20:44 -0700 (PDT)
Message-ID: <a5d4902ff3ad297e2e30c4a0b41ae99d8b40a07d.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix deadlock between nilfs_evict_inode() and
 find_inode()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Thu, 24 Sep 2026 11:20:41 -0700
In-Reply-To: <20260923164345.18456-1-konishi.ryusuke@gmail.com>
References: <20260923164345.18456-1-konishi.ryusuke@gmail.com>
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

On Thu, 2026-09-24 at 01:41 +0900, Ryusuke Konishi wrote:
> Syzbot reported a deadlock between nilfs_evict_inode(), executed via
> an asynchronous workqueue (kworker) as:
>=20
> =C2=A0 process_one_work()
> =C2=A0=C2=A0=C2=A0 process_scheduled_works()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_iput_work_func()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_dispose_list()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput_f=
inal()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 evict()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 s_op->evict_inode()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_evict_inode()
>=20
> and find_inode(), called via
>=20
> =C2=A0 nilfs_mkdir()
> =C2=A0=C2=A0=C2=A0 nilfs_new_inode()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_insert_inode_locked()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 insert_inode_locked4()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_insert5()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 find_i=
node()
>=20
> When an inode is deleted (i_nlink =3D=3D 0), nilfs_evict_inode() clears
> its
> ifile bitmap entry and then synchronously triggers the log writer via
> nilfs_transaction_commit() if IS_SYNC(inode) is true.
>=20
> If a concurrent directory creation via nilfs_new_inode() attempts to
> allocate the same newly freed inode number, however, find_inode()
> called
> just before inserting it into the inode hash, blocks waiting for the
> old
> inode's evict() to complete.
>=20
> Meanwhile, the synchronous log writer invoked from
> nilfs_evict_inode()
> tries to acquire a write lock on 'ns_segctor_sem' which is read
> locked
> by the caller of nilfs_new_inode() (in this case, nilfs_mkdir()),
> resulting in a deadlock.
>=20
> The synchronous log writer invocation from nilfs_evict_inode() is a
> legacy artifact; it is no longer necessary because the call itself
> (triggered by iput()) is now handled asynchronously with a kworker
> if i_nlink =3D=3D 0.=C2=A0 It merely increases the risk of deadlock.
>=20
> Fix this deadlock by removing the synchronous log writer trigger from
> nilfs_evict_inode().
>=20
> Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6646318bbcf419411bc5
> Fixes: 7ef3ff2fea8b ("nilfs2: fix deadlock of segment constructor
> over I_SYNC flag")
> Tested-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this bug fix.
>=20
> This fixes a deadlock issue that had been reported by syzbot but
> remained unresolved for over a year.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/inode.c | 6 ------
> =C2=A01 file changed, 6 deletions(-)
>=20
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 64437aed8390..33490e8063eb 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -895,13 +895,7 @@ void nilfs_evict_inode(struct inode *inode)
> =C2=A0
> =C2=A0	nilfs_clear_inode(inode);
> =C2=A0
> -	if (IS_SYNC(inode))
> -		nilfs_set_transaction_flag(NILFS_TI_SYNC);
> =C2=A0	nilfs_transaction_commit(sb);
> -	/*
> -	 * May construct a logical segment and may fail in sync
> mode.
> -	 * But delete_inode has no return value.
> -	 */
> =C2=A0}
> =C2=A0
> =C2=A0int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,

Applied.

Thanks,
Slava.
