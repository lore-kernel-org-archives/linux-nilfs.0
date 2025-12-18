Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09944CA6F
	for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766059332; cv=none; b=msaY9atsz8Q82puH7DUz6HvbF5Id23MZfelV5ojNc7+l/UyYwFHih1zmhDbmcnwGvDrHmLJyFaq9w5RCUOJmGg8p+rOamg09USmERVm60nR48H+Kk0kuTuIn4YqxO2nY7teiCn9Kq86OCoZrL5dsnbx/opmP3soKilCsUpIamFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766059332; c=relaxed/simple;
	bh=Jtd/hfOzKj0bvyjVO6XmwoL9zi9IzI1bn/12mEhQ9KQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqIfaAbWsdZuexJBMjtQqCuMmap7KYZQHS1p7y8Kt5qJ92GhwD+7bpUmNtIC2PxAKIinyWqgEKJzjqQXea3KYMyvIUCc5ZxgIpTxq0h8P6k8/YkkLFab1zyourSRzvXl5btAxJlFMe15sQlAZrrtvel5BbnWafGKt6qZad1WSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZmcOM+wV; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZmcOM+wV"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-787df0d729dso4341697b3.3
        for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 04:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766059330; x=1766664130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IN/1rEAx+ZWLAsrrQxqEaq8dVO1KExf1KgoeeaCeSM=;
        b=ZmcOM+wVEP9Au7BFJuijwZ7LJX3+hh9q+zkm/xzkULq7Lyik9SaWzR5a9IWD30iQCd
         zA3vKASY2C5RUlbmAjK3OB+79w4UpWaMS+pt6kxp/BsC9QEdPAqnbgv5+H6rHo94VMbj
         jbPE/DSKmGZDztMpvEaNTujy9R5KKDYFKzHNLejnHlF+gos8tq9dkzTDRBiyN2aRBuk4
         qzyAFLAQvn2b0BTZM23aucbDr5HIcpb989I2UE868THUB1JUl5Q/zcqE/aYtwqCKMaIU
         cFA4IWc7pFd2m5KYbd9NW6oBgBEsk40OI9Vs6QylItykD27kl6cPoFgsRd7/SE1oBwJx
         AdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766059330; x=1766664130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9IN/1rEAx+ZWLAsrrQxqEaq8dVO1KExf1KgoeeaCeSM=;
        b=dI7XbZnXFxT6PenYRHS3RM3Xb0rywrvnQfCj37b9ekBIK8e9AszRia6jj30HZhSqFu
         gLvpvmIEGKdFKOBxKZ8ePBAGA9MLfsnZLd6mini+4KHq9+1FIgDoSJqo4t2ll7cSlGQJ
         Dnh/5vuFQhLQV5SY83xclUZhdS8rCBYQDx+n908h41234Hk8m+TsIO+cqK8reU7+TiKS
         pFitH60oc571jR0z6TtfvxW1uyXBdJQqFEEagxkZqnerJQbZaiFoTrwEvEh/fnf2uTtG
         iKGvE0wTvlL9nKR10ja7KSj2Fw3NyjM75WT2sJmY8Lv3y8X9kXqqmfbmMRNWL2Og0Kw0
         /r3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3r8L4j3hmeAOLuYnHNlvMOL+YSklTNdFM2OqGmKkq3vLSsQeQ/wo4Qks9v234qCssATqu2m0u5oBoYw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0KRcZudNnI/H1DSdBi8dVO7+y6SUxXz5s5MH6rV7UUynKRKHW
	3EOXU6JItuZTYctra6xEah12MPFwg9EDIWJG6I7BBYifO70BzDTOqHlzNZllQU0igw8J2a83meo
	D3EhRaYAEEqtnI0lC+QJH5Dfm3UUxhvI=
X-Gm-Gg: AY/fxX4yGWUOxT3t6WC9TwRSfY/wMB5wcnJOYNU+8C45JMHpaUGzDh4P5yVBG7VLVx4
	RoDVzp/HnmYBCV2EqVkR9SQCd0KuRZBkUV+g/cKg4sOItzAQcrg4Zi0bPrQN+VtyfTJnAxcd5C7
	Fss2MkfKzdHnv25dC+f85Gz/S9Xm9zjrGxVlfrcFdeptQ4j5V/sDz3izLug4Znv/YEaUTJy7UnS
	CVxSoVOk/8EsATNchkXuLmMlCUPHgdeWFTunuEtwdiXHVu8si/jg8jOuJzJ79l6/OOJjSj/
X-Google-Smtp-Source: AGHT+IGeEhtsdMFkun6eH5mq7mpKGUPRIiR5POXpFCWs3Fryg0kZerBcwib4GBofiVfYIovNFhNes4N6klY0XgSKIIU=
X-Received: by 2002:a05:690c:6008:b0:787:caf4:574b with SMTP id
 00721157ae682-78e66ce483amr158753327b3.6.1766059329579; Thu, 18 Dec 2025
 04:02:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMomckE-AKyZE5jJvKPn9-fWSEncqMPX=PP+cr3j6y==yDg@mail.gmail.com>
 <tencent_DD9A67C7C6F012DAC64B49AF6EF0EED98C06@qq.com>
In-Reply-To: <tencent_DD9A67C7C6F012DAC64B49AF6EF0EED98C06@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 18 Dec 2025 21:01:49 +0900
X-Gm-Features: AQt7F2oAZA4G2Ewocd2g8g6hAcgiFvY4eQgY_n6Dw-90uV0uqcKCdlLewJz6GEs
Message-ID: <CAKFNMo=602x-hdCCQtPdZ7PxX5FezeUERLEcrT17OjYxif=RMw@mail.gmail.com>
Subject: Re: [PATCH v4] nilfs2: Fix potential block overflow that cause system hang
To: Edward Adam Davis <eadavis@qq.com>
Cc: axboe@kernel.dk, kristian@klausen.dk, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 8:48=E2=80=AFPM Edward Adam Davis wrote:
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
> v3 -> v4: check end block and first data block
> v2 -> v3: change to segment end check and update comments
> v1 -> v2: continue do discard and comments
>
>  fs/nilfs2/sufile.c | 3 ++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 83f93337c01b..5d7cbd26a910 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, stru=
ct fstrim_range *range)
>         else
>                 end_block =3D start_block + len - 1;
>
> +       if (end_block < nilfs->ns_first_data_block)
> +               return 0;
> +
>         segnum =3D nilfs_get_segnum_of_block(nilfs, start_block);
>         segnum_end =3D nilfs_get_segnum_of_block(nilfs, end_block);
>
> --
> 2.43.0

Hi,

One of my comments in the v3 patch is not reflected.
If exiting successfully, it is at least necessary to assign the
discarded size (0 in this case) to range->len.

For future optimization, I recommend leaving ret =3D 0 (the initial
value) and jumping before the final assignment statement (since
ndiscarded is also initialized to 0):

        range->len =3D ndiscarded << nilfs->ns_blocksize_bits;
        return ret;

Regards,
Ryusuke Konishi
