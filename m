Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54424139CFA;
	Thu, 14 Nov 2024 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731627152; cv=none; b=CUr3qPK5TGOXUQuwD9vJJeGeQ4c0KG2RUx6crDe+RwrdRT5OQ/WYSQ10IjQ7HfKjVQ3ILJvl9MNX6pPih+HSr0lMIeAxrIonaFxiZljmetY7PwL/ePVPYqLajKiCcmH4gaV7AsuXS0k2pZmM6QFds81TILVM7fWcHCbOZfEG8O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731627152; c=relaxed/simple;
	bh=r5qlinlgZbkeyRF94Q+X7z7IPq61D/QwNJCW1TEHC1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C4NFr4Z/YWjEV9BigRJLCtBLD/78iY0DKJYw5F4etxOkKB9r0T3zH4WZ4Skskl8rlZSsn/Tz5HgfUSz1h193joYaAZWzjt7P9N6juzNAFy4tM2vCm6deeh0cu1Wp+BUDGx0mGqeijYPGVFFQ4tVRHlR0cwZm3UH3NrpGoXIUwcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrFDbWz1; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrFDbWz1"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53d8c08cfc4so1044528e87.3;
        Thu, 14 Nov 2024 15:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731627148; x=1732231948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAox7OrLC9evhrM94BAPa5uAF/5KGEHvdJMWRYb0aO4=;
        b=TrFDbWz1uWLOL/rXTtUnjur+ex+aPUlbdrbcUVUcFPwdJ0+RGsN/oOJ5WspoBij/hM
         kxSvumREbncCpLPXsIBZck2MtNfJN54YuVfCAyBtqa7S87NjQ0fOATuJ/h5MSpPUykJr
         JXJU7TWNCD+65wC+2ivX6uWwvD4SA7DQYFixhhPZF9fEw3RLe9wzVYSOGzBSL6078FPj
         Uxazl+/1bZqYzKFxozepHNPrR4pml4Ws+xuhmVvSnrxKDSJXiJfOZkOKoISzgeNSxv8B
         J1iwBxus7CZQl0si7RQ914Yc3eDq/Xpnx5E+/ckdgZGqMPdvo6/1sYsJEqTmINAH/P4I
         5E9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731627148; x=1732231948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAox7OrLC9evhrM94BAPa5uAF/5KGEHvdJMWRYb0aO4=;
        b=vkKxvLTO2ithnEKleEyGKa6FX2sZgCK8acTxUNv7IYzu+hBYPzWg2MApR5l6eM5wAK
         5jVj6Ce+G968pTveQHVFcb2F5PFCtp7LBXbNGPuDt+GwT/9kWFUobC19XUdECrOgZ0pa
         d4Se1MfBvhCRwez6err7d9PX2PuJAXO/JFTejD64EfAI3UR1A6FNy5vLWW1yEj6LUxdx
         Wuv+p2KukldHSpy46NKdil7EQQMN0lO02Z6dwNxNGe1xY5cWsNpq0Z/GhkajNzL3f5G3
         ncsriINCPhNEf03WoGLKNwVK39VvoCmO/vRSLXow27EEIa/Ccf331shwXZayiSViQtE+
         oh1g==
X-Forwarded-Encrypted: i=1; AJvYcCWGQC0KqpLjm2RQ3/Rwjn08xNJ69HTv6WuAPSR4dWp7as97ol7jrzCboVxJpvN3E9I6OcLMw+Nk0MkezA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzprdfSowfAdG0glzCAAHXHagEd4VwnjCkK4LzsreyCh6xO+bqv
	sNefKyYnqJcZazOn7WHxH6JVr7gHqsmforZMzLex6iTPDptRRLugpCjAwUYGVS0CxqhSt0xqGFi
	wQp2CP51scLf4RqQBe8LzY6AEqzZGBiXR
X-Google-Smtp-Source: AGHT+IE5h9i6XkrPSiyX3nOSSC+yL7OxuBJtwpGMOGV9VIhVJqa8ehf857I1HP2B7FVRr66U+qjw/UWAh66SWtUZ8J8=
X-Received: by 2002:a05:6512:ba1:b0:538:9e40:94b with SMTP id
 2adb3069b0e04-53dab29c93dmr171846e87.19.1731627148097; Thu, 14 Nov 2024
 15:32:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMok4ycxT48mUzNGkfvhw+evbSsUJ6U2MuTUSGwC1f_YcNQ@mail.gmail.com>
 <tencent_E58D929272DD80DDE119284FBF0DD325EC07@qq.com>
In-Reply-To: <tencent_E58D929272DD80DDE119284FBF0DD325EC07@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 15 Nov 2024 08:32:11 +0900
Message-ID: <CAKFNMokni2i-qPtCxG7QQjnnRVo105zNZZtvL2qBvSqwszoxsg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 9:01=E2=80=AFPM Edward Adam Davis wrote:
>
> On Wed, 13 Nov 2024 23:54:39 +0900, Ryusuke Konishi wrote:
> > On Wed, Nov 13, 2024 at 11:28=E2=80=AFAM Edward Adam Davis wrote:
> > >
> > > On Tue, 12 Nov 2024 23:38:11 +0900, Ryusuke Konishi wrote:
> > > > On Tue, Nov 12, 2024 at 7:56=E2=80=AFPM Edward Adam Davis wrote:
> > > > >
> > > > > The i_size value of the directory "cgroup.controllers" opened by =
openat is 0,
> > > > > which causes 0 to be returned when calculating the last valid byt=
e in
> > > > > nilfs_last_byte(), which ultimately causes kaddr to move forward =
by reclen
> > > > > (its value is 32 in this case), which ultimately triggers the uaf=
 when
> > > > > accessing de->rec_len in nilfs_find_entry().
> > > > >
> > > > > To avoid this issue, add a check for i_size in nilfs_lookup().
> > > > >
> > > > > Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.co=
m
> > > > > Closes: https://syzkaller.appspot.com/bug?extid=3D96d5d14c47d9701=
5c624
> > > > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > > > ---
> > > > >  fs/nilfs2/namei.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > >
> > > > Hi Edward, thanks for the debugging help and patch suggestion.
> > > >
> > > > But this fix is incorrect.
> > > >
> > > > Reproducers are not creating the situation where i_size =3D=3D 0.
> > > > In my debug message output inserted in the while loop of
> > > > nilfs_find_entry(), i_size was a corrupted large value like this:
> > > >
> > > > NILFS (loop0): nilfs_find_entry: isize=3D422212465065984,
> > > > npages=3D103079215104, n=3D0, last_byte=3D0, reclen=3D32
> > > >
> > > > This is different from your debug result, because the type of i_siz=
e
> > > > in the debug patch you sent to syzbot is "%u".
> > > > The type of inode->i_size is "loff_t", which is "long long".
> > > > Therefore, the output format specification for i_size in the debug
> > > > output should be "%lld".
> > > Yes, you are right, I ignore the type of i_size.
> > > >
> > > > If you look at the beginning of nilfs_find_entry(), you can see tha=
t
> > > > your check is double-checked:
> > > >
> > > > struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
> > > >                 const struct qstr *qstr, struct folio **foliop)
> > > > {
> > > >         ...
> > > >         unsigned long npages =3D dir_pages(dir);
> > > Yes, now I noticed dir_pages().
> > > >         ..
> > > >
> > > >         if (npages =3D=3D 0)
> > > >                 goto out;
> > > >         ...
> > > >
> > > > Here, dir_pages() returns 0 if i_size is 0, so it jumps to "out" an=
d
> > > > returns ERR_PTR(-ENOENT).
> > > >
> > > > I'm still debugging, but one problem is that the implementation of
> > > > nilfs_last_byte() is incorrect.
> > > > In the following part, the local variable "last_byte" is not of typ=
e
> > > > "loff_t", so depending on the value, it may be truncated and return=
 a
> > > > wrong value (0 in this case):
> > > >
> > > > static unsigned int nilfs_last_byte(struct inode *inode, unsigned l=
ong page_nr)
> > > > {
> > > >         unsigned int last_byte =3D inode->i_size;
> > > >         ...
> > > > }
> > > >
> > > > If this is the only problem, the following fix will be effective. (=
To
> > > > complete this fix, I think we need to think more carefully about
> > > > whether it's okay for i_size to have any value, especially since
> > > > loff_t is a signed type):
> > > >
> > > > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > > > index a8602729586a..6bc8f474a3e5 100644
> > > > --- a/fs/nilfs2/dir.c
> > > > +++ b/fs/nilfs2/dir.c
> > > > @@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struc=
t
> > > > inode *inode)
> > > >   */
> > > >  static unsigned int nilfs_last_byte(struct inode *inode, unsigned =
long page_nr)
> > > >  {
> > > > -       unsigned int last_byte =3D inode->i_size;
> > > > +       loff_t last_byte =3D inode->i_size;
> > > >
> > > >         last_byte -=3D page_nr << PAGE_SHIFT;
> > > >         if (last_byte > PAGE_SIZE)
> > > >
> > > I have noticed nilfs_last_byte(), I have other concerns about it, suc=
h
> > > as the chance of last_byte overflowing when i_size is too small and p=
age_nr
> > > is too large, or that it will be negative after being type-adjusted t=
o loff_t.
> > > So, maybe following fix is more rigorous.
> > >
> > > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > > index a8602729586a..0dbcf91538fd 100644
> > > --- a/fs/nilfs2/dir.c
> > > +++ b/fs/nilfs2/dir.c
> > > @@ -70,9 +70,10 @@ static inline unsigned int nilfs_chunk_size(struct=
 inode *inode)
> > >   */
> > >  static unsigned int nilfs_last_byte(struct inode *inode, unsigned lo=
ng page_nr)
> > >  {
> > > -       unsigned int last_byte =3D inode->i_size;
> > > +       loff_t last_byte =3D inode->i_size;
> > >
> > > -       last_byte -=3D page_nr << PAGE_SHIFT;
> > > +       if (last_byte > page_nr << PAGE_SHIFT)
> > > +               last_byte -=3D page_nr << PAGE_SHIFT;
> > >         if (last_byte > PAGE_SIZE)
> > >                 last_byte =3D PAGE_SIZE;
> > >         return last_byte;
> > > BR,
> > > Edward
> >
> > nilfs_last_byte itself does not return an error and is a function that
> > assumes that i_size is larger than the offset calculated from page_nr,
> > so let's limit the modification of this function to correcting bit
> > loss in assignment.
> >
> > If any caller is missing the necessary range check, add that check to
> > the caller. I will check again for omissions, but please let me know
> > if there are any callers that seem to have problems (I hope there
> > aren't any).
> Yes, I agree.
> >
> > To extend the bits of last_byte, declare last_byte as "u64" instead of =
"loff_t".
> > In assignments, the bit pattern is maintained regardless of whether it
> > is signed or not, and declaring it as u64 also avoids the problem of
> > negative i_size here.
> >
> > Comparisons between unsigned and signed integers may introduce
> > warnings in syntax checks at build time such as "make W=3D2" depending
> > on the environment, and may be reported by bots at a later date, so I
> > would like to maintain comparisons between unsigned integers.
> > (PAGE_SIZE is an unsigned constant)
> >
> > If the problem of negative i_size is actually a problem, I think we
> > should add a sanity check for i_size_read(inode) < 0 to the function
> > that reads inodes from block devices (such as
> > nilfs_read_inode_common).  So, I would like to deal with that
> > separately.
> >
> > I have already tested a change that modifies only the last_byte type
> > to "u64" with syzbot, but if you could proceed with creating a patch
> > that includes the commit log in this direction, I would like to adopt
> > it.
> You are such a nice person.
> If I did that, I personally feel that you would suffer a loss.
> There will be another chance in the future. I look forward to the next ti=
me.
>
> BR,
> Edward

Okay, I'll handle this bug fix.
I don't mind either way, but maybe it was a superfluous suggestion. Never m=
ind.
Well then, maybe another time.

Thanks,
Ryusuke Konishi
