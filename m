Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFEB322A2E
	for <linux-nilfs@vger.kernel.org>; Fri,  2 Oct 2026 03:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790913422; cv=pass; b=awfJXeKGKTM0C035LsAuteww0tIR2JxC18bz5D0mb+da/c/A9pY7/tHBHS72D/J6VmL1BBcz+JGxq0cADubfV/xCwfnq8V+0ivnudTcdwjprFXr0lMh3dbLD2DGPqQVcJb5IICwjFS8aLWFq0Dbx2IOZ2PW/bY/jDhD2yd93gyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790913422; c=relaxed/simple;
	bh=o16IJPVWRZbPctbF6Ov13nKhFAjKehId0RQwBENOXP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evrqGZAwGjdBWEO6Pbl0AYHbOomAjiouGdSwhxkhFqeXLvTcnKy9Hh3nP12Vt2B7yat0TL84VVzpNbprXK5wnP7p1SpPlIf2VlR6HJi288FNa3Ich/BIi3cVLw9Pu+sWF5dPWrG0MiASSfMw3Tc0Rc9Y5nJCvevlBhqVB8EXeao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gt9koEn3; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gt9koEn3"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a00d8bec5aso22865095e9.2
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Oct 2026 20:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790913419; cv=none;
        d=google.com; s=arc-20260327;
        b=hLiIOjiaAHTbN9ZM66hQoG6eEt7UA/qlPIQaGlZgdpfGIApEbGmt4C12a3ki6Myq/d
         0o7Go7/CfofBe0AyD7u+B2nuxmCmHRrFcbMU70FI+LRg8osYOIiaeOL4yoQx6XKVbuaP
         dpvGYlD61r7c+vjHZCa6TxudzSeoPOpF8nXae1k9OvNXYAWI0S4lXn6oMK2jjw8F02Oe
         zKbvPXX7WwciXVOZMY/+ItSElFBVra0mzJeiEC0rqHiZnCDLjaYGRuNRpbTi82SS8jcd
         kRAdiJdT0et9X9/5ldM3usWmvD2U2piUDlqnO6r1HmI4JIAe2QFqUzaTF6xEZ+yUCB9s
         NSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0l8CkMr54y0b7W/DIQrVlXnOtMgAg59dAHWQIymno78=;
        fh=Sm3OSXvFCyV7T2xxd3zPsVteGnSzUIeIAKXY7KsRcfY=;
        b=kUgHqZCzZb6BsZ9ZMzmD3K19erBo+QppjFXEq6JAx47Hmmq4Yg2od/oPKjpjqG45jN
         7PpBcLf0/zRjA857njYSUVhUItsY6ahKvaZ3i5Fbf590S73IuULWubWwxu0oLuO80KNN
         +pLpKRSqQ264WT9FNmDTx1+ra9NYmZENK1IBvjT7DvkE+I7navzFzRa0t1ymWy3hPjuY
         jBJeASQkwB52XAzq3EWrFdXZcgvIYvOHGD1B5s0y2+8h7HY1HlMqMHx2unAWTMxpLZbj
         tf8O5U/8W56OefyeU9T33QMGG5/QBLwIT+1J9byX558lGFceK5MNNjG3wXlQDD/177SS
         /bkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790913419; x=1791518219; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0l8CkMr54y0b7W/DIQrVlXnOtMgAg59dAHWQIymno78=;
        b=Gt9koEn3r4Uvbu8YyXTnwAswRRP5px4pptCFrFzeynYO4uXoJu0BajaWTSMSjG1TGJ
         UBvqY8IcZ8MhEjoYOoSapwYtc4TTqIc12aVG+QgSHGtDw84/Ce357dhmL9wAsH+3zlFy
         yyQ4ZgQk9m/WAD4ZneAfqG0gz4BRO2FvHuINDYxk27XW1TbcC3+xVg0ATkvRaNl+yhCv
         hRe51pep4pfUgwSBibCGzEVCfXuYsP49vbErBcUgomtn8/D1AtRe3FMGRYbb2906oDgh
         bkhQPw0lHEelKCiD6neHALfF8n/caO66Y/BCQtnbKXRqPDZtJMcljr92fpMCtO4MQoxS
         /mrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790913419; x=1791518219;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0l8CkMr54y0b7W/DIQrVlXnOtMgAg59dAHWQIymno78=;
        b=MDEmuL5wed2IS+KfP6Lmlhnh4/sMoCYSEHBI+W0MdGEde4EGRVZ4wYaX/LvbIuN8T4
         ipQM2x44NSWVBCOh1b92aIXdwx5s09sR420njZBhHAbuHS55IccxH3an86dBCi4/Uj0m
         haCxWMQow8IQGvmya2tnhH7jthdrZjizOlevIUKVknzsv9P0xYExXpsLVXF4HYqbEn46
         XGAJdE2KM0mk+3r8STzeNQDdAkej1gIxINppDF2CIITiAwGMbydeRJipDNRNIm70AAYz
         YFr1MTm4LTuy0gWTg4Q9CWc7qKzvoe7tEAKuPNMYC/d6KuW/0I5NtC4NtLGK3Ge30Gp7
         3YqA==
X-Forwarded-Encrypted: i=1; AKwUvBwhbs5I/loveANZbe6rwoleKJ1uVhDyI05UldnbaOUCdzSk7b040FTGFn+me/9914eRdbWwFovsy3vKHA==@vger.kernel.org
X-Gm-Message-State: AFuF++n0GQPkKfakVzm+zwqNxAQPd6JOD+zp8TzsbZcDgH32lnspq+XB
	f3p7c5IByyIxz//WYkKz1Na72h3i5kTvUnRBu9LzIV2L64wtl0eisiKywqUZh4vD5mj0VMEEEC+
	2tiELxhv3FHgWFH9daZAniVHIiURoaJviWw3t8nU=
X-Gm-Gg: AYBFou0t25bJsXTdVruBpRZSxJ2IDRtNeKGMEGx4JIx9K8NU/IUY/MJA4Fy+m360qxd
	7qDbO0viJPo+6/i2QWUrCiHZg2oviiWLVV8hKRZoIl8298RNhN2TwQ9D0Hti7vkgSmgaeVuuv+E
	C8VUcR7YLUd4UXdbgxpv7PZ/ff91y4G7AnrLXegzEh9zqd/vS8wy+qJGJho/oKSwiYrKFxnHTvV
	7wrQaGYZpavwujdXHsZwCF+2ueazE4blLNJLA9O+vYXvgSvzbsTklpMsrtKLAfw++30VX+e3oop
	2VrytcBQ6AeS91ntdkdVDdG7q4+mun5V17HzJ0ECu9BfQgHGSlJXbsXnRWqbwPA5Gvg=
X-Received: by 2002:a05:600c:871b:b0:49f:dc71:e609 with SMTP id
 5b1f17b1804b1-4a0276cba9amr23096195e9.20.1790913419123; Thu, 01 Oct 2026
 20:56:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-3-southampton.jake.labelle@gmail.com>
 <CAKFNMok2oRBaSxmRLOs1+g6LWDbDAcstg1myzRjZ=y6t_mf-=w@mail.gmail.com>
 <CAKFNMokQ_iwmSig2PruoncoxqhTNCYrzYSp+KMF=6vMjct12JQ@mail.gmail.com> <CAKFNMokwGHQabG-W-zmo3kwFnYAj5ZJFFNGH6szv7F49gwo3Hg@mail.gmail.com>
In-Reply-To: <CAKFNMokwGHQabG-W-zmo3kwFnYAj5ZJFFNGH6szv7F49gwo3Hg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 Oct 2026 12:56:42 +0900
X-Gm-Features: AclHuK9yIAvyBODapVGqQYB1XGpnByTFnNeDfaJzliHBPGaJnBwTzvZA0YNJHcg
Message-ID: <CAKFNMo=tNBDsQ+uSwHLKYxFF5Txa1d2onDOYNpcimZzEY0V2BQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: validate directory position after llseek
 in readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 10:58=E2=80=AFAM Ryusuke Konishi wrote:
>
> Hi Jake,
>
> I have one additional piece of feedback regarding the commit message
> and code comment that I would like you to reflect in the patch set.
>
> Looking closely at the commit description again, the statement:
>
> "possibly reading past the end of the folio and returning unrelated
> memory contents to userspace."
>
> appears to be inaccurate for the original nilfs_readdir() implementation.
>
> Because the inner loop enforces '(char *)de <=3D limit' before
> processing any entry (where 'limit' is capped at
> 'nilfs_last_byte(inode, n) - NILFS_DIR_REC_LEN(1)'), an unaligned
> pointer that points past 'limit' fails this check and never enters the
> loop.  Therefore, it cannot read past the end of the folio or leak
> out-of-bounds memory contents to userspace.
>
> The actual issue is that an unaligned offset within the valid page
> boundary parses arbitrary bytes inside the folio as a valid
> 'nilfs_dir_entry', returning bogus/corrupted directory entries to
> userspace.
>
> Could you update the commit message to reflect that the bug is parsing
> bogus entries within the folio, rather than out-of-bounds folio
> access?
>
> Similarly, the last sentence of the comment added inside nilfs_readdir():
>
> "otherwise dir_emit() copies name_len bytes from a fake entry, reading
> past the end of the folio."
>
> also has the same inaccuracy.  Could you update that sentence as well?
>  For example:
>
> "otherwise dir_emit() copies name_len bytes from a fake entry,
> returning bogus directory entries to userspace."
>
> Thanks,
> Ryusuke Konishi

Hi Jake,

Sorry for sending multiple emails in a row before hearing back from
you, but I must retract my previous comment regarding the
out-of-bounds access.

While dir_emit() and its underlying VFS actors (e.g.
filldir/filldir64) are designed defensively, looking more closely at
their implementation, the safeguard appears to be incomplete when
dealing with a corrupted 'name_len' (whether that actually triggers a
kernel bug or other issue in practice is unclear, but the point that
an out-of-bounds page access could occur seems correct).

Even though 'de' itself satisfies the '(char *)de <=3D limit' check, an
unaligned entry near the page boundary may have a bogus 'de->name_len'
(for instance, 255).
The verify_dirent_name() helper inside the actor called by dir_emit()
executes memchr() on 'de->name' for that length, which will read past
the mapped page boundary.

So your original description about reading past the end of the
page/folio is correct.
Please disregard my previous email about updating those statements in
the commit message and code comment.

Sorry for any confusion caused!

Thanks,
Ryusuke Konishi
