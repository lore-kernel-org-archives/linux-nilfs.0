Received: from mail-lr2-f24.google.com (mail-lr2-f24.google.com [74.125.230.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CC544A3E6
	for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 07:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789976866; cv=pass; b=jKggagPHVMHzEfK02O1bM8fSlFnd6r4rao6gdmLKkmKS1SKsU/Ohmli3Z2NOTYOpTi5WKl/yFBD5llRt4QNa9qb9FEmSuObchxuP0dh5Vq7MxrnfWTBlqNEDmDZ7YOy5QACELU3+TXNQHI0e45yUMDvJ4KsqUY06kDtHkHqruFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789976866; c=relaxed/simple;
	bh=KXxGTuxzh5HQFPptUgQ65qoWgJYcpw7UQPKggFX9gnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eiRAFkGiUfTVFMG/8xPcdlmK+DrdR5myt1KjGMWzDUNQ3J3DtDpna9AtoiuMDdB2qgzlR1Xq1CX3i7TLUnVaLs3+8KMis4RVeoy3r7kPJTW7s9BqNeaX28H21s8Y6YYczvbaiKSKxbcBAtN2H9JWJJ05AKw6x06x0AoFT7eaVpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESN3o5oy; arc=pass smtp.client-ip=74.125.230.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESN3o5oy"
Received: by mail-lr2-f24.google.com with SMTP id 38308e7fff4ca-3a2ff163f65so18109451fa.1
        for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 00:47:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789976862; cv=none;
        d=google.com; s=arc-20260327;
        b=CadMZJxSpzveWybkRGEe8QtydnBo1JoxzkN5Sv1TNCacNP/h/+ki/kCSuMNUn5KIRX
         fQipNwqbyhFgme0zvvkHsxhvoXBOljKuvGd+52e7VNkY5lVL9VVp8loAFzFPxWHnjbX5
         uLypVdv03A+HOFVTVuIKrIBwxtb5TPr2TWIFx9DmMc+ULDBI3uLoxqD10RL1WqaK8uzd
         20LNqyatO31WSJ3U7+EK1SZQCaaVu8K2LXt4woHaCzr9ySWV+tFgHMX5o2rbGiCvvWK8
         P+3aSEsObE7ykV2J0NuIBYIv/ITA/jhkSN8hiEglkEZrLv864swLfoQ/mzyI+OlE/z+o
         y43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ql+wH4qVovd9jAggtOkZvhGPFd9egOe0LH+fm0OHgS8=;
        fh=Yvonrmt6MJx8r5c7CA5G/YPH1RyWvc5q6o2wNOkKr+Q=;
        b=V+swLlaqn40+5hadqw9HflyhE2lWr4ok80hxmrtY2fzqcy37PkYQ5Hm5lZiyB/ZKwa
         NV2fSDdu6KcQsmIH00hup9Y3Rw8CTMF8zQEp3jslf/k2TIxfKeIunNsI5opzoADajXY5
         8Lph6cFJ4Y3ItP+C0CPUltYvBSmy5ZHjAOAQ42/urJCrpYfc0RC/oD6itpqTZavVCQcI
         5LrfPWObNxhcS6XOJoW651sBh1Yx7fAHnhHIvL1sty3gvPds1DJRPjTHRbanEFb3nbkn
         gXvu4WzBgQzUrpzs6vIrwLM5p4LBWM4M3q/f3GtHk8gEh783u1eVEBfiEvvXDFkuuKz8
         dn9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789976862; x=1790581662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ql+wH4qVovd9jAggtOkZvhGPFd9egOe0LH+fm0OHgS8=;
        b=ESN3o5oyt4hVhz3mwTfI+vJ6xtOiROi/WsTjZSeKXZ22ndjPtcfhVLpMT1qco6Y474
         1Gf5q+RV8TcwLrmQgRt14p4VJmMmIYw0Za8RAcwBA9obV0RsXY8QPQ09GglIuni5Virm
         /VxAUrduUQDfNZKL/GUcETPZXUP8mA+36Da8EhrIMyQAO5DjUdNA2fEOxEm2yZDwzRgG
         PmQ0lJY9EG8EszQDYK4PWauiCbsO8Lb6WDcyuw68nov0Fvf+k2KZ/o7yDT2EUX32ccaj
         JTOSkXCMLGgarEMXfXjHK+xsNORoJP5P5I5g4i06Grq4R1ZJkR6z0j6Tl9qleFVVwC6u
         vIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789976862; x=1790581662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ql+wH4qVovd9jAggtOkZvhGPFd9egOe0LH+fm0OHgS8=;
        b=QO8TKKDqkwnocKCXwyTTevmbAiZMwbilIXfGxRNYohJ7H4tGG6764EWEcW4ngyDIfj
         BPUN1vT6Tloao/ERsOZZa92V5ugMPTpIILoKPq/rX3mGqx4HFmuTvIsEyvGp1yp11eRh
         eVAqOSWyGYDGAVkFUDuNSFnVLbAV8a2yuuwJbV/isivuy2ut1ce4ubHGK2/ZeLwpAmVJ
         eEmK5a372TjT8nalyMpMFNtuLdSXXQyLW3mrtMAdQoQbWX23l9VUekW0vneiQmHE50J1
         zdVoQg5eNRUTLubuXFzfPiHr5x+jW5Y+JrLQgdv9QrBvpq9dEFbj0K77TUuDl1qZ82v+
         D26w==
X-Forwarded-Encrypted: i=1; AKwUvBwzBHdmNZ8sw+7X3rd0urWZ8qSBcW8BZdrBMdJlYr8zmuvtrfgh6xTojZKRZFKZSgYdYi177+d4S3IRFw==@vger.kernel.org
X-Gm-Message-State: AFuF++mE7HNYmsl4tmTRvADhgcqa3mo5Llrp7CFG9uIGZZoctGnTxvb2
	8cDi9P0z+9LAmWfo9q/YrVzh1EqDki9luY34ZI4Zw7lnrRIreHd3zkyd3n/BgT5ildl2TMnlpGG
	0n3ff55eJRTS4X3Fecy6uNt6Zv9HoSFNCZwOfsPY=
X-Gm-Gg: AYBFou0dfB/QyLQ7wsNYEkesYPX78Uj/s96o9A6Ef6kAGQLWhVi39OsS68XqPLr3WF1
	gf6M0+dFXhSI2GPzfe8ywi3k4z06Vf6P/yQfcj4bsqw7hA0el/B+sd+Ih3Q2tMjqvgaduUAXO5z
	bz0/LXm2cokDnvJuc8X4EnDp/cVkesXs4ahlSGt4KHhUdf7GbXhofOs2SSqd6h7+5LAS/F7c0b0
	Oyweu7k/D5e1DQ8n9zh8ZqLnwFj5qSHhvqk/VkUlsa7qwJfjvdEXMtJmivbEkcfR6P1uH+5K8K4
	SbUIyk2ND8y4iklIZzQcl3pu8a02kQWj4IPN36va+L+ju6c853IyGWqA
X-Received: by 2002:a2e:a9a5:0:b0:3a3:476:2e37 with SMTP id
 38308e7fff4ca-3a5fbe36d88mr21411961fa.6.1789976862279; Mon, 21 Sep 2026
 00:47:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <13b330df140a2ee488952b4c7145e261ec884555.camel@dubeyko.com> <20260918212153.23651-1-qwe.aldo@gmail.com>
In-Reply-To: <20260918212153.23651-1-qwe.aldo@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 21 Sep 2026 16:47:24 +0900
X-Gm-Features: AcwNN1XF1zg9V9W7pIcfaTTC797llgXNMo377_BEL2cpbxL6SjSpyOdv0GuJxt8
Message-ID: <CAKFNMoneRHw=-hsGvzY+Mdktm3+EtodSU2vpNoaXZnheu+VjgQ@mail.gmail.com>
Subject: Re: [PATCH v3] nilfs2: fix checkpoint root lifetime on sysfs errors
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 6:22=E2=80=AFAM Aldo Ariel Panzardo wrote:
>
> Hi Slava,
>
> No, wait_for_completion() without a timeout is intentional here.
>
> The kobject subsystem guarantees that the release callback will
> eventually run -- CONFIG_DEBUG_KOBJECT_RELEASE only defers it, it
> never drops it. So the wait is bounded in practice.
>
> If we used wait_for_completion_killable_timeout() and the timeout
> fired (or a signal arrived) before the release callback ran, we
> would kfree() the root while the kobject release is still pending.
> When the callback finally runs it would access freed memory -- a
> use-after-free.
>
> wait_for_completion_killable() (without timeout) has the same
> problem: if the wait is interrupted by a fatal signal, we cannot
> safely free the container because the release callback may still
> reference it.
>
> The unconditional wait_for_completion() is the only safe choice
> when the caller must free the container of an embedded kobject.
> This is the same pattern used by other subsystems (e.g.,
> blk_mq_tag_set, configfs subsystems).
>
> Aldo

Hi Aldo,

Thank you for the patch.

However, in my view, introducing a mutex for synchronization (either
by replacing the spinlock or adding a mutex alongside it) is
unnecessary and suboptimal.

nilfs_sysfs_create_snapshot_group() performs memory allocations and
sysfs node creation, which can sleep.  Holding 'ns_cptree_lock' across
this operation causes concurrent read-only callers like
nilfs_lookup_root() to block unnecessarily on a lock that originally
protected a very fast, in-memory rbtree lookup.

Note that checkpoint and snapshot mounts themselves are serialized by
'nilfs->ns_snapshot_mount_mutex', so strict mutual exclusion between
concurrent insertions is not required; we only need to eliminate the
race against nilfs_lookup_root().

Instead of converting 'ns_cptree_lock' to a mutex, I think it would be
cleaner to keep 'ns_cptree_lock' as a spinlock and structure the
creation flow so that new is fully initialized and registered with
sysfs *before* acquiring the spinlock:

1. Allocate new and initialize the basic fields required for sysfs
creation (cno, nilfs, etc.).
2. Call nilfs_sysfs_create_snapshot_group(new) *before* taking the lock.
    - On error, wait_for_completion(&new->snapshot_kobj_unregister),
      kfree(new), and return NULL.
3. If sysfs creation succeeds, acquire spin_lock(&nilfs->ns_cptree_lock),
   link new into ns_cptree, and drop the spinlock.

In nilfs_put_root(), we can keep refcount_dec_and_lock() with the
spinlock, erase the node from the tree, drop the spinlock, delete the
sysfs group, wait for completion, and free root.

Could you please update the patch to keep 'ns_cptree_lock' as a
spinlock and complete sysfs registration before inserting the root
into ns_cptree?

I think this approach should work, but please let me know if I've
missed anything.

Thanks,
Ryusuke Konishi
