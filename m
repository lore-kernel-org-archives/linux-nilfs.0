Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854B233722
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 06:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786342083; cv=pass; b=M0lRHacRJibHDLZ/XsPENMoxic4BrI+E0JhfQPksazjvqqMBrtyhB1IM6hGqT1zn+pD9Q7CjUsHcoWdbMzGQrKdlX6YVCU6QoPAU6Q6Ne87q4ZomI+G9+qhYf4pUZnlG5iF1C6zxxvYR9Q5SzTtqvK22HYXGLpSVdrX63SZnF6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786342083; c=relaxed/simple;
	bh=q3J7sQEHmq1FPB5XZHWxopMX6vQuYRbARqk1G6DW2D4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PgNNNijUEdpjZJAbrFfUVrLxLB+WPTJYiabu3OKDtbERq0enzG0vjJXXb1ETTb4Cjps22r8MNz4vR7JjjUAFgtL8m+9Hk5Gw+M0esGiDAvPinP/xQjTvzEZv+oqs3C00PlX/YzTOs1t95vzFoVFnFfuZRn7CQ5IbsgGCDWLqPGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNrWQhXH; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNrWQhXH"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b011edaf7dso1578014e87.2
        for <linux-nilfs@vger.kernel.org>; Sun, 09 Aug 2026 23:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786342079; cv=none;
        d=google.com; s=arc-20260327;
        b=cXD+AWNpINsI0tA5rBwAp3z3Xno4YdL0yoW1lm0/C9R9HmZgNpWHPz/L6uEAMwaJZM
         PREwu5DrTM7S1nCHcAinNTfKpxoAIUo+iQXbMnjy26qlqean+bIqlm2R4bOZGVF9dD3X
         Pk+NOi9DPpaDcMEO5L7X2H3zNcF8GyDVemwkDQKM3e9lACXZ+IoyZK34/wDG2Zo6JPYo
         fXNs6XvvvYKSnbm5uwe4iHD0rQqBkHpVxxLtBJJ/CZnmk/DxxHEYyTqptziNi3ueyOMs
         6DOMQ4VSofgRlVQpitl3lX293D8HywdTFYnAd6c66dEwAZhdm78/Ry7+JDMOo7Ey90Lr
         +DUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=miOdKlVs7qub6GQjgOXN3WlfdBzlfzSnavTuNq0mj0I=;
        fh=h5nzZgn1GAChjRkqoztboM1a65EE32adgu4wTHKFKik=;
        b=dwDpZS6njRJ1idJ9lL+ExC97w/9nLlIeGRIsiAZu6nZxJ4F+ATIVfZuA9UQ80J2XM6
         GbPbhdsqx2D+7wzZk9gQfjy12wOuwAcI0MyNsXhhPq+HWiS87gayDvhsEgbAR7wWeaM7
         WvYivFW5iEQ5AGcojmf064c6JBEj8bo3EOjdUFwrtETacJVI2a9NspNxkdpAJSTKcKWo
         bBWf11sjG9kVolKX/10yW0WLHzZIyVDHI88idiRCXPex9MgOZ3jiiri6qZobjbfd4+82
         WHnpCZ4Kgv5knFAMibI2gKZZ3BwSbS0hgovxMibNby6Cu4ACdVvdfHP4AZM2ZhQ0cslE
         9cDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786342079; x=1786946879; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=miOdKlVs7qub6GQjgOXN3WlfdBzlfzSnavTuNq0mj0I=;
        b=QNrWQhXHwZucxJowsQgK0vH4Sb0fjJ1Hkliu6YTipUm2wliImLRaOjrITiHTS17DvZ
         h2gXtZK6J7NrA/ZHQtkGZx1fOOVYTXrEt9dj7qiBcmc/1mJy3T3OKDCxkhYQHUH1ZQYV
         tCHOsfXxyT3Y2izoqOzR1sl46Wlnl0YkMul8sBpY/mUvPRJRTlcDXCvZz3daklK1tk2w
         sVqRD4uFq2y16iM9ZKVE6oj++RoAZxXnXNEFpcKtcoNzaxlf7YKdd1cPUJ+7v+pXcMUz
         SMsRYQsFkOgTOjT8C2jxv5EhSSQibOeX3DiriqL5OGeG3+xCQbHA6bK5VpD5Rfumwu9t
         y/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786342079; x=1786946879;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=miOdKlVs7qub6GQjgOXN3WlfdBzlfzSnavTuNq0mj0I=;
        b=ff+pV4lmxIiRN3Shf6szhycxPoMy2F94NqQZUhManxBCZ52mqevNQyNH+5y5jmuId2
         +t9nK2kjimrOM+7aIvBg0lihY1c5LappYITKIxoJeQi8P4+SrwLFO9s5DJ6BT/51g/Uj
         4eDfEH8DiTYfH1KxDbrGvaZxa9BlypUWOHANGHUE3ZwP+uX+B7rCmDBuENiWS2YV+Mp7
         a2m/A643KnuXliRzcF3CDCzxh9P0r+a1eV3dpQ4pCNshZmvUShupkfX4CDMRyvpsKQVK
         EDz8CoqjQpkgUT7JIbp74zC552gYFxw+PCB/mMTkDstu9pCG/ROQoyqU/hUJEwPEAxl0
         TbYw==
X-Forwarded-Encrypted: i=1; AHgh+RoOzXYAwsw7b69fgmBhhAWk++VQZ04V/fPtOVQmNjfLDzxS2qEEgfmvFCNuhoTycdB6BqbaFPxDx4kz3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjImgwabXnO/4kfPy8eTwCXR2iCTnk+Pqm0LCTf0sQLb+NAfhp
	ybYPc9WmfT5VCGRSJL9r1qLVzkmRSxZUJvzKTS/1iaM7XIFHPdXT62hZenO1yjXgYNlhbG2bKNS
	su0IlMF0+SOogBjUIdAr2Hihk8hbelmVWHvam
X-Gm-Gg: AR+sD12qexaI3dveRhrRaI5iOHQ1s/O/D215naG+UUX2vwwffsZvoEBfnbikBcWEY40
	F9wWyJpL4uBUN5fCBvW0uS4OfwhSeg4F0e/jH8ELepcyVEJH4YgmH8+xcFujxS7D1gD1D6K8Uqt
	0QAL9MGxP+ozqeYeTdJO7eqiSr7dhxWjzM+NEqjseoddeaIRcJlPoOlGF/40/ZiFfsNn7sM0lra
	U8cvK/ZRmmHnTWb/wxkbIfnd+5tK9nvZyzFWI7H9ZpOiC9kxAjTlMKi0qZGMvqYVZIphpJ72Zuw
	iTC1cnGznNDUW5h2VsIsihVQeYy4v076Jh2RqX+id9eUiw==
X-Received: by 2002:a05:6512:2386:b0:5b0:eda:de2a with SMTP id
 2adb3069b0e04-5b2f4cc4699mr4847336e87.35.1786342079172; Sun, 09 Aug 2026
 23:07:59 -0700 (PDT)
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
Date: Mon, 10 Aug 2026 15:07:42 +0900
X-Gm-Features: AUfX_mwp2Qn95IpGghEf_5Ae8rfCAf60b5cOHOlSWSRw4YCP8fALioromL2D9dg
Message-ID: <CAKFNMokpNB9jYvnU_GqmNvRdAfDNx5z1kMWrKkLU1xVH3fsqAw@mail.gmail.com>
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

Hi Wang Jianjian,

Regarding this issue, as the analysis in your patch's commit message
indicates, the fundamental problem is that when the inode or directory
has sync write attributes set, nilfs_transaction_commit() calls
nilfs_construct_segment(), which receives an interruption and fails
with -ERESTARTSYS.

Consequently, the rename itself is retried even though it has already
modified metadata beyond the point of no return.

We need to consider proper countermeasures, such as prohibiting
interruptions during log write commits or making the transaction
properly rollback-capable.
Adding the i_nlink =3D=3D 0 check is still merely a stopgap measure, and
since interruptions can occur during normal operations, we should not
trigger a filesystem error (or mark it read-only) because of them.

Handling this issue requires careful consideration.
Since we are late in the release cycle, I do not want to rush this
into the upstream tree right now.
Could we please split off the b-tree key sorting inconsistency check
patch to be processed first, and keep this rename issue under further
investigation?

Thanks,
Ryusuke Konishi
