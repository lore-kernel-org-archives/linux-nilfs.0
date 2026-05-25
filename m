Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D93E3F4105
	for <linux-nilfs@vger.kernel.org>; Mon, 25 May 2026 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779728864; cv=none; b=l6JmIVweFoCV36QMX5bOLGGrDxNDyZI/P8JjwgEG4UVfUwe/o17nkk2L4A5DwwitiK/vz4/zbq6cvegGgQxXfAIxfvdmUYJbBkjPd8fTfgVE+mwrs+H2c5VPQLm4+um00d1UNxl5pxIUsk6MntFp70xnt2x8hPu/rr9Xv97NGhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779728864; c=relaxed/simple;
	bh=EGS2JGmyeWkbOCbREIX2qtEvE51ujoNsVgCL48xBWXI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DRyQZZv1aY7a0zZF3aHThVtaG5uIp32DRCPD7PoaqXTi2NrtXBpXqCvpOMsH1R/NcpKJzwCPS1PI9xtvqbDYN+OL2nKDaxTvkSYZv4FLBhtUG2bQGbQVBeWkH2g3+P12zIN6njPhKA93MHXRAPb8hZq3q2DqDxc1NlRB6ITDgoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dhioHvSU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B4IY6GkQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhioHvSU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4IY6GkQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779728861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQ8f0KL2cvJbeqS1wq3el83kZ9Z8vH79ZAL6r1+vgks=;
	b=dhioHvSUW0LXwpL2ye6gY9aEtrH575Eode9Y3bZkyFDeYpbbTkYBTB9MM0JZkKtl1AeGiF
	GoG47VJHDsbLzrDndbsVcyDWtVD5D/9ES7k8HW9uIoQQ0Csb5CtsMlQ7xRiKMN1+vUvum+
	IwbtAkSnwz5Aia90ZNw4ZnOg9+/OCig=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-eYxNEcdAM6SjQAiucdxLHQ-1; Mon, 25 May 2026 13:07:40 -0400
X-MC-Unique: eYxNEcdAM6SjQAiucdxLHQ-1
X-Mimecast-MFC-AGG-ID: eYxNEcdAM6SjQAiucdxLHQ_1779728859
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7c485e98f8fso152655917b3.1
        for <linux-nilfs@vger.kernel.org>; Mon, 25 May 2026 10:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779728859; x=1780333659; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QQ8f0KL2cvJbeqS1wq3el83kZ9Z8vH79ZAL6r1+vgks=;
        b=B4IY6GkQoeA6mxx8zFvjIHv1rw5Br7ObA6BH4M64VQ4WU6Hqk1GAUiuxBN81Ysi8fR
         ZwDRoKuZnH2y3aD88NE7jRHEBpMqrXc8vy5r5h3UTA+HgtWjx4fq5ehhF5VbbP+7movw
         CLTuGQqyAkdTSdUBZyjv7Emf0tHIBhS00MOl7s7WeYGyoWn2jsXYdpP66s0MrFJJG4ea
         3IivF1Xp8tUen58bukrpcQRp3jpeOEkaWT7Hw7p7lyR6GpmYkqVAJNcuLG/MJacz00Y6
         tRDq2BUx5w3dsFFV76OzIuQ2jHxDC7lL0r/GBonXJnS4WDQun1sK6026uV0PscSu56e+
         ohsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779728859; x=1780333659;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQ8f0KL2cvJbeqS1wq3el83kZ9Z8vH79ZAL6r1+vgks=;
        b=eAVjDodpi+d7DA55D+5B5tQzLLgNEZKYulWuxscy+64tgerjj3CfjSblMoujJEemLq
         1TneiWJMSjYJnBBK4rsRfM3s8z6THLfotj95YU6x9UJJ2PRLFUcQQBpmN82iRrAmbakZ
         Z77uRIZU5oToitdtDhAi/dJANdOTh6gd2vvwkOOsGBPEj2FrhhfrDLbUMrFADRpFhbbu
         8SuxJ5t2qGhUTobbC3AktkHpIqe1gt2na0+yI4Uyrj43hNJzv8fGZaO/Ibky9ALuhk0F
         LhRx2/KQV+RHfa1zER8ikBopgxosd7rgyyF3rtyO3MrIfgvFqeaWD1ui2I6s09pESVNI
         ltQQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4h18LkLl0XorBjcXN0m+j/BJR9bgVBBAuLkoMFOsegYQKvt9wxnjEDsAG9V5vs3mazveP20tkTeF7GA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTS1T53hwKgNOG5a4vsNCfANbFjl1KIzheNEziwllnkswT2QZv
	3jmrYbTppA4aVYVKxi+MY8+nvZaPT87uNXQAQz9j+2v4wVxRUT8VwqFtKKoZnlY0iS8/KhWlRY/
	8t9vEMLhfaLpCIvVyzcf/INo6AJDIWpgFhXn4hYtl8m223H61CSH2sJ7Q5yDQa26+
X-Gm-Gg: Acq92OHU/RAEVhP4DrOvf6Dqtr3vdumug+Oh6JMjGy9k1O4gxlXHuG1ejbqsieNVjYO
	gzQybDqUmULPjKjVR8xXEme8hSxB+d2RYpPa7fLxyCkJji3LYlAEi7eSyNr2xCUcrq1sTYk1F9T
	I0b693W29HuDYElRxc3gCdeZ5JvfigJwkrzaPyIeKviox6SJzUTuiVWbNaoAChwG67Rwqq+AbbE
	ZDh2KIcrT7YkbRezCAxGA/syCJf7FWTuSm3f8rhs2FP7a8eUwVZxXiQHhwrbZsbbTPUHtPKzswy
	dK4H46cQAy6RGjzUsWWnwnuj9wW/yf6bFG3w2FWTeN7RxS1GFZSuvRLA7s4e7oNcN8NqfmyHu6y
	NmLXwfW2xEwDM6XqLse8OysTvM+fsVctLpUu1dkjWAOGr9AJ50X0p
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237687b3.18.1779728859430;
        Mon, 25 May 2026 10:07:39 -0700 (PDT)
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237227b3.18.1779728858828;
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d389813ea8sm48480087b3.4.2026.05.25.10.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Message-ID: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
  Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>,  Ryusuke Konishi
 <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Trond
 Myklebust	 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever	 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown	 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
 Ngo	 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o
 <tytso@mit.edu>,  Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>,  Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 25 May 2026 10:07:34 -0700
In-Reply-To: <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	 <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> get_zeroed_page().
>=20
> kzalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>=20
> Replace use of get_zeroed_page() with kzalloc().
>=20
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  fs/nilfs2/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index e0a606643e87..b73f2c5d10f0 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilf=
s,
>  	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
>  		return -EINVAL;
> =20
> -	buf =3D (void *)get_zeroed_page(GFP_NOFS);
> +	buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (unlikely(!buf))
>  		return -ENOMEM;
>  	maxmembs =3D PAGE_SIZE / argv->v_size;
> @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
>  	}
>  	argv->v_nmembs =3D total;
> =20
> -	free_pages((unsigned long)buf, 0);
> +	kfree(buf);
>  	return ret;
>  }
> =20

Makes sense to me.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.

