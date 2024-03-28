Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C021F12F398
	for <linux-nilfs@vger.kernel.org>; Thu, 28 Mar 2024 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711639305; cv=none; b=l+aEUnpL7GbMdCz8rEMXf39c2rgHXXDbcNYTIKAfd4MGl5xVXSL47DL8et2KUw4Ldazw3xGYNfdHcyfWecmAM160CF0+eja2M+gMB30dndPJntIuSYb7fIqbb2u6XBeJTEED84mfcHHCainiYboQwhNpfTFoKjn0OD/Mo44munM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711639305; c=relaxed/simple;
	bh=ondHyxfZ8OX6rwV1SB59go4V4JhpfH4Z1BXh1xU7Kls=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W6dGwDoBXwqerLoIcscIk/fcMGzIzlWK0i78+0U5Ai9o3uwVEISkA32SwRTx3TBi4y0A6v9szaMG59Nze/zPADWpBAZObD0t08nHkV4G5RczGnZFx2OqB+kapA/QcPf/O3zRJ0GfvJGLUrQroWllJKr8pWB3xB+QS390kL0MYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VadRuTya; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VadRuTya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711639302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ondHyxfZ8OX6rwV1SB59go4V4JhpfH4Z1BXh1xU7Kls=;
	b=VadRuTyaPp4rI1YtDQpMI/zFJKkyHUyq3a8E1lPfHeA7cAFgBWcrsckZqZuAHnF3ko4iX+
	d0WLfNnqJgKIPt+Kt8M4/U6s5NDO+QWkytGmg/FE+X/iOcebLnMi/o1RF3eoTzk9kfMMgs
	iMxFXSol+XsllrKBz/G/0M3hOZGW+uY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-wep_aDFPPNuMArGAf8qnGw-1; Thu, 28 Mar 2024 11:21:40 -0400
X-MC-Unique: wep_aDFPPNuMArGAf8qnGw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ec826d427so245919f8f.0
        for <linux-nilfs@vger.kernel.org>; Thu, 28 Mar 2024 08:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711639300; x=1712244100;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ondHyxfZ8OX6rwV1SB59go4V4JhpfH4Z1BXh1xU7Kls=;
        b=JUqtRe2pvT7ZldCaS8ydiuogycBEtUhb3k4WA2khn8F1Lz+/f5LuMQ1HeMK01voFO0
         uypyvinYeDByEP+IkpYpaH0qY4M7YY3D13L8lntu/91Ib3+rjBYIgh5D+iMnC4aSOlbe
         ZJotq2bUwElwMT9MHMk0cGo5O2HHKxkbCbwEQpIPsHAJ7S88pBB7wreWo3p9Ibg9levN
         7QxOR0EEc9TEIHDCt7joJJLz/kKOylhurrvfzbmhWI7LFbJROqGNmsoZbU8U8QWotd3E
         7jWS/cI1MrIJt8Ro/HCN9n+npkDNwLOc7/DXgWZOw3wsltWHOzZqo0D/ZdQKWjaXyeA0
         XMFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNcIJ0kmjyY3Xo7Bm7YmNG3tCHMPt8PTuXytLbu2PL72FtLpTCbEpHKwmo8sPIotyyifib2ZpQMgF90i3NOm0rtLAhvoq0tFtgdJc=
X-Gm-Message-State: AOJu0YwdHqtne5O9FtHcobCvwoCJODbnn0Yp7pKPZs1bwprlpv+xNUze
	mxlexKgZhjXIW7KyfYyIJraDoBzEBRcEVEMBv+wzy/6l1LmqQnUQgo3Fm/NHvaEX3opwDqXVg+a
	1JK72QzS+K0lMBSRltUXzRcTjle7WTEyLOnm3zNrRLvD6C6ZITsvqpcND/dY8
X-Received: by 2002:a5d:4d12:0:b0:341:8f18:db39 with SMTP id z18-20020a5d4d12000000b003418f18db39mr2162771wrt.1.1711639299850;
        Thu, 28 Mar 2024 08:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4wODag+R6YZegPQpjBBcHxwLoBqvrwbnJ8kbwMlZZahD5JYP2dGk26tLHT2tkN0npnp32mg==
X-Received: by 2002:a5d:4d12:0:b0:341:8f18:db39 with SMTP id z18-20020a5d4d12000000b003418f18db39mr2162753wrt.1.1711639299507;
        Thu, 28 Mar 2024 08:21:39 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32de:9a00:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m3-20020adffa03000000b003432dcdb5d3sm1987109wrr.35.2024.03.28.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 08:21:39 -0700 (PDT)
Message-ID: <25b5f2297c98500ed91971a61ccc4bfa5921035e.camel@redhat.com>
Subject: Re: [PATCH 6/9] nilfs2: fix out-of-range warning
From: Philipp Stanner <pstanner@redhat.com>
To: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org, Ryusuke
	Konishi <konishi.ryusuke@gmail.com>, Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Nick Desaulniers
 <ndesaulniers@google.com>,  Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 Thorsten Blum <thorsten.blum@toblux.com>,  linux-nilfs@vger.kernel.org,
 llvm@lists.linux.dev, pstanner@redhat.com
Date: Thu, 28 Mar 2024 16:21:38 +0100
In-Reply-To: <20240328143051.1069575-7-arnd@kernel.org>
References: <20240328143051.1069575-1-arnd@kernel.org>
	 <20240328143051.1069575-7-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-03-28 at 15:30 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> clang-14 points out that v_size is always smaller than a 64KB
> page size if that is configured by the CPU architecture:
>=20
> fs/nilfs2/ioctl.c:63:19: error: result of comparison of constant
> 65536 with expression of type '__u16' (aka 'unsigned short') is
> always false [-Werror,-Wtautological-constant-out-of-range-compare]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (argv->v_size > PAGE_SIZE)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ~~~~~~=
~~~~~~ ^ ~~~~~~~~~
>=20
> This is ok, so just shut up that warning with a cast.

nit:
It's not a warning, but actually a compile error, right?

(no idea why they make that an error btw. Warning would be perfectly
fine)

>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Should / could that be backported to stable kernels in case people
start building those with clang-14?

Regards,
P.

> ---
> =C2=A0fs/nilfs2/ioctl.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index f1a01c191cf5..8be471ce4f19 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -60,7 +60,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs
> *nilfs,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (argv->v_nmembs =3D=3D=
 0)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (argv->v_size > PAGE_SIZE)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((size_t)argv->v_size > PAG=
E_SIZE)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*

