Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FC38C10
	for <linux-nilfs@vger.kernel.org>; Sat, 20 Apr 2024 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713621477; cv=none; b=Cw/1SWQr9CiLqL4OfWcaF0ZloEMSXcOd1KUEWgklmwWCnSDAq2dO6UzRuWC/Q/qXEgpE+xu60sXpJLJK3VqAnCJnX4z/PJCLMfcZ83Vw12zeMtDEMhlyBiM4L+5PlvF3Qj5RXEjRdLVcQ0QQaWYvtiyO9wGJCMHR2nCB4V/qhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713621477; c=relaxed/simple;
	bh=YxZXrHf8XQA0FSBVDv/MLFisuG63AA6vaAxOKpkXGt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AL9A0pqozJ2iXQd1mkSI6qeENuSVKN+rYBR1Ex7asrchxVC5E8IWiQf2729JavGOTlEJXl8EzrTbNujAWFdJbrDhKaj6qUaaZ4tXKT2dFbfKLqdU44/g9vxCOKe+XsGb+XLbEAJ3BjpLPufF6cBImT2pny/zu6hcbDEvVknRw7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Exiis7Nq; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Exiis7Nq"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2db2f6cb312so53394661fa.2
        for <linux-nilfs@vger.kernel.org>; Sat, 20 Apr 2024 06:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713621474; x=1714226274; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrM3k1ZQl399RIKXNLLTsm+QDVaWerIS9+Rgs9ZVEWo=;
        b=Exiis7NqDysOCmqd1zq5a3Bti3/EEVZTv+jUXhWPn7JfDCHcnfro070ke4OS5pzjbn
         1U+gB90ZB7QAdxBvk1tkrPuV6AJ6OOxR7HPvsEAvKsZIAByI7FgcgFnc5IQZ+umuWfYt
         scKpk51rLpMpSIcgbOGZO4dyvNcgHvHyKPgHZRo0cJ6yhqWFAGklNtlo/RW8yICHDnwF
         3tpmVNd5Qf90xTn+/fW7K2is9+gw6f9Vgn+pnGVp3O/gzh+Li6OlfNAvDApKo5ipoX7a
         3ZA3gN3N26lpYgYc2jfE2i+7fnwLS46U0wXMvaZp7q8zIzg5l+Ql3qZEpiDwkS4h59v8
         vnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713621474; x=1714226274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrM3k1ZQl399RIKXNLLTsm+QDVaWerIS9+Rgs9ZVEWo=;
        b=lyLrlXN6w+yxcgbl97K9bwdh7CENtBFhz3Yaq2IpdlFJzC1Z4fsQo4+RPhMFU0ixZ1
         rdGLZuOGGGc3Tg/h+nWqeW/KVuamT1rodagfN4mSnVIqEqSkl2uMBhBEYtLcmEhOXHQ0
         lBibbYclffeFCofUVxZnBcvbnUNXNCnACcXnyTUw+rUi20BTLmERA1p87fKx94PcuZKR
         6QJ6Gu5HthkGJO7yJ23xVTANU+dh8NSyB6mgH+lnAssuTnTdNnbgnAzbIhQXVDkm83J1
         kTz/oZDpxk7Fz9EVRuoY/WHjLLvWd7UMJ7dmFhPUv//mLZ5kiN6u/RHd1paWerG6Xkct
         A1mw==
X-Gm-Message-State: AOJu0Yydjc4yoQmj20Ha5cBdoq11S0SLJPTQcCwy3N4hN4doLOUr53gI
	CSF8ip8aLgd73ohYDnzOkDot0WZ9/h19XN/mv0TmWMSpdMmuBuky0K4utdIqE9BF650OzfV60L5
	sSN7E17npj+dNpz0G7KzhDVUUVNA=
X-Google-Smtp-Source: AGHT+IGOnpLqjuZGl1ZVsiMUqZMK6qdg3wNRy4bOWRv5AW+5grMDM6tEh2XKZFzn8VmwnaYlCkGmbk7ZQCwvlW8gbek=
X-Received: by 2002:a2e:b059:0:b0:2d8:6a04:3bcd with SMTP id
 d25-20020a2eb059000000b002d86a043bcdmr3522786ljl.3.1713621473742; Sat, 20 Apr
 2024 06:57:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com>
 <CAKFNMokRBcoP8z8Y6m60bYb=Se9SSn3N459hE0KWAnN7tEop=g@mail.gmail.com> <98da70e0-8a2d-43d3-863d-edc37b56ece4@redhat.com>
In-Reply-To: <98da70e0-8a2d-43d3-863d-edc37b56ece4@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 20 Apr 2024 22:57:36 +0900
Message-ID: <CAKFNMomMKfqBMFeJa7Ct4zR7MWiwN72D1ccTMQEhUEygXyhgew@mail.gmail.com>
Subject: Re: [PATCH V3] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 20, 2024 at 7:06=E2=80=AFAM Eric Sandeen wrote:
>
> On 4/19/24 3:12 PM, Ryusuke Konishi wrote:
> > On Fri, Apr 19, 2024 at 1:45=E2=80=AFAM Eric Sandeen wrote:
> >>
> >> Convert nilfs2 to use the new mount API.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
>
> >> +               if (result.uint_64 =3D=3D 0) {
> >> +                       nilfs_err(NULL,
> >> +                                 "invalid option \"cp=3D0\": invalid =
checkpoint number 0");
> >> +                       return -EINVAL;
> >
> > At first glance, I wondered why the nilfs_err() super_block instance
> > argument was NULL here, but I see, it can only be used by remount..
>
> Yup that's right, no sb yet on initial parsing. Hopefully the message
> is ok this way. There is also an option to emit mount option errors throu=
gh
> the API, but nothing is listening for that yet.

The above implementation is fine (the original
nilfs_parse_snapshot_option() also does not output the device name, so
nothing is lost).  I just found it interesting.

>
> > ...
> >> @@ -1172,7 +1157,7 @@ static int nilfs_remount(struct super_block *sb,=
 int *flags, char *data)
> >>                                    "couldn't remount RDWR because of u=
nsupported optional features (%llx)",
> >>                                    (unsigned long long)features);
> >>                         err =3D -EROFS;
> >> -                       goto restore_opts;
> >> +                       goto ignore_opts;
> >>                 }
> >>
> >>                 sb->s_flags &=3D ~SB_RDONLY;
> >> @@ -1180,130 +1165,56 @@ static int nilfs_remount(struct super_block *=
sb, int *flags, char *data)
> >>                 root =3D NILFS_I(d_inode(sb->s_root))->i_root;
> >>                 err =3D nilfs_attach_log_writer(sb, root);
> >>                 if (err)
> >> -                       goto restore_opts;
> >> +                       goto ignore_opts;
> >>
> >>                 down_write(&nilfs->ns_sem);
> >>                 nilfs_setup_super(sb, true);
> >>                 up_write(&nilfs->ns_sem);
> >>         }
> >
> > There is still an issue where the SB_RDONLY flag on sb->s_flags is not
> > repaired in the error path of nilfs_attach_log_writer().
> >
> > This seems to be the only essential issue remaining, so I can add the
> > following fix (safer one - drop the SB_RDONLY flag for
> > nilfs_attach_log_writer, call it, and repair the flag if it fails),
> > and send it upstream.
> > Is this okay?  Please let me know if you have any opinions.
> >
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index a54fa43331f5..a8f03c860e87 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -1164,8 +1164,10 @@ static int nilfs_reconfigure(struct fs_context *=
fc)
> >
> >                 root =3D NILFS_I(d_inode(sb->s_root))->i_root;
> >                 err =3D nilfs_attach_log_writer(sb, root);
> > -               if (err)
> > +               if (err) {
> > +                       sb->s_flags |=3D SB_RDONLY;
> >                         goto ignore_opts;
> > +               }
> >
> >                 down_write(&nilfs->ns_sem);
> >                 nilfs_setup_super(sb, true);
>
> Oh, I'm sorry I missed that :( Yes, I think that looks fine. Thank you.
>
> -Eric

Good.

Well, I'll continue testing, so I'll keep this patch for now and let
you know if anything happens.
I would like to send it to the -mm tree as soon as possible.

Thank you!

Ryusuke Konishi

>
> >
> > Thanks,
> > Ryusuke Konishi
> >
>
