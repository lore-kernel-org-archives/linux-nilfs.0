Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6152D1911
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Apr 2026 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777522144; cv=pass; b=tKlfFrgvrVqxFY4oQjZn8ZAkfbbFpdONmdw9WwpboZNcXROcPzF9CI9fnetrwn97osFIQz8hDHGEKHdiRuigxFiXmjyhu+fnhSJRRhZfyj9g8Wz1L5KpP0E+3X4fCLu8bBJhpr6qaaDDt4/cNHAh2Z3dda0hs1UO6H4QrXiHx24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777522144; c=relaxed/simple;
	bh=3JFyuMQHVB108UxjuouDl4SYDlcKyU5nip54Et18JSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IBLC5Tgkj/xcHlvNjokCyLGEr1SHQtC/suFejBu6DrL3gUVdRSNcYH3ZRDcDoYNhAILNCN1u8dGiNnBXTk+eLypRm1HDV5Be/ad2gwTV33fHq5Jzh2ZbBegMTWB06QuoZx+PsW0AGdQ+uJJIU+Jw7umfht8xtan6utOgGTP2ea0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFmusIgL; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFmusIgL"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7b23713eac9so4817507b3.2
        for <linux-nilfs@vger.kernel.org>; Wed, 29 Apr 2026 21:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777522142; cv=none;
        d=google.com; s=arc-20240605;
        b=JfLftTAHhUZRWxrTeTtN3Xv0qDojhZ24CJSPTij3kICfoA+myjuXI/YW5OYlHkXvRY
         bDBL5eXsm6hEFxd19qBbFuwyzto/evH1AYfvmnpJkVVzsB4rXV95FD2oZ0y0mFwYH04s
         /67b1tNhjz4fHJcU4NH3SwiJLcktvhVowx09ihfrMHqXhyHxGNhMt6Y1bx8p4Epi+VqI
         O7tbRYDHpOlHB+OWbJ9JgUZeQM4rkNeS86iGy/zg+o5/bTQSq2bDEQwK2I3adj4ffZ41
         WNREC5CnAIG+gE3Eb7rBu3AnX69QdHkHszZLGujWSt9N7Jl22brhwyc4ttvqS3uXmgVY
         vaFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tPYWn1pFz2Pgey4eVQGV/x4lDzfQrPvRhlCiK0bKikE=;
        fh=5frYkAYNOhSxzyReHivWI/wbsNWH9q7DHlwwaAtRxF8=;
        b=A9cAvdV5gXl2XPV1xDd6t4980YaTIsxbBo3WUt+kD3Qhfr8JGX1ulI4qMZ2BRDAiOk
         S7Rq979jDe8XSQXe4qhPhtj1fYorAUUC91JS4ur5XLliWYIxdFTnby/UJOIyVaSKZu8K
         KnX8Jen8T+FljxNzwPw4foKV/UHhjANJtd/mXSV6CW/52h82UCGnQo285ZUfs+VcDeq+
         0sTExHua80Fws1uRODm3JgftXSGvlk2A6ROHYigp2e9oRNEirQAYwuE2y/GP4S1mib1V
         4CdONo2hLFxEAUFYgATYYAncqT3V5frFoJnKmhCUQ/fF2+8xforD51HRdFsZcjWBlGga
         CPnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777522142; x=1778126942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPYWn1pFz2Pgey4eVQGV/x4lDzfQrPvRhlCiK0bKikE=;
        b=lFmusIgLig2CaACbx1N6XdpTkRiFB5MjS7nJuDd6qAhLb50SVQB/Q84Tw4uRLhmDPO
         QUTt6GXpPBmiPBPbqsrLFOLbHRDsqvUWaT+pqM98ne0aLP5G5XombRO4SBiVnLqCQWHW
         iV9Wn5qg3Djk3TAR6T8dq4gKwkt4NlFRolJQyuNkwlgUcfbTIdMnR7UW+yZF5rTbE7Fg
         Hn3Q2hoeWEmqxaAOf6mD9fdzrAA+ewg6nCo2EDMI71KRLmNsq+K7ed7Yg0t4u7gMQnIj
         T2pKcZqX2sP3HmLpe2aJfvFPxK3Fwq6lMgd/quXn0+f3GTaaNDPUU3bR0NN+ivqE/FGU
         M3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777522142; x=1778126942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tPYWn1pFz2Pgey4eVQGV/x4lDzfQrPvRhlCiK0bKikE=;
        b=arR3qeAqeabS5Wj9r6MYk16pUWskZNDL8SgRuYuNkoVAV9zDJeRVVLzBD5X6nFEJut
         jdD0/Qfm5jpogfAcr5AeTzHe29v5i3pOTBxrXM8p8m7VS2UTTPEG7uRpjhwytZlN0XVR
         2bbDUMditSHpeQhc8a7fnOluYW0yIkhHK6Fy6rm7ZL5QxXOmwx8uGoBe0Ifes8y0o0LG
         F3GPfRpiW8L4Ge9fBQcuEMLwCqpJR1yc6QWzwd9IaN3XcbXz+YLV+Aw0V1YkMwSmvv4O
         zw5fXVdTnlYmy3M8tl06+VUHaliuYh9502wuMGlTV3VyYZXbAq512+RB6ip7PIgfoQHA
         RLHA==
X-Forwarded-Encrypted: i=1; AFNElJ97aLvORtsjvUHgHIA+9U4sjgQLVXX3hcU45bCxbQ7TgQ5IVjemtraNw1JiULOmaiy+i4O9vV+vaQy5iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLKL0yM9SRYfAtQ6x+QyeDHuhf7LBG/2EqMCYAe3QpYB39inUY
	urtjLgaFk5KmtO8xq/vAW62s+NOaMV/aB5oIheCQQokkX9F52flDNwNHNhW9e7d3CVYyE6hlEoX
	+x5TWltDvsFIjTODCeEOY/5f9DqYINMY=
X-Gm-Gg: AeBDietFbrwl+LE/C6JgVopcgq9dxk/JbMnTmgHtBLrLP3yqIEqUrdJmJ2JutJatr5c
	G6rfzzk9xApkmRyBakXKM43WUtVMzZORfap2jcvg+yRzKDPW4tNAyCA2gpUYirPDg94E1SKT5QN
	hEJoizbv2hpE5+aZiiojiAzYiXg2VdJSwWLth/JVNXMHfXh+3Dhlfr10fNHpwnYJ4U6Pw4nhJF+
	owXf8FNYooD9FoKxiUfOrCN9sIKmv9/Id0vUSpubJTdpRQBx45FLoi8NGuMJicvp4AOEn3v4y9E
	Mt+h9TXdI6KWwnNpV8hmPCUNscH0uAbOJQNyFJJ8brRS7sEThC7oGhSYrPA5p2BFiJTwSpnNLCI
	AkIoppvU=
X-Received: by 2002:a05:690c:6b01:b0:7a2:1f26:3d5f with SMTP id
 00721157ae682-7bd548a7947mr9771397b3.28.1777522141500; Wed, 29 Apr 2026
 21:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428040256.84403-1-kartikey406@gmail.com> <2ed28b6008cf898a06036d5836380cc5cc45f118.camel@redhat.com>
 <CADhLXY5Q8UsSQZYm-KWpJ3q753xAcxbnk9y+vGfkwA9RF8VcrQ@mail.gmail.com> <CAKFNMom83SJqvN7ZSMt3p9TVvGVL_sC5sfO4+ZrC+zi6OC+HVQ@mail.gmail.com>
In-Reply-To: <CAKFNMom83SJqvN7ZSMt3p9TVvGVL_sC5sfO4+ZrC+zi6OC+HVQ@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Apr 2026 09:38:49 +0530
X-Gm-Features: AVHnY4II14EwlQikmsqUEy-F6foWShKK8RfRmQjjSm2gsv_H84WEBj5yK5Pj55M
Message-ID: <CADhLXY6ihygaBJHpTj2QtkudX-kYf0yKvYd8dVs13FGCOVuX9w@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 6:02=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> On Wed, Apr 29, 2026 at 10:50=E2=80=AFAM Deepanshu Kartikey wrote:
> >
> > On Wed, Apr 29, 2026 at 12:29=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > On Tue, 2026-04-28 at 09:32 +0530, Deepanshu Kartikey wrote:
> > > > Syzbot reported a hung task in nilfs_transaction_begin() where mult=
iple
> > > > tasks performing chmod() on a nilfs2 mount blocked for over 143 sec=
onds
> > > > waiting to acquire ns_segctor_sem for read:
> > > >
> > > >   INFO: task syz.0.17:5918 blocked for more than 143 seconds.
> > > >   Call Trace:
> > > >    schedule+0x164/0x360
> > > >    rwsem_down_read_slowpath+0x6d9/0x940
> > > >    down_read+0x99/0x2e0
> > > >    nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
> > > >    nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
> > > >    notify_change+0xc1a/0xf40
> > > >    chmod_common+0x273/0x4a0
> > > >    do_fchmodat+0x12d/0x230
> > > >
> > > > The writer holding ns_segctor_sem was a concurrent NILFS_IOCTL_CLEA=
N_SEGMENTS
> > > > caller, stuck inside printk while emitting per-element warnings fro=
m
> > > > nilfs_sufile_updatev():
> > > >
> > > >    __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
> > > >    nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
> > > >    nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
> > > >    nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
> > > >    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
> > > >    nilfs_segctor_do_construct+0x1f55/0x76c0
> > > >    nilfs_clean_segments+0x3bd/0xa50
> > > >    nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
> > > >    nilfs_ioctl+0x261f/0x2780
> > > >
> > > > The root cause is that nilfs_ioctl_clean_segments() does not valida=
te
> > > > the user-supplied segment numbers in kbufs[4] before calling
> > > > nilfs_clean_segments(), which acquires ns_segctor_sem for write.  T=
he
> > > > range check on each segnum is performed deep inside the call chain =
by
> > > > nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entr=
y
> > > > while still under the segctor lock and the sufile mi_sem.  Under lo=
ad
> > > > (repeated invocations across multiple mounts saturating the global
> > > > printk path), the cumulative printk latency keeps ns_segctor_sem he=
ld
> > > > long enough to trip the hung_task watchdog, blocking concurrent
> > > > operations such as chmod() that need ns_segctor_sem for read.
> > > >
> > > > Fix by validating the contents of kbufs[4] in the ioctl entry path,
> > > > before any FS-wide lock is acquired.  Out-of-range segment numbers =
are
> > > > rejected with -EINVAL synchronously, with no work performed under
> > > > ns_segctor_sem.
> > > >
> > > > Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3b=
bd7
> > > > Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clea=
n_segments ioctl")
> > > > Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > > > ---
> > > >  fs/nilfs2/ioctl.c | 16 ++++++++++++++++
> > > >  1 file changed, 16 insertions(+)
> > > >
> > > > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > > > index e0a606643e87..38822dce1839 100644
> > > > --- a/fs/nilfs2/ioctl.c
> > > > +++ b/fs/nilfs2/ioctl.c
> > > > @@ -846,6 +846,7 @@ static int nilfs_ioctl_clean_segments(struct in=
ode *inode, struct file *filp,
> > > >       struct the_nilfs *nilfs;
> > > >       size_t len, nsegs;
> > > >       int n, ret;
> > > > +     size_t i;
> > >
> > > What about re-using the n variable? Does it make sense to introduce n=
ew one?
> > >
> > > >
> > > >       if (!capable(CAP_SYS_ADMIN))
> > > >               return -EPERM;
> > > > @@ -876,6 +877,21 @@ static int nilfs_ioctl_clean_segments(struct i=
node *inode, struct file *filp,
> > > >       }
> > > >       nilfs =3D inode->i_sb->s_fs_info;
> > > >
> > > > +     /*
> > > > +      * Validate segment numbers against the filesystem's segment =
count
> > > > +      * before entering nilfs_clean_segments(), which acquires
> > > > +      * ns_segctor_sem for write.  Catching invalid segnums here a=
voids
> > > > +      * holding that lock while emitting per-element diagnostics u=
nder
> > > > +      * the segment constructor.
> > > > +      */
> > > > +     for (i =3D 0; i < nsegs; i++) {
> > > > +             if (((__u64 *)kbufs[4])[i] >=3D nilfs->ns_nsegments) =
{
> > > > +                     ret =3D -EINVAL;
> > > > +                     kfree(kbufs[4]);
> > > > +                     goto out;
> > >
> > > Are you sure that you need to free buffer here and go to out? Maybe, =
we can
> > > introduce another label and to jump to kfree(kbufs[4]) at the end of =
method?
> > >
> > > Thanks,
> > > Slava.
> > >
> > > > +             }
> > > > +     }
> > > > +
> > > >       for (n =3D 0; n < 4; n++) {
> > > >               ret =3D -EINVAL;
> > > >               if (argv[n].v_size !=3D argsz[n])
> > >
> >
> > Thanks for the feedback. I have sent patch v2.
> >
> > Thanks
> >
> > Deepanshu Kartikey
>
> Thank you, Deepanshu, for the patch proposal.
>
> Because nilfs->ns_nsegments can be modified by nilfs_ioctl_resize(),
> we must avoid race conditions regarding this proposed fix.
>
> Therefore, it's appropriate to insert this check within the write lock
> section of nilfs->ns_segctor_sem, that is, immediately after calling
> nilfs_transaction_lock() within nilfs_clean_segments().
>
> As a coding comment, directly referencing kbufs[4] as an array is not
> very readable, so it's better to declare a variable in the local
> variable declaration section of nilfs_clean_segments() like this:
>
>         size_t i, nsegs =3D argv[4].v_nmembs;
>         __u64 *segnumv =3D kbufs[4];
>
> and then compare by referencing segnumv[i].
> Here, the original variable name "nsegs" is confusingly similar to
> "ns_nsegments", therefore, it would be better to simply change it to
> "n" or rename it to something that more concisely represents the
> number of segments in the array.
>
> Also, to help identify the error's cause, I recommend adding an error
> message like the following within the pre-check loop:
>
>         nilfs_err(sb,
>                 "Segment number %llu to be freed is out of range",
>                 (unsigned long long)segnumv[i]);
>
> Finally, a minor comment: to avoid scattering the function's exit path
> when making corrections according to the above policy, it's better to
> add a label like the following to nilfs_clean_segments() and jump to
> it, rather than returning separately.
>
> out_unlock:
>         ...
>
> bail_unlock:
>         nilfs_transaction_unlock(sb);
>         return err;
>
> Thanks,
> Ryusuke Konishi

Thanks for the detailed feedback, Ryusuke. I have sent the patch v3

Thanks


Deepanshu Kartikey
