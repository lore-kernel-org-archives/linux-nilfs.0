Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793204284;
	b=vlTzFHMW/z0rl9OkYlV0i/tamjxP4qpr4Fdh4vYFFz2p0nS7+JbEsbQwVfbvQZnMnAqZ
	 FOZyMiIMsWW8AqSeVQoYvIxlzAN59Ju9i2A9BV1Enh5FGZkaw3Ra2itfAxFgMthk44LXH
	 u6QruORawcQvaAYZ8cyQOS+9KNIM4aV7nQ6YbGtsOoihw40zkARzvRojaA27jOB+2E8wm
	 aO96YUnU6NR00+Nnixz7fVeZUNP95rXK35mFGzqHfl5E+yYgEHBfn8b5VfQBCOzqkXcFD
	 deqJCev8i4yn1lpqoAtb6CAegJxME4RNcTzioqfDop0OtRnwswQSdA1RdTIOXANUHeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
	b=qkK8ffF/gcUW6Y/BNRY9XaE/dn8aJ96KLvS6EQsZZy8qKJOvbzi9/1BKqJIMZa9/Dbqn
	 IXUbZY9+w5fyGibO246EFW4qyM1eVzXMCuc7SGt9/8izKl5AdtxnO245Ni+CnFi0Ncbm2
	 WRGcRXgJEmQjZ7xlh0+D+DTlMLne7CdbhkGl6MG7dcJFQhsPeGUtMYeWfZppinVuTYqB0
	 YxQjo2vB+4+sRiq8a7wgEyVzlZYYTPhfs9jM8mgjVna9aTvvKdscJ+v0kmBlXEqYmMkA2
	 P5fW93zgWxqbdcQcCAZKNE7gSBPYQHx8dpBPbyNnDZzKauDEcDHyH5pQswXDzrUaH+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC27C606A31D
	for <linux-nilfs@vger.kernel.org>; Wed, 28 Oct 2026 16:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC27C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-89ff475a152so575109b3a.3
        for <linux-nilfs@vger.kernel.org>; Wed, 28 Oct 2026 09:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793204283; cv=none;
        d=google.com; s=arc-20260327;
        b=a9urkNWZ0lO4P0PuyQ86TthI4whTgtT/wCoCuWzD1JyfouSTvwKQz/uJyxDL0uI3Oa
         tygpDnU0K9UyAqVZ2dEJYsh8Beq14TY6RtoVM6F2aQ8M6PbQloHmccKnVTNXn1WQN0Ok
         qXTSPs2MM3TcJkZA1jBLNZyIJjYmgrqLF8EwoIaeqmP1+guwYRhtziEn3BTxLtfYNz6j
         5086R0vQ5lXzne8MWAiYOzV64uu8u+A0tW+/lLK6eYTM0DFlXr3sg5nZsAaXTGWWbnb3
         6Jj0mBD9x9qePnMf9fp+1txcQ2UvQX0gq62UnsFUq9bgyztDhb19H5uUHVHtu4e7xHGr
         6lAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        fh=C4Fywuu8Du8qC3Nw6CVBDAImQNrz2/s+35LgYya2ywg=;
        b=XVtKJGf6FTPvjPmPwY86e1JiB9nq0yxbXgS343COrO2mLcur5Xp+Jtviv0gIRq61RQ
         8BZ+oNAwhZ+LKrmFBvGYdLemJZiibyEV4u39zKNEHlKf1GOikA9qyttTr8fplXPUDUuV
         rX6ZriZFREaI37YTGkLFzqZYuGTAXNIYrk6Jm5MyXKRPh80KRunzB8rcHc53/c6QdnIK
         px+d4asElnljQzg5inej3XA/Jb+SK3vK7E8rvzSNtbJiT1AQkS0+/ABqAjF9wsIlcaNc
         NHT/tcGOaEXzuouSlvglhGuzYxTEeGuSmzCBPpRhBLtdI9U0uhn/ES5Sbxx52w5/50uj
         Q/ew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793204283; x=1793809083; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=aE0UVEPlAf/V7Y31izbriey87faIFsoS80MZfhPz+nDPK2fFTvb3pIODF+rYWahhAL
         IE/GRtPxJFWJY401Rp92EZ6jNjNQiz4DcR1KQKNa6Wrp8DP5JXEhIV3bawUSZ6OBMF3Z
         Fag/CZu8p4S0vDV+pKLBKXG5EdyK4ORV7TOV/oJxfGOY2FaA54ToDtf6HylO7ckImk9L
         EZJGWpNqqI1H/cea5knc2AQwEuMaFuJBcGtCUYmE2I6v4kVZDruIbLWQjeqrsqwYkeKv
         brBqy/vSgeArKD9ZAiQYA43dPDFIFx74Cu6p0i9jVLMzAd7CHb1//RgOJp9+fhNk+tAC
         6PvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793204283; x=1793809083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=Y6uEMY9IBLITutuZIxnNC17PaASIA206EZnTMtxq4GP0UcZ8XVSsDzUoYpKOVF1/fm
         cSxc6LTVu5tYHEdG611p3NN9q5UhRmQT33/xE1Zs4nA5kPuTOvElpXUMmRwt+XcDSFhT
         iphjFwqOAKyeYjckAGRt2AVi8gYDvYoJ6CBCTyvBn0LsRGEFXuLIkz42006mE6KpmdFj
         DKbti5+v2mw5f4b+V5IvMHARZYv6ya8JBLai4d+bpxy+yGxPvPGoqIb7WuTHo1hX4L8t
         fboZY8wKRjXhfgybnh1E2Z3N53E907Y30Mf+AKbdj9rc+VvIY01q1hccrTGG7lf9x9gt
         gyWg==
X-Forwarded-Encrypted: i=1; AKwUvBx3Tkd5+4Y3JFVTcOI5p19uwI41xt+7sZPK99f2ohNSk3eyJ43L5htIbEOQhZv2NREUmoYSK3DWZnG/wA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLU5H6esHOBh51U8D2+KTRJQN8zw+VaorQs6tah8zR7YpggHyNu
	LIdb7cPTa4bKj6F3CK3ol4Jol83UwGdCApuiFoSFE5p4uSVCGiG43VMdIIcPQAR9h2D44NMYTe0
	WBjbTsRRL1cEgvlIEYhelrPc794sjW9g=
X-Gm-Gg: AYBFou2Dd+lMjFf/FrejXCrDB3bpK4BzLANBzwIbbZZWc60wXbuP2Xd43ZLNihQJyHE
	ax4bNQnZoLK63b/M9+ZarbNOGRBXCwKk49AdYUZzLOXpmPnFtmzp1GBX5sDm16cidYcCE0Lf6n/
	xSd2HUuO/LPfrTnbDMkz2sdLGMphtZHIKIMr5mF0U0RMqdhfNROxGAvmnXL1hKYoaHWWxxZ25x+
	Qtm/z0Zi7PSSf8Wfryw7jhUySqTxE7j910SRP8rcvP3bfwCmxDkzvJrsXktJRO95aFyWH725eSp
	E2DkXR79cfFp2bwhwtin1JoY5N0EAAmSpg53RrtiDe+SEBU8L9JP4PZlGLasWp1BiZhMrkxbSeT
	jSR20zymRdJKa2QjkweYOtHCYO530bnk8rDEUmw==
X-Received: by 2002:a05:6a00:391f:b0:89e:9560:fc7a with SMTP id
 d2e1a72fcca58-8a6e6efa7a7mr2168656b3a.29.1793204283163; Wed, 28 Oct 2026
 09:18:03 -0700 (PDT)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <20261027215326.2693300-2-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-2-joannelkoong@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 29 Oct 2026 01:17:43 +0900
X-Gm-Features: AclHuK91pZpqmliH2N1ROYQZJFORz_xx3uP0uM_hYUkPFZ1oO9AzV0q2NKIx0ms
Message-ID: <CAKFNMo=Kqs0T=a578WN+=PZ2gse2APWZ_jnJ64XyrerFK41sXw@mail.gmail.com>
Subject: Re: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, 
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 6:58=E2=80=AFAM Joanne Koong wrote:
>
> Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
> is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
> iomap_iter_next() helper to finish the previous mapping if needed and
> produce the next one. No functional changes are intended.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Hi Joanne,

Thanks for picking up the newly merged NILFS2 iomap code and handling
the additional conversion to complete this series.

While this patch is an intermediate step, the changes look good to me,
including the finalizing conversion in patch 4/5.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>  fs/nilfs2/iomap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> index e130ed63abd9..359786c97f2b 100644
> --- a/fs/nilfs2/iomap.c
> +++ b/fs/nilfs2/iomap.c
> @@ -67,6 +67,8 @@ static int nilfs_iomap_begin(struct inode *inode, loff_=
t offset,
>         return 0;
>  }
>
> +static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
> +
>  const struct iomap_ops nilfs_iomap_ops =3D {
> -       .iomap_begin =3D nilfs_iomap_begin,
> +       .iomap_next =3D nilfs_iomap_next,
>  };
> --
> 2.52.0
>
