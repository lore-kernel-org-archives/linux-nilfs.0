Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED01280325
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746721017; cv=none; b=pzNrPa545hJie2BNKQcxl13QwUSni6ipRd8d+/ZeD0emrnSVXzJw2DUsTvlORjzSWiiFi+aSD4eTx9Hkq5cp1AdkO1rFV+xghzWZc/2YXs+JeKURne07ZHZ4E312YJQdMrpVUdtbqEDdPsDo9TdAUCnOo6oNB4YqBhO71t9UjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746721017; c=relaxed/simple;
	bh=lTLvFcYdsuDNX3jZBRjzSWErgHC9+LrS5i1J8K2QoLI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SE+StODyTwV4s+4JkuRSFW2v3nB7VY3lNUGCzK4+zYY7mXv/VWB8vUENT1EN8UCj9YCisdkHEKXGE4dB58DyaZhgY2zhtza4fWCzcAxOrtfEuZzCe09zkWKYiokRPPigyqXuVL0npKsIC96vNd5PYdkNEEuL0UTDwh3yLsN5XnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzqZQVeG; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzqZQVeG"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-30effbfaf4aso12297991fa.3
        for <linux-nilfs@vger.kernel.org>; Thu, 08 May 2025 09:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746721013; x=1747325813; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2FcLWNKlETZsjsOU2pyZWvaK+3qhKlNJLCtbz+byxQ=;
        b=OzqZQVeG+w8X7w/Ed2aUPXBFuNQlksH5UW7a4Q9hX5ZcRp3qj2dOM/S/Q6ztTe4ylJ
         CQwrKNjHlAIwYs5z3en3Lovr1JX3POM1rEb7UR5KYqif8+lH0sc0Zcj98JxwXl4ATwfg
         T/7wx+CCoy3wzzC6ge3sMW5B4fD2i+VnVdif89H0c3lEs5gHKFscCJlbPI0OnYl5FdjV
         yk0nrysWhthCXI2HfyuN1b2MBiLla/Clh2464sFGxiSHHiU2XBnruRwbJBfQytERvvTF
         1e30e+FUQG3jm5en1mKrJut9oKwhKc+6D1gzdND3gLlh/UMMu4u+Xlua+Q+PbvGQ1XLb
         0ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746721013; x=1747325813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2FcLWNKlETZsjsOU2pyZWvaK+3qhKlNJLCtbz+byxQ=;
        b=ePPKiCsNNN2CorZhdt0vRbpGLyZSCQmr73eFZ6X7V2YXiUeYfInFISpzZJSsc/D3nl
         N1U98TM6DoTFNu0zmN6dsXSkUpbqLYiQ39LmsWnY6CwrQw7rnA6ByjLNmuu/gmwX3MN5
         Ftyo6USlw/IidQFQZct5czOni1znrSLXX73EkwvdZI1vprKrq83r+SPg7lHnBpUp7lb7
         20kJvJRos7gUr2vQw6dudWLZtHrKc9bQgFfZlp1HwjWjJVZjUHUybJXcVDrQyrnUu7H/
         k+h0IOCAkI1OAdfj0RmLvTRhU+ZfkulZHCmKRdk7ZI2IUkr1Q9uo2eU0kU/F4ZT+Cg6C
         4K6g==
X-Forwarded-Encrypted: i=1; AJvYcCXyBzwt4Qr4G8hW9oZIjm0A6Us+KbaIQiSfZUTgMR2JjaUEZBJLeBylxsfA9jyVPAWZ4ZqcHUR/Jbl/Og==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6Bm/hoM36SQVAZdq804dVZEAVoMFJ/G5dZqXvQY/DSBmrWhE+
	fRS5m+Qupl1TxVYF/mrpzhWYbqZhHrMvivT34IHczNMHtq45PYCwmAQ+XSKSCZGbE4Z863HnXSc
	5MuxeDEl8gMnvcwmXpJG8NN6bzFo=
X-Gm-Gg: ASbGncsEeg9JVLaNiz17a2/OYcIaVAwqTDLcUPQDOXraBArXv5QetdcnaIEFsq1eEqu
	vGQEf8SawjMpTFQV5q/IskIrxnCUPN6gSnjUjFpbuKCyUCdRUpc7MF3laEWWyRpv+0eNlQC4OHN
	E1eE7dRY49etbSICHzoJV1vNj2PvbqmLSOHpRr//CcpAWNqlE4QVUUeCM=
X-Google-Smtp-Source: AGHT+IFnVwRMLST132t2t3JGJmksuRe+Yd06Wq0nojF1mVXeWRq4KS3lrWP76WwJhGJSQhynVWJIg2asj3kJL3BDuI4=
X-Received: by 2002:a05:651c:30c6:b0:30c:1002:faa8 with SMTP id
 38308e7fff4ca-326c456b4c4mr796351fa.7.1746721013146; Thu, 08 May 2025
 09:16:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508054938.15894-1-hch@lst.de> <20250508054938.15894-7-hch@lst.de>
In-Reply-To: <20250508054938.15894-7-hch@lst.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 9 May 2025 01:16:36 +0900
X-Gm-Features: ATxdqUGTwHW8espuEsxVZpRE448RcFshfvrIDwDSW-80W6UWKETHTF1usKUFjfs
Message-ID: <CAKFNMo=nQ7e99ubGmB_9myjSmHxmUJ+XEoknRGF=fMuzJZMPNg@mail.gmail.com>
Subject: Re: [PATCH 6/7] nilfs2: remove wbc->for_reclaim handling
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 2:50=E2=80=AFPM Christoph Hellwig wrote:
>
> Since commit 013a07052a1a ("nilfs2: convert metadata aops from writepage
> to writepages"), nilfs_mdt_write_folio can't be called from reclaim
> context any more.  Remove the code keyed of the wbc->for_rename flag,
> which is now only set for writing out swap or shmem pages inside the
> swap code, but never passed to file systems.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, the parts removed in this patch look like dead code now.

So far, no issues have been detected with the previous conversion, but
even if it turns out that something has changed in that conversion and
needs to be fixed, I have no objection to this cleanup.  Feel free to
add:

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/mdt.c     |  2 --
>  fs/nilfs2/segment.c | 16 ----------------
>  fs/nilfs2/segment.h |  1 -
>  3 files changed, 19 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 2f850a18d6e7..946b0d3534a5 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -422,8 +422,6 @@ static int nilfs_mdt_write_folio(struct folio *folio,
>
>         if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
>                 err =3D nilfs_construct_segment(sb);
> -       else if (wbc->for_reclaim)
> -               nilfs_flush_segment(sb, inode->i_ino);
>
>         return err;
>  }
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 83970d97840b..61a4141f8d6b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2221,22 +2221,6 @@ static void nilfs_segctor_do_flush(struct nilfs_sc=
_info *sci, int bn)
>         spin_unlock(&sci->sc_state_lock);
>  }
>
> -/**
> - * nilfs_flush_segment - trigger a segment construction for resource con=
trol
> - * @sb: super block
> - * @ino: inode number of the file to be flushed out.
> - */
> -void nilfs_flush_segment(struct super_block *sb, ino_t ino)
> -{
> -       struct the_nilfs *nilfs =3D sb->s_fs_info;
> -       struct nilfs_sc_info *sci =3D nilfs->ns_writer;
> -
> -       if (!sci || nilfs_doing_construction())
> -               return;
> -       nilfs_segctor_do_flush(sci, NILFS_MDT_INODE(sb, ino) ? ino : 0);
> -                                       /* assign bit 0 to data files */
> -}
> -
>  struct nilfs_segctor_wait_request {
>         wait_queue_entry_t      wq;
>         __u32           seq;
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index f723f47ddc4e..4b39ed43ae72 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -226,7 +226,6 @@ extern void nilfs_relax_pressure_in_lock(struct super=
_block *);
>  extern int nilfs_construct_segment(struct super_block *);
>  extern int nilfs_construct_dsync_segment(struct super_block *, struct in=
ode *,
>                                          loff_t, loff_t);
> -extern void nilfs_flush_segment(struct super_block *, ino_t);
>  extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv =
*,
>                                 void **);
>
> --
> 2.47.2
>
