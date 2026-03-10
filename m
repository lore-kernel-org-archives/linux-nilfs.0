Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB103348457
	for <linux-nilfs@vger.kernel.org>; Tue, 10 Mar 2026 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773161673; cv=none; b=M6qL2+N9W0Ru8BAek8joiuymYLs6NKvDaJF0J66mTu/WCuikwwgmb08y5bINb9toY+7qdRP0tQD5oaOINlNBhM6UTUuRTMuztw+QZrYkuQ7+1UsUucAWaEbKhMNmkepj26tgQXgE2A35DPrezoqDZCafvTTcDdL/7dNdQU/RvNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773161673; c=relaxed/simple;
	bh=bBAFu2yyXdiAsw4cmI2FgxwowRwabRXcNMDJDRQqsGE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V2Dzy+LrkFN1bzTqNAU//X9GCQAmOkTjDAKJUbLiw34iBDPc+Hdof+b/hZb/0hroOVnqK0wm9sV+53Q7J9wnq0mmEnVs5hbBoH/3J08jnyxSdKfMpc4yHtPq3jhLZhvramUnh0qhE0PXuLZMc6jvYso2WcmYXnZQ9m97iqJp1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=p53jRwu/; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="p53jRwu/"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d73be007a1so3141688a34.0
        for <linux-nilfs@vger.kernel.org>; Tue, 10 Mar 2026 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1773161670; x=1773766470; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+koyysHEgwYLGjTMWchPnqVqiDSFwULCAON7pQbpaUo=;
        b=p53jRwu/2CvEv86F797S2VjC3TrR4NwvcN+JIoso/yqEcGtDKA4G98Kgqa4DX3rK1J
         PSNPxc4w8VRrNQliGBTA2N+LQtKWpcUaTKGbRPzOOn2IiIVtdZPB8YshB5fZSlEdXt+T
         ALKHgcdI3UyBdrlcathOwFCC8mExAYzq2X89tyMLepfHVGkLWSIK7a5SM9372RnKYJWd
         086gu/4c/80HWPIG+qBY3qaSsvFz59VLMGsukC12YTs/LLrar01LjlyGNiCvs818xDHF
         SEcsHCDTnxNEjSuR8wnwjjRimjmALLgFfUn4m48BOiXFF9AATMKbr4oa6JA9Tl4c81ei
         srXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773161670; x=1773766470;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+koyysHEgwYLGjTMWchPnqVqiDSFwULCAON7pQbpaUo=;
        b=kZ9ApvAg41SuE/Tu5pQQ6GMFpT1wCOesuQ1r3ZBcXVUhJJuDdfyiiFUJN34aA9RWXg
         43c1BunRkvKEeG6sIzfAWl4TSde7mVo265BVyWNjqstlDnVYCWX99TQPi/mIuwIKdSPa
         e3MtN+QHGU5mpxsgs6lDgVn8oNXHB07MGEQ92JxZqsfsyblVU8vtTnBzyilGKm5FFOde
         VakbouxHwQ9HAdIEo+kpBXQ802XpglzX61L8/xUgBBFabWDL1LfAvY3xOSYjRLj8obxM
         Z5xctsfL4mHpHim7yGKw4iz2O6H7Faj1tKn0YKnWVfrElpWi27wQlon+F2MJXXFINfsP
         B1LA==
X-Gm-Message-State: AOJu0YwLyp05AcCOyxheKJGu89REFapcQZRBuezkltlg3b+prrsIjyFq
	2LVCkYZoRmH+jnZ8jKcdD2CGjQs1QNm+tecKS/foCyVCZqIzmFjfhi/Jy2S9pQWMNAWTOg5+KJA
	GbzgXcl8=
X-Gm-Gg: ATEYQzzdzZH15+MQvhCkqMoRm7nF8e9bX+lFMJvWEAiNsgVzmvbft7yRnXWPQM4arJb
	uJsQWz6Q7YbLDSKV7vdn5WjdeRZORHXQ42OfJOM5m6x/XkSxCl23qlrXgPdVG0SablDRZsYNEBi
	rVjsxDgGpXLA94eG7/XxuaqGdFIrqTYW7wtlIHeI8XP0Ng3HRD54ZYaPCO2YRau7cOa7phEy2/A
	h4z4A1DukRcyv9gma+Eye0MevXSeAbcoakuOit+Ltp65mSqFYsho/D7+3zETwr1Seus4mfvRHHL
	2dezSY4KNzlZ3704g/YygZjaXg7BXu0jNIURoQhp+m6fd4aU5PC5WeuhQJRF2+L/6YK3V6G6oxO
	vqe/uvHJ2r1mQLC88RXdKlC9zTfnBKfn+6B3FtacpVscUwMXg8rXm6xMKz2Hqx50aslkVSTt1d4
	424DTO+0HIF8TNEkwj1lZufrghXMd4mY2No6KwrE3NL/5uboKZX2CBtfcnL9gmn5DuJbxjoODi+
	pYQnqnQ2gH7m0iIhYuGJX9xAbbjfczAxkozCm5gk7TK2Sv8RHImGdzr9Q==
X-Received: by 2002:a05:6830:6887:b0:7c7:6043:dd8f with SMTP id 46e09a7af769-7d726f631bdmr10091186a34.15.1773161669861;
        Tue, 10 Mar 2026 09:54:29 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:a85:69a0:8fa8:d652? ([2600:1700:6476:1430:a85:69a0:8fa8:d652])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d745cac199sm5377746a34.9.2026.03.10.09.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 09:54:29 -0700 (PDT)
Message-ID: <b0225cff966425a16213e2dae7cd30ba438e5af7.camel@dubeyko.com>
Subject: Re: [PATCH 1/2] nilfs2: fix 64-bit division operations in
 nilfs_bmap_find_target_in_group()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner
 <brauner@kernel.org>,  Ryusuke Konishi <konishi.ryusuke@gmail.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Roberto Sassu	 <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,  Eric Snowberg
 <eric.snowberg@oracle.com>, Paul Moore <paul@paul-moore.com>, James Morris
 <jmorris@namei.org>,  "Serge E. Hallyn"	 <serge@hallyn.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 kernel test robot
	 <lkp@intel.com>
Date: Tue, 10 Mar 2026 09:54:26 -0700
In-Reply-To: <20260310-iino-u64-v1-1-18422a053b04@kernel.org>
References: <20260310-iino-u64-v1-0-18422a053b04@kernel.org>
	 <20260310-iino-u64-v1-1-18422a053b04@kernel.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-03-10 at 07:43 -0400, Jeff Layton wrote:
> With the change to make inode->i_ino a u64, the build started failing
> on
> 32-bit ARM with:
>=20
> =C2=A0=C2=A0=C2=A0 ERROR: modpost: "__aeabi_uldivmod" [fs/nilfs2/nilfs2.k=
o]
> undefined!
>=20
> Fix this by using the 64-bit division interfaces in
> nilfs_bmap_find_target_in_group().
>=20
> Fixes: 998a59d371c2 ("treewide: fix missed i_ino format specifier
> conversions")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes:
> https://lore.kernel.org/oe-kbuild-all/202603100602.KPxiClIO-lkp@intel.com=
/
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> =C2=A0fs/nilfs2/bmap.c | 9 ++++++---
> =C2=A01 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index
> 824f2bd91c167965ec3a660202b6e6c5f1fe007e..4ce9a93149a5af13bc215cc1877
> a757e2c6cf49b 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -455,11 +455,14 @@ __u64 nilfs_bmap_find_target_in_group(const
> struct nilfs_bmap *bmap)
> =C2=A0{
> =C2=A0	struct inode *dat =3D nilfs_bmap_get_dat(bmap);
> =C2=A0	unsigned long entries_per_group =3D
> nilfs_palloc_entries_per_group(dat);
> -	unsigned long group =3D bmap->b_inode->i_ino /
> entries_per_group;
> +	unsigned long group;
> +	u32 rem;
> +
> +	group =3D div_u64(bmap->b_inode->i_ino, entries_per_group);
> +	div_u64_rem(bmap->b_inode->i_ino, NILFS_BMAP_GROUP_DIV,
> &rem);
> =C2=A0
> =C2=A0	return group * entries_per_group +
> -		(bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
> -		(entries_per_group / NILFS_BMAP_GROUP_DIV);
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rem * (entries_per_group / NILFS_B=
MAP_GROUP_DIV);
> =C2=A0}
> =C2=A0
> =C2=A0static struct lock_class_key nilfs_bmap_dat_lock_key;

Makes sense. :) Maybe, rem is not very good variable name, but the
whole logic looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
