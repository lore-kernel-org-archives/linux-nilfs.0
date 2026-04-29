Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D9F3EF663
	for <linux-nilfs@vger.kernel.org>; Wed, 29 Apr 2026 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777465922; cv=pass; b=H+T0XOoXiRq4XJuU9hAH3Hdg5LPgIR7C7Z1xZHm4iWcnJPTMh6qtXaJMjb4PVCS1yJWKW3A1CX5ndU2Ss+TH7fj7GCXWjWtRsKIsrKSjTXTtzCb++ZZT2wrrpAMp7hJdZV+1+9jIOwXrNHR4HyTLTmmxsw0wBFHqBJ9JxXUCBRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777465922; c=relaxed/simple;
	bh=tjtIE7m0wNPcSN/iRChuOeWFihNAknwysQuKEqVGXOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZOqq5fr16Jhz0FYIH/9WGtl+NsTg0aDqRvv0sVOcq8bJOPLyyu9mmtUS8UC/yuEhcT1FHSB2kOrvNvwMLvHTtw1ZoWwNQ5KJFIKjHh5kslsiHXbQa5TR6omN1LNHXmMVklJlRKyQOaV7uS/SSQ7aSMK11kkBlojbkUtb5JQSe3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Os6Rr3iJ; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os6Rr3iJ"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38e7d983f50so140233411fa.1
        for <linux-nilfs@vger.kernel.org>; Wed, 29 Apr 2026 05:32:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777465919; cv=none;
        d=google.com; s=arc-20240605;
        b=jEYTMzcTgDiMc947ufGZZZ2ThLcApWMOc4zIDeonbzHOEj7lByjw7NxS3M5rYz1NLr
         j4dvLDt3RgFs/WFVAf7DXHd3FtLZSOsWfOVQU1ZDJbRxGzHqMhD4EhaZIvJk1KHue0+5
         wKTFo8FFxwA2+R1c2cts9ZgNq66jylCQ5JzDekZFnKLTZxCMby/MQFlc3sXdsB3YbjVY
         KQ5upzBjYuZZ6hgW4EaklvjImZT3vUOdvt45MruCxt1nlhhiLXYFfOglnTyfuT9OFWjd
         n68QQvKaG0u48mTxrxGY03/daH4vjJZ/V5XbjIoNog8slBFnF5wKOkm3lCEV0BQuFIB6
         wfmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CcUMVv2sYXDZck138krtGx21VCuPbN4nsX7Mkfsx8/Q=;
        fh=Sm8vF+MX9Y1Jp8GY/y385HLGMvtcTrs/yzpZfBvPJ0o=;
        b=HUJL816k6wgxHh8nXgbJp49fcNueSEX8gfqc3m7bszbp8kbS7iz1SyYFA7CE0Y+ioS
         uFNBdfNVrWKGeyKfcuCZhANL2yQ3l2UyIigtb4xPHaobaJf6k96gTbRlX0WVeUMWFaj1
         rCxmiZbnh7Kl4OyfNIMASpkkZZqs+jpiKQhFL3divkU5xNZkBLIXs17tAi5hFUJc9CBN
         LNfu3P+0XvgLbaW29mfpeuKyQqqvQEsWZ7AJNfTUBUzAx87Lr62ygcSSNpgCKR/vY3qK
         BLm6SEcM//cus7oR1JzSeX/CWB+K4KnFIGWgsGrOWZogQLUtVywwHsiFH/vX/IRr5PDh
         vglQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777465919; x=1778070719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcUMVv2sYXDZck138krtGx21VCuPbN4nsX7Mkfsx8/Q=;
        b=Os6Rr3iJ3y+IcXoc9br9V6gcJzSwf0iXtdGcGq/tBvoGvGxOBvGQNGJunBZztLEgfl
         67u+4uFZxp5s8AmKrlDM4Z1LLMH66HuPVodrWwGps8AY0p/sN3kejt8kPNEF+B3pKMJZ
         60a40a/aj7iAL36zhrIDCNSupptgwLsrKeJcbKFCg3ejI2YGNZdTpZ2y2Bg8Bqz4WFfW
         M7zKPTTGoZU8drZmoOwz2xQJQluqlIREeyrZxGwWBRI80GSgvladHYcv1w2pI/KSzYWJ
         zg75kgrHl+63I2xkqxnX/rjSnlUoao6mcK5D1tRTwsApqv+jkDgZeqgD+fIRyFYZJ/Aq
         h9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777465919; x=1778070719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CcUMVv2sYXDZck138krtGx21VCuPbN4nsX7Mkfsx8/Q=;
        b=cfJce3qdhvkL1EJ6GJw7vc0JlxP0TS4qhPAFhjXf5D038OH0/AaPjGvu2zE6PpCbNA
         1nTlq9h3cO7PSiZ0p402cZabGvhKHyVhlhM/fO813ANmPJIg9yiKSQvwsn6wZRlBAUBR
         7XXI5LnKdFplDAsYQZNX+LGKlMWICJxhxkpd0aSpEOv+q/hvpr0wEciHRxuw0oaNXdgs
         /YjY0Z258hGB62L2Ci/hge549+99c3V/D6EuEuGFACDhYv+YGsL8NyK+4LutZq/E2r55
         YA1xxt48fVCXQJmPLYRfp+P25S0TaWuWgCBauOMsXo4S7I94EdxaGIu2Th8nnMxY4Zya
         PFUA==
X-Forwarded-Encrypted: i=1; AFNElJ+HeZ0SjO9H1c1yEHunDllkkit1nkp9nrHxLBx0akL9bLCzEhj5c1qv7uzCq8sTqfRdQClVJrp74V/Qfw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3UNEqaBBconxZBXFAcQ6L/ihnZlMBeajxMUZZfefbdHWGFWs3
	pczKfhlcoYqCWNMIIfjp6T/frKmunuWv2b6cAEujpp6u7/lxaBrfj8X2xPDvs/SiPzMPFqU2Psu
	5dkbHBGC8ly0dFst8A3pMiXuz6H83Qc/DNL1J
X-Gm-Gg: AeBDietElGqgf30RzB3AIPOdH+e2QlgZe51eyO8f52iKqRxonS0wF2MRw9uOceXuBxf
	C49lZnfVOfK4A2Y+anAkflonE8UV0Bm0sGxebuqcH8c34X3UJnvogA8PAA2M6I2GX0gFE1mi4JG
	p1SmyCDj7+I1Ldy87w1toyhGwioCzEN2uchY7F352FdjGkmWOblMUtHOsz6VfspyZWk7OVaxnKg
	X3mdnupRlIvvQ1CY8hG5bdKaaYuwcKrD4FU3DTtWDcMKIs/hCCTIt0N4rMmzvZ4y1LcNc7uJgMQ
	bdlJ/aLE7XH6qUQr63o=
X-Received: by 2002:a05:6512:1285:b0:5a4:d4:5c5e with SMTP id
 2adb3069b0e04-5a74660ede1mr3098863e87.22.1777465919039; Wed, 29 Apr 2026
 05:31:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428040256.84403-1-kartikey406@gmail.com> <2ed28b6008cf898a06036d5836380cc5cc45f118.camel@redhat.com>
 <CADhLXY5Q8UsSQZYm-KWpJ3q753xAcxbnk9y+vGfkwA9RF8VcrQ@mail.gmail.com>
In-Reply-To: <CADhLXY5Q8UsSQZYm-KWpJ3q753xAcxbnk9y+vGfkwA9RF8VcrQ@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 29 Apr 2026 21:31:42 +0900
X-Gm-Features: AVHnY4IM4pZjE57TE3iyIGLB1c-YKcub8kRGIcL9ajOhKdhSMULNzDOj_s5mqsk
Message-ID: <CAKFNMom83SJqvN7ZSMt3p9TVvGVL_sC5sfO4+ZrC+zi6OC+HVQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 10:50=E2=80=AFAM Deepanshu Kartikey wrote:
>
> On Wed, Apr 29, 2026 at 12:29=E2=80=AFAM Viacheslav Dubeyko wrote:
> >
> > On Tue, 2026-04-28 at 09:32 +0530, Deepanshu Kartikey wrote:
> > > Syzbot reported a hung task in nilfs_transaction_begin() where multip=
le
> > > tasks performing chmod() on a nilfs2 mount blocked for over 143 secon=
ds
> > > waiting to acquire ns_segctor_sem for read:
> > >
> > >   INFO: task syz.0.17:5918 blocked for more than 143 seconds.
> > >   Call Trace:
> > >    schedule+0x164/0x360
> > >    rwsem_down_read_slowpath+0x6d9/0x940
> > >    down_read+0x99/0x2e0
> > >    nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
> > >    nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
> > >    notify_change+0xc1a/0xf40
> > >    chmod_common+0x273/0x4a0
> > >    do_fchmodat+0x12d/0x230
> > >
> > > The writer holding ns_segctor_sem was a concurrent NILFS_IOCTL_CLEAN_=
SEGMENTS
> > > caller, stuck inside printk while emitting per-element warnings from
> > > nilfs_sufile_updatev():
> > >
> > >    __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
> > >    nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
> > >    nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
> > >    nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
> > >    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
> > >    nilfs_segctor_do_construct+0x1f55/0x76c0
> > >    nilfs_clean_segments+0x3bd/0xa50
> > >    nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
> > >    nilfs_ioctl+0x261f/0x2780
> > >
> > > The root cause is that nilfs_ioctl_clean_segments() does not validate
> > > the user-supplied segment numbers in kbufs[4] before calling
> > > nilfs_clean_segments(), which acquires ns_segctor_sem for write.  The
> > > range check on each segnum is performed deep inside the call chain by
> > > nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
> > > while still under the segctor lock and the sufile mi_sem.  Under load
> > > (repeated invocations across multiple mounts saturating the global
> > > printk path), the cumulative printk latency keeps ns_segctor_sem held
> > > long enough to trip the hung_task watchdog, blocking concurrent
> > > operations such as chmod() that need ns_segctor_sem for read.
> > >
> > > Fix by validating the contents of kbufs[4] in the ioctl entry path,
> > > before any FS-wide lock is acquired.  Out-of-range segment numbers ar=
e
> > > rejected with -EINVAL synchronously, with no work performed under
> > > ns_segctor_sem.
> > >
> > > Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3bbd=
7
> > > Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_=
segments ioctl")
> > > Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > > ---
> > >  fs/nilfs2/ioctl.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > > index e0a606643e87..38822dce1839 100644
> > > --- a/fs/nilfs2/ioctl.c
> > > +++ b/fs/nilfs2/ioctl.c
> > > @@ -846,6 +846,7 @@ static int nilfs_ioctl_clean_segments(struct inod=
e *inode, struct file *filp,
> > >       struct the_nilfs *nilfs;
> > >       size_t len, nsegs;
> > >       int n, ret;
> > > +     size_t i;
> >
> > What about re-using the n variable? Does it make sense to introduce new=
 one?
> >
> > >
> > >       if (!capable(CAP_SYS_ADMIN))
> > >               return -EPERM;
> > > @@ -876,6 +877,21 @@ static int nilfs_ioctl_clean_segments(struct ino=
de *inode, struct file *filp,
> > >       }
> > >       nilfs =3D inode->i_sb->s_fs_info;
> > >
> > > +     /*
> > > +      * Validate segment numbers against the filesystem's segment co=
unt
> > > +      * before entering nilfs_clean_segments(), which acquires
> > > +      * ns_segctor_sem for write.  Catching invalid segnums here avo=
ids
> > > +      * holding that lock while emitting per-element diagnostics und=
er
> > > +      * the segment constructor.
> > > +      */
> > > +     for (i =3D 0; i < nsegs; i++) {
> > > +             if (((__u64 *)kbufs[4])[i] >=3D nilfs->ns_nsegments) {
> > > +                     ret =3D -EINVAL;
> > > +                     kfree(kbufs[4]);
> > > +                     goto out;
> >
> > Are you sure that you need to free buffer here and go to out? Maybe, we=
 can
> > introduce another label and to jump to kfree(kbufs[4]) at the end of me=
thod?
> >
> > Thanks,
> > Slava.
> >
> > > +             }
> > > +     }
> > > +
> > >       for (n =3D 0; n < 4; n++) {
> > >               ret =3D -EINVAL;
> > >               if (argv[n].v_size !=3D argsz[n])
> >
>
> Thanks for the feedback. I have sent patch v2.
>
> Thanks
>
> Deepanshu Kartikey

Thank you, Deepanshu, for the patch proposal.

Because nilfs->ns_nsegments can be modified by nilfs_ioctl_resize(),
we must avoid race conditions regarding this proposed fix.

Therefore, it's appropriate to insert this check within the write lock
section of nilfs->ns_segctor_sem, that is, immediately after calling
nilfs_transaction_lock() within nilfs_clean_segments().

As a coding comment, directly referencing kbufs[4] as an array is not
very readable, so it's better to declare a variable in the local
variable declaration section of nilfs_clean_segments() like this:

        size_t i, nsegs =3D argv[4].v_nmembs;
        __u64 *segnumv =3D kbufs[4];

and then compare by referencing segnumv[i].
Here, the original variable name "nsegs" is confusingly similar to
"ns_nsegments", therefore, it would be better to simply change it to
"n" or rename it to something that more concisely represents the
number of segments in the array.

Also, to help identify the error's cause, I recommend adding an error
message like the following within the pre-check loop:

        nilfs_err(sb,
                "Segment number %llu to be freed is out of range",
                (unsigned long long)segnumv[i]);

Finally, a minor comment: to avoid scattering the function's exit path
when making corrections according to the above policy, it's better to
add a label like the following to nilfs_clean_segments() and jump to
it, rather than returning separately.

out_unlock:
        ...

bail_unlock:
        nilfs_transaction_unlock(sb);
        return err;

Thanks,
Ryusuke Konishi
