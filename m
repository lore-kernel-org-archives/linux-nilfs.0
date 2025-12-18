Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD278242D91
	for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766057589; cv=none; b=TSq/sAZ0gWufuBIxy/sW/FrAoXYyXeVn+vDtcN9oqYqZMm2D+Q//VTJo1qGkiGUI7oZnYrxr97BHH0sTSl0gjtEJELnu4Q4J6dz+0N50h7/1p8BtNWWTuAIEKlHth5ZpcJcIYDOymYuqtKFbvmeA9Xj6uyBddIIKtyeRgsUOFaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766057589; c=relaxed/simple;
	bh=/vqnBii8f8lFBu3BYFA/Bn6BsaZprQpg6uen9h4Ka+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJFGhp2vk8IprtJsg80u238oOmeMFhQy6IwS3ghCD4pcBoOqFfDHCa2pMyB2LJ3WV67N7tfhxYDIEDz6FuhpihsY6C97A0XYEjB84kpX0Xy/AnUm/JH/LBEYGDvMgGqe1ZHezmDr8Kd6xrBxI9kTnQXmElGl3/dp3nv7GKJp3tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxHZ+s4D; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxHZ+s4D"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5942b58ac81so440503e87.2
        for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 03:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766057586; x=1766662386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZvltwoFCW9IuTTaktRFaiX8K+pWAPVSUHpjPIaw+DA=;
        b=GxHZ+s4DNWrQkVylUJGm9z06qguwjQ2bphAHIR28UJGyoREIq4N4VEcnffLByJu/FT
         MzheGsdYilRFn4wA4gMp/LtO/Y8HGMB2zEwQkbFzJi+qx3PNgHTK0RqfUHP/qu6cUXPd
         uj7QYhvXHZe9SEQlsFOr8M9FRG2mkIOc6iuWyd1PzXVLtDuXg9RWr9vxjs9jcShLLxbZ
         9EbhZfMn6bMuhK0qIOMk0t/np5xK/GoVF8hIUkoPafN/Ibc5AxxlnEaOml0cjibqZlJd
         ij5YAkMLITGZJCpDugJ9xtrFdgRi4a5WQ4UGStflrhRa+CBFbkw6VaB9VTkqdAHsS/81
         EChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766057586; x=1766662386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vZvltwoFCW9IuTTaktRFaiX8K+pWAPVSUHpjPIaw+DA=;
        b=Fqzl/YPAxLcljhB8sT+t7KDU/7NkgSE8VTcTISkG9VnGiAbP32FPEWM4d2t7umuj/O
         EKm2OfdrmyNs7g/mOTv2B0+HlEDhxIvoE1MZJ9YgdiZjlk+PAI0exGp5CaB8EUmRCmNR
         TMrzD5j3mh3sKImid7AERoZGNjuK0WFzrS1NFS1M7YMpdgm5IG2DdFM6KqPnUW7uvg0V
         Mer21zdU1AfIiXZvx9fUY7ltn/Uhx9yumKwDmkx1uAhraOaSaxMuzOLcLAJpRTluXRI7
         vxyB9VRrgsVjtk3q2xdlAF67ICM+nkqfjn0rvjUATYdNKfQTPi9xiMDAJHLjM1yr9FyZ
         sWwA==
X-Forwarded-Encrypted: i=1; AJvYcCXehas5lnJ/QtY+0YOC8+AfhgBr/zt/SElq97Kb7wgMhGYqsmsOFfERinEMn7t/DFbzKe/DySJem3wh8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0RAFxcV4t08CaWWqpxZdB0fuYB5FE15jbrggsD8j/hLHT7tq0
	9KadYRTCK9e2KYbwWTp+xWwi0eWLD5WEhSS2L0V7sZwxdJA+UM9cqPMp2+3vG+kvuXdZ+jLD/y8
	ztsdGZ1GVDQvxTpjcGc7/7Bf1GrYAVy8=
X-Gm-Gg: AY/fxX68wjzNLDkLVrnMNPa0FV4Ids44DYsmCU8GTnBrI7tQJoSHl/o3sAj0KwsyL1F
	p4u59ytQ6YhIN+7P5UbU03M2RY9Gu5CgehAAY/zxZ4i2PrMj2wjIkP+Hu8kJTZQwpeiKlKFinI9
	JamOiKT3zuzxKev5e7BnJdXyn73jlNwYpNlXix9cryRbsD7t8s0QhyOLO1j7fXTa2jTLOpW+fTF
	E3KH+vNIYcLU6PtCgmMyu72ZP5NF++ak6g+c/0JksH3oINsztLDodjgEG2Z9hXe9rb+lclw
X-Google-Smtp-Source: AGHT+IHsbzVsoSEXK/fumUZMHCNZkv62UzN1jn97rSIUxv7uKAGrWCMzczxAipj0NZeTvf4DgZ6ZBpH+fROr1QVhfcs=
X-Received: by 2002:a05:6512:3089:b0:598:ef25:c30 with SMTP id
 2adb3069b0e04-598faa8f42emr5928022e87.37.1766057585453; Thu, 18 Dec 2025
 03:33:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_84D71B07255DBA68BBE733F89E1F1B344B08@qq.com> <tencent_62C5D2DF8647899D2EE26EECCC8CA7C44606@qq.com>
In-Reply-To: <tencent_62C5D2DF8647899D2EE26EECCC8CA7C44606@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 18 Dec 2025 20:32:49 +0900
X-Gm-Features: AQt7F2pjkDHD2fk1ZwPTg0OsFOr9r889Mv7MVrnkd_b1OA1oXRcM_IDXfRSNq5U
Message-ID: <CAKFNMomckE-AKyZE5jJvKPn9-fWSEncqMPX=PP+cr3j6y==yDg@mail.gmail.com>
Subject: Re: [PATCH v3] nilfs2: Fix potential block overflow that cause system hang
To: Edward Adam Davis <eadavis@qq.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, axboe@kernel.dk, kristian@klausen.dk, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 1:22=E2=80=AFPM Edward Adam Davis wrote:
>
> When a user executes the FITRIM command, an underflow can occur when
> calculating nblocks if end_block is too small. Since nblocks is of
> type sector_t, which is u64, a negative nblocks value will become a
> very large positive integer. This ultimately leads to the block layer
> function __blkdev_issue_discard() taking an excessively long time to
> process the bio chain, and the ns_segctor_sem lock remains held for a
> long period. This prevents other tasks from acquiring the ns_segctor_sem
> lock, resulting in the hang reported by syzbot in [1].
>
> If the ending block is too small, for example, smaller than first data
> block, this poses a risk of corrupting the filesystem's superblock.
> Here, I check if the segment's ending block number is 0 to determine
> if the previously calculated ending block is too small.
>
> Although the start and len values in the user input range are too small,
> a conservative strategy is adopted here to safely ignore them, which is
> equivalent to a no-op; it will not perform any trimming and will not
> throw an error.
>
> [1]
> task:segctord state:D stack:28968 pid:6093 tgid:6093  ppid:2 task_flags:0=
x200040 flags:0x00080000
> Call Trace:
>  rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
>  nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
>  nilfs_segctor_thread+0x6ec/0xe00 fs/nilfs2/segment.c:2684
>
> Fixes: 82e11e857be3 ("nilfs2: add nilfs_sufile_trim_fs to trim clean segs=
")
> Reported-by: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7eedce5eb281acd832f0
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> v2 -> v3: change to segment end check and update comments
> v1 -> v2: continue do discard and comments
>
>  fs/nilfs2/sufile.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 83f93337c01b..fa612d5ec726 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1095,6 +1095,8 @@ int nilfs_sufile_trim_fs(struct inode *sufile, stru=
ct fstrim_range *range)
>
>         segnum =3D nilfs_get_segnum_of_block(nilfs, start_block);
>         segnum_end =3D nilfs_get_segnum_of_block(nilfs, end_block);
> +       if (!segnum_end)
> +               return 0;
>
>         down_read(&NILFS_MDT(sufile)->mi_sem);
>
> --
> 2.43.0

Hi Edward,

Thanks for submitting the patches.

However, I see two issues with the v3 patch:

First, this patch results in ignoring discard requests that are
limited to the region within segment number 0.
This is not the desired behavior.

Also, the final processing step that sets the actual discarded byte
size to range->len gets skipped.
When exiting normally, the code needs to goto a (new) label just
before the following assignment:

range->len =3D ndiscarded << nilfs->ns_blocksize_bits;

The root cause lies in the logic that clips the last free extent to
fit within the range specified by the ioctl.
As you noticed in your v2 patch, the issue is that end_block (the end
of the clipping region) is located before start (the start position of
the free extent), which causes an underflow in the following nblocks
calculation:

if (start + nblocks > end_block + 1)
        nblocks =3D end_block - start + 1;

The reason this happens is that the beginning of segment 0 is
truncated to reserve space for the primary superblock, so its starting
block effectively becomes the block number defined by
nilfs->ns_first_data_block.

While the segment range obtained by nilfs_get_segment_range() reflects
this adjustment, nilfs_get_segnum_of_block() does not (it returns 0
even for blocks preceding the first block in segment 0).

So, if we want to add a check beforehand, I think it would be better
to skip the operation if end_block is less than
nilfs->ns_first_data_block.

Thanks,
Ryusuke Konishi
