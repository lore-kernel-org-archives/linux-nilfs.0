Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8083446CC
	for <linux-nilfs@vger.kernel.org>; Mon, 16 Mar 2026 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773684432; cv=pass; b=HmRbVHDmdI2o6dmoBkLu7b5Z4RDWf4UJ+YZc2l6ZuDg/K8h+hsUx+O7NDet1+rdl01navJYEC3gi5tgp42vrZjAEDlyL33agQoEmpXJxTg2fbjpOk5ebIWVqsWhmHRTCy7rFmGi14Y+79jhGMXXmmkv6NnRB3tBHRiUPR5m5g9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773684432; c=relaxed/simple;
	bh=7unitKYn8keomRHY4yq8+3PpiN6rsAq0TWo2S3hWj5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oC2Al33Ck80XnHrKKwPEpRuHCIUQWuvWuVgk0g8dnn08IOmxs/RUBu1dW4rmSteBHVKrd5VjPclFOFY4b365T3IaIvn1TKN0NIcJ3g8W3ydwZr6rcYW+aiPUkHLVLLFenV6zLRRLA0OyFqwjglqOaPUwTj6pxgWW0InvaEWUOqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHPubJmj; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHPubJmj"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a140efd2d5so8856581e87.2
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Mar 2026 11:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773684426; cv=none;
        d=google.com; s=arc-20240605;
        b=bowN32n2CkyU1MlE9ee82ww4VNfBCBQIpys6DPExEW557sabSZANJEZHg3f7DaaW44
         u8LHOQXiPJhTnJ95lDtxVDW6rCvKFmqd4tQt4y/lknHTtB4ixS/EDgWoYRKWQ/fyUdC6
         weBX9QBr8+5UadmFB3uB3nDBYE+z9DDEwQgvDpWAdB9uiWiZ29dtBym5nQr3DRM6s37q
         1la/g4IvXTJOSliBdsC/Suj9F2Y/lbKK/hZ/eyz38thqehWs6+R+DxWgClSt3vF8i+7q
         FnfbW9KdLiDSd5ETs2UV55nXWyrQnrtNS/fQVmq2O1Bik82Xc0+447jF8XdCNnlj2dBG
         wO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdAyIT2i4xeBkYzcRUZlVlUOW2WeACg70IfzXtqvGxA=;
        fh=tksmvcHycvhl53wIk3CaPBya0nHh2OOz1mK3FD2YYtk=;
        b=heQRblHgXDIZS4sp/dM+DU4fGdxIoyKySPFkl7kpgslyeCEbueIa89a5MGBjEVkfX0
         1+Yh0y7HVezbEN1q3W0IiA7rXIf4GXTQ2GpGog0MP2BZkeIPkko3JGzvBQs8Elqz3Bux
         HeLJrNw83yFUAtaDf5Y4KcK/d/4Y92a9CxSHrKb70w1jK+45qgZqxatFi2avIbyg2ucq
         zB3WRtnxkLqoE5C9fFu2yIROw5G8qcm3OT6NpsTRr8DSsuZNvttxzi4B8kxbiFv2z/CZ
         XMXlYE/7vWWZ2N2rmbvT0smuLneW/h5huD3zKtnLFth3LvG8YQHV62ctHnovsrAN4+oz
         PB0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773684426; x=1774289226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdAyIT2i4xeBkYzcRUZlVlUOW2WeACg70IfzXtqvGxA=;
        b=dHPubJmjztMSd6n9WUVmgrc8yqkiRIKa7azepgic6RZxUqACoeiPF0UzdpNts5RD4i
         aoIF1SxlnH7KR9/nnpqyKanUsbqj9P/kryGwk8au6O89MnsmJVd/zQyLyiCBUHeFXkuI
         2CROLm9gxI6xloX2N2zNjbRdxWqUwBRq/KDlBIfch5mxUd4kUby5N6LWnUAaqgLe2zWs
         4b1UWh44zZ+VgL0Rtj/zXEHVwBd9USGJhTkufAK4S5wC4kTwhT0NUKz1U9ltk0c/T8vT
         O8TYEpJcgFC/E110kmvfJ48FuAh7+8bE4FKhYaj3fLDwl+pgKz0n4ITC4XRi8zd8mWbZ
         XCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773684426; x=1774289226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdAyIT2i4xeBkYzcRUZlVlUOW2WeACg70IfzXtqvGxA=;
        b=NbY/UPoSlyNYbQe2fh8czhkCZJuqmxN0HP3COG8HEIfZjGpI1L7iaP2hw31pJGXLLE
         btNDOURqQXkRowuraEXae6dh6KozE+kCTK5ev+su3IWEuMkc18TEZaXqMYzFJLa4AEz9
         nDkf3cEa4sqPQoXm5RM6qGrWARRpwXzc++m0AYXuDfa6v7JD8hDiEcpeiTgIXtU0ncNf
         bUjWWZH+djtFYu806+H2K3ATxrJQJzFeLmsDCbfnEYcRV50sLEhdEmpZlncC3afhPp4I
         3JiEn79KZoufTO9lZo0Ud7COFcAK7/wvvuTQtiWeuk47dofPFU/8XndCbcU/9w1C8onR
         deUg==
X-Forwarded-Encrypted: i=1; AJvYcCX8MxTuJ80l0+dk5Ov10fDTGrA4UofQKZY7MWp/l0pV9EygpV+ImdB1RJMwBjnxBJSVxLGPAl/YopeEkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6vl550s1U/o/RVu/tId5kwjQBbvTttdJ5y9aFue33DPzeWPls
	g+F22289A/6kQW+/Z2bfYrBDqfnfYetT5Co1YSay24Vk1dmLRYAWa5DPlcmKznAIXJa9Gm+tzl2
	WbZy/oSVLTe3xMnTcAZC+/dpd8ROLK6s=
X-Gm-Gg: ATEYQzyDjlWMWyAoiOV/KsHNXuQb/b3Jc6iDBeNnip4cVHZpdnFSYJCxt8MyLHUhmYx
	639WjEkOKhxWCzHXJYvsMoui1B9qXxXEsriU2wurxE3PX5pVbz1NIL6wsLFzYR36f0PypMrT2ZX
	+Lpaj56xOjyqLmOUttht+Xxi5g66V8iqBkhN8qFKv/vYStGYZshJuv08zEX6MvW2b2eDfW++L6g
	GOnPMJJCnyLQIksaB1hdO/pa2i1/UYaZT8NQmusoGQZkbfeB1UYBDtX7cD809pCFcPDXn7v9x57
	XuHhWShSDWofPbYl9UQ=
X-Received: by 2002:a05:6512:23ca:b0:5a1:3b78:17ed with SMTP id
 2adb3069b0e04-5a162b16e63mr3445752e87.40.1773684425700; Mon, 16 Mar 2026
 11:07:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260313-iino-u64-v2-0-f9abda2464d5@kernel.org>
 <20260313-iino-u64-v2-1-f9abda2464d5@kernel.org> <20260314124748.1ccdf93b@pumpkin>
 <361258925536e2280ce62c5e49531af5c42aa491.camel@kernel.org>
In-Reply-To: <361258925536e2280ce62c5e49531af5c42aa491.camel@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 17 Mar 2026 03:06:49 +0900
X-Gm-Features: AaiRm51-JNtIyZb3PA-K-WobeTklyHQjodaAw0PHxkAwRGut69J0x6uW-2Hk1RI
Message-ID: <CAKFNMomRoq+rxF2HzzTpWhju+GCm3p3fjhm7e9mmvZKdsJHwZA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] nilfs2: fix 64-bit division operations in nilfs_bmap_find_target_in_group()
To: David Laight <david.laight.linux@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Christian Brauner <brauner@kernel.org>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 14, 2026 at 9:59=E2=80=AFPM Jeff Layton wrote:
>
> On Sat, 2026-03-14 at 12:47 +0000, David Laight wrote:
> > On Fri, 13 Mar 2026 14:45:20 -0400
> > Jeff Layton <jlayton@kernel.org> wrote:
> >
> > > With the change to make inode->i_ino a u64, the build started failing=
 on
> > > 32-bit ARM with:
> > >
> > >     ERROR: modpost: "__aeabi_uldivmod" [fs/nilfs2/nilfs2.ko] undefine=
d!
> > >
> > > Fix this by using the 64-bit division interfaces in
> > > nilfs_bmap_find_target_in_group().
> > >
> > > Fixes: 998a59d371c2 ("treewide: fix missed i_ino format specifier con=
versions")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202603100602.KPxiClIO-l=
kp@intel.com/
> > > Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> > > Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/nilfs2/bmap.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> > > index 824f2bd91c167965ec3a660202b6e6c5f1fe007e..abcf5252578ad24f694bf=
ccf525893674bfcb4bc 100644
> > > --- a/fs/nilfs2/bmap.c
> > > +++ b/fs/nilfs2/bmap.c
> > > @@ -455,11 +455,14 @@ __u64 nilfs_bmap_find_target_in_group(const str=
uct nilfs_bmap *bmap)
> > >  {
> > >     struct inode *dat =3D nilfs_bmap_get_dat(bmap);
> > >     unsigned long entries_per_group =3D nilfs_palloc_entries_per_grou=
p(dat);
> > > -   unsigned long group =3D bmap->b_inode->i_ino / entries_per_group;
> >
> > Are you sure entries_per_group can be more than 32 bits?
> > It looks like something that will be the same size on 32 and 64bit.
> >
>
> I'm not sure of anything here. I'm just want to get this to compile on
> all arches. FWIW, I'm not looking to optimize anything in this patch.
>
> > > +   unsigned long group;
> > > +   u32 index;
> > > +
> > > +   group =3D div_u64(bmap->b_inode->i_ino, entries_per_group);
> >
> > You don't need the full 64 by 64 divide.
> > IIRC there are both div_u64_u32() and div_u64_ulong().

Isn't the type of divisor in div_u64() u32?
Since entries_per_group cannot exceed 32 bits according to the current
specification, I think using div_u64() is fine.

> >
> > > +   div_u64_rem(bmap->b_inode->i_ino, NILFS_BMAP_GROUP_DIV, &index);
> >
> > NILFD_BMAP_GROUP_DIV is 8 (and probably has to be a power of 2).
> > So:
> >       index =3D bmap->b_inode->i_ino & (NILFS_BMAP_GROUP_DIV - 1);
> > is the same and likely much faster to calculate.
> > (The compiler will have done that optimisation before.)
> >
> >
>
> That all sounds reasonable to me. At this point though, it would be
> better if the NILFS2 folks stepped in with how they'd prefer this be
> done.

Yes, indeed.  It seems that the application of optimizations will
change, so this proposed correction is better.

Since NILFS_BMAP_GROUP_DIV is a fixed constant and cannot be anything
other than a power of 2, could you please adopt this proposed
correction with the following comment?

#define NILFS_BMAP_GROUP_DIV    8  /* must be a power of 2 */

Thanks,
Ryusuke Konishi

>
> >
> > >
> > >     return group * entries_per_group +
> > > -           (bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
> > > -           (entries_per_group / NILFS_BMAP_GROUP_DIV);
> > > +          index * (entries_per_group / NILFS_BMAP_GROUP_DIV);
> > >  }
> > >
> > >  static struct lock_class_key nilfs_bmap_dat_lock_key;
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
