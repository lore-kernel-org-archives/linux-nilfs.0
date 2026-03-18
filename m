Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CD025C6F9
	for <linux-nilfs@vger.kernel.org>; Wed, 18 Mar 2026 02:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773799841; cv=pass; b=rUHgLmMt3AxQHLCVV6lAT3u6wsocny/yxmwX8NzqkuNMF/gZxQXlOXxRjaQ1c4FTchvvOfAmooTd4yBf+cI+bneIp4FuC43rvyAMSs2qwLabG34bL0GbOrkax6XSwEcJRTtklGkTS+pt+eh6YK+iS/CIPW0/hnLwP7YN68Rkz+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773799841; c=relaxed/simple;
	bh=e0JPB7Ul1862fdYhG1SLzDh5XHxBmHzMGLY8DA06Lyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bNSzK6HsPtUoUgf/ba1YZjLf8k8LPomShCV3AxA4qRZ7Ogb7BsMyHNb/h9OzsZB0aNYX8x5zATH3lTyuABW2pLrYHb/A62IYtrV9qfRUl7ApNPk5wbyNpnC5JW8vZHQkoIPEB2xqK3NaBDngiJ00AsAD/9Era8SWgnpU9H1v8/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/VDxgWa; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/VDxgWa"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a27b65a863so20965e87.0
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 19:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773799838; cv=none;
        d=google.com; s=arc-20240605;
        b=Mql9ddxMjR8syt5yPCJJ0qXF1LMMURZskp0QtICYqE41Bi9eaMpyj80SjyVzfK6mmi
         UkwjGlsiVmCLEY1uzhviUAJOBJTkbogKr3+gDQnxiTAoVPOo4M47887aOp+7ngQH0hTK
         0MPNIvrRJ+ZXDHkppyGpggiMiqN+WRzi+8XlBsBZb8R5WtBRksp4FnDyQc8ZkDmDl4z1
         RJwhHEBQUNFrLjRv+Vee5dHavwvkZoAtrY5SpfHXNJxQOyOgPOFuOKZU/sqPCRsxF6c3
         7/OykkNyGj8ShHqRM5nza44AH6TjwrbvIhT5sD8s3UAfSbvGKl2go5+00Qgmg4ciVYf0
         3z/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZydEE/IaRmaswQKiT61pFyFMU/Uk9V8y3kVXUM+9TD4=;
        fh=o8KZt8/6hNsdXi/bq49sbDX2ky2ggLUS1drBCwU4z5w=;
        b=OWR3c2V1gntU94UDHsL2zzeTbpG6pzeWQ4Q3VZZWBJ+1dDr7mr5WHgCbwrFa5lJsjZ
         9vwLRkKOf4gTPp17n09pg29bqq7dNYy47lxYWMG/aDiy9ABJHK3xilUY1tDto1dRA/oa
         Yvc4sfHvcA4mPgbEHDloGJ7YMV7Do9gj+WKLXc9jSApigYCpz4ia+SwBPSQODsBaTATl
         DEf61JRG+X5WHo+0a2UDDQmhszW27/XIQ4CTDdYL95mgEdzXlQi4CxkTRMlyCNy7If+9
         vMGreB8Ep9ZvabIDNYxuz6clIZlrq2Hm20I+QHuCRFJg4nJjkyntHf4ru96RynlxWDUj
         ELPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773799838; x=1774404638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZydEE/IaRmaswQKiT61pFyFMU/Uk9V8y3kVXUM+9TD4=;
        b=K/VDxgWasyuC8kaH8KT5wc95qaU17hrZQH4VuBFPx/03QZ7IFXiG/xzsGCxECUN6V/
         I7C9LqM2iR0+KqjPn2N3Rr4j99tKP7PiNBDP3nIROKaTVguSUo1ihOtlz/RdsJ8LSfrr
         yMb23FFmHxQNVkf3tGgRPD+W1Lyz9QKm0Qipv9P/nUQzraLDQ3nVRKZHIYCHUQ8UYZCx
         AddTJoW9103qb76lywBdIQc09dhWtYpzpkFWSa3WTHmBtPi0mVs8pqx3HOTpOzdkh6Nb
         J+/r6RjYkRxeIbmtYe07dUcXHOdU06PUGBv+WLzMSxBLwMUOhW9MHh7jQWsEYT091gAL
         tN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773799838; x=1774404638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZydEE/IaRmaswQKiT61pFyFMU/Uk9V8y3kVXUM+9TD4=;
        b=pU0GUyeMfyAncfi8bh7eIjuiZgy/EdmVMby8P2QipDrrhTvnOc87BwhQw0GU1GStLQ
         s8v3ug/1yVOXsEdOvmfo3CaypN6TGIJmvGIkHYHdVJq9qzjTcYSzRwnKeHhb5hKyAXtW
         r/lWNlleXkcXNHlwzMMPGLc1OrT4WjRoWrkFXO8wQWbRgH3QKWtT98bWb0fsiucvXxDQ
         flrShm/G/a7/XRqqejkKn+pj6mvo6DO1INzAIydzC3b/BUotMSz0NvLAPQ20zsljn4XJ
         W9LQfpL0DdlVmoEn82x7W4nT0FhGq7EbMkaEl4zl4BQVsBDjvR7HloLDcMthpnjlo8CD
         YoDw==
X-Forwarded-Encrypted: i=1; AJvYcCWxdgMC+a71ecOWclsH9jnMTyWh2jF/4j6mKlLy5F6LI7EX5BSMxJe4rg/xe9n5q184ARuhcYHN2HEntw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXBfB2mPqeyjCwirlCpVXXfvcOfhMAMiBCrkISHZgSGLxB4RoE
	NPfH7pm9799SvVagxp3r4qZEJOdNLdBCsNag3bAs99nXL4lGcqA8eZdoRmglKaxLYI/UunQd/x+
	6VtVjMGIHLy2kNoQqRaZbpalpuK+n0PA=
X-Gm-Gg: ATEYQzzV6KPBWJjGttk0yBJ8PJIM/aeIJyWFW58QrsyU70PzqcHLhooXKKzdA7yUEIl
	oOlF7ZLUZKpkLtqCgKAPExG204ozXZ+/LIZpXL5F1Xg3MF5Zoa7ZrGAFrT1Pke9hjVSXtUYBzB+
	PmzuRKEpSmjIOEnT1K7lnQ8C3ia1RWhlsepENgO4z0//5RW/ZXYnCtyYs6PSc9SvOptNh5woIOL
	3v1hX3jBFVmgJme6Jq/C5iKhXMGsPacyARcvoGrMYJrWKXaVsZ+CXLH9SN1/oew+kxzaQgiUPzF
	j4Iu8MYq
X-Received: by 2002:a05:6512:1597:b0:59e:65ff:1e8c with SMTP id
 2adb3069b0e04-5a2796c33e1mr718677e87.21.1773799837613; Tue, 17 Mar 2026
 19:10:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317090109.878401-1-kartikey406@gmail.com>
In-Reply-To: <20260317090109.878401-1-kartikey406@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 18 Mar 2026 11:10:21 +0900
X-Gm-Features: AaiRm51U9uMDuPFqmSR1A2ydV9tEyqPaHqmx8QDMY3XbWWFfyQ3bE3HdGi2p8rM
Message-ID: <CAKFNMo=eqZDh3zEWX2Vyi853Hz8JdUJ7_kAqQbFcJfsS7Ld0Cg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: slava@dubeyko.com, akpm@linux-foundation.org, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 6:01=E2=80=AFPM Deepanshu Kartikey wrote:
>
>
> The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
> during btree operations. However, nilfs_mdt_save_to_shadow_map()
> assumes i_assoc_inode is already initialized when copying dirty pages
> to the shadow map during GC.
>
> If NILFS_IOCTL_CLEAN_SEGMENTS is called immediately after mount before
> any btree operation has occurred on the DAT inode, i_assoc_inode is
> NULL leading to a general protection fault.
>
> Fix this by calling nilfs_attach_btree_node_cache() on the DAT inode
> in nilfs_dat_read() at mount time, ensuring i_assoc_inode is always
> initialized before any GC operation can use it.
>
> Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D4b4093b1f24ad789bf37
> Tested-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
> Fixes: e897be17a441 ("nilfs2: fix lockdep warnings in page operations for=
 btree nodes")
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> ---
>  fs/nilfs2/dat.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index 674380837ab9..888dc1831c86 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -524,6 +524,9 @@ int nilfs_dat_read(struct super_block *sb, size_t ent=
ry_size,
>         if (err)
>                 goto failed;
>
> +       err =3D nilfs_attach_btree_node_cache(dat);
> +       if (err)
> +               goto failed;
>         err =3D nilfs_read_inode_common(dat, raw_inode);
>         if (err)
>                 goto failed;
> --
> 2.43.0
>

As I've already answered in a discussion about another patch for the
same issue, I'd like to adopt Deepanshu's patch as the fix for this
issue, after doing a little more review (mainly for error cases) and
testing just to be sure.

This fix pre-allocates inodes for the b-tree node cache and is a
comprehensive stabilization technique that covers multiple potential
cases regarding non-existent b-tree node cache references.  Since DAT
usually starts using b-tree mapping very quickly, I believe this
approach is not overkill and is a practical solution.

Thanks,
Ryusuke Konishi
