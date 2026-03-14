Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E8719D092
	for <linux-nilfs@vger.kernel.org>; Sat, 14 Mar 2026 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773492473; cv=none; b=L3q9rbn1tJzSzMHdQPeTnoSiSoOzVl4aUQQePQrLSKL4ahnnwUuRKLJBB/ZQK3Ax1TvcxJRlGAm0c/HzHbNv6i4jOCbM/lPPVFjvYCAY0Jbto42+5UHkpDZk7tAmQm0Lk97ZFhNHLR3OdFucobi24nzDp/mEb5WjGiIFG/GhlV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773492473; c=relaxed/simple;
	bh=fA+lyYP+110atZU61RzhzGbte3ZkKDvt1ynoLWRnNes=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b8OKa7tXtSbuK5IwQbM3t0VWmJT5lKNtrF2Aaq3d7pfG1H/kH9sG8L6XfEAUnaEi8Tnq+MBxgS9os0kRxs7jKJiHemTiqQV4cW08jbJkFPjC1DfY1zrBME5dVbsV76g9X8e1UdP0RHv2zlpwalZ3R1s1UkCw66CdYKR9aGpDhKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SLrjb/7e; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SLrjb/7e"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48558d6ef83so13787565e9.3
        for <linux-nilfs@vger.kernel.org>; Sat, 14 Mar 2026 05:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773492470; x=1774097270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaFmVkPTbLRBufh3Qs4dGizBfbZxXt2RQDq/b/ikJHk=;
        b=SLrjb/7ehi9mvnV2lp8cG6GHoo8DoxbKPQA9OfghINpA2cBulLrDFt0cTBop6qCybZ
         Z74tVSY/x1UMCAkrib7HuJvcTIzN7xYqE9UVpD7QR9zFnOL+qAT8tSwBj6FArLhw+luj
         4Tiqt0fBcpROCkc3zTYes+EsNyt39+15GaJuCcJe1dvPSmRlVT1nXxGC2GpPnjal9WDI
         zKcwhYmsjtVhq1yVY3Yl65iSqGFjp7eQ2BIV+XnXSNN4DoPQCCTuwNWvGC4UJ+zpUhO6
         C4aIF2gapzA3Db7q9kstfSnrhu043ksiaU+NBR9xrEacnxH3dLPVsi2tsquwp1R5tuEF
         f72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773492470; x=1774097270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vaFmVkPTbLRBufh3Qs4dGizBfbZxXt2RQDq/b/ikJHk=;
        b=g8pXrGhpMEg6yrZ4IHHz+o9FMgOeXltTKwWE+artwjoE+60dvoDUoyxLIlF2chA5aH
         XVoCEvB18y8ym5igAZs3tSBllU2GrSY/uy4rzcN7PlanfgCV0EhcPu90ASg7j/zMyQWA
         vsEtxxrkBKnA7CEG+dTBlsxN81WdXnExHF4sTlMPqQTE4RlILRLdm5CLvNLtQiVIJFQn
         En8r+Bl1qkEShRo4bmbg/zT+8E6r3YiSy8MOuILzylFHxKlTVb/ivddX+cr7s+qL1X37
         Ssdl79x9bPGT4w1EeofH8T95sGMOtmzDrP88agn52WCW8zdPAIhKQhy72bbVSdo7Mr+L
         bXxw==
X-Forwarded-Encrypted: i=1; AJvYcCWFlEWULT/KjR2zc1q/L5lpbmNFFlhAICieTlIqQFrlbla6MCCRi2HfjiDHTIpboWvD/YIHoH3aVfSIlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbdgwgTusIdMZnh/URrr1OrcYbmHqBdSJ2K2a7IGSxAXL1PfoB
	763Lx9HlsdC0bMG+Tkt23Zx7LJ3YoRaaHakqeAqqFkFFZ81p2lFITPG+vdXMn8sn
X-Gm-Gg: ATEYQzyjtNtr73WXOL0uJZrvakfaUEPc0b8JQfGZmxNH8qSAdSAGgS/mypLka87fqxF
	JWAdosgkerVipUMSrUoRiz3Ixz1W6Wvw9lCYgze/PZy6ScDLfS2OGsLFIbYF9KOV8y1BXv/3fU1
	OXTSKgiJMxelA5PGb0Cxc8JKV7rKXqzraOfEAtEgJL7UC6D4m+LsVWwJ6M7m10OlD7+xUolFqd2
	tfUrE887HnaYW8nbNH3iph8+hzqwoWzAsUvxBpfZAbfuTW4f+26qqXexT4faSIqd3IlKKUcZ44G
	wTrn+2j4wdc4T8yKu2yKskfbmdBgP0K5QE4/EVP/5v5ds1KiJSX8fZ6qz3wYsH5c1QP6rM3ala0
	3EAdyxHsqFOGmHoeF7rbfMwJk8Twzz5tApgBWQR1ltoDrXKAHfe8mRyeuYWc+DmtxUN67EwpnZm
	fUaULoiJvQeHD+adStPHOB/zn+k+PE+iWdfGLhdHofOs990rh/MDJZ3wso+rpt/EGo
X-Received: by 2002:a05:600c:8b83:b0:477:54f9:6ac2 with SMTP id 5b1f17b1804b1-4855648f5a3mr104574955e9.0.1773492469891;
        Sat, 14 Mar 2026 05:47:49 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854e2537c3sm281121385e9.15.2026.03.14.05.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:47:49 -0700 (PDT)
Date: Sat, 14 Mar 2026 12:47:48 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Christian Brauner <brauner@kernel.org>, Mimi Zohar
 <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, Dmitry
 Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg
 <eric.snowberg@oracle.com>, Paul Moore <paul@paul-moore.com>, James Morris
 <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/2] nilfs2: fix 64-bit division operations in
 nilfs_bmap_find_target_in_group()
Message-ID: <20260314124748.1ccdf93b@pumpkin>
In-Reply-To: <20260313-iino-u64-v2-1-f9abda2464d5@kernel.org>
References: <20260313-iino-u64-v2-0-f9abda2464d5@kernel.org>
	<20260313-iino-u64-v2-1-f9abda2464d5@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Mar 2026 14:45:20 -0400
Jeff Layton <jlayton@kernel.org> wrote:

> With the change to make inode->i_ino a u64, the build started failing on
> 32-bit ARM with:
> 
>     ERROR: modpost: "__aeabi_uldivmod" [fs/nilfs2/nilfs2.ko] undefined!
> 
> Fix this by using the 64-bit division interfaces in
> nilfs_bmap_find_target_in_group().
> 
> Fixes: 998a59d371c2 ("treewide: fix missed i_ino format specifier conversions")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202603100602.KPxiClIO-lkp@intel.com/
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nilfs2/bmap.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index 824f2bd91c167965ec3a660202b6e6c5f1fe007e..abcf5252578ad24f694bfccf525893674bfcb4bc 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -455,11 +455,14 @@ __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
>  {
>  	struct inode *dat = nilfs_bmap_get_dat(bmap);
>  	unsigned long entries_per_group = nilfs_palloc_entries_per_group(dat);
> -	unsigned long group = bmap->b_inode->i_ino / entries_per_group;

Are you sure entries_per_group can be more than 32 bits?
It looks like something that will be the same size on 32 and 64bit.

> +	unsigned long group;
> +	u32 index;
> +
> +	group = div_u64(bmap->b_inode->i_ino, entries_per_group);

You don't need the full 64 by 64 divide.
IIRC there are both div_u64_u32() and div_u64_ulong().

> +	div_u64_rem(bmap->b_inode->i_ino, NILFS_BMAP_GROUP_DIV, &index);

NILFD_BMAP_GROUP_DIV is 8 (and probably has to be a power of 2).
So:
	index = bmap->b_inode->i_ino & (NILFS_BMAP_GROUP_DIV - 1);
is the same and likely much faster to calculate.
(The compiler will have done that optimisation before.)

	David


>  
>  	return group * entries_per_group +
> -		(bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
> -		(entries_per_group / NILFS_BMAP_GROUP_DIV);
> +	       index * (entries_per_group / NILFS_BMAP_GROUP_DIV);
>  }
>  
>  static struct lock_class_key nilfs_bmap_dat_lock_key;
> 

