Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B5346E74
	for <linux-nilfs@vger.kernel.org>; Thu,  7 May 2026 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778190108; cv=none; b=CoHSlaoOCJv1qnggCdZpcGdL3fAZWgLqVfmF5BXIZflxcO8EV0dtSx6mZKYa07bsxnb+Dqcsylj3Fsn3t3GUT2QxRkfrEk0qgZQokxU9P5CPwsA8zDgDehhlS2E3m5oJHTsL5MImHsvq1MkQTJvc2RbOlfGMMfFxSbz3dDvodiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778190108; c=relaxed/simple;
	bh=U3a1Rvop2Bo7hkyN/DK56QhgCdGnBNh1cl29APUanZU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qf7otgRlhyK6ykP5D1/5HPvj6Ca94dHgOEzCg80Es2B6llKbM2ZcJNqG2OJrgyeOgR5JivJjvsFE1IcHjKc2+4q/spcO5x7FsbsSJukk/kMyynDk8n8rA5zEdpl3iIMRPrFCEg0e3FZ6/nkTVMqSx3BnjvOfgzTbaJJ6+n5mugc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJqPteKR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgW/D+mB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJqPteKR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgW/D+mB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778190105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wm30c8FokIh/dw9WAqFPgr9dxyPUU9O9WsqvHE9ngCQ=;
	b=gJqPteKROkqsCWlRyXhZoC7NrQzTl5Ya7gKu8Unh5nGtPB5Z5r3ziOjzDP0DUknLv45us6
	blGvH3odtjFZGj539527W8LXozstkxq8/NT2cb6dv04WC6QIHUEt8nOA8hLVZHhSxlPrzj
	Bhs0p/f8A7mDOAOTdU49A8MDN66cIeE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-xHuYek-PNJSMwcM5SVqPGQ-1; Thu, 07 May 2026 17:41:43 -0400
X-MC-Unique: xHuYek-PNJSMwcM5SVqPGQ-1
X-Mimecast-MFC-AGG-ID: xHuYek-PNJSMwcM5SVqPGQ_1778190103
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bd5c9e2e4aso34238397b3.2
        for <linux-nilfs@vger.kernel.org>; Thu, 07 May 2026 14:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778190103; x=1778794903; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wm30c8FokIh/dw9WAqFPgr9dxyPUU9O9WsqvHE9ngCQ=;
        b=TgW/D+mBxPQJ1XkGnmUzUwSlrbtXO3cINEbqHoSkHJ2L8d2eeQlafXxZ/brPHfurSN
         ifBM6AzUzbyrNPR+Tbmfb1TdAdrDvK+GoiS/cWj30nuCL38cvtEqUgNqIZwEhEMcXYjn
         jQda/XXwFhZrTJTYaS/CrXC53H5NuMJuTsLIZEph6S0ZgKedbTHeDRkMhBfXiUjhjOs4
         5vL9aAumwP98k/R4OYFkoPjT3wG1k9cXFOKwVxzPtiHYoygQdwaLeo2KM4meTQWU1Zbv
         rKnB+nwnsqEvxmzs0vGE7Jp7H9wNbwS0YcfFlPFACdIQ2bWc6EeuHCIUUm6bpBwVVoIj
         w3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778190103; x=1778794903;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wm30c8FokIh/dw9WAqFPgr9dxyPUU9O9WsqvHE9ngCQ=;
        b=k2z4QTSlUPKFAIRoB0Pjr9yxgOXhzXd/NSLoSZJfWG7Y2//6nAKodx2ZQBnZImGYkl
         im/Ximd76p/QAMTW16U73qCMvkCHwV5rqmGQjEIenb1uQEcH9i3mR/7IfyvRQVd1B5mO
         5A9++aJp08lFe6N2FcBKE7kVs2mCYJAMlEYg6Fy96zgCRy9x0UcV5HhVvlI6yph3ht/0
         N0G4CFI4uMqXeobWHA84n2FomAKOpN+DUcTdCCgJwcgecAgSo6a8JTz9ph77SgN1rUfL
         1RszrUTV1B2B+rzsB3YqfjqZforZn2Xex72hLgD5EX4+jMrN7a/wMWiTE8ufUid8AOMi
         QAYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/g3R60ggykjXGWSG3hSq/QuwqWLZCulZI+hEJVnJb/++NeR9ZrloDnvj1tikxveMcQxuT3R5bpaJ9SqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk/+T5TSt+HM6OUdjJVsFkA7vmmeBWdNqzCp0/TFGjMW45DiI5
	oswkS1unJcxzteRyz8C2Uz/2/TLCYhbuXTkTTYKDi/BR+G69Ge7AbduqZ8P0/tOcqT+6Kt14noi
	d/RH1HGNb3DQyL1+vVpLJY58597n1kBQCLlMdsNkK+IshBJFdivLUMTZSP15jLj7v
X-Gm-Gg: Acq92OG6bWpfIpplgqSyRhOFvX1QFF3x2DB27eosry4Y96QsxUIRxsSJf8a+swicHL+
	xLkDFUYQk2/ocCE3e/K9+wxSwVzaxi/3HQhD7qTYOxKDWrcmcv3jjsYkZ9f8Rqk/0BjINPsN174
	hGYMAe1LjFd2iKBxD9/aRUk8MVSbPJ8T1LErxGVJTzGaRkz9oFeFMDoQNux3U48k45eT2/hRuao
	SJe3ZOkazbZzeGxTMjvCTi9SZiKuxIph6rxwHqJToLOxzo6o2XxTJhZ371OaVmT4el5KKel2cT/
	PWr+vzizs6xDpuzQHYHeE9LdYQ1eJq9Bph5SDCS1fjoog5M0t45qQmEaYMVVpHpb51kE6FjEvEw
	MIAmkLf9w0mR8HmBFOhnUdIgXMhxyzG84Fi+dBdHOVxJxRNzH71XZ
X-Received: by 2002:a05:690c:e094:b0:7bb:c0f:19d4 with SMTP id 00721157ae682-7bdf5d7fff7mr108131637b3.4.1778190103105;
        Thu, 07 May 2026 14:41:43 -0700 (PDT)
X-Received: by 2002:a05:690c:e094:b0:7bb:c0f:19d4 with SMTP id 00721157ae682-7bdf5d7fff7mr108131367b3.4.1778190102565;
        Thu, 07 May 2026 14:41:42 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66885907sm99820107b3.43.2026.05.07.14.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 14:41:42 -0700 (PDT)
Message-ID: <bdc4f9e52d007cc4fc4ab6832906f7381d22013f.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: fix backing_dev_info reference leak
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Christian Brauner	
 <brauner@kernel.org>, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 07 May 2026 14:41:40 -0700
In-Reply-To: <20260507155021.941895-1-shuangpeng.kernel@gmail.com>
References: <20260507155021.941895-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-05-07 at 11:50 -0400, Shuangpeng Bai wrote:
> setup_bdev_super() already initializes sb->s_bdev and takes a
> reference on the block device backing_dev_info when assigning sb->s_bdi.
>=20
> nilfs_fill_super() takes another reference to the same
> backing_dev_info and stores it in sb->s_bdi again. The extra
> reference is not paired with a matching bdi_put(), since
> generic_shutdown_super() releases sb->s_bdi only once.
>=20
> Drop the redundant bdi_get() in nilfs_fill_super(). The single
> reference taken by setup_bdev_super() is enough and is released
> during superblock shutdown.
>=20
> Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate the mo=
unt code")
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>  fs/nilfs2/super.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 7aa5ef8606cd..893a504cb80c 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1070,8 +1070,6 @@ nilfs_fill_super(struct super_block *sb, struct fs_=
context *fc)
>  	sb->s_time_gran =3D 1;
>  	sb->s_max_links =3D NILFS_LINK_MAX;
> =20
> -	sb->s_bdi =3D bdi_get(sb->s_bdev->bd_disk->bdi);
> -
>  	err =3D load_nilfs(nilfs, sb);
>  	if (err)
>  		goto failed_nilfs;

Makes sense to me.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.

