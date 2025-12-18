Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C3C332EAA
	for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766061793; cv=none; b=h0vDlMiAIQeJMMtYdgUtPOtXODwJ/q6pfyVqHQcFAI/PH3e65wxvJtv/Q9KKGK5I0xnn7rhXtEV0X9zuZJJwAxPrcKU79RzIUPZHRVMQmvuSk3EjRKh/QPZIGeBQDrx8wxf//ECsbYUFuYVYGSCkoCDYzMS5K2liirFRbWwP+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766061793; c=relaxed/simple;
	bh=up45tRbosLlqlluwLPuRjrk1Zq7vrz8pKfhR/3uydvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEkUxBobMxPuj6B56qWKyAGLz02YnFirGz97FcI7xXR7jxAU+dm9Urr8MUX9UYgblpGX4N9rSYbXPfGhuIZH3W6f+DJxFeWIO5AcDdFWpEHvNi9gvKWYoGuR3WZWEytKzNMj3aeu+uFI+IIGQNQeF6iXtHoCNbD7y5xZTHUhnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aGNGxiiP; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGNGxiiP"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so4348831fa.3
        for <linux-nilfs@vger.kernel.org>; Thu, 18 Dec 2025 04:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766061790; x=1766666590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPFRGvWdnjneL6gcP+iIUvoKt06DA12JMmJFqetCxC4=;
        b=aGNGxiiPB/R2v3B6cif+uozP49ei4O6KAkIBpG/OhdaXwld6BD93G9Yu8LwtHXdpF/
         F7Mv6icJAOGUR6yo9KB3nhr/L2JuLBi1iMfPuH56M+345UiAUt8XjmPLvcL8Nr73Fp1i
         81h75faKoXjJXYOtmmVZcN+e6gHhkWC5uzLogbg9UAP2abHEtsujGBVDs7VgAOO1dP+1
         aHY6kxW/Ddo8FmRcOq+48mmfcga+v5L4666vo1becv2ku+L8tUr6XTCOfoXRnxYdRTR1
         SVEvOVpOCANlLRNzWvzSUyzrMKqmHXqDVVxyCrH6WfkvJPCjGxjpqHMc+ozVeS5M1g4Z
         g+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766061790; x=1766666590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vPFRGvWdnjneL6gcP+iIUvoKt06DA12JMmJFqetCxC4=;
        b=LBQU7+eOYlBb/1lCR0jZZC1iEuiXldjt3+yNfxjQUX9E6VgGXA+IceaD7/CzCNBwfk
         IGeYbZ+lwEHe1quh2LAHfvrV1AaGTnzzjvEwaPa0grnv53Q9XJDnEG7Xrg3Gpqek8ZlT
         KlV1ekpWN/6wj8Zwp+IdiNBzbgEdRTgUSvEsL8br5oBc3IpRcasp+xNsDzua6YQXy+ru
         XqA3Dyxq/td8M4dZArG+j4MmN+41meXtLpx0izNs6MbXuRnyM5HQY3vbMoo+8Li3XhCm
         BJa9qMIe+S3Wd7io9AbZgHg9W9BQHEICypQWXpy8CPCy92fnejKmVxGmTX+FRTpamUP+
         GKFw==
X-Forwarded-Encrypted: i=1; AJvYcCXYHcSqhAGrfi1tQBxJkmk3QVeK+sRTIO5kPFxGTVGyVlj6LWJi2UJM/Yxuirnxa1ck+n8fo2crk6laew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaeAectsCaGbJWDH85Zz5ITFbeMAS7Czqw8esEIdbkCQ2rrXhE
	sp5wM+k/V9SIl0yK8S84syVKMouThGhU3SSye2HidoilxseCmNPGF3uT2YphjHrTJ7feHt7+NK+
	h4MfRkzRjfvMsO+WNfQ+5K2WxcsMVRvo=
X-Gm-Gg: AY/fxX4zmKY5suzWPj/v3m0MCf4o+l8jfwUDLvz7KhEnxkC6IlptgZHAjtW8Crmtiab
	tSRcQThJbUBoxNwulhMe/TT4I6fZDJ5tEAJyGHoU3qFxPYbkLT7aS504cFtaA5S5fT61WAQ/Mfo
	rDsbEiQGukPhoIyzOjRMmfcQrCBg2OjnrhmWxuazLhrC38IkMb5h//sIpku5/FtFProdCiSNgx8
	bqzyySebI8qea1uLCm1SpvxodqQIZfhq+hCNOJqFBeDhSQX3UKgNGlOsJ4KDL0Q6b3gKdsd
X-Google-Smtp-Source: AGHT+IGwI88wN3MlkEZqCd8u2hmwW1SfXPQl0m1UQ9m/pmeVp3DIopy5kEYHKpLrt9IvV9cwEEX4lksx65pLesU+tN0=
X-Received: by 2002:a05:651c:1508:b0:378:d5dc:17c2 with SMTP id
 38308e7fff4ca-37fd0799359mr64347121fa.11.1766061789377; Thu, 18 Dec 2025
 04:43:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMo=602x-hdCCQtPdZ7PxX5FezeUERLEcrT17OjYxif=RMw@mail.gmail.com>
 <tencent_B46C5094A8EAD2EEAECDEC7B126EF42D010A@qq.com>
In-Reply-To: <tencent_B46C5094A8EAD2EEAECDEC7B126EF42D010A@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 18 Dec 2025 21:42:53 +0900
X-Gm-Features: AQt7F2omicZr-Uo8MkaC8HfJW0ChHni39EAyQthLNuvQEM6ATm9_gsb9nr4q88E
Message-ID: <CAKFNMok7oYJmwYtEEOLZ4qYHAPzqq8uJnc3AgospWq6Q-DrpEA@mail.gmail.com>
Subject: Re: [PATCH v5] nilfs2: Fix potential block overflow that cause system hang
To: Edward Adam Davis <eadavis@qq.com>
Cc: axboe@kernel.dk, kristian@klausen.dk, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 9:11=E2=80=AFPM Edward Adam Davis  wrote:
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
> Exiting successfully and assign the discarded size (0 in this case)
> to range->len.
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
> v4 -> v5: assign discarded size to range->len
> v3 -> v4: check end block and first data block
> v2 -> v3: change to segment end check and update comments
> v1 -> v2: continue do discard and comments
>
>  fs/nilfs2/sufile.c | 3 ++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 83f93337c01b..eceedca02697 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, stru=
ct fstrim_range *range)
>         else
>                 end_block =3D start_block + len - 1;
>
> +       if (end_block < nilfs->ns_first_data_block)
> +               goto out;
> +
>         segnum =3D nilfs_get_segnum_of_block(nilfs, start_block);
>         segnum_end =3D nilfs_get_segnum_of_block(nilfs, end_block);
>
> @@ -1191,6 +1194,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, stru=
ct fstrim_range *range)
>  out_sem:
>         up_read(&NILFS_MDT(sufile)->mi_sem);
>
> +out:
>         range->len =3D ndiscarded << nilfs->ns_blocksize_bits;
>         return ret;
>  }
> --
> 2.43.0

Thanks Edward!

I'll send this v5 patch upstream once I've tested it.

Ryusuke Konishi
