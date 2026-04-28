Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC01A254AFF
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Apr 2026 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777402744; cv=none; b=KKZ41SH7w9UduNKcaLlsWT4c4N5G37K46Gk6ZRYHREZe/pe8ZG/NnhPgZZR8P1Lv3AY6c5Y9Mp/JukWaj5nKv9Rc/6amwylp0Tfhgv6DxgcRZd7BQyNeAMC1pT5o1j+05//J7i3Lfybr8ngUuRmXclwRdSWR/RATEv85FvpHvRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777402744; c=relaxed/simple;
	bh=QqUFJ1sI54loRY/AvauXi000zUZCENkk3hc1qg9TCP8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bRwve91iL5lRkK22cOQ1b9EEUJRWxXK2jzAt6ewIqC3Y0ESUwmEjVlXJsPxXWXrhW8rFVSt0m7gIG8AEk2liZcnpmWyzY88GFAkqRpYOGCpX9k4SU7aaCxnS3/5iSaJra+6PFPXUxi5ejPVbOoSEHU9Kyk4KyWmEudQF83UFjV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZAIuoOew; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBSfzO+N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZAIuoOew";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBSfzO+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777402742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uq7bRTEWA7W510g7UhzlUVPAh9bOA/MUyIcc6NjXG0w=;
	b=ZAIuoOew4KuPlPqacjacqgAq4vnBghD/nS3yoEi1xTcH2y7UgLIuUoqQzTZsMQhL7IaeSh
	n+quMKrPRW/1I/3rNHzZsZRMs4seX76u7weGcNVQh8k8df1nonBKI8TAfwDf7Q+IShJwk1
	kHMgx2wkUPPdqCDUDk9zXZ9BnpQz3sI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-ZbHokIxsMu-ZRWzUMNHgvg-1; Tue, 28 Apr 2026 14:59:00 -0400
X-MC-Unique: ZbHokIxsMu-ZRWzUMNHgvg-1
X-Mimecast-MFC-AGG-ID: ZbHokIxsMu-ZRWzUMNHgvg_1777402740
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-79cfec4344cso198738837b3.2
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Apr 2026 11:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777402740; x=1778007540; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Uq7bRTEWA7W510g7UhzlUVPAh9bOA/MUyIcc6NjXG0w=;
        b=XBSfzO+NM2xJ9F5xknjvegoDvKhO+mGLPTPxCVdVwVWGyG+S90rZ1H6igsSeNiSZpF
         /ESGyBvuZ4aKnMIsrWMWYmdFWyYfECCH0/9bqCIGbDEbVoU63De/V2eZ5ScM/o/ODTHK
         VSui+PBkPzxEakXobz7aWqbkm0FdvUuma+xKBi3hDxp6W4nBriqgWmdjKqdLj7pgoi1P
         P4AJRBpc3rH4JSPaHtZAoBPbW8BOL8EYmyiG/Cm4kB61aWHXO8Iu5LzdmZ4XM4QAFCnq
         YJeyMIApMKS92W1xQ4/cezdW5Hg2bfnS++QuHiXpF971pO/qwPSbKm0k8cwIBZcw5suS
         QU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777402740; x=1778007540;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uq7bRTEWA7W510g7UhzlUVPAh9bOA/MUyIcc6NjXG0w=;
        b=EgMrl4o+PrHpzttTyZ0Y8TfxhRY2mPyJf1dck1SKEg8W3QSh7gzrhev185mJp0G3Hp
         386jKgoEVYwSVNHDijDsyg9DDtro8zDmvm3QHZIv9Mn6LR7dJQR5A3/39zcasYQdqWXZ
         7BwcDCoe6iZ088VuUrwKuaB2m/Y5Ym3qqs0iQluhR7lvCz0fCS+L1LsXwD576uATWiiL
         295srQnSIGCSV0ydTOH2lP5yYV3/E97KCYLtRrAm5/DZAfrLUAmwrCsDNzv5ZVOm2u8J
         PctB79Zq6hu03LDFEGruhyW/uRrS0v87q3R2aiBMvxy5ig754PsU8y8MReQMHHn7aeGO
         olxQ==
X-Gm-Message-State: AOJu0YzdJKT3CX0KxlHekpsMtNqRnFuMvpzKu70U8zmNohjTxrWJ3s4C
	9ToeHAlNNWIgTOBPCex8kUYhu3DY9E7vva1lojNUGvRKVEsal3XqZD6+zK82i3YpxBaLIqPHnaa
	Re9kXJNNCg84fyfWcNoR3xmUG4v4lm4g+C/hKK6Wf/KmpySSj3guRiQEUB6Zev5Ar
X-Gm-Gg: AeBDiesB3bkrXe3hPfaRrKOAVjTPdQ58V/SR8wcz3Nsn/uwJg6gMmCqiOlXC47FvKPw
	OW3T4V01kzv0lVkCGJQ7EhdiVpQG4iTvRTvAdpTJ5DOGXj/XHNj1qLOB1YBS/VC/l6j81DpQBVd
	WzjF62QOJS9G9yiR/lwJmJebxWwgnDl9eq2j+Lo4ZjcYPTTmWEdRYiQS9Wb8RgDB50wdP+0zmth
	lsLdocA4hJqA19SYaJmYGMEtSvGIBc/neFWdTsDzA2yXsZ846T8l3G06tZwxMaHxPMEWDxK3e4B
	bJXv37Jz0andGqcYH7MVkM5TJXtgWJMB5TQE9s/YuqFNgKoDdj1czN1yoAIi7dF1ZxyvORfJseI
	lSq74k/UOf1gZY0EKbiB2kknCDX4QccE6+3b/b/e8oUyz9uU3g38tMmAKTayr0pg=
X-Received: by 2002:a05:690c:dd3:b0:7ba:f6b4:3591 with SMTP id 00721157ae682-7bd1d49a45cmr9276607b3.11.1777402739958;
        Tue, 28 Apr 2026 11:58:59 -0700 (PDT)
X-Received: by 2002:a05:690c:dd3:b0:7ba:f6b4:3591 with SMTP id 00721157ae682-7bd1d49a45cmr9276347b3.11.1777402739461;
        Tue, 28 Apr 2026 11:58:59 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd22fc7270sm1563667b3.22.2026.04.28.11.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 11:58:59 -0700 (PDT)
Message-ID: <2ed28b6008cf898a06036d5836380cc5cc45f118.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>, konishi.ryusuke@gmail.com, 
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Date: Tue, 28 Apr 2026 11:58:57 -0700
In-Reply-To: <20260428040256.84403-1-kartikey406@gmail.com>
References: <20260428040256.84403-1-kartikey406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-04-28 at 09:32 +0530, Deepanshu Kartikey wrote:
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
> The writer holding ns_segctor_sem was a concurrent NILFS_IOCTL_CLEAN_SEGM=
ENTS
> caller, stuck inside printk while emitting per-element warnings from
> nilfs_sufile_updatev():
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
> The root cause is that nilfs_ioctl_clean_segments() does not validate
> the user-supplied segment numbers in kbufs[4] before calling
> nilfs_clean_segments(), which acquires ns_segctor_sem for write.  The
> range check on each segnum is performed deep inside the call chain by
> nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
> while still under the segctor lock and the sufile mi_sem.  Under load
> (repeated invocations across multiple mounts saturating the global
> printk path), the cumulative printk latency keeps ns_segctor_sem held
> long enough to trip the hung_task watchdog, blocking concurrent
> operations such as chmod() that need ns_segctor_sem for read.
>=20
> Fix by validating the contents of kbufs[4] in the ioctl entry path,
> before any FS-wide lock is acquired.  Out-of-range segment numbers are
> rejected with -EINVAL synchronously, with no work performed under
> ns_segctor_sem.
>=20
> Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3bbd7
> Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_segm=
ents ioctl")
> Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/nilfs2/ioctl.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index e0a606643e87..38822dce1839 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -846,6 +846,7 @@ static int nilfs_ioctl_clean_segments(struct inode *i=
node, struct file *filp,
>  	struct the_nilfs *nilfs;
>  	size_t len, nsegs;
>  	int n, ret;
> +	size_t i;

What about re-using the n variable? Does it make sense to introduce new one=
?

> =20
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -876,6 +877,21 @@ static int nilfs_ioctl_clean_segments(struct inode *=
inode, struct file *filp,
>  	}
>  	nilfs =3D inode->i_sb->s_fs_info;
> =20
> +	/*
> +	 * Validate segment numbers against the filesystem's segment count
> +	 * before entering nilfs_clean_segments(), which acquires
> +	 * ns_segctor_sem for write.  Catching invalid segnums here avoids
> +	 * holding that lock while emitting per-element diagnostics under
> +	 * the segment constructor.
> +	 */
> +	for (i =3D 0; i < nsegs; i++) {
> +		if (((__u64 *)kbufs[4])[i] >=3D nilfs->ns_nsegments) {
> +			ret =3D -EINVAL;
> +			kfree(kbufs[4]);
> +			goto out;

Are you sure that you need to free buffer here and go to out? Maybe, we can
introduce another label and to jump to kfree(kbufs[4]) at the end of method=
?

Thanks,
Slava.

> +		}
> +	}
> +
>  	for (n =3D 0; n < 4; n++) {
>  		ret =3D -EINVAL;
>  		if (argv[n].v_size !=3D argsz[n])

