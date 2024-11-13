Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284A1CAAC;
	Wed, 13 Nov 2024 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731509699; cv=none; b=Sj+dwBA93rsWgNo+9IH8gNsRWs7zWbbjRa8Oj5EzVPuFOLfVXW2DhRj3clwGqXVJmr2BnekEmkcTu5Li0AZkIbWKnvnS8X0WwGG3XsLAipHjPPLIaWFimFPCOLSEZv31rHB9CG3lThVwNvXfPcqAH6SWkNMVJzD/FRZtJ7ohvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731509699; c=relaxed/simple;
	bh=HgtTdevTgzmXe3ndxnmilmTemjMYR9RjaVxlqOTn1LM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MF3UG+V11/iVrJl5Pkt8t5feUKckKEE1QYVwZb6Ig98rTJLvBmOcbSYTo31P+5/FDBc4e6S+MmiL4hSPYFeE20RM7mTHnho1Hu/rQ+dgqahG0lIapyhelwtyalMYhew0uuL/M9BhTVR9CCnOmbHwxiVPdl+k4u6BOb+IiSeZCSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTxWzViJ; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTxWzViJ"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53da2140769so751385e87.3;
        Wed, 13 Nov 2024 06:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731509696; x=1732114496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISWTcci1pQC9mjxzaFrD2zlmilnEBrr730jv2qJZhlE=;
        b=HTxWzViJ3nqrdPmWAXRtqKsnbtLjXMPEFxrp6/63Wy4Bs7jjM1TDF/3VJjxEw8D0wv
         khTULswzQC5Kad8lVw1013N58UbzjTTIqOs+bQcAg901nHpHSqtZNZxIgV/DDLSpqDtN
         7gPAlmso5uR9IZX4KjZ6MBAM5Us7nxoh/0p4Wjab5dEjR7xlji3SJeug7dDx9IoeOSxj
         9RORCRXlu+cZmEg/PUHD9JnDLJu68aVgMAzNQxMEIYJ6sfPdw/BzL7lrm2d3pXX99Igo
         DssjWbisvIb9l7GiMyG2CGmq1d5yI0/dYq08XLOu+EngHJAa4dglFCYhphkbfftgG5Ab
         9gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731509696; x=1732114496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ISWTcci1pQC9mjxzaFrD2zlmilnEBrr730jv2qJZhlE=;
        b=DASTtndJJh9B8gKPyVahAzFHv5/sP+iLfamrtAEAKqqsyAsCP7wlT/ecdMP5E7FEzX
         Zs0w3FT+qnLDXUMNFeDVHu2IfccE50OPsdS0OqUER1kF01Z5O02xIxOYrZLbYGrKpKB0
         aqkyC2etV8ZI3OLuESzkqFmPhTrkZohwZYr7JIr7Jv2e2XdaHhCOcbvyXK1TOuSdl7XT
         HySISV4oqeYX84ikVs6GhOQGYuoKB4h+EpHTP/txvgxBetPznmRkbYR3l0gZ21X+7cNW
         HZ9GqgHY3k+KmVkLPlDU00X5uPNk8S+CRI8IoF+rcVGwrKcL7bBBoxlAchm/6oTiko0/
         pBqw==
X-Forwarded-Encrypted: i=1; AJvYcCURGJNa/cFsRX9HYTrknttEEvoufIj4Lz0EFcuyURxGG68Y3Rny1H4IGMvKovGxDQLWVo6Yo5/653oaCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvj8VvsEu8OFqybZmgLid/h6YpBaIi5CifFC5pympD0qjQkIa4
	revJH2yuOUqI4QLsNTSa6GiG2vcIYI1lbv4/Jja9720DgM99x1T5dSuDmHjfUmXwzPI4DD8AAZm
	5zQ60K39gxBAsD8e0zGR+j797pVA=
X-Google-Smtp-Source: AGHT+IE3ZaVdwMJSuVUEHMJrxcp2ZIiddTnixGuOw1pZGBbo7gewhx8o9K/jjLQXww/HCoDw+891xHpZ/pAB/uK/CME=
X-Received: by 2002:a05:6512:3e0b:b0:52e:987f:cfc6 with SMTP id
 2adb3069b0e04-53d862ebfadmr8612416e87.51.1731509695440; Wed, 13 Nov 2024
 06:54:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMomm9UjJxdxADBDTL4ksvY7Bycs3WV=cqYmJu_TuUi7crA@mail.gmail.com>
 <tencent_5ED37D036BA97D43A6A4549765F77C86CE05@qq.com>
In-Reply-To: <tencent_5ED37D036BA97D43A6A4549765F77C86CE05@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 13 Nov 2024 23:54:39 +0900
Message-ID: <CAKFNMok4ycxT48mUzNGkfvhw+evbSsUJ6U2MuTUSGwC1f_YcNQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 11:28=E2=80=AFAM Edward Adam Davis wrote:
>
> On Tue, 12 Nov 2024 23:38:11 +0900, Ryusuke Konishi wrote:
> > On Tue, Nov 12, 2024 at 7:56=E2=80=AFPM Edward Adam Davis wrote:
> > >
> > > The i_size value of the directory "cgroup.controllers" opened by open=
at is 0,
> > > which causes 0 to be returned when calculating the last valid byte in
> > > nilfs_last_byte(), which ultimately causes kaddr to move forward by r=
eclen
> > > (its value is 32 in this case), which ultimately triggers the uaf whe=
n
> > > accessing de->rec_len in nilfs_find_entry().
> > >
> > > To avoid this issue, add a check for i_size in nilfs_lookup().
> > >
> > > Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D96d5d14c47d97015c62=
4
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > >  fs/nilfs2/namei.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> >
> > Hi Edward, thanks for the debugging help and patch suggestion.
> >
> > But this fix is incorrect.
> >
> > Reproducers are not creating the situation where i_size =3D=3D 0.
> > In my debug message output inserted in the while loop of
> > nilfs_find_entry(), i_size was a corrupted large value like this:
> >
> > NILFS (loop0): nilfs_find_entry: isize=3D422212465065984,
> > npages=3D103079215104, n=3D0, last_byte=3D0, reclen=3D32
> >
> > This is different from your debug result, because the type of i_size
> > in the debug patch you sent to syzbot is "%u".
> > The type of inode->i_size is "loff_t", which is "long long".
> > Therefore, the output format specification for i_size in the debug
> > output should be "%lld".
> Yes, you are right, I ignore the type of i_size.
> >
> > If you look at the beginning of nilfs_find_entry(), you can see that
> > your check is double-checked:
> >
> > struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
> >                 const struct qstr *qstr, struct folio **foliop)
> > {
> >         ...
> >         unsigned long npages =3D dir_pages(dir);
> Yes, now I noticed dir_pages().
> >         ..
> >
> >         if (npages =3D=3D 0)
> >                 goto out;
> >         ...
> >
> > Here, dir_pages() returns 0 if i_size is 0, so it jumps to "out" and
> > returns ERR_PTR(-ENOENT).
> >
> > I'm still debugging, but one problem is that the implementation of
> > nilfs_last_byte() is incorrect.
> > In the following part, the local variable "last_byte" is not of type
> > "loff_t", so depending on the value, it may be truncated and return a
> > wrong value (0 in this case):
> >
> > static unsigned int nilfs_last_byte(struct inode *inode, unsigned long =
page_nr)
> > {
> >         unsigned int last_byte =3D inode->i_size;
> >         ...
> > }
> >
> > If this is the only problem, the following fix will be effective. (To
> > complete this fix, I think we need to think more carefully about
> > whether it's okay for i_size to have any value, especially since
> > loff_t is a signed type):
> >
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index a8602729586a..6bc8f474a3e5 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct
> > inode *inode)
> >   */
> >  static unsigned int nilfs_last_byte(struct inode *inode, unsigned long=
 page_nr)
> >  {
> > -       unsigned int last_byte =3D inode->i_size;
> > +       loff_t last_byte =3D inode->i_size;
> >
> >         last_byte -=3D page_nr << PAGE_SHIFT;
> >         if (last_byte > PAGE_SIZE)
> >
> I have noticed nilfs_last_byte(), I have other concerns about it, such
> as the chance of last_byte overflowing when i_size is too small and page_=
nr
> is too large, or that it will be negative after being type-adjusted to lo=
ff_t.
> So, maybe following fix is more rigorous.
>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index a8602729586a..0dbcf91538fd 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -70,9 +70,10 @@ static inline unsigned int nilfs_chunk_size(struct ino=
de *inode)
>   */
>  static unsigned int nilfs_last_byte(struct inode *inode, unsigned long p=
age_nr)
>  {
> -       unsigned int last_byte =3D inode->i_size;
> +       loff_t last_byte =3D inode->i_size;
>
> -       last_byte -=3D page_nr << PAGE_SHIFT;
> +       if (last_byte > page_nr << PAGE_SHIFT)
> +               last_byte -=3D page_nr << PAGE_SHIFT;
>         if (last_byte > PAGE_SIZE)
>                 last_byte =3D PAGE_SIZE;
>         return last_byte;
> BR,
> Edward

nilfs_last_byte itself does not return an error and is a function that
assumes that i_size is larger than the offset calculated from page_nr,
so let's limit the modification of this function to correcting bit
loss in assignment.

If any caller is missing the necessary range check, add that check to
the caller. I will check again for omissions, but please let me know
if there are any callers that seem to have problems (I hope there
aren't any).

To extend the bits of last_byte, declare last_byte as "u64" instead of "lof=
f_t".
In assignments, the bit pattern is maintained regardless of whether it
is signed or not, and declaring it as u64 also avoids the problem of
negative i_size here.

Comparisons between unsigned and signed integers may introduce
warnings in syntax checks at build time such as "make W=3D2" depending
on the environment, and may be reported by bots at a later date, so I
would like to maintain comparisons between unsigned integers.
(PAGE_SIZE is an unsigned constant)

If the problem of negative i_size is actually a problem, I think we
should add a sanity check for i_size_read(inode) < 0 to the function
that reads inodes from block devices (such as
nilfs_read_inode_common).  So, I would like to deal with that
separately.

I have already tested a change that modifies only the last_byte type
to "u64" with syzbot, but if you could proceed with creating a patch
that includes the commit log in this direction, I would like to adopt
it.

Thanks,
Ryusuke Konishi
