Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BF145B3E
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Feb 2025 07:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738825699; cv=none; b=GGTsb2lZsUUlJGXPZDQJ6pF6ccJ52ckffCp6V/VXCq6fdgh2q5wF2LpKwYWx/qaKTV23SC8Y+jkN/nOAZjwDPsdjVmyJHvsa7jRp75yyon+OVL3IwaLCOuFB0SJP8HNQgGNI39/AWf2naPzmEPDg7tR9nPqQOd+uAbBYjWqwRwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738825699; c=relaxed/simple;
	bh=ImsANtgJWoTI0NfSEDIF85LOZA5mVbVk6IlYwN4PTmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUuyVB5pU76d0r1u9E+ix8kLNQV2V1EMhEk+n1ijAC2ck/5Rte7UVv8WCdh+IPWNv8Awl5Au1Kfqm/Hdd0KzkYgxVElMIzkpZBqajIOI2l076ndRY3mNby+oSIQmGNt1l3OYwt8Ep047Ih9EP1zGH6VTG+Z7yDoJjjFw8gflr6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzblVgCS; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzblVgCS"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-307325f2436so5226331fa.0
        for <linux-nilfs@vger.kernel.org>; Wed, 05 Feb 2025 23:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738825696; x=1739430496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8pUaQQqJ2xU0FAabHk0RqUjVVx9K0IZZsDB9D+D8IhM=;
        b=AzblVgCSuekxHmUgWnPC4gxzKGBXeqK5MDHx8o+fjMK+s6Q0cJJLAF2pbswHdjiaxp
         lajIPZPkCu0PPl9EF0SLrH1HET/o7gn9rFMFVmE8ZwX0y5K8+37J8pUWB7i076z9IU1A
         hR9P2mi91WQw4+re2axdGK8+T0nvZESWucq7NYCIiNZUrofbhNkJlmoEOLjSeq6/45rT
         AY78/vUpVE8W1Xv/0fM+ZyzxK4i6H8XfeedZ4CZL3TmWlEWDXKmqrOXEVbJ6iAYDmkqL
         SgJrilyTvbZPEIq/GpEWdNRAfmp3e0W8WoCEosEvUPZLWz0cmjKb/2eRbbiJzZV96hcA
         Awyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738825696; x=1739430496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pUaQQqJ2xU0FAabHk0RqUjVVx9K0IZZsDB9D+D8IhM=;
        b=dyhbyi+0jj5ZcoxiOD6jNo3Ihh1nvGdboWZi8OkFkr2UFqV0VNg3MUfWSTLYcPs85t
         wLS3s2A/XBHP6ZYWugTRPMhTIy4A9vv2fFp2kF0chTOVrhGVi+qYEZuZ2U71qZMuw4Fc
         du88K1WJZcbiPX9Zo5NBfdqafsk+ggTnBQ7GPcFCw51YimMF8FOBIeAOp9UijWFosoZx
         V40fVM0jSVjzt/qgf74JAuOsF/dn6xGFpN33AtnjBsksq02s12aL1KOwjROdis7Qb46r
         mwrH3gqN7HXBpFzuXpY+m1koF0d1d03NYm2N8enuyQltlUnSjSA9Gvpx7Uop0X9j5YCo
         OS3g==
X-Gm-Message-State: AOJu0Yy9t225XuV370FVQaJVHLpF/onp5m4+/Vx/6dKf6xY71ruesrBI
	b4/LqjmVSnGYCI8Q41hFGwkxpil3ZYoF5sIgYoH1h2froQjRxB0fbQlVXpTQMMaYPCP2qq8v2x4
	g9fwvZr1YKABfL5eggaH5xIXh+EwkS4Az
X-Gm-Gg: ASbGncsRFKYEduSiMO3wv7JEYYzUT7dIYarFB79YXhmc5YJKtBb2mdW0EWjAE6zkRnN
	TTutQoooTHQUQQLf0C7uQjZ0phkEOCu92lzFAWyziHaT/v4LGdSrQmF/SCFWrH1JsW0h2YNvfim
	sx+6RX5G+tAqk8HI37mux+CK1HctKQDg==
X-Google-Smtp-Source: AGHT+IEdn3CxNX7j4KgHUMga4mL0f7Mgfx79HLSCmUEc8Jd9i0tTyoPU3lLHR9s8Ari3yZf3u7SulE994Xk2n6KyETw=
X-Received: by 2002:ac2:4c45:0:b0:544:11e4:d53b with SMTP id
 2adb3069b0e04-54411e4d5c6mr95389e87.48.1738825695422; Wed, 05 Feb 2025
 23:08:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
 <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
 <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
 <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com>
 <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
 <CAKFNMomMZB9oBppxqfAebOQNHAS1+fQRTDPORVH4PYTVnapBig@mail.gmail.com> <CA+m_8J22Maw3+=13QvCKvy5fQpFQ+taCZDU3m2yXHAh1+B3QcA@mail.gmail.com>
In-Reply-To: <CA+m_8J22Maw3+=13QvCKvy5fQpFQ+taCZDU3m2yXHAh1+B3QcA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 6 Feb 2025 16:07:58 +0900
X-Gm-Features: AWEUYZlEARenK0gcPbTJhF2C5fTddBFwz4DS-zdjtN-INg02rY_aFJqu2-2nUEY
Message-ID: <CAKFNMon2MZkOY3FA_cH2pR=g1UxuFNnb2D__cUjeR=g+TDR5fQ@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Felix,

On Fri, Jan 31, 2025 at 5:14=E2=80=AFPM Felix E. Klee wrote:
>
> On Fri, Jan 17, 2025 at 2:25=E2=80=AFAM Ryusuke Konishi
> <konishi.ryusuke@gmail.com> wrote:
> > GC runs automatically in the background based on the watermark
> > conditions set in /etc/nilfs_cleanerd.conf, even if you don't run the
> > nilfs-clean command.
>
> When I run `nilfs-clean` with options such as `--protection-period=3D0`,
> will that change the settings of `cleanerd` until the next reboot? Or do
> the options only apply to a single GC run?

It only affects a single (one round) GC.  Once that's done, it goes
back to normal.

> > If you want to ignore this ratio and force GC, use the "-m" option,
> > like this:
> >
> > # nilfs-clean -S 20/0.1 -p 0 -m 5
>
> Thanks!
>
> Regarding `-S 20/0.1`, that means the cleaning happens 20 times for
> every 0.1 seconds? And each time `nsegments_per_clean` /
> `mc_nsegments_per_clean` are cleaned?

'-S 20/0.1' gives the GC pace, meaning that 20 segments are GC'd every
0.1 seconds.

The numerator of the speed is the parameter equivalent to
"nsegments_per_clean", which changes only during manual GC.

> > LFS is a legacy method and is not common
>
> =E2=80=9Cnot common=E2=80=9D I understand, but why legacy? What does supe=
rsede it?

Generally speaking, copy-on-write file systems such as ZFS and Btrfs are ne=
wer.
The concept of LFS (Log-structured File System) itself was proposed in
1988 and implemented in UNIX in 1992. It is an old method, and I
believe there are few surviving implementations today. In that sense,
I used the word "legacy".
In a broad sense, LFS is also a copy-on-write file system, but the
difference is that it divides the storage medium into segments and
performs space management (GC) on those units.

> High frequency snapshotting is something I am missing from other file
> systems.

That may be true, but frequent snapshots are in principle possible in
copy-on-write filesystems (apart from the actual support), while
retroactive snapshots (the ability to turn each checkpoint into a
mountable snapshot at a later time) are unique to NILFS.

Regards,
Ryusuke Konishi
