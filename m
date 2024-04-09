Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5CF51C39
	for <linux-nilfs@vger.kernel.org>; Tue,  9 Apr 2024 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712695020; cv=none; b=c0U+UHzzQCJvE+XBEAiU4R4mcbUGB99lYFUhEuN7NXNc/uMNCOknfKPjI2S/AER6h3OruGsO+d2ic5f1NzVFd/3+H17dedSTYlpxWbIKmQqpbUVPGqagfMSwTcM0KyFyzvF7xOfPU1daN+8kJaNAkvRet5LJHH5rub4jSU28yc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712695020; c=relaxed/simple;
	bh=6eJmaLCvM44g5tejIcCo4u8pT1jQU4SL8ZiOJYTa6Bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V1r7ynsvV7SzkrfSQXBSJSWDUq+KY8SoC4qtMkgJDwNVw78JQxdcvKFv4fCEmxN4RPKpDHK5AO2/X+h7kxke+iOKY3Z6vPaUTn781+L+13isk6GPnJucXR2Js4PMy3/fVEazfvRHziajCymxfnEbubOmszndLKc6+JuI062ItOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIU96R8c; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIU96R8c"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516d2b9cd69so5608325e87.2
        for <linux-nilfs@vger.kernel.org>; Tue, 09 Apr 2024 13:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712695016; x=1713299816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meOPBkw8+4057VWbLtjzNK6Y7Qt5JX/X6n+SYPUHrvM=;
        b=aIU96R8cgKfvGR08iSKgDCkaNpsjECrCQFSeCJ0+9XWapQCdNldXTDtH1l33uLRVgw
         pHuj7ebc2QPYHL1cnvuOzRBJ0Ldde6Mu/sVZ0jh2dzn20REC7YEV+ucHqlUMFxIQ0mS+
         f2Dn7FMF9VQRKH0O9URpNf+RS2xYZMOEWEt+O6AN3CkhbXx0fABuovVwFI6E0HUqSTrP
         rfePoHyetRaLK2+Z9iVkiwSEjGqdaX5bfx/DaD4tt9WJGg+xEJqZ5ynrIGTBR9+eZk88
         mptfu6hGzJ4xWv5LgcRDQ4IzWWrYp54sz9mzMFlpuiApmZn3Cjv280YD6jEMMA+8Upx+
         5saQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712695016; x=1713299816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=meOPBkw8+4057VWbLtjzNK6Y7Qt5JX/X6n+SYPUHrvM=;
        b=pdfO+7iKUrrTVtuePx96cjgXWOdc29H0Kcl0cratigX/wHIClzFnr9a4oFg7QKYBr8
         IRVP29oSGBNeOg9HJ/wUFarURqcVU2JPuf/DX8/999mmstaJJaDOc96AJ5dORZiPgDpD
         9b7NCl7IBxv4tXalaf7+j1g2OeLVhv0xA1QwSim8lT9csNv6uwHnUhmTEOE5bOl9aDPu
         gfu4gqdWikrdnmrxpI45wBru7ps/I2yPj8/Ql5o3hYs4hEo7V8gOG0nnyho378m4l8rC
         cF+Jj215u7EyjSc1wdnX+BI3kk7yKetsh9EADr56dvaOQLV0kqVPGIL/BeRauY8oHi7o
         IqIA==
X-Gm-Message-State: AOJu0YzMqNRUnqQmJHoihlra1rSgQ1uS+CNv7jOghuLPLLjjetfM9PY1
	T+xVAIrufnMuafHAqo3xnd8cU9w34LeQV2EMxj2ZNW34T0ksicH9nli+851qQULJhElJUGr91Iv
	Jq7QXwvBGBKGpf29A8JqVu7QdYr0gkD39WYw=
X-Google-Smtp-Source: AGHT+IFIOnkSeJNCyGt0oP0GuwpVxkbw2eevH3H/a2fyxSZs/TcvzvNi7lggT0dznnsrHrjpFFDttOk4e8bn5VapBaM=
X-Received: by 2002:a19:2d0e:0:b0:515:d10b:522a with SMTP id
 k14-20020a192d0e000000b00515d10b522amr327283lfj.30.1712695016121; Tue, 09 Apr
 2024 13:36:56 -0700 (PDT)
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
Date: Wed, 10 Apr 2024 05:36:39 +0900
Message-ID: <CAKFNMokAXad=2XSp5QjrKL_7atJKiPqSaBjk2GVBJajMg==F8Q@mail.gmail.com>
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
>
> > Regarding style warnings, I will reply to that email later.
> >
> > On Fri, Apr 5, 2024 at 12:00=E2=80=AFPM Eric Sandeen wrote:
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
>
> ...
>
> >> -static int parse_options(char *options, struct super_block *sb, int i=
s_remount)
> >> -{
> >> -       struct the_nilfs *nilfs =3D sb->s_fs_info;
> >> -       char *p;
> >> -       substring_t args[MAX_OPT_ARGS];
> >> -
> >> -       if (!options)
> >> -               return 1;
> >> -
> >> -       while ((p =3D strsep(&options, ",")) !=3D NULL) {
> >> -               int token;
> >> +const struct fs_parameter_spec nilfs_param_spec[] =3D {
> >> +       fsparam_enum    ("errors", Opt_err, nilfs_param_err),
> >> +       fsparam_flag_no ("barrier", Opt_barrier),
> >
> >> +       fsparam_u32     ("cp", Opt_snapshot),
> >
> > Checkpoint numbers require a 64-bit unsigned integer parser
> > (originally parsed by kstrtoull()), so I think you should use
> > fsparam_u64 here.
> > Since nilfs_parse_param() was written assuming fsparam_u64, I guess
> > this is a simple mistake.
>
> Yep, I think I mechanically changed anything like
>
> {Opt_snapshot, "cp=3D%u"}
>
> to _u32, and missed how the actual parsing works.
>
> > Also, "nilfs_param_spec" is not declared with the "static" class
> > specifier, so could you please add it ?
>
> Sure thing
>
> ...
>
> >> +               if (is_remount) {
> >> +                       struct super_block *sb =3D fc->root->d_sb;
> >> +                       nilfs_err(sb,
> >> +                                 "\"%s\" option is invalid for remoun=
t",
> >> +                                 param->key);
> >> +                       return -EINVAL;
> >>                 }
> >
> >> +               if (result.uint_64 =3D=3D 0)
> >> +                       return -EINVAL;
> >
> > For the case where the "cp=3D0" invalid option is specified, could you
> > please output the following error message with nilfs_err() as before ?
> >
> >    "invalid option \"cp=3D0\": invalid checkpoint number 0"
> >
> > Other similar messages seem to overlap with the message output by
> > fs_parser routines, so I think just adding this one is sufficient.
>
> *nod* good catch
>
> ...
>
> >
> >>         sb->s_flags =3D (sb->s_flags & ~SB_POSIXACL);
> >
> > This "s_flags" adjustment overlaps with the flag adjustment just
> > before returning with normal status.
> > I think there is no problem with deleting this.
>
> Ah, I think you are right. Will make sure nothing depends on the sb
> flags before then, though.
>
> ...
>
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
>
> ...
>
> >
> >> +       if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
> >> +               nilfs_err(s, "invalid option \"cn=3D%llu\", "
> >> +                       "read-only option is not specified",
> >> +                       ctx->cno);
> >> +               return -EINVAL;
> >> +       }
> >
> > This error check conversion (to check after the read-only flag is
> > determined) is ok.
> > But, the option name in the error message has changed, so please correc=
t it.
> > The original message looks like
> >
> >   "invalid option \"cp=3D%llu\": read-only option is not specified"
>
> Whoops, I think that's just a typo.
>
> > The checkpoint number expression cannot be reproduced to be exactly
> > the same as the input (as in the case where the radix is specified
> > like "cp=3D0x123") but I think it's acceptable.
>
> Yup - that's a difference w/ the new mount API, I think - all of the moun=
t
> options need to be parsed independently, and we can only look for invalid
> combinations after that's all done and by then we onlly have the value, n=
ot
> the original format or string.
>
> If you would like to keep the original format of the option, we could sto=
re
> it in the fs_context as a string (I think) and emit that in the error mes=
sage.
> Worth it?

No, I don't think it's worth it, especially unnecessary if you need to
change the common parser implementation.
Almost all users will probably specify checkpoint numbers as decimal
integers and will not notice this difference.

Thanks,
Ryusuke Konishi

>
> Thanks,
>
> -Eric
>
> >
> > That's all for the non-style issue comments.
> >
> > Thanks,
> > Ryusuke Konishi
>
>
