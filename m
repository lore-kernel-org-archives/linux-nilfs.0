Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245ED5336E;
	Thu,  9 Jan 2025 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736433547; cv=none; b=JZG+hlLvAcGo/tCUOA7y5k9DaBFW2k8DkUo6SI4hG3OWcYKwF3eCLw8YtH89/ABaLdOUloNe1eVpJ4adC0B3HkZSh5hYGerJwNT57mozZ5/kg8jnOW+JaNcU9lhMbXQlHIkybwqcKzeUCrhN0hr1EqohbjXf1zBjTHSBaLjSUkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736433547; c=relaxed/simple;
	bh=JnlYDHapqWxdddXGPcVbrbYnUwEeOQ+I4cSmJhujn08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QUrZKge9v6/BcLJPB7LDQpl+ljRjh0qIVpBaKaPzsqbcs71tpENsTeRCv9pIbDpXpobaSoRKlvwMAd2yi0GWXousH42ORaWAE4tR/UnNkQ7xGLQzIqGehtqK94ubg7P508vxxKCT7e1oZykvizvSMkf+5lrH6794+jheigiJGgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yn/Ffv41; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yn/Ffv41"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5401b7f7141so874286e87.1;
        Thu, 09 Jan 2025 06:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736433544; x=1737038344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fAPIttVU9byZiID9957/iFXjuTO/WnXwtCRzD2suDQ=;
        b=Yn/Ffv41pJMdC6OSa3yS1/OMKExC2ksfAJmRHsKx9l2msOnPC1vVgIYM577CxjTuCD
         gKQR5mJh0iAFVFALqHGE6jCzngeFEA0eCs897hYS62m9BHZaNXPa8unOJ6sIY3ZNiMwg
         5bjT9Mui5Rf2ID2I4mIXogRbAvXWKKBVoz6nTgwSIJ+HT3giddhekbYOvwX+6Rj5Jfqe
         xCjsQxgAs53J14b70Soms4y17Kev6e27gf8zsJthRF0HB3vmsd/jvd1nybyW6k67p4Yv
         qp9815bi8IZhlOJfPC36DeRqfuS2zxlxzSShoy6NHclGnaDyGU07vhGPe0xG8SJqOR4T
         SVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736433544; x=1737038344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fAPIttVU9byZiID9957/iFXjuTO/WnXwtCRzD2suDQ=;
        b=tQICPhpnx3k+cB3i4Qg+gXIeQz6yS0jUwIN79hPqhf+upYr3B6PvnThs+ix/a4j7CJ
         AmJdgGj8B5j7fRu56lcFxSUw6iLVzOXKVyenH9Fuuq9vSdNqDSeUd/8223pAm6j6Y654
         CiQsR9CQs9+4PUQ9RV6gfJ+EFPeaFqH9lg6RyRm84cY1YqOojKvh2uW1+sdX9BOK0X5L
         gr7Yu2kSH5JK5/H9cycINKwl6/fhgZaNQFtF+ZnJ0bqQsu6DtkB4jcOzZPDue0f8adPu
         Q89zlzFu5Gav+AES9iOTpMYZ0YieX7QvEwjkBob2B6nwTHee4Hh9aZr4th7BNPBEtenN
         SOmw==
X-Forwarded-Encrypted: i=1; AJvYcCUaw9ySYon5YSic7hTg3hePgm+M84cWceAcf3sPOBCrK/91IVDPLuNiEcoisX3Jf58rnjgUBUApD7puPs8=@vger.kernel.org, AJvYcCUnEe2peF0pWfjkiI5vUyY3nFzJBrVnlHSwv9LqGA6YP50ZIvZFD0+qkVyVNq1XtvHBaAYgIY6zKhBUa6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOCYvuyEBOzYjZmIXMTlmyIj6KhkfsTCCc94MgraIz+xP83t9H
	6Q/ikcvIQ4hPKwDMGdnrr1UiBPnvKjHy9nT8Knb+yzWjVpQISup0dtvv32hnYjpewG/KWeyF5v0
	4TZa6njSArHYrTszaTvqPbjSDb9Y=
X-Gm-Gg: ASbGncsH3552RfIp7lxoaiAkQO1TDmqGTt/HZ+qrczOmH1Z/hdQaweQW2taf6I11+4P
	VU6/o7CEn04HlW93DW8t9bChH4xZDviIqrLNdArSAR8EEMT6TqGlbwmlcNAney3w1fFwSbe9s
X-Google-Smtp-Source: AGHT+IEVC0TE/eE00WuzMILEFHWFyMyp79RdKsRLJCy2K2y5q/3/HF7LO3nfzr03SUGv9FjX3Y7i4r2O4CzqqmMaNe8=
X-Received: by 2002:a05:6512:3994:b0:542:29a6:a063 with SMTP id
 2adb3069b0e04-542847f9de7mr2187691e87.43.1736433543876; Thu, 09 Jan 2025
 06:39:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
 <20250109032846.10147-2-konishi.ryusuke@gmail.com> <CAAq45aNh1qV8P6XgDhKeNstT=PvcPUaCXsAF-f9rvmzznsZL5A@mail.gmail.com>
In-Reply-To: <CAAq45aNh1qV8P6XgDhKeNstT=PvcPUaCXsAF-f9rvmzznsZL5A@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 9 Jan 2025 23:38:47 +0900
X-Gm-Features: AbW1kvaq6n6GlfrSljPNmjr4PsmLhyKwZcHE_ViS4glb5u0QmmwhaSxEFd6V_78
Message-ID: <CAKFNMoksY6f5NtVwmn6K0K2QKTvdjq+s0FbdgLvHzS3YueKqYQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] nilfs2: correct return value kernel-doc descriptions
 for ioctl functions
To: "Brian G." <gissf1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 10:44=E2=80=AFPM Brian G. wrote:
>
> Hello Ryusuke,
>
> I'm somewhat new to public linux kernel contributions, but I have been
> following the NILFS2 mailing list for a while now.  I know you have
> been putting in incredible effort into supporting NILFS2, and I
> appreciate the time and dedication you have provided to the community
> on this.
>
> I think the new description comments look much cleaner and easier to
> read, but while reviewing your changeset, I noticed a few small
> concerns.  I will describe them inline below.
>
> On Wed, Jan 8, 2025 at 9:28=E2=80=AFPM Ryusuke Konishi
> <konishi.ryusuke@gmail.com> wrote:
> > ---
> >  fs/nilfs2/ioctl.c | 220 ++++++++++++++++++----------------------------
> >  1 file changed, 84 insertions(+), 136 deletions(-)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index fa77f78df681..f7bcc95847bb 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -457,7 +439,8 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, _=
_u64 *posp, int flags,
> > - * Return value: count of nilfs_bdescs structures in output buffer.
> > + * Return: Count of nilfs_bdescs structures in output buffer on succes=
, or
> Typo: "succes" should be "success"
>
> > @@ -494,19 +477,14 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs=
, __u64 *posp, int flags,
> > - * %-EFAULT - Failure during getting disk block descriptors.
> > + * * %-EFAULT  - Failure during getting dick block descriptors.
> Typo: "dick" should be "disk"
>
> > @@ -1202,18 +1156,12 @@ static int nilfs_ioctl_get_info(struct inode *i=
node, struct file *filp,
> > - * %-ENOMEM - Insufficient amount of memory available.
> The error value -ENOMEM can still be returned by the new code, but it
> is not included in the new error list
>
> Also, throughout the changeset, in multiple files, I saw lines like:
> > + * Return: 0 on success, or the following error code on failure.
>
> These lines should probably instead be something like:
> > + * Return: 0 on success, or one of the following negative error codes =
on failure:
> Noting the specific differences of:
> - "one of" prefix before "the following" when there are more than 1
> option in the list
> - be sure to include the word "negative" (some cases did, others did not)
> - using the plural form "codes" instead of singular "code" when there
> are more than 1 option in the list
> - trailing ":" to indicate that a list follows
>
> I hope this email was helpful, and thanks again for all you do!
>
> - Brian G.

Hi Brian,

Thank you for your feedback!

Your help in pointing out the typos and the missing error code, as
well as suggestions for improving the "Return" section, are all very
helpful.
I'll update the patch set to reflect your comments.

Thanks,
Ryusuke Konishi
