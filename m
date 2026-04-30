Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC602D7814
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Apr 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777572710; cv=none; b=gfNi+tu8ynphIzbbH0xDjW94FqCh79kdJu0ZMuoFHuxuKx5GP5AthslFESQoH/FQy/JjsSM0eu538JibHO7NovVozR7Azl6WH2FZiQvCdRCEouoJh5842yOAtunOLBtRCvinOIYAiTaELIdlV0AWYY4+2vw4Vo52u5qavUOjlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777572710; c=relaxed/simple;
	bh=gQzIxcSxyvmzQKisxCRYc/QwhGs1vo24eOUTTDHgv8E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RBv9vSeJCOScYrZsNbHKALzQGyZLGKOqSZJgcqvmgWgVitooOO6/jfDasld29AZr4kNm0fglutCvpUcgHsOhWhzgfuFhV/SZIq8x7WTjUTQAEwCt3+rxt1sa5+mTZKQhmdSYa7gY4KiCQ7la3zX+Q9zYpcwkyHw3eDPgTioW1kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAMYNzlg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZlvGqInO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAMYNzlg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZlvGqInO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777572708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1Whz6JpMQNNVhu6Dh4cuj5tfSFS3tpn/UV4LHkcCn0=;
	b=NAMYNzlgntPOq52za1sJMlBZ2ebGBjp5L00jK7NfMk+EJQHZp+Fwl8dGS6QImGWqsNwOO2
	X2WUxscWJUSrHdgMUf6yrT7Zr97Tg0W28jUi9tzvfvp71AFg+edd84ZrbuEFET224BkJ1S
	HRYuBez8qGzITvl/2Y8LaGIN+lixbzU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-W1eTew81NPGa2aY6-XAkng-1; Thu, 30 Apr 2026 14:11:46 -0400
X-MC-Unique: W1eTew81NPGa2aY6-XAkng-1
X-Mimecast-MFC-AGG-ID: W1eTew81NPGa2aY6-XAkng_1777572706
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7b3e41a97f0so22052577b3.0
        for <linux-nilfs@vger.kernel.org>; Thu, 30 Apr 2026 11:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777572706; x=1778177506; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W1Whz6JpMQNNVhu6Dh4cuj5tfSFS3tpn/UV4LHkcCn0=;
        b=ZlvGqInOeLThxWAhEuc+p+raJDiJox/1MFDzfJyHtWYDOf71V4DtyM+8Aw4dTCCjHC
         34b9G8oQOD+N8YEyz1vonIqQwGvKr35ENDnpLjN5+vZ+N/1Pj4Buqo8AJIIcHRyz6qcR
         UzU4sah0wvXjeiLw0Qq0AasHZ/FoAO6tHYVCNvy+8C+LW+8SeZVc8AaPq3Gchjy7irVE
         PODdWESAQmkepcBhNVEejtSOXCHYBTutGGaHk5LKNB4XqkdA1oJ4LYpdSq5WSi/VUVhR
         qAtaQxlzpDfNLYlcitxarTyKzVcINeFtxTPk0R5lAEt3kCm/S8I5UmSo9lWJmKtzsluM
         MB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777572706; x=1778177506;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1Whz6JpMQNNVhu6Dh4cuj5tfSFS3tpn/UV4LHkcCn0=;
        b=pHGzCkF72iH5XdVPfUxaL0uUEMH6+J3ZznMa4NG8eRCuYTSFe1g14f3R1sWuPjgtdB
         OVN8IcIYdMA87PS4W7yxfl2Ke8SG5lmIRg9F2NULMU5TJ234Yk1PWNTFdgBqh37mv9sI
         85N9oyKEDWzcLxVWzNoKlHbju0ZFyRP4KSQtG2TqckGFPbgXL1qfNL5CSH3NFUPtw4/L
         ckdXR10KjLbTIV8ji+kCETshAxqFlT+KBY9jLXUqrRC6iVOGFik4cWhJCCbQHnQFnfig
         DM/Qs3f7+t5AqH3E8HXsT1c5Tj1LKFRRS+cDqpxSbAsPNX28jg1lKsXyxKJIKK/g+xrf
         NVPQ==
X-Gm-Message-State: AOJu0Yw5DiAVCjN/s9ZC/0zTm2X9Y6KRzfiLZQyAyth1Uw1U7zIJqpdS
	nicwKzmhl4WFWhrydvFOj6DugR/kdvpdIZECS30tbybzBFehjpOMflk8FzmKWnYdJor8Sq1LqZO
	GKL5d2YsEQFZmPnnDHxa+kRsqjVR3kkTFE7V3gEMAJhc0xYXY7DpZHkaCYzf9Rs1eoYBJQNiF
X-Gm-Gg: AeBDievtK1G5CrwEGPYP1zifB6wulIH4jaWPd3mw7h0+bUzACwGwt6M8v0x6poAJUo8
	Lgbke9kvtdukrJQuSokkOdJ36anixsdydRp4B79us4IuSlV2AAFMWinBWSuVjZllUPWHl9nsGFf
	97HpX1LBACfJvWKt5poOb11ur830DzPywraU64iJyWP4oCkqwE6SY3OtVNHqFSstGbw5VrAwYC2
	Ox9OvmcW+x3Mj6rS1RwtovZv7MLbhpWbz1YQ25nuCDt8pTnpN/ig3rie0WGZocpay5R0yrThMBU
	D/NbLzft7Wt3UGChM58HpPnQLb47qoakgJQnROvA1K4baFeyNNwOjMgraNGp/9/8QgFKTtHJKVW
	5G1ewNE7jnx2iS4yHqMe91SbKuZfKjUOV74eQm0l/IbNThlJfhVLCyU4xcJ24kKw=
X-Received: by 2002:a05:690c:660d:b0:79a:dae4:5832 with SMTP id 00721157ae682-7bd52892ec7mr42941157b3.22.1777572705782;
        Thu, 30 Apr 2026 11:11:45 -0700 (PDT)
X-Received: by 2002:a05:690c:660d:b0:79a:dae4:5832 with SMTP id 00721157ae682-7bd52892ec7mr42940677b3.22.1777572705281;
        Thu, 30 Apr 2026 11:11:45 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6683836asm556967b3.25.2026.04.30.11.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 11:11:44 -0700 (PDT)
Message-ID: <eea194aa0f8734f38fa645db935aca47175bdf17.camel@redhat.com>
Subject: Re: [PATCH v3] nilfs2: reject CLEAN_SEGMENTS ioctl with
 out-of-range segment numbers
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>, konishi.ryusuke@gmail.com, 
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Date: Thu, 30 Apr 2026 11:11:43 -0700
In-Reply-To: <20260430040704.113622-1-kartikey406@gmail.com>
References: <20260430040704.113622-1-kartikey406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-04-30 at 09:37 +0530, Deepanshu Kartikey wrote:
> Syzbot reported a hung task in nilfs_transaction_begin() where multiple
> tasks performing chmod() on a nilfs2 mount blocked for over 143 seconds
> waiting to acquire ns_segctor_sem for read:
>=20
>   INFO: task syz.0.17:5918 blocked for more than 143 seconds.
>   Call Trace:
>    schedule+0x164/0x360
>    rwsem_down_read_slowpath+0x6d9/0x940
>    down_read+0x99/0x2e0
>    nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
>    nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
>    notify_change+0xc1a/0xf40
>    chmod_common+0x273/0x4a0
>    do_fchmodat+0x12d/0x230
>=20
> The writer holding ns_segctor_sem was a concurrent=20
> NILFS_IOCTL_CLEAN_SEGMENTS caller, stuck inside printk while emitting=20
> per-element warnings from nilfs_sufile_updatev():
>=20
>    __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
>    nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
>    nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
>    nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
>    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
>    nilfs_segctor_do_construct+0x1f55/0x76c0
>    nilfs_clean_segments+0x3bd/0xa50
>    nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
>    nilfs_ioctl+0x261f/0x2780
>=20
> The root cause is that user-supplied segment numbers are not validated
> before nilfs_clean_segments() begins doing work; the range check on
> each segnum is performed deep inside the call chain by
> nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
> while still holding the segctor lock and the sufile mi_sem.  Under load
> (repeated invocations across multiple mounts saturating the global
> printk path), the cumulative printk latency keeps ns_segctor_sem held
> long enough to trip the hung_task watchdog, blocking concurrent
> operations such as chmod() that need ns_segctor_sem for read.
>=20
> Fix by validating the contents of kbufs[4] in nilfs_clean_segments()
> immediately after acquiring ns_segctor_sem via nilfs_transaction_lock().
> Holding ns_segctor_sem serializes the check against
> nilfs_ioctl_resize(), which can modify ns_nsegments, so the validation
> uses a consistent value.  Out-of-range segment numbers are rejected
> with -EINVAL before any segment-cleaning work begins, so the bad
> entries never reach the per-element diagnostic path inside
> nilfs_sufile_updatev().
>=20
> Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3bbd7
> Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_segm=
ents ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v3:
>   - Move validation from nilfs_ioctl_clean_segments() into
>     nilfs_clean_segments(), under ns_segctor_sem held for write
>     by nilfs_transaction_lock(), to serialize against
>     nilfs_ioctl_resize() which can modify ns_nsegments
>     (Ryusuke Konishi)
>   - Introduce local variables segnumv and nfreesegs for readability,
>     rather than open-coding casts of kbufs[4] (Ryusuke Konishi)
>   - Emit nilfs_err() once on the first out-of-range segnum and bail
>     out, instead of nilfs_warn() per element (Ryusuke Konishi)
>   - Add bail_unlock label for the early-failure path, parallel to
>     the existing out_unlock structure (Ryusuke Konishi)
>=20
> Changes in v2:
>   - Reuse existing 'n' loop variable instead of introducing a new
>     one (Slava Dubeyko)
>   - Add dedicated out_free_segnums label so the validation-failure
>     path falls through the existing cleanup ladder rather than
>     duplicating kfree(kbufs[4]) inline (Slava Dubeyko)
> ---
>  fs/nilfs2/segment.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 1491a4d4b1e1..dc54643866ce 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2512,12 +2512,33 @@ int nilfs_clean_segments(struct super_block *sb, =
struct nilfs_argv *argv,
>  	struct nilfs_sc_info *sci =3D nilfs->ns_writer;
>  	struct nilfs_transaction_info ti;
>  	int err;

Usually, I prefer to keep the err variable at the end of declarations. Beca=
use,
it is the ending state of the function. And I am feeling that something is =
wrong
every time when likewise variable is hidden inside of declaration list. :) =
There
is nothing critical in my remark. But anyway... :)

The path looks good to me.

Thanks,
Slava.

> +	size_t i, nfreesegs =3D argv[4].v_nmembs;
> +	__u64 *segnumv =3D kbufs[4];
> =20
>  	if (unlikely(!sci))
>  		return -EROFS;
> =20
>  	nilfs_transaction_lock(sb, &ti, 1);
> =20
> +	/*
> +	 * Validate segment numbers under ns_segctor_sem (held for write
> +	 * by nilfs_transaction_lock above) so the check is serialized
> +	 * against nilfs_ioctl_resize(), which can modify ns_nsegments.
> +	 * Rejecting bad input here, before any segment-cleaning work
> +	 * begins, avoids the per-element diagnostic path inside
> +	 * nilfs_sufile_updatev() that would otherwise run under this
> +	 * same lock and stall concurrent readers.
> +	 */
> +	for (i =3D 0; i < nfreesegs; i++) {
> +		if (segnumv[i] >=3D nilfs->ns_nsegments) {
> +			nilfs_err(sb,
> +				 "Segment number %llu to be freed is out of range",
> +				 (unsigned long long)segnumv[i]);
> +			err =3D -EINVAL;
> +			goto bail_unlock;
> +		}
> +	}
> +
>  	err =3D nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
>  	if (unlikely(err))
>  		goto out_unlock;
> @@ -2558,6 +2579,7 @@ int nilfs_clean_segments(struct super_block *sb, st=
ruct nilfs_argv *argv,
>  	sci->sc_freesegs =3D NULL;
>  	sci->sc_nfreesegs =3D 0;
>  	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
> + bail_unlock:
>  	nilfs_transaction_unlock(sb);
>  	return err;
>  }

