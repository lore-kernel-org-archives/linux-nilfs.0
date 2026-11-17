Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794939648;
	b=q9qec8CQGdXjrjSo/ErRLc5hFGGRrqezm1P2ldkKh4jjUFVC9M/y6hZf8pusxmmBrkAb
	 VCZz6TCnOU/oA3SGMhOTgfKhkm5Su5FKdYlkbX6SC1qzABtP9aWmoL5OfmxOglm6ii2mW
	 My0pLmDglo3R6HCxPZym2wsXOSabqpmXzq8tU6F6Dk6r2dOYkunEcKhWIpNQWfd8UPxvX
	 fzecMPmCxOAIL/4KWGYXhxzqQlkf71AXODHoy82bDBOVNHnc6+oaUHA2kUMBJg1tfSWQR
	 5v+WDCpQU8kYKK5dv4I6CfNZ91+VlALONEK1GxPZa6YlVYJkeYXhsOozry4Tg1QlU7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794939648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:Autocrypt:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=gEpnTVL6/f36zmbCQlhINdIlM5qtOZv7QnnpCH/wsH4=;
	b=FQYqL+tk7zFiZ8U/mhV/a/oWKXdN1hKLzccYZSFOTb3bwl0HvpAwkiu/l8DJ8it3CFpH
	 5N+kPcmxNq3KysKUlJPCvBZRIzRQuZ8pqx2cRngbWXxKLRBrLvEOcMcJ3w6emPW2peCzs
	 TNOF1cUjX3LQSLSh0WvEhqAB20d6ZbMvkrIY9+dlpwOMsSOBEDG/OVpQfT5gK1s/Ab8N7
	 dMBeU/uDQjq2aO0iBhr6MQGGth8/q7AqbpfiPR1964SJ+RIeBNnsvjL+szRGE4dPbIybj
	 HU43bdE5Y7LIAnBgiWx47CQyW2qN+IAT5jak2omhkmrUC6cj+MtUq8r4FNDBlK5ESGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SG71CXL4;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041DF606A31C
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Nov 2026 18:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 041DF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SG71CXL4
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b4e246acc2so138677b3.3
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Nov 2026 10:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794939647; x=1795544447; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gEpnTVL6/f36zmbCQlhINdIlM5qtOZv7QnnpCH/wsH4=;
        b=SG71CXL4MMSwo18OwqecZo7oLfa4OkacsopHwxwn/L+p1kHpbBCAfZ7+xrr+fsB09S
         OwnOQcNCziZAGA+lkUsFr8Ghnu7lCS+LgpzWO/NXdt5C81LFEeKQcDGJ01yBd/bRg+/1
         HBqRDx+zsU1z4FZj6ptg5ap/7q/8K8KjTXLUF7sL0VqFyPeBrYWFc9BCRStQUdma5zFi
         /19WPR4RNOAqOVTC9qeiqClrqIQC7PzBauuZDDKjaSqHrlvR6dmjqhSjBwSxJUUDqXAQ
         Sr42ycY8w8LNMW5f2FXnlCoCcNfw2SrQUqHeBBjoEP40Fxyt4nSFb1keje9fX2kU98mQ
         hRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794939647; x=1795544447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gEpnTVL6/f36zmbCQlhINdIlM5qtOZv7QnnpCH/wsH4=;
        b=WvsCeFZybHQAFtvyKvLwDSru1qDhyYu3uG2yNqMQMrR5SRqn2B5i3zN9toly+tBDsB
         llSZRwTHgA5V5WZW1ArPkGAGat909fMYYGAuPvX0TtYPKyrOW9ItYnZH4Ph76HSFB05S
         MQaz4R9qi8Va63hvwBIKx6EMDDWEjJbNT9MfQ7cNP1j2qg1hzj7tZTlqsI2JrGk4JoMr
         W6SrZi+BNDHTIhNoKPBx3lk4MRThD58okgvSc5pZb2yIkLDx+H7lOLibpgjgnwugX6eQ
         +62MiaT5wnlIrSE+jfVPClOWpjOdC4eBkxDMolEkZg7zrD4P8SYh/XJOZUpej3Emlf7o
         ZxkA==
X-Forwarded-Encrypted: i=1; AL+hErHghM22W1A/4G/5rLK++MnZvenj8PDsOD+QSlkRmpg9Pzcka+Ognuwn2MlwZbqnYzCcV+0lirBxk4Upug==@vger.kernel.org
X-Gm-Message-State: APuU4Z8c0baOig/B3GiffOies977WzzDvGUG0SW5AqO+6INZtKGDwsua
	BYwg7650Oxyvyn09YpbmAXvr+lUQ8a5CgbN/cFlCewy0GmECYAQa/pLcjSSeerlY9S8=
X-Gm-Gg: AZFdTZc8W5yCJcGZ+gcVZL4I2t7Fu/U1a3Y3UNSGpdoXs1T406f5/Kv9zr3WrDL0RE/
	IofNlvF4ItQKAxxV4qAm1Kv/BxqQEuBauGyOjaA7bGheXLc7WxxqrXqOZ0MY6K2il6kHPL3UIqR
	0yn+EVevHHln/zBXFzaoKKW9C6KrmTljWFtZ1XmEDHAR0VbrJiucfIOI2OUQYhFB/9jyElMjiWc
	EGc0cOylbm12YqO6d7OkNRqoI1Ju38VqJ/F7BffJ6gmuzzhzwp6PzxvjctTIT9JHQRm6OIuCBMr
	CDQgJexl+/frOLr0dWpjFkfuLq6QuRVVXR74TG6i7xO1SS74JiwLd0IZgOupdsTHRw1NWtTTX5r
	0lmbLv+Z6aWUgg32/RY4UX1tAU1rVwWg4bATVTjxc9pZHs1FyZxnr46i3iy/6T0mdik3VOeUWEm
	3222WIZtorSxFcTBvjj1kBTDV+n3e5+XM9kYT84H3Nqh3z9d8g7JkB3t/Rj/NeaD8q3mv2tkyQJ
	dRXQrXi6hZHwi9AWyizYQelfcuoTkYpKY91WLxDL/A6R2g082M1TKqDBT0iXB+DKJOp/GPsju3N
	6qxRBu9OD8YhDcRIBBNMkhZ03BmeH+/yD6IYtSmZY9SQwt0fN6Ld+HZokSwoDrlvELWCOFBj8wX
	yxgPBPaeJNWjVgT56joFpDSxdhDBVeoyo7IqK9TWyTlik1AVCE26f4XHeY7DiqFBtzB9Y+IGx9f
	SMeGgof71vAuNKK+Hdid4=
X-Received: by 2002:a05:690e:12cd:b0:671:26c4:3ac6 with SMTP id 956f58d0204a3-67dd454764bmr145475d50.37.1794939646693;
        Tue, 17 Nov 2026 10:20:46 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:d1c7:8722:e551:bec4? ([2600:1700:6476:1430:d1c7:8722:e551:bec4])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd402aa48sm272431d50.14.2026.11.17.10.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 10:20:45 -0800 (PST)
Message-ID: <0318886d45a4eb49aaaa2af5227a3d92f558712d.camel@dubeyko.com>
Subject: Re: [PATCH 0/2] nilfs2: atime support
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wang Jianjian <wangjianjian0@foxmail.com>, linux-nilfs
	 <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2026 10:20:44 -0800
In-Reply-To: <20261117065122.41553-1-konishi.ryusuke@gmail.com>
References: <20261117065122.41553-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
 NFdvziOa4FgUBC4X71upsZIoZJeii2V/Jtc3B4g==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-17 at 15:47 +0900, Ryusuke Konishi wrote:
> Hi Viacheslav,
>=20
> Please queue the following two patches for persistent atime support
> in
> nilfs2 for the next merge window.
>=20
> This series builds upon your original patch [1], which Wang Jianjian
> followed up on to address review comments and add compat_ro feature
> flag
> support [2][3].=C2=A0 I have made minor modifications to those patches,
> including filling in missing kernel-doc comments and adjusting the
> commit messages (such as fixing the Co-developed-by tags).
>=20
> To use this feature, install the updated nilfs-utils from the
> 'atime-support' branch of the development repository [4] (which will
> be
> merged into the master branch once this patchset is queued), and
> either
> format a new filesystem with the atime feature enabled:
>=20
> =C2=A0 $ sudo mkfs -t nilfs2 -O atime /dev/<device>
>=20
> or enable the feature flag on an existing filesystem image using
> nilfs-tune:
>=20
> =C2=A0 $ sudo nilfs-tune -O atime /dev/<device>
>=20
> Once the atime feature flag is set, the filesystem can only be
> mounted
> read-only on currently deployed kernels that lack support for it
> (until
> the flag is cleared with "nilfs-tune -O ^atime /dev/<device>").=C2=A0 To
> avoid confusing users, this feature will remain optional in
> mkfs.nilfs2
> for the time being, though I plan to enable it by default in a future
> release of nilfs-utils.
>=20
> Note that when enabling the feature on an existing filesystem, inodes
> written by older mkfs or kernels have their on-disk atime fields
> initialized to 0, which will expose the epoch date (1970-01-01).
> nilfs-tune warns about this when setting the flag, and image
> conversion
> (such as copying mtime to atime) is not supported.
>=20
> The series consists of two patches:
>=20
> - Patch 1/2 introduces the read-only compat feature flag
> =C2=A0 (NILFS_FEATURE_COMPAT_RO_ATIME) to manage on-disk format
> compatibility
> =C2=A0 for atime support.
> - Patch 2/2 reads atime from on-disk inodes when the compat_ro flag
> is
> =C2=A0 enabled and stops unconditionally setting SB_NOATIME on the
> superblock,
> =C2=A0 switching VFS behavior accordingly.
>=20
> [1]
> https://lore.kernel.org/all/20260219204343.70117-1-slava@dubeyko.com
> [2]
> https://lore.kernel.org/all/tencent_E3847A19056D4E914FACD269A3C77BAF0905@=
qq.com
> [3]
> https://lore.kernel.org/all/tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@=
qq.com
> [4] https://github.com/nilfs-dev/nilfs-utils.git
>=20
> Thanks,
> Ryusuke Konishi
>=20
>=20
> Viacheslav Dubeyko (1):
> =C2=A0 nilfs2: introduce atime support
>=20
> Wang Jianjian (1):
> =C2=A0 nilfs2: add atime compat_ro feature
>=20
> =C2=A0fs/nilfs2/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/nilfs2/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 +++++++++--
> =C2=A0fs/nilfs2/nilfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ----
> =C2=A0fs/nilfs2/segment.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 --
> =C2=A0fs/nilfs2/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++-----
> =C2=A0fs/nilfs2/the_nilfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ++++++
> =C2=A0include/uapi/linux/nilfs2_ondisk.h | 12 +++++++-----
> =C2=A07 files changed, 29 insertions(+), 19 deletions(-)

Applied.

Thanks,
Slava.
