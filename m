Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257B192D7F;
	Mon, 30 Sep 2024 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727711122; cv=none; b=Eb7ODNLno22NNpARH3/E2hj2+HUYqgHLUUSFxpnMCTjTLOP0scPooerq0TObVZBFgqzUY88qccpgSuIoy8YcbgvjpwJjE+XoRYWXvyEYpC/lgql+MCze/hAkvggMsfn2ZnbLtGcC238pLXb7lYeA4mKVuEX7FoJx8eI274BfgA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727711122; c=relaxed/simple;
	bh=54QtDfOFZWQjQIZsxi1l5Zntt1q9m/AQygHN9qU1CtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQ/5PNPcdMI+ZeJ2gEcENlII7bx43sZdhi0gIMqmsWM6vtz/ARBF9DdAQuYgMiMam4lZb7Vh1EDl8m5pT8bEcgjmsL/Q4T4cW/MiMjN5IuMt5visaWJuMag94wNWZp7JBWjMecezP1ayt2lsmU2QaYTzJpxjKCesDWCkzHg7jfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfYrI1xZ; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfYrI1xZ"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2f75aaaade6so44961731fa.1;
        Mon, 30 Sep 2024 08:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727711118; x=1728315918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0GCuNFHYJZHQ9So0+GzqQwOm8+QoN7jd/8DcXPzcJs=;
        b=YfYrI1xZXFBlkyS+t10H3Y145GOVa7yQnH9wxIJqdi5UaGTyK/8XOCNn1D5YBlOI3w
         VN/DUJEpxM9bZxWnJ5+564/mdI63r329TQU4AGnN9batCfLUck0/lrQRFNmIVBE6oSSm
         uz1K/WixTCxBps194GI5SFft5fh2YXuJ8L1VG0j6N+rIZ6wcf18ioRMIxViOWI3uSSEq
         U5GvE6ICsfnqYNDpiEAU/ROsdpcBU2CfNRDB1chiE+U/z7XrLuPlqI3HVlwSDd0F9ToU
         uqmuqjpeD5KGmhRAc/sQ7nntS93ziKsY8qvwOgf2S8fghr+jx9dYkc6VylQ5xFqgvug8
         kmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727711118; x=1728315918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0GCuNFHYJZHQ9So0+GzqQwOm8+QoN7jd/8DcXPzcJs=;
        b=MB/vz+1cT0sK6mM08FEpshHVPPJO9FzsGSnXHqxhTALn4zknXobB1Q6xiMqBASJvky
         7xg/dG2BHQfBeX1B8T2yd2qOZJIzsXC3dtIdQa6Le7ZYnm/7ajVt+KCqToIM7fUS2t4h
         k+qQZw4B7xBRDwC3hO6ZN+vE9exHJBbiCy1ESvG8IdBX7cf1iugOk2jG5VwY4xX3uDcl
         /EM8JNVATCBPkH3gTVEuHLKLkHbR3VSoHcTlV3mSSKpo/qQulHmnQZH9n+s4wUM44ZHx
         jrF6igQQoKnq/El/ur1UIJPKiVdr5Xbye5815PAHCYF/0UMshGqqARwrhcRk0EEdV/Pt
         gdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3n1oqXRU+naECNi7BB+x+DU4ZzwSWlE6Y8dMY6LPsmWerEVBOUqxK+U8zLPyClVtDGQf/z89n/DUXmdw=@vger.kernel.org, AJvYcCXSr0DFziKIrMY12eLhhPUURsYzbBs9djDXTsp3I4lg13TxgUclNl4aaErMp215qqnZHprcY/UFf+2qR74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2J2wHYxMa5RdXp0QiPFqYCg3ZKxBr0CoaIDCaZwZ8xPM0sUot
	Aoq1Wloe+qQOtGNaaJnx39eOUYZ1932K1e0EdFLKxF0p3qJ1zhMHdcU98jJqc2m/6f49+XQcwWW
	qCPtn9puGCVD/JWp0Aoo1pOYVD4M=
X-Google-Smtp-Source: AGHT+IHm23wT3xL5o2D4tD+RLCX2VJKZMXyyXeM2ItTQoeRo4s1EwsNd0swNHiAfTbvPAludg+iFs9TDLaStVXuZxz8=
X-Received: by 2002:a05:6512:230e:b0:536:53fc:e8fc with SMTP id
 2adb3069b0e04-5389fc3c786mr6877467e87.16.1727711117959; Mon, 30 Sep 2024
 08:45:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927134620.2081991-1-lizhi.xu@windriver.com>
 <20240927151900.2596508-1-lizhi.xu@windriver.com> <CAKFNMok4U8OTVDV0YFDUGotsShSZKST532snzL3fQBVFcUL9TQ@mail.gmail.com>
In-Reply-To: <CAKFNMok4U8OTVDV0YFDUGotsShSZKST532snzL3fQBVFcUL9TQ@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 1 Oct 2024 00:45:01 +0900
Message-ID: <CAKFNMoms=mCn60bPy-L9L4bn+RozQW0urvDzPwW4Fgq0rH2HfA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: add ratelimiting to nilfs2 message
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 3:18=E2=80=AFAM Ryusuke Konishi wrote:
>
> On Sat, Sep 28, 2024 at 12:19=E2=80=AFAM Lizhi Xu wrote:
> >
> > Syzbot report a task hung in vcs_open.
> > When rec_len too small in nilfs_check_folio, it can result in a huge fl=
ood
> > of messages being sent to the console. It eventually caused tty to hung=
 when
> > retrieving the console_lock().
> >
> > Reported-by: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D8a192e8d090fa9a31135
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/nilfs2/dir.c | 24 ++++++++++++++++--------
> >  1 file changed, 16 insertions(+), 8 deletions(-)
>
> Thank you for the patch.
>
> I could confirm that the problem is reproducible and that your patch
> prevents it, so I will treat this as a nilfs2 side issue.
>
> The patch seems somewhat straightforward, so let me review this a bit
> more.  I may ask you to make some changes.
>
> Thanks,
> Ryusuke Konishi

Hi Lizhi,

I found that the root cause of this problem is that nilfs_find_entry()
does not abort the search loop even when nilfs_get_folio() returns an
error.

If the i_size of the directory inode is large and the directory is
corrupted, nilfs_find_entry() may continue to loop and output error
messages endlessly in bursts.

Rate-limiting may be able to prevent serial hangs, but it cannot
interrupt the near-endless loop in nilfs_find_entry(), so I don't
think it is the right approach to take to fix the problem.

Like ext2, nilfs_find_entry() should be able to return errors from
nilfs_get_folio() like this:

    char *kaddr =3D nilfs_get_folio(dir, n, foliop);

    if (IS_ERR(kaddr))
            return ERR_CAST(kaddr);

However, this approach requires some preparation changes so that the
error code returned by nilfs_find_entry() can be propagated to its
callers.

So, would you mind letting me fix this?

Or, if you want to do it yourself, please let me know.
If you refer to the ext2 implementation, you should be able to figure
out how to fix it, even though there are some nilfs-specific
differences.

Thanks,
Ryusuke Konishi

>
> >
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index fe5b1a30c509..0a89dda75414 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/pagemap.h>
> >  #include "nilfs.h"
> >  #include "page.h"
> > +#include <linux/ratelimit.h>
> >
> >  static inline unsigned int nilfs_rec_len_from_disk(__le16 dlen)
> >  {
> > @@ -115,6 +116,7 @@ static bool nilfs_check_folio(struct folio *folio, =
char *kaddr)
> >         size_t limit =3D folio_size(folio);
> >         struct nilfs_dir_entry *p;
> >         char *error;
> > +       static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL * =
5, 1);
> >
> >         if (dir->i_size < folio_pos(folio) + limit) {
> >                 limit =3D dir->i_size - folio_pos(folio);
> > @@ -148,9 +150,11 @@ static bool nilfs_check_folio(struct folio *folio,=
 char *kaddr)
> >         /* Too bad, we had an error */
> >
> >  Ebadsize:
> > -       nilfs_error(sb,
> > -                   "size of directory #%lu is not a multiple of chunk =
size",
> > -                   dir->i_ino);
> > +       if (__ratelimit(&rs)) {
> > +               nilfs_error(sb,
> > +                           "size of directory #%lu is not a multiple o=
f chunk size",
> > +                           dir->i_ino);
> > +       }
> >         goto fail;
> >  Eshort:
> >         error =3D "rec_len is smaller than minimal";
> > @@ -167,18 +171,22 @@ static bool nilfs_check_folio(struct folio *folio=
, char *kaddr)
> >  Einumber:
> >         error =3D "disallowed inode number";
> >  bad_entry:
> > -       nilfs_error(sb,
> > +       if (__ratelimit(&rs)) {
> > +               nilfs_error(sb,
> >                     "bad entry in directory #%lu: %s - offset=3D%lu, in=
ode=3D%lu, rec_len=3D%zd, name_len=3D%d",
> >                     dir->i_ino, error, (folio->index << PAGE_SHIFT) + o=
ffs,
> >                     (unsigned long)le64_to_cpu(p->inode),
> >                     rec_len, p->name_len);
> > +       }
> >         goto fail;
> >  Eend:
> >         p =3D (struct nilfs_dir_entry *)(kaddr + offs);
> > -       nilfs_error(sb,
> > -                   "entry in directory #%lu spans the page boundary of=
fset=3D%lu, inode=3D%lu",
> > -                   dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
> > -                   (unsigned long)le64_to_cpu(p->inode));
> > +       if (__ratelimit(&rs)) {
> > +               nilfs_error(sb,
> > +                           "entry in directory #%lu spans the page bou=
ndary offset=3D%lu, inode=3D%lu",
> > +                           dir->i_ino, (folio->index << PAGE_SHIFT) + =
offs,
> > +                           (unsigned long)le64_to_cpu(p->inode));
> > +       }
> >  fail:
> >         return false;
> >  }
> > --
> > 2.43.0
> >
