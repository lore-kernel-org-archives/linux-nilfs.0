Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D73B33F8B7
	for <linux-nilfs@vger.kernel.org>; Mon,  4 May 2026 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929304; cv=none; b=OKKimo1WBtvR5gYGuANtjCJ/OYeZa1YNE1V7kFsN8CRH/lk0OJArjxw4RJ8DYm1rMHx8gqFScXjKTd7FvkyGKoU3Rn1WRj2upe2l7aO6ltWv5A0Rp+ALs/ZAOYZEuysLNFs+Wkhvw04LMTWh931sqnQNIiWz35SeJRCggFn+KBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929304; c=relaxed/simple;
	bh=PM+hkaHZgCfqdEFmSA7FEQ2xqIO9Evw2ShqX/sHT/Gg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qOOhGXLjTsipmCGBvOxJThg9WBKk0ptt1S3EAWS0E7cIUxJFj41Aw664d4TNcA+hR5K3UOVrOixPnNB/jwClCYPwWdioGZLmqud/xb/17ariG+U3e5dyWAWBFqwudlW4rmO28VVwvCtzkdPWEVI8solJ5FZoXB/Njl08OUeOB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLP0Ro4+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l1J55siL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLP0Ro4+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l1J55siL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777929300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gxvw3Qdk6v8FuJouRyKgQWLX6q4jluWaAR8BxfLyUoI=;
	b=NLP0Ro4+eCDZMxh7obybpLS4ACc8nFAfZGiNXWLalq0PJ1eHhUlJNMaVuxE6b+FgoGin5p
	DfegbicfsI2WHSpNyX0vXnelcbUK9FDRS1zbrHcdNVemdp6z+9zlVviBkxMWSE8p/yQROn
	B2egLLFRgNQVu9eR4mpbxwPGSflhWWs=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-g6vk9r9CPcKllJJKonOtdA-1; Mon, 04 May 2026 17:14:58 -0400
X-MC-Unique: g6vk9r9CPcKllJJKonOtdA-1
X-Mimecast-MFC-AGG-ID: g6vk9r9CPcKllJJKonOtdA_1777929298
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7b3e41a97f0so76954117b3.0
        for <linux-nilfs@vger.kernel.org>; Mon, 04 May 2026 14:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777929298; x=1778534098; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gxvw3Qdk6v8FuJouRyKgQWLX6q4jluWaAR8BxfLyUoI=;
        b=l1J55siLZnylBAL2PGKThkEk25gL+R5c0LIrtqoIxnWfRlasO89NTEo0BSFGOkbleq
         SqVazeSNWoIcskJO6Pm8vA9Uo8dSJpVbGxSEVwWomnhdScvmeba/yyAWJOMgVOcEvH4e
         YJ3jGlLbR6N+IV7NaMMrt+Lnh3EutGXnkduEd3zEwi9onYL6NW2i5VbfMUuAFHyoYkqO
         7+2tXEpb0iC9aEeBSDhJCdRTPbXbhrwxhuBw6SyAtreMSWdDijUSAPXjZbA/sQGKoT+a
         h6FP1UBlsweyKa/8QBtOrPOG9+KzsujpsqugAllA+UWAbBBsVCGr+qvSMm/mjlcOuEjq
         +GfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929298; x=1778534098;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gxvw3Qdk6v8FuJouRyKgQWLX6q4jluWaAR8BxfLyUoI=;
        b=M4NuxJFP58FmF7T7POfTRcN/Lp5Zy5VvMbb3J6h91Z7uhCJ0W16tGNcq9Oi00INJzm
         Yy27hA7BgCJo+x3v9c2jYIUCjWZhxs5the3PlrzJmPrFpe4xGEi9tDbAUFAOP/ntEcCW
         SnxKBRV2QWdqpihu8cnQJtDrt7AkbCZAs77dG7tsGn5P4X1+oIifziazGj2+T4ms06yD
         x3tBE+cau4lGLB4bAGH4ov00pTqCjG/BW/uejT9b4SeOAYIael3/zoswChlAktlJoEFa
         lGBmxjMqTkMjSou/Egki4/KyHnEG2rnoSo//JuPYLACyuYX02UZNGwEeL8k22KU9wB+P
         15Xg==
X-Gm-Message-State: AOJu0Yz5XmvNcPfMzx8k2Yz3cy0n99B+ePJBXcNtGLKIvZPI8DHXlQtn
	1L/viAptXRKt5HwmZomnpqWfsQkgHtYjEh5VM/9CsoADxRMf9C3dm2QjW5GXAlJcyHDvUg8kD6j
	KbLvwiFdccHhAn336dHFwtUlJZWlKehMVMXRZBJ8PzCwnkQwhJJlWFNu/V7vSZbqo
X-Gm-Gg: AeBDietQ1nENlwX7HCNLRH0rfUkLWxU2tTE0uma+FYW0a99R8SyPdtsIZvUorRkYbwX
	CNQt9TTI1iAn9uOCFaQu5saGMUBwH9ZVjG2i3hj50EcMtE6t4hnMbILvxiB8YIcYa/wI+j8Hr/2
	DVq8r+l9M67WegCVMprdyApRXH1FQAdBbW7l+m+p1iL5qa2A819bXwy5DokrZJhLSsyicmT0ptO
	F/zsPPsiKQSJZ3d4TG5LkF4V09L0IxJWRlXi8ZuEkeoZ8MCtDaTDbabpw+ECbpeTXtV1po6dnfl
	rClgw4LjDkNQKGW/WUohGF9+Vv3/R4CfD26YXGYrTVmebHSRt++8/R+Pdtae3zvTmYjnB6EcAjk
	FbMwAEMrMq6wMWp84EK0JEzhN0jHAzQ23O/2Df938aFBdkIM2nxmHJXwQSMAgcCw=
X-Received: by 2002:a05:690c:9517:b0:7b8:8d3c:17b7 with SMTP id 00721157ae682-7bd7712831emr102769437b3.42.1777929298242;
        Mon, 04 May 2026 14:14:58 -0700 (PDT)
X-Received: by 2002:a05:690c:9517:b0:7b8:8d3c:17b7 with SMTP id 00721157ae682-7bd7712831emr102769167b3.42.1777929297760;
        Mon, 04 May 2026 14:14:57 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66838851sm54759867b3.23.2026.05.04.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:14:57 -0700 (PDT)
Message-ID: <f67314c205d1418cd0abd1bbd74fc76857309cbe.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	 <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 04 May 2026 14:14:56 -0700
In-Reply-To: <20260503043357.7031-1-konishi.ryusuke@gmail.com>
References: <20260503043357.7031-1-konishi.ryusuke@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-05-03 at 13:33 +0900, Ryusuke Konishi wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>=20
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
> The writer holding ns_segctor_sem was a concurrent
> NILFS_IOCTL_CLEAN_SEGMENTS caller, stuck inside printk while emitting
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
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> Fixes: 071cb4b81987 ("nilfs2: eliminate removal list of segments")
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please queue this patch.
>=20
> This is a fix by Deepanshu that addresses the problem recently
> detected by syzbot, a hang-up that can occur when GC ioctl parameters
> are invalid (this time, when a segment number to be freed is
> out-of-range).
>=20
> Thanks,
> Ryusuke Konishi
>=20
>  fs/nilfs2/segment.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 1491a4d4b1e1..9332f5ac6083 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2512,12 +2512,33 @@ int nilfs_clean_segments(struct super_block *sb, =
struct nilfs_argv *argv,
>  	struct nilfs_sc_info *sci =3D nilfs->ns_writer;
>  	struct nilfs_transaction_info ti;
>  	int err;
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

Applied.

Thanks,
Slava.

