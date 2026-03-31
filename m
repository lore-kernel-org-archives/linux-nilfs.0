Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC82936C5A1
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 02:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774925969; cv=none; b=ZyG3fgQZYszImi0FH8Cq7FJoIAD+jueJ0DV2qjohGb5oaLar2qQusFZYByJvnc1HZPhnL/ZmkiJMicYl9GQlegJiIcClUHjPC9JrFk81n49OVw0kS4Z+CZ4GEj5m9rilqkY3xr5WG0RQ4JFkUupb7HaPUMJP8rCEUMG9vqQzXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774925969; c=relaxed/simple;
	bh=zNhgUz9ReUGHOQ83EN9pFtwcqQdeke/vCJ+vd+ivkn0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sNKfUbxLaMy6USB1Y6fnxUUjr9ZE+knLA5tgdWXdNP+0TAjN6dKhQUOAwOadI9dCIW/e3kjPPnhHy0Jh2McoUe/bBzLhdURI/wcrE6n0K3PziDsZfjKl54Yl7FEiCa+gM0uA4acZ9DmV/K34Pi43rEoVBE5I205nSOwVUnE0qsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MBmISfNz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LDMZpk7j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBmISfNz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDMZpk7j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774925967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0g6gRYM7q6LCZWMA79d4gm190i5DzNRGgx3Feq2BXc=;
	b=MBmISfNzlGIYplSN6wVcxb3oC1biZpUSrvTnVbPiYaZp7dcriIIaQCTMnEbGYz/zGAqo+r
	hGC5n6iSe33V+ZAWyfkj463hXb/OpducU8jdU7fY3M1lA/r1ZcjPK8rYRrZDok5yO2h/Ol
	7XP0u2PDPRIQX5X2Mp5WQbNU8nQZics=
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com
 [74.125.82.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-DBu17xwsM9216y4nswxanw-1; Mon, 30 Mar 2026 22:59:24 -0400
X-MC-Unique: DBu17xwsM9216y4nswxanw-1
X-Mimecast-MFC-AGG-ID: DBu17xwsM9216y4nswxanw_1774925964
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1275c6fc58aso6460359c88.0
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 19:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774925964; x=1775530764; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E0g6gRYM7q6LCZWMA79d4gm190i5DzNRGgx3Feq2BXc=;
        b=LDMZpk7jO3CqV/8d1bgSbQpFE8Snibzy11vHdGAfUara/84O0Q/d94ytxwjNiYby1G
         74ZlfYp1llsPGi04vlTSmdUxfBGNDazfpCHQqaW1WK6+aFiGzaf7O+pgzslbKUEovExs
         vgpbtktirxoMV7QGhU8IBLmq91fG074LD1Ydv7IvkMpTt8pjd0zUmCrVlHrMaBAplgNy
         eih56lSnTYdYtgGLbjCsVggxK09Ci50KzPXugqm7qFENO8lPwKZT5YWasgsbv7BdoqUk
         z9KH54xatp1Q2DbKnIW/IS7Ub9yky6l561PaBFUhzmoEKP/ttMn0K3JWU3ZxnOgwJbll
         z8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774925964; x=1775530764;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E0g6gRYM7q6LCZWMA79d4gm190i5DzNRGgx3Feq2BXc=;
        b=C98g0DA4FKRlxqQKQz3jeVEiN+aoWSiwRXsVwv+svgOwwEEj0P14j1pQErVqhKYxoR
         GUtCr5zS5XnxTJsB5Hc0oPAzthZiuTJweQiUBPo5em1+JMbca0Fl+EtIWI5htv+PkWC9
         PeLWYOu81J8/HCQgE1PVHiYAzLAm7NpypBFLfeP8QflpbquHsoCViZf4+8QB4R8Lyn5P
         BfkT4vEyV0usOopOH2uVyPXvL0bLu5W7AldrInhT0NbCvy4hOZT6KkaBgUynq9fU/Sw2
         b/v2pLxKslfaeIREB4MUFxyknmdu3KsJkUg+RHq1eLolT0UY8Kv6GMdx1dzU3PsAKaa4
         eqjw==
X-Gm-Message-State: AOJu0YwOMZEfKmpakEbTbb/nuXLOb92fC11i1dOIjV5w0bImsSo89JrR
	8BBUh1+yVeFx2fUmPAwYujjtHmMpaR2f/rP8jrNzcq0JGSf+sM0e2FMfgplpIaXG2Xzvr/GOsMJ
	WNQ+TNYk+0Ur1EDpOef4emso4WJmWuVepFUMJTA38ciznD6RTWc2bC/91Y4q25Z7p
X-Gm-Gg: ATEYQzzKc4TYeqH7nD1qL5y3lryf1FVbMkpCVPb1X/jkCpljm6EX7IT6wcbpfuxGh2I
	WPKtER9Inw1MNB7HZK9EP9fkl/hHdtQF5qAeEWlYv/swiG54DuCAiMezKNdWqyz5DwKgK2kVGMv
	LHibnFJynYarq2Qe+slKU+hU1tZGWtz17JyqhzsqSECAuy7pk56KwUdTNv2z/kPl/whzDyWG4xP
	zaEdCtlWWMZ1xVh0KI7yPP7CVt6YrE36/LGZM52n2XoIrAl01ufZKyihscCJ/P4jheXcQIRbK/x
	4ClXQIdDbsnv9enqjpwxC8LNZ+hxDxIuqrbsqlhA3PXDxCImHL9su7Sg/VqDJ7qJlzJ3jPGoCBf
	ayk4coQAOW9HtKIKjRofNvLut55sPkqMWOgV6t4D2k8WvGiaKMaJC
X-Received: by 2002:a05:7022:f8b:b0:128:bec5:1b37 with SMTP id a92af1059eb24-12ab2877c40mr6788928c88.16.1774925963627;
        Mon, 30 Mar 2026 19:59:23 -0700 (PDT)
X-Received: by 2002:a05:7022:f8b:b0:128:bec5:1b37 with SMTP id a92af1059eb24-12ab2877c40mr6788916c88.16.1774925963105;
        Mon, 30 Mar 2026 19:59:23 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab983f9f3sm13665287c88.10.2026.03.30.19.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 19:59:22 -0700 (PDT)
Message-ID: <5e8a0bd840b83601909186fc908f025fdb946b33.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: fix NULL i_assoc_inode dereference in
 nilfs_mdt_save_to_shadow_map
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	 <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 30 Mar 2026 19:59:21 -0700
In-Reply-To: <20260331004734.25792-1-konishi.ryusuke@gmail.com>
References: <20260331004734.25792-1-konishi.ryusuke@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Tue, 2026-03-31 at 09:47 +0900, Ryusuke Konishi wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>=20
> The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
> during btree operations. However, nilfs_mdt_save_to_shadow_map()
> assumes i_assoc_inode is already initialized when copying dirty pages
> to the shadow map during GC.
>=20
> If NILFS_IOCTL_CLEAN_SEGMENTS is called immediately after mount before
> any btree operation has occurred on the DAT inode, i_assoc_inode is
> NULL leading to a general protection fault.
>=20
> Fix this by calling nilfs_attach_btree_node_cache() on the DAT inode
> in nilfs_dat_read() at mount time, ensuring i_assoc_inode is always
> initialized before any GC operation can use it.
>=20
> Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D4b4093b1f24ad789bf37
> Tested-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
> Fixes: e897be17a441 ("nilfs2: fix lockdep warnings in page operations for=
 btree nodes")
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> Hi Viacheslav,
>=20
> Please queue this patch first.
>=20
> It fixes a potential NULL pointer dereference defect that could be
> triggered (likely most cases are intentionally) via the GC ioctl.
>=20
> Thanks,
> Ryusuke Konishi
>=20
>  fs/nilfs2/dat.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index 674380837ab9..888dc1831c86 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -524,6 +524,9 @@ int nilfs_dat_read(struct super_block *sb, size_t ent=
ry_size,
>  	if (err)
>  		goto failed;
> =20
> +	err =3D nilfs_attach_btree_node_cache(dat);
> +	if (err)
> +		goto failed;
>  	err =3D nilfs_read_inode_common(dat, raw_inode);
>  	if (err)
>  		goto failed;

Applied on for-next branch of NILFS2 git tree.

Thanks,
Slava.

