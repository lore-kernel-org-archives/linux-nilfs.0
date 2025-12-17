Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723636B078
	for <linux-nilfs@vger.kernel.org>; Wed, 17 Dec 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978733; cv=none; b=Et0cZDOF4ijcMyVYaUi3DeBoKIyrylYlfUpQhqdg0uBfhBrEdQ2vPz2k/fS02HMXtd5NARO5TsIa3COrF+3FD1e9pb08WZKZ+3SVAmro6M4Oluq34mZoqCYVx8/nFlRus1of88oJLPA684Zg8faPt9mtOs2ko1iKQ5XVJUdS+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978733; c=relaxed/simple;
	bh=ryAq8jG0MJcRdwAUrOL7InqBU1agO3Y1r1pyHtV3HJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPXifJsVZKhk/cLsYUJ96fU8TErmeafvePlb6Kz3NCF0utT042DJc8WnJ6iyzcgiSIs30tFT/f5lg7j45lHfNQZ7rLFVwC9srolP1SL0Lo7aBGDHvBwLPS074VGyre8D+MvE7C3iTdYrJHwRZfh/OSdRV1wsBSxxAQ7ntWRjfxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwqCq5FN; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwqCq5FN"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59584301f0cso6233751e87.0
        for <linux-nilfs@vger.kernel.org>; Wed, 17 Dec 2025 05:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765978729; x=1766583529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMqtIv6p0pYVdVIS4E5Mccw6/1CKl4VD7sXdUq5hqLI=;
        b=cwqCq5FN3B/Ud7pu82YSjmjOX8vyYAa20A0DVLzDvMIuTw7I5LjxUX/cIVbLRTcRaF
         SQgM4TOFQtnaNfkoT4IqtcFNwxVEtoaGhEr86P8Uh41r3VeZeeMrwtm+GCLnvoGNt4DV
         yMlLwAKw+8X4k/hHtkDsxmGWIhurFjfsJf9lXBfElYQ8e0kfR2pc899fAm3yYCCi1GNF
         15Doan+IFqYmFhs4xdSuhPOPu4fMDaLRW3iN2mIH3hgyRSNWG0OpSUhEbFT57h63yhe2
         J7BKioX0dqbXBqpTQachalpRlu/Lb0Nq7d2/nB1j7Bdhe99g0cOu9sQsIP3eETPS4HUa
         YLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765978729; x=1766583529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vMqtIv6p0pYVdVIS4E5Mccw6/1CKl4VD7sXdUq5hqLI=;
        b=vvfr4KEr60HlzQWLnSEeOtRdw6AlCdYdYhdLS6pmUWJf3gBtxTjOmDrMvxwKnTjqAB
         SV0LgndpEcvx/tyTzpx1tSxkn1/XFEr5NGYcw9TQTlEJt2IBUah+G2fI0+c4/EiABWo4
         mdY6MTgOc26FE286QwPJlqCC0uaLI6VbKu0+qd114wfeMt21ZUD7URJXaenQn3YfkdgU
         vYMbbhr07uO9YsXZKwcnGD2lKYOgyPU+UxXyNbq8uPUPLAiB77zNwNAQHmqUAuGIfMEZ
         DtPAWxTl6fL9dqcRFjqSCFndMvJKLGnAg17Ql8+0BQL136AnACABhMm2BhIx9YaGeoUj
         tn1A==
X-Forwarded-Encrypted: i=1; AJvYcCUjzGUpNH6zuDa3N7sSYmwAmmTo5Un1UuWxsT5Sv+s+xFPpOorgYmcUpNvZTZV0yYBBf26t46nclhZ8KA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG35kyS2gjgRJUy3dhGvIPYDZd6ZA/VTIfW8bKhzXNARQ865gA
	qdjiY5oM+aFj/g1grbLRgqqmJKqjTWv+7Ge59EI2Ap0wQm1yqRZwZxgSo38kG1iXWXZGzx4o2lD
	5biDrPlbnvvTCwzyIC87iM6dQ+/EDsP4=
X-Gm-Gg: AY/fxX5iiuf1nDQgBGKfOQgga6r+m9CAxRsCozx3POyArJRNF1N3yeAo5b5QFK08sEy
	tfQSM9LTF8yRAzHplOCz0QlBpRIn+cg/0ap92eWmaXIklQ5vVgrQ1YDputYqaD7EckGebYAr4My
	F5DnyFYqQ4ph25m4aduGrz3pAae3iV09cV7sTT+Ehxp/V6WuZZ8tT3FG/HcsowibAPRLI8U8gxA
	W8hXQcuFMGqtYmdt2ozq3xb7/iV6oZKNC4IMbtu+1/qa603PtIuHwlvfCD9dLWNe9R2vbtM
X-Google-Smtp-Source: AGHT+IHW11rtu8rQZMAW7iQg6vsRC1fzpPukGVN5r9zSc00IezYXFGbcmz9YqDcKi/SZMH3HN2UiV1sxLiVqw8s15d8=
X-Received: by 2002:a05:6512:2396:b0:59a:1187:6670 with SMTP id
 2adb3069b0e04-59a118767bcmr182924e87.23.1765978728830; Wed, 17 Dec 2025
 05:38:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6941fd62.a70a0220.207337.0022.GAE@google.com> <tencent_9DB079AA6FCC2CB56C2494E0EB32EC26CF0A@qq.com>
In-Reply-To: <tencent_9DB079AA6FCC2CB56C2494E0EB32EC26CF0A@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 17 Dec 2025 22:38:32 +0900
X-Gm-Features: AQt7F2p3zyAhqyPboAfe45dwO-7a9Y5mvZ0dtS9N1So956wzrHEylC4iqz70LdU
Message-ID: <CAKFNMokBCsjR-QvQCAHcAoSfC5yFAGU+xpiA2CUnGPhi7f-uFA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix potential block overflow that cause system hang
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com, axboe@kernel.dk, 
	kristian@klausen.dk, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 5:43=E2=80=AFPM Edward Adam Davis wrote:
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
> The fix involves adding a check for the end block: if it equals the
> start block, the trim operation is exited and -EINVAL is returned.
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
>  fs/nilfs2/sufile.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 83f93337c01b..63a1f0b29066 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, stru=
ct fstrim_range *range)
>         else
>                 end_block =3D start_block + len - 1;
>
> +       if (start_block =3D=3D end_block)
> +               return -EINVAL;
> +
>         segnum =3D nilfs_get_segnum_of_block(nilfs, start_block);
>         segnum_end =3D nilfs_get_segnum_of_block(nilfs, end_block);
>
> --
> 2.43.0

Hi Edward,

Thanks for the patch.

And, sorry for the noise on the block layer. As his patch points out,
this looks like a defect in the NILFS2 fstrim implementation.

However, I would like to discuss the approach to the fix with Edward.
Since the FITRIM request size is larger than the block size (which is
1KiB in the syzbot reproducer), the request itself looks valid. I
believe we need to fix the logic that causes the loop overrun instead
of rejecting the request.

I attempted to reproduce the issue using the exact same ioctl
parameters, but it completed successfully. Therefore, I suspect that
specific disk usage or metadata corruption might be a prerequisite for
triggering this bug.

I will follow up with more detailed feedback later.

Thanks,
Ryusuke Konishi
