Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854583F9280
	for <linux-nilfs@vger.kernel.org>; Wed, 20 May 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301374; cv=none; b=WIy7u8EROKcvng2Y3M8cfOCWlrpvSfg4zQB+mYDrRRgCjPcu8Xvs9bqOZUD7xHeDC6PS29YzMFNopAJdNP+AvDx6Yzrf/My4QLD4GVdqXB5SWpexBBL3CY1+8ZFW/HMLEpiBBZAnbz4t9qNnXYXzJNOs+7RgrxR6cXaj2F7itVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301374; c=relaxed/simple;
	bh=+1DbRAYSjuddyF5jr/yEfLb6KnACKasLyU4fqXF0s4k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eWS1w7gp/Zp3Ty4pJGKFy7TjHt5PStvs38rHA1c0ndcqh/qFtY6zp9BPlYZl7rfLBUyHcZTdZvYxaMplHtsQU57WuOBip8CadwRW+HkaQ4MzZsNrBzjJ7CiebV3hwDsjTFEX6W434V70gqfzikYKoXP9PYDoBPSje2aPsDV/Kjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dC9tdRE4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZBiTM2Kp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dC9tdRE4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBiTM2Kp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779301371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWj+yOsSh8H863lqUCbXUEHFYFBatSqkhVNAfcgLZz8=;
	b=dC9tdRE4k1qZMQ2j4ed3w+z1OFiBSEx2h7CBQj+eylU6ou8vRQjpDr6VV8zE/LN+C7BxHo
	XDSPEojF9Nn83ELGDHmL3TkB4FUkplwS4YLUJ7aqZVVSv3uilt+MWOVKQA69PqrFczlOsC
	Yyn0l5xrdlxoUUdyM/0r9FrCFmcQO+k=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-GfEfBQE-MEmW3X1V-wumVQ-1; Wed, 20 May 2026 14:22:48 -0400
X-MC-Unique: GfEfBQE-MEmW3X1V-wumVQ-1
X-Mimecast-MFC-AGG-ID: GfEfBQE-MEmW3X1V-wumVQ_1779301368
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7c24193e2b8so94463217b3.0
        for <linux-nilfs@vger.kernel.org>; Wed, 20 May 2026 11:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779301367; x=1779906167; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zWj+yOsSh8H863lqUCbXUEHFYFBatSqkhVNAfcgLZz8=;
        b=ZBiTM2Kp7+MENFf7CAJMM3iUOo/ZfwivjKSYz8G69nrWklOJLZFRsUg9CPDidfhTdl
         SSMKk3WLyslWNMFNtXc8dvhoZ0OWhzgpFpSiOOAyu4AXKrfszNe+LSFruC3uYAI33Hrm
         u4EP2IczEOUTBAUhC4VKPKbYvFvpwl31bHYvORex3eQqIvSb5plGHJxZjxxhXfwZXvY4
         ehhOPShdwPirK88m625qu50VH4C3HU6GA0E2Rp62lEIHrlnB6Ix601Q/qmyyZZaS6GAG
         U6yYJggTHyBM8MxIr+vblWbQTeUJwdJkWffIKg5yXUMNrS9AC0j1selQXB9HGi8P98xW
         uLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779301367; x=1779906167;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWj+yOsSh8H863lqUCbXUEHFYFBatSqkhVNAfcgLZz8=;
        b=OVffA5KkIgE7Jb4Y+PghsgFY+Tuh7oYd2rdYlUSecEbwKpaBEtyCkjc9Iyyfy9Jo/f
         ysiTzltJ/nRlWnqzPIuc2nZh0la0YputARYA2d+DOHlsUFS+dtl4V+8UnVh8DqNhj5Fc
         G1ocs4cqb83PXWwlkNqxhpwzMU7RCDxaQaBcZQalqdM0UvvGixdTcxiBjNSgYG7UKrC7
         I2zMfXGXhYcja68QYD8VsLTd4o449739K4DUqzggoqkBO+IpO2CcqYHdoR5GQE5d4McT
         iVWZIKOA1Cpyex5TOaUoxZkYuTiB4dQ96CqgcpbdDQGubewXIEooWe0M7pSsT1+uWngV
         XD7w==
X-Gm-Message-State: AOJu0YzUB6fClbf47BOUwPAmkiyms0fAOax1J336Zj8ovvHNJzYtcIaZ
	J8BQPdyICzY4pyy0rzLsEcjd5WPiOwpU1s3nyn/gKdTgrr5jUL28t9QxoWsWA/W9UBgsphZL1+H
	jvd0vhUByhH3QM9IaB8j7hhdAQSK40kJFQgp4wMLBlQhB4NBz3eOonFfNb3fKCVqH
X-Gm-Gg: Acq92OEc+M9TofXh2QUSrziW9uUJW4tmzIPj/QgBaaHbPeD8pdY8xRwqDvbjEfDLB88
	iDCIwFWbLoUzPGkQZDlHzPaFzj0qmyDLuTi3Q4jm51gQA55TQ4cmVw4UhzmVlGHRFXKASN5DDT8
	0X9lIDcRm1sbK/4bnsb43JDrIokWhtbTGSdsrsyz5zDnmfzXuJ2Fnv/q9jUeTWOD1Wk3c+k7Pi/
	/DH1HBWwVqJwGeqwD8WWbnhKoPDzRy9ILu2lsmwT6u/pXNeOrQ1NeP75e5zBkncOubiEUWarNYE
	76r1ZImrMJHBmhRImDGrG9tkjdRml3fhmQwxNxpOp5FSH6XuCrOkQOpPT6aBY+nCUSuiH7XIYsd
	XUpdagwRA5KJ5rN5WJtKWhF2/ZzaceXQSsCxMAieI63zt/VvNkb2J
X-Received: by 2002:a05:690c:660c:b0:7bd:a4dc:c25b with SMTP id 00721157ae682-7c95d1d6b5cmr262840317b3.40.1779301367479;
        Wed, 20 May 2026 11:22:47 -0700 (PDT)
X-Received: by 2002:a05:690c:660c:b0:7bd:a4dc:c25b with SMTP id 00721157ae682-7c95d1d6b5cmr262840017b3.40.1779301366890;
        Wed, 20 May 2026 11:22:46 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc997be36fsm57274807b3.16.2026.05.20.11.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 11:22:46 -0700 (PDT)
Message-ID: <5e93451665b895d2d9088dacda79683e691e5219.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: Fix return in nilfs_mkdir
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	 <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Hongling Zeng <zenghongling@kylinos.cn>
Date: Wed, 20 May 2026 11:22:45 -0700
In-Reply-To: <20260520101600.19734-1-konishi.ryusuke@gmail.com>
References: <20260520101600.19734-1-konishi.ryusuke@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-20 at 19:15 +0900, Ryusuke Konishi wrote:
> From: Hongling Zeng <zenghongling@kylinos.cn>
>=20
> Return NULL instead of passing zero to ERR_PTR.
>   Fixes smatch warning:
>      - fs/nilfs2/namei.c:261 nilfs_mkdir() warn: passing zero to 'ERR_PTR=
'
>=20
> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dent=
ry *")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please add this to the queue for the next cycle.
>=20
> This is one of the fixes by Hongling Zeng, a patch that individually
> corrects a semantic issue (which is harmless in execution) related to
> the use of the ERR_PTR macro that arose from a recent VFS change.
>=20
> Thanks,
> Ryusuke Konishi
>=20
>  fs/nilfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 40ac679ec56e..e2fe95de3d71 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -258,7 +258,7 @@ static struct dentry *nilfs_mkdir(struct mnt_idmap *i=
dmap, struct inode *dir,
>  	else
>  		nilfs_transaction_abort(dir->i_sb);
> =20
> -	return ERR_PTR(err);
> +	return err ? ERR_PTR(err) : NULL;
> =20
>  out_fail:
>  	drop_nlink(inode);

Applied.

Thanks,
Slava.

