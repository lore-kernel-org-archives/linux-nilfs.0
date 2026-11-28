Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795855383;
	b=XjmR+filBF2jQSqJ3lcwP6P+jTu6RtQUHaZ6hWkM+umqhUtkp/BF3VSddON9SerUwkC9
	 GVyhzm25DoFChw/fHjQnffHylJrc5Ojr1Kxa2gpc/55Alr6Ji47LJgLONCxKBRSTIWVr+
	 +4W8pjddyASkP1Qc6EmxvDZKZnKM4L2qj53yQ4Qpq80CkmGNg07zWETsug6bwnrV0r6NM
	 WqGF28wihxPKk1bII+GmMHEzAIcxaAqBfHUVAieXrSrZmOH33zm9YPsSnhBWJPjnjtnXm
	 88/pQBByEivzd+e3ZfLA14WiWXhcNANPzbW90EEK8iX1DpaWUVSJDYOwf7s7THL8KuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795855383;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=/vmNzAXY2gPKYfBH/ZGOV4RzlGajhNF0O8LgH4vrbKg=;
	b=CqoPn5tXIyvCyiP6+ICUyuvukVA4/MzKz0Urd3QjmpGiByzCvNyKqgBRpyyYs7EtUto2
	 oscP3nBhOpC/Wu6KcC/522jedjK42rSLNiC1tMWWdzajf/O69niu0+d0998DMnJfEatK9
	 eGH3tQ+9a3jdl5/UhpenwKFpspuZMZtsfWYi+g486K6Ys5HXVmnpm8hifjrfq1fkRLOB4
	 Umif/qsnUKfdoOxkYV7asSwhAFhD2BbNcripFeWZJeTgbwUOwnEyRnZVm+phDmYcQzoN8
	 zX71UVxB+i5OxoQ/odRy76dBAXrGGONa5IwnL2jApc6Zt6P69pIPLSTmXd6QC5lu/3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bFiFctjD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C91606A31C
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Nov 2026 08:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72C91606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bFiFctjD
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4b467581b98so84013415e9.0
        for <linux-nilfs@vger.kernel.org>; Sat, 28 Nov 2026 00:43:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795855382; cv=none;
        d=google.com; s=arc-20260327;
        b=WiP+CxdJNexYTtDZVqthMpYmeOVaAjMxpppcKzIDlKISNV2lIcLxgEJ7nqkr2/ZUJq
         EOTwrP6Rs1z1oOo6mzTyGR6TuGGsJavjRQDPFMhpG5yjzjbnD+v+iZ9VzkbO6wjdEu/U
         hUa7q1MOHewMKcdou8/FdUOz621L2yarighZ7wNrQNIsejaXRL4u3vHTyvIW7rRnKSK0
         92d9jyztoxMZj4MNDcmJZLsYsHhC/dYeogpm/HArKwr+XqU6zEkD6hl4lzXI3WbhhBS+
         sMY8gvcjvnZpPjsWtn95XwLkc3r6y0WMJq6KOPhO+ArUsz3bEn8Qmjvdc4AYar7DMgBe
         K+6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/vmNzAXY2gPKYfBH/ZGOV4RzlGajhNF0O8LgH4vrbKg=;
        fh=PmE/GkxI+SYHl669VQz4b2ouKjIkJ/hRsCKO1SqCqKo=;
        b=VXKU/N8uSI6usW35yYEbIzFNVoImae6v3/0ftdpG63XbxigdpbWKfz+W3QLmRaQrBL
         39B3cXJ+i4zNZfgG9tmc4I+OhVtIQ4HAvyGstuiz/DjxJJc4yxZ42p6Vk7qp4v88REvO
         k0ktK+6pLKmOcaCJ+jwKpdtE3Bqsg4gl4/wDURLKzJXTPly5LapAbD5IpvkVidKxILn9
         e52Ce1Vn7JlfldG5DiRD4mAPnCOzbKEaa6aWD4uO8/Jv0ty+awvKfgllG0uOHGD15v90
         0lPZk4XMTgusIS9nnsK0IXb3wIRBoyV50wwU9im8I6UevUZIXM+62cVWE8Z3NGLaEwBS
         J4Wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795855382; x=1796460182; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/vmNzAXY2gPKYfBH/ZGOV4RzlGajhNF0O8LgH4vrbKg=;
        b=bFiFctjDD3KDaxnkrgf4Kq+/MDop5h1eEMg41J6ZiF83+lPPts55hdVdx7nKoTF6LM
         CLXvQJc2NEnl18PjieRjVqMFIS2rT0/i7kQcgVyPIy1Mgatu/vHHfsG3dQQ1TJU8JFmD
         jQp7W7XOlkqmJDpAZFCpwE0u7DDfWYROY1AyyOk0qVxvCdDPegZtUTW7ljEy53Kdszqy
         h/YTGC+qcRBc59ugfID4di4klCBax7bLqBWmiHjlSfVAm+ctU6S8XlKqAuqnwMyoVnR7
         RePk7f3qWuTIrU+K/y8ClcORPwZq/U9JT/oPn+3PwYGDELxlPPYzcQjQL5+RD/FkymE8
         I+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795855382; x=1796460182;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vmNzAXY2gPKYfBH/ZGOV4RzlGajhNF0O8LgH4vrbKg=;
        b=SXNBcDH0hlRONXtmu0nxXMPSbxsNRqMfXbmPCiJRbAmIqnfcl0NOPd3F3pA/DXwnUq
         ZUXLo3DmvBh1ZrEMGdCqrHn+5Yr+vNGUkiPsLSr2/0abnlutvFCiY2IQVIkdp7CwmSVk
         NMddJWA5irK/fB5L3WYb2m4OwgpX3SJdD+O/PrOz7tknuT2pTjnZdzA0FxgF2/VuB61r
         qkJJHHxnGA8ektRZrLDGh9y0pvAhcSzHF5NH7ckj1gnimCuax1xRU6Dn1POBEyCJLM4q
         sPnCMjPLlgcke6QKbtIngUVHQ6ESPdhzpKRaO56l2T9sMDh9LnL7kvTdjFUPy4e1b2Pf
         5big==
X-Gm-Message-State: APuU4Z+b1RrGR4TAzDE9SEo3/JGQhoIK7Lgmal47cVyginNF+KnL7Cdp
	83lbY4Gyei4gBcrJVbGiG/Yk6Nrft7HrYco4a906Y5d793LMER9Q+4UcyAmaPr69xwxOiDMKgbt
	DodWtii6T+XzchZsf+KwHHp+OPOprJNM=
X-Gm-Gg: AZFdTZeRZiBPOvsIDDm4WR7h4e5g0ZkmerAlhCoX1JsCaAulpeSc84JqrSEHGb+GRAm
	WN3qPGri9ud1QnFYQh6Uz1Q3csY+eiq3QnGgLbg/0NuocDGmGSI2ccMiQMfSABGyGC4Orckt7YY
	r/9GomrMN+2uumY4oKxh5dkiCrp4kEtubQ/LEi20n9uSS++2Pg+uLeRAJJlQDcKM5jRiG+JmRPZ
	UtJt3K4r0mF5oFVpsLrEq1/R7k+e6CAsL45oUlfkr7+kIlU1hvdWumkfXJCAVp6SThyfEYb33g5
	fLUkqKGsuIKQHTkixZr1YYT+Hp/BHyMEVPgB4VSEbQVRtKV9GF67dh6ybv42NlhN7faFQbl/gcZ
	Nr6kO0kUGsLJigf0+okuv9o6V63wqQufl7janBw==
X-Received: by 2002:a05:600c:1d0a:b0:4bb:840c:72f2 with SMTP id
 5b1f17b1804b1-4bb889323a1mr532900045e9.25.1795855381671; Sat, 28 Nov 2026
 00:43:01 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <0ee434a194ce4d8090007b8082a3667d.1@linux-foundation.org>
In-Reply-To: <0ee434a194ce4d8090007b8082a3667d.1@linux-foundation.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 28 Nov 2026 17:42:41 +0900
X-Gm-Features: Aa3M54oZrBkaXieZ8pTV_wGg4WETpwZAJTEdOD4TS3FoJpXJj-9qxETXVRC5cLk
Message-ID: <CAKFNMo=NT6Zxz+k31pncas++nu4EkbUT=kK_afPWjZFH3yCPzg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: report mapping errors from fsync()
To: Viacheslav Dubeyko <slava@dubeyko.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 3:27=E2=80=AFPM Andrew Morton wrote:
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: nilfs2: report mapping errors from fsync()
> Date: Sun, 22 Nov 2026 17:23:26 -0800
>
> nilfs_sync_file() constructs a segment and flushes the device, but never
> looks at the error state of the file's mapping.  Nothing else in nilfs2
> does either.  So an error which was recorded with mapping_set_error() is
> never reported to the application.
>
> memory_failure() records -EIO that way when it has to discard a dirty
> page-cache page.  On other filesystems the next fsync() then fails with
> EIO, which is how the application learns that data it wrote has been
> lost.  On nilfs2 fsync() returns 0.  The memory-failure selftest, once it
> checks for this, fails on nilfs2 in 20 of 20 runs:
>
>   memory-failure.c:413:dirty_pagecache:Expected fsync(fd) (0) =3D=3D -1 (=
-1)
>
> Call file_check_and_advance_wb_err() in nilfs_sync_file().  Call it even
> when segment construction or the flush has failed, so that the recorded
> error is consumed for this file either way, and return it if nothing
> failed earlier.
>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: Viacheslav Dubeyko <slava@dubeyko.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
>
>  fs/nilfs2/file.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> --- a/fs/nilfs2/file.c~nilfs2-report-mapping-errors-from-fsync
> +++ a/fs/nilfs2/file.c
> @@ -29,7 +29,7 @@ int nilfs_sync_file(struct file *file, l
>          */
>         struct the_nilfs *nilfs;
>         struct inode *inode =3D file->f_mapping->host;
> -       int err =3D 0;
> +       int err =3D 0, wb_err;
>
>         if (nilfs_inode_dirty(inode)) {
>                 if (datasync)
> @@ -43,6 +43,15 @@ int nilfs_sync_file(struct file *file, l
>         if (!err)
>                 err =3D nilfs_flush_device(nilfs);
>
> +       /*
> +        * Report an error which was recorded in the mapping, for example=
 by
> +        * memory_failure() on a dirty page.  Check even if the above fai=
led,
> +        * so that the error is consumed for this file.
> +        */
> +       wb_err =3D file_check_and_advance_wb_err(file);
> +       if (!err)
> +               err =3D wb_err;
> +
>         return err;
>  }

Thank you, Andrew.  Looks good to me.

Viacheslav, could you please pick this up directly into the nilfs2 tree?
Here is my Ack:

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
