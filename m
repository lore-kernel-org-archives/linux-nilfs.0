Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00F815920D
	for <linux-nilfs@vger.kernel.org>; Wed, 10 Apr 2024 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712753288; cv=none; b=gQWicv0ZUwaURP2dvN9z2bsmL0XpYzJh91XYAHKQJtKQCrk7wuHarzrS28uyP8WQFatBg+OMkj8X7E2oj4FyCCUz8pn0Y2S1BjwDIWLSZFWQxhLqsg8Ok2M5eFWCY0gim048/pV7ig41YcaOuJbIfIFP3jC0fMmYCGS/93gWeXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712753288; c=relaxed/simple;
	bh=hQjzVLEF7LZEsGLbGGinzxO7xtiNIQZKctKxi5STK40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jXmQKrajv633hvIEesemEuiWgMqbhN4RFRTCdDQan+hziW/JETyJuZ8GMuXQXtTUvL8P21Thh7W6FvIvP4fmu8jwwxz073Z9jXaCgCKvXqIs7b0azROXL9ysHlxuEvHe6xXN7mmtOMdzTndoHr0HvReJITrcc+8+wlUg9iVe8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQQnGt3J; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQQnGt3J"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-516d264d0e4so5438342e87.0
        for <linux-nilfs@vger.kernel.org>; Wed, 10 Apr 2024 05:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712753285; x=1713358085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hydvzTwL7ePB4dUVs/9Axe4Vj3LIUX1et3RIHQc6siI=;
        b=UQQnGt3Jpn2zc7MOfePN+kKBztoOQGsxMKK39wiza3nc4T/x5nC8CAMJTFigjvlwIM
         flu4GHiQgOqV2zuz/sxwkT+m07D3awI235TeThyF66yv7UsMk1W+4R3fsHU8Px3xxMca
         HlsqDwYn+2HA2l/zfh1rT3E6ZbvQrv8JXWnjbmAWYnfPHmd3EV07KBBCcoN67BCqptYp
         znI4rHNbnf90rGLvHVihbNIJ8juJ/2bpbpv41hOiGBwajwWV0MkHKB6rkWK9Kb1xzvWi
         HjY+GOcsWHq1OiYUVa8tr6jN2Q5cyOiJSMCJfW6wD0YPorvMvhBavcQ0SQvMt8W4WeBB
         2ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712753285; x=1713358085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hydvzTwL7ePB4dUVs/9Axe4Vj3LIUX1et3RIHQc6siI=;
        b=IEZKKzd9BXqWZPbWm9irYGl419cb1vcc3kUrlA631wlV1foDmDlTF4qphFh0G+RPzt
         Wnft7KhfrHrZhBpLKacmwzjgvfZuHe+6R5ChV1nLCPZ37cHFU+9jjBXGd/NipzutFqgP
         9IInj0aOGaPuUzQlInsy+6bjdLwnSMINs1RoQCoaQKxCnwg0/26D2RnjCjAi9b7a55XR
         tWKMDr6nfECJ/B+040QxzDqxWK1+PUz8oM+/JBZ8BSZ8pwXhxy1EoQn+tSnsZqRzC1i2
         bu6clRCPS/fKBcgzWFdV+YpoOTRMP6tVrs2yg9AB9Xhmmvt6MW/M0/MNk18pU4AY8Lm4
         Lp0w==
X-Gm-Message-State: AOJu0Yw0Aqq5WKH/+Ut6w/SONqt9VVO5Ch4tcjBLk0vW5AmYezLGZMfq
	l/uW8y1iWrKYPsqLfC4WEFzCv/E0zj8KF8nuvo+D920MZBPhLBMZgbuRAqWim/U96DE5zs3qN2C
	mU98qrarfayaoTVHNhFJP5f+quy+MhnmZvs8=
X-Google-Smtp-Source: AGHT+IGBQ5qLvkyCRBI5fd2jMa+64SVFDCvMU2M43sPZiq3vps3UPguka0AW6pi0wp/us93JKcvvpZlgU1j0ZUTLu/Y=
X-Received: by 2002:a19:e047:0:b0:513:e677:790a with SMTP id
 g7-20020a19e047000000b00513e677790amr898616lfj.6.1712753284554; Wed, 10 Apr
 2024 05:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com> <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com> <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
 <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com> <CAKFNMonx-qZPUn6-qCFGbiFd06K-3bjsHyaw+rw_uq3YU_m=9w@mail.gmail.com>
 <55663cac-42e0-4be6-9f3a-e3f9f3d1ab50@redhat.com>
In-Reply-To: <55663cac-42e0-4be6-9f3a-e3f9f3d1ab50@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 10 Apr 2024 21:47:47 +0900
Message-ID: <CAKFNMo=4NP_3-YebtVO-OcxzxCNvjSNAW_PY-Uv-7wvdgvxp9w@mail.gmail.com>
Subject: Re: [PATCH V2] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 4:54=E2=80=AFAM Eric Sandeen wrote:
>
> On 4/9/24 2:13 PM, Ryusuke Konishi wrote:
> > Thank you for waiting.  I've finished the full review.
> >
> > I'll comment below, inline.
> > First let me say that this patch is great and I don't see any points
> > that need major rewrites.
>
> Thanks!
...
> >> @@ -1180,130 +1163,57 @@ static int nilfs_remount(struct super_block *=
sb, int *flags, char *data)
> >>                 root =3D NILFS_I(d_inode(sb->s_root))->i_root;
> >
> >>                 err =3D nilfs_attach_log_writer(sb, root);
> >>                 if (err)
> >> -                       goto restore_opts;
> >> +                       goto ignore_opts;
> >
> > Here, if nilfs_attach_log_writer() fails, it will return via
> > "ignore_opts" without restoring the SB_RDONLY flag in sb->s_flags.
> > I think it is necessary to repair the flag only for this error path,
> > what do you think?
>
> Again, I think you are right, although maybe if the above flags copy is
> moved to the end, it won't be a problem? I'll look more closely.

I also dug into the code to see if we could move the flag manipulation
backwards.

nilfs_attach_log_writer() is responsible for starting the log writer
thread, and this itself can be executed without being affected by the
SB_RDONLY flag.
In fact, when I tested it with such a change, the read-write remount
completed without any problems.

However, since the behavior of the log writer thread is affected by
the SB_RDONLY flag, there is a risk of introducing potential
regressions.

In conclusion, it's probably okay (unless you want to avoid even the
slightest risk).

Below are the details.

The first possible side effect is that log writing may start for some
reason before the SB_RDONLY flag is unset, and it will fail due to the
SB_RDONLY flag.  The call path for this is as follows.

nilfs_segctor_thread()
  nilfs_segctor_thread_construct()
    nilfs_segctor_construct()
      nilfs_segctor_do_construct()  --> sb_rdonly() check fails and
returns -EROFS

The log writer thread ignores the error and does not output any
messages, and the write request (if any) will fail, but this is
expected behavior at this stage before the transition to read/write
mode is complete, so it seems ok.

The second possible side effect is that the log writer thread calls
iput(), which in turn calls nilfs_evict() through iput_final(), which
causes inode metadata removal to be incomplete due to the detection of
the SB_RDONLY flag.

This should not normally occur since inode->i_nlink does not fall to 0
in the read-only state, and even if it does occur, it can be
interpreted as the intended behavior since the transition to
read/write mode has not yet been completed.

Even if there is a problem, only syzbot will probably be able to detect it.
And If that concern turns out to be true, I can deal with it.

Sorry for being roundabout, but the bottom line is that the change you
think is OK.

Thanks,
Ryusuke Konishi
