Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0666E2D1F44
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 08:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786178653; cv=pass; b=t1wwElF4bXHVB10b4up67GFO6FCp2fth7jwVdQTP0k78ohZH5DQObcC/mAqTjVjrCmkKEpnK2+awminf+9YT3yV3WWSKJ3kz1H7yd4CnRA13eeGBHlRTpjoWKHXBH+qt7GnnRkdXVTAeC2PSN0YuRwYpfpCwiFJXjypCw4+vSIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786178653; c=relaxed/simple;
	bh=hzu99rKredqFTLexCpl9DeALOHaPv/iUvmN6A7qJS44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zs/VnwTAmVK4cAanu8lpJ7Pplwy84mYCXn+/UGhTOcvg9RsVfOrLZPqrFb4dxvnSIH3ElBYMgzrcoxzFe9SR3R4o+Uxb/IhUSyj9R1xAwGfQdLjoPUWiYHQuvTwCbbWwjYa9j5fdgPzkk9ZblyiIcNxxprwpPcTm4w6bj9otzXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cRNp+KBl; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRNp+KBl"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b0f19bea2fso339027e87.1
        for <linux-nilfs@vger.kernel.org>; Sat, 08 Aug 2026 01:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786178650; cv=none;
        d=google.com; s=arc-20260327;
        b=jEWFi9QuDoePzT05LdyLXYcFwBbr80ozbjFMfUyqmnBmdpzWhHh9dG48BB04VrcyBr
         26XHPKcU+diuReJgcp4yBiRpp3T8zeANuH+5f0poruTC8DWYhYwHrqVKtnZ35ZUz/v3w
         37HQB6WF4vXJDLf9vk+TNEqG3PkiqAUdLo2n6fJEaKxGg6YkDoCy0wfNOPl9vTWJnPjB
         jVPTP513pU+G6u2FhcPQBLM74gmYj5F23rqBvuh8DzQN2C2P6Q9EbD8uBHb31Ph+ae71
         JVbG3WzXXpbD3Buyk/JYTx0cCgxeLGoFjF7Gh5z1jNUNo2rC75CbFWLXWZFs7MgGGHHX
         33QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EkkoxhVSk6DgYcMKYcrqMLf8vvSO5l5E5LrZJIB7fTM=;
        fh=YfFUii3hjROxIgu6FdsaMdBw+NFAFpkYdfg85Wrk0po=;
        b=YBKXRpJUo9tsirJxCRwKi1j2JYtxcFF9sFrVAFLTkBTVOR353JRBb10UsG77Rr9xpU
         3Eu2NsOAaabxWultCnw+oEAdn19w8TDIeAKrlhmLvgeyvfRxt4eWIrGTOeKY8bAVFWKU
         yiW0Hcuq91KPgTVG7geGV1WgqHSXWLJVxPEy86mJLvJD3HqpgJX8MUbSm3CpzFOr97nj
         G9LcqGKoAt95JLRmmdHHrY02C9x9fohMzjeNdxKysk8Vu3oTmVFIfRX7wJR6KL/1p4SI
         QCuPa11bOEhECjZgzknrCk5pyO0/1L9CNWWPMdhAgLEJ0IEr+SP4qa0nAvAjn9aNhiAG
         q3vQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786178650; x=1786783450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EkkoxhVSk6DgYcMKYcrqMLf8vvSO5l5E5LrZJIB7fTM=;
        b=cRNp+KBl0hQpjQXS2+Pg8vKdrrYgVrYpei3LpcgVgPBnz0XFRrzgTpyqlvvGhzInG6
         sN2exa8GiEwvF6khTO1q2eEaERnjoEuZTomY+aF4FtiyU7W9aKNqqvFPQUHSmk/4FViE
         W7MlZQ8VharS3pXSdlqy2vfxVzoAmqOr0AQfYHDKqdlNltneY67ibAsCVxbtbV26Xzpq
         M/ZJL9ZP+Q6K6KvjIYPNE1eHLXy4wCBT0QR7rv5xlrnIzpfvOLXNAi64WLGRjh4jHbsX
         86mi7Kiud7vEpzwfAGFBAyZUTzQQTrlDTtpw9QmGmjAxoel/CGxy7L03kJrw07Osqno5
         SxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786178650; x=1786783450;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EkkoxhVSk6DgYcMKYcrqMLf8vvSO5l5E5LrZJIB7fTM=;
        b=JsbYqJUYzo6wYOIiqAZx1PNfTAowkvRHoime5s5zj4891+F3DIllLAKIL/peNqpAkG
         CJaDz9Jav14I9Nf/6bsv3/Vjj+Zh6his4Xuw7MS/mRkczS8Tmf03pCcJXCiCw8iQNSXa
         HoUlweNXJ/TexNCoaL6fuxiVi3ZYyx4eusOLSdcFGZsDAY1P1qLflsRdHGvg7thz1ILO
         mVu2AcuxaPOhbQHDtt88atpj3wIKMLEasFtjIR60yAKFtScdg+xXxVKbU38vQGXY92Hl
         1cOs9rGGpfC7DmY3T8NsgMxPbchcr+cjBAZhWgZ+Wa8cQPjRDCySq1orjwbMRx33x4d9
         44YQ==
X-Forwarded-Encrypted: i=1; AHgh+RoL0yDu48/g085jjXGbvzRZyhR61pQJpynv528KDgn6B7JKd8KVQ+MFw9tewsE0D4SjdJnRJYzYK7vmLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyemh/RrIyg30egOOesZzQ/dGrRyyfxban8TElmA68zgprnqy1i
	0JyaE/Z0nqPlVTFeU3HDHiyKGjtBl3cFGa0cfol9X3inNqIdDEoQsyy0nSwPE5VE9c8h6Oz0jFZ
	w0rbggKj8fYB/I9BQRk/cxXwlVebIVJE=
X-Gm-Gg: AR+sD10rbkxuJ1gLqdclxbIWRnj+6GWZBL9PZH/o18vmB8BJOoT4/rXP1AyBY9OKWD4
	JbM5I0r4tjBwuBuhf3UzUSIDRhRXHmyveYQa6AlqFNapMSQLq/S7l/d6w7yTTxxYSjVkJCfeC6O
	mvgnUFNiN+om8TXDaOtclqHtxB1X0MHqq+pW9Rglugi+OGtUO2IDeI9HJhwwNGbqfSH2HAENrBv
	5lubzsZcDd0nrCoFSvLYmRli5NKdTH2Xs7+ZQrX8qw9xeWQ81NkX3BQB/3JTP325e7R2usqDX4E
	Q6uNCbMCeHod+Aph99ATdZnYpUpf4SevdiIxyIK7AvB7CQ==
X-Received: by 2002:a05:6512:1293:b0:5ae:b969:417d with SMTP id
 2adb3069b0e04-5b309127faamr1430202e87.0.1786178649734; Sat, 08 Aug 2026
 01:44:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730120105.2746192-1-wangjianjian3@huawei.com>
 <20260730120105.2746192-2-wangjianjian3@huawei.com> <CAKFNMo=_QiAVYgqCggCqVBBwC4F+g4cOWgS=Nt=AAghda48gAQ@mail.gmail.com>
 <000b9199-ef5c-4959-8a46-47d5fda76f15@huawei.com>
In-Reply-To: <000b9199-ef5c-4959-8a46-47d5fda76f15@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 8 Aug 2026 17:43:53 +0900
X-Gm-Features: AUfX_mw3L5ffTPKJ3B9dUxWAcEq_YO1U_1c559Fkckki1jI0NvwdWf1zDtf72nY
Message-ID: <CAKFNMokXz7HtN7QLFjZBK0wZ2uvO-5+Lx7-rngJ8hL6v_vMmMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] nilfs: check new inode's nlink when rename
To: "wangjianjian (C)" <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 5:31=E2=80=AFPM wangjianjian (C) wrote:
>
> =E5=9C=A8 2026/7/30 21:31, Ryusuke Konishi =E5=86=99=E9=81=93:
> > On Thu, Jul 30, 2026 at 9:32=E2=80=AFPM Wang Jianjian wrote:
> >>
> >> When rename, if new inode exists, then its nlink must not be zero.
> >>
> >> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> >> ---
> >>   fs/nilfs2/namei.c | 5 +++++
> >>   1 file changed, 5 insertions(+)
> >>
> >> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> >> index e2fe95de3d71..db171789a316 100644
> >> --- a/fs/nilfs2/namei.c
> >> +++ b/fs/nilfs2/namei.c
> >> @@ -397,6 +397,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
> >>                  struct folio *new_folio;
> >>                  struct nilfs_dir_entry *new_de;
> >>
> >> +               if (new_inode->i_nlink =3D=3D 0) {
> >> +                       err =3D -EFSCORRUPTED;
> >> +                       goto out_dir;
> >> +               }
> >> +
> >>                  err =3D -ENOTEMPTY;
> >>                  if (old_is_dir && !nilfs_empty_dir(new_inode))
> >>                          goto out_dir;
> >> --
> >> 2.34.1
> >>
> >
> > Wang Jianjian, regarding this patch - much like the previous one - is
> > this fix related to a Syzbot report?
> >
> > If so, could you please include the appropriate Reported-by and Closes =
tags?
> >
> > Also, please ensure that the filesystem name in the patch title is
> > "nilfs2" rather than "nilfs" (kernel patch title prefixes generally
> > follow the filesystem name, nilfs2).
> >
> > As for the patch itself: rather than using a stopgap measure to check
> > i_nlink inside nilfs_rename, could you investigate the root cause of
> > the inconsistency? If there is a flaw in the checks when reading the
> > disk inode or a race condition involving link count handling, that is
> > what should be resolved.
> >
> > Additionally, you are returning -EFSCORRUPTED for filesystem
> > corruption, but nilfs2 does not yet utilize this return code.
> > Following the established implementation pattern, when filesystem
> > corruption is detected, you should report it via nilfs_error() (which
> > logs an error message) and return -EIO (while I agree we should
> > eventually switch to -EFSCORRUPTED across the board, doing so here in
> > isolation would create inconsistency).
> >
>
> Hi Ryusuke,
> I have sent v2 patch and the root cause of the problem is in v2's commit
> message. I don't think this check is a stopgap, other filesystems, such
> like ext4, does this check too.
>
> nilfs_error will mark fs as readonly with default mount
> option(NILFS_MOUNT_ERRORS_RO), I am not sure if this is overkilled since
> this make the whole fs readonly(however, I add this in v2 patch).
> Perhaps we should isolate this error and only mark this file is bad ?
> For fs like ext4, we can mark one group to corrupted but nilfs seems not
> have this disk layout isolation.
> > Thanks,
> > Ryusuke Konishi
>
> --
> Regards

Hello Wang Jianjian,

Thanks for the submission.
I'm currently swamped with other reviews and testing, so please bear
with me for a bit while I work through them in order.

Thanks,
Ryusuke Konishi
