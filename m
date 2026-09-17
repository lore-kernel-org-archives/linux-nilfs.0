Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36114ABBD8
	for <linux-nilfs@vger.kernel.org>; Thu, 17 Sep 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660047; cv=pass; b=pR0Zc/S3rFlsPzh/L9/gnHLDZvy58bYdvstEYtQ0UkXQwWrLVqKAYsI3LxMoTR0augOTBnnzB0B7a/6uKn5eDCBcQuzODqaGf7Gjtd0NIRPzLLOl8vss/Bgzzigh58XF5DcaMpfudd1srgSb+j5Mc7opHGAgOCUV40P1hMnfC/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660047; c=relaxed/simple;
	bh=HhKgh+AhoovE+nLXKxFmLwpFzc2TTxLCaPaNRYCrGXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ui1Dsuzsy6meGlBZBO1utYRZQcXoirUvmfelWDj+gt2iHQO5uBzLTbag6fl3Ibljjsve9ZaaI6CVchNAyoYyEWhltgK74umFJ4KTwsL0iPkjlegZb3PXw0UA6lYklP8VqB1+/TMOx069B8uXzLXaLYA6vPVlGRtYXOqv4o/OgAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPH7Kn5G; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPH7Kn5G"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f17450so823635e87.0
        for <linux-nilfs@vger.kernel.org>; Thu, 17 Sep 2026 08:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789660036; cv=none;
        d=google.com; s=arc-20260327;
        b=XGDwtbCL/Vih4Mmzao46DzpTXGnxugWsTmiZF86VwlPixXQ1mVowUW8XbO4Wz7/Ssn
         JFYNo7DiuJWztnQrRvzfoTDcgoPiabZNq9FeUiNwcQk7Q5m5LtKLBmVPjWP6JbdNf4DI
         t6oHZT1Mr+fnnRPreA66J1CSlWIL8w8IxAOpWEnS7vf+izHTjlv3x0AyePz5BtuaxXRa
         o3M+/cYas1o8aPMKyPaydkAMGW+DEZa2ITJ4tZ8smQRY0/y8PE2av0BAbSZD9lxRfTVS
         dXHaCnUTy1g1lXDAwCeNwf6Wsc1ewtLZaza6+Ak1WfVJ+4KprVncRgfBPPS9GXNTTEmv
         hDxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jzy+gQGDahxjRYzrMpnyvQ4GBuSr45Ef8jvJeyFAvyM=;
        fh=eeqmZBx8R/FRaI/HyghJPOjxED87+MZR2DNWmThvHj4=;
        b=N4bw1JrlpyFlPOgavqGxjeYHIMgBWeC/twHcvvIfNEMXQrZX4MVMNdzCi3IxVAazSS
         j3v7cSjmBuz9ew6N5r7pZOqM7cXXZPLuOzNEkNo+VYqyyS3Xd1PsnP7ZU4DrVpBrL9I0
         lohn8UerIq7tDhXM6PqAqqv98jvXpnYQYgDCNNLIIK4VuVuijt8xglmuEIF4qRYyfFLS
         KGRTb3e81OkCK26CLIQNNC3uCqceZrOJyb/Gk3EjXdzEkxNFf/ZMGKPoPx0QAj/gQxgc
         +uCemeAjEkUnpRCIwua5unFymCBDh7NaRhNuGnrkz3Z5maI+1qaNU+CyfShpJqmPRT6H
         IGeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789660036; x=1790264836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jzy+gQGDahxjRYzrMpnyvQ4GBuSr45Ef8jvJeyFAvyM=;
        b=UPH7Kn5Gc2k5NVCrqN4WeOufJSlpZ0TE3hCzj/ldttsZGZq9jp1U0DQLBq6Mtsm+oa
         q93kPN4FQdFYjocqX9S+IMHHNEnVxrbkcQ8OqXrn2H7O/J77oZRbHjdI4Ae0WBusAqpp
         Hdlg9wkikrS3ZgmZPHx5jWzWbLBJJGxW6bhqWIWDdA7lY1DNlyX1waPlZzSqUC48kxE8
         qe3HwkoliuyoYNKDASyiwJi6UTc5X4Dur03+KAkVPxWEFP7C/YFdG2uDKfbgfFkcqjej
         rS7fR9SMTsIY9HUnjvNVvtJ4Aq7rsauHNksjf0LJciyzd1qY1Ri5JrPXiLlEHlNAON1o
         QmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789660036; x=1790264836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jzy+gQGDahxjRYzrMpnyvQ4GBuSr45Ef8jvJeyFAvyM=;
        b=j0rAJU/NiWV8XqaICl85THCJ4a/ti+N9lhcx3Pht2P5TZu25fjRXFTCuCxzS6btffZ
         N6TkCs1lu7qYdzMDEA2Hd5MYkEmyc1di2KkAgCrwyOc0E99mt98g7cA5T18stHMilkBo
         l4b/Wa9qB3Ys2H+zhs+dKMI6myuBFCG2syV3+VQ8hMt6PfEVSfpISTb6NgSQOqj+sIi2
         y+8dPf70f9UmcNKayijcAu4qBQsHaosxX5ej7UDgA5EVHAqWc01dRDG++BOc0dX3brR9
         sS5L/0PHzAW2GX//wlP7aEPvgwIHDs+y1XJTCBE3X6hOFc1lqIi9GpWBk9AGok152Dnq
         hQyQ==
X-Forwarded-Encrypted: i=1; AKwUvBwtIVZ9ZBynfPd6PXQ3HsFtyNaV1mgtNmeHbOwhCOsROYek3Id2R+Nn8a9o4HFsHp3N/TawAkjPIibEog==@vger.kernel.org
X-Gm-Message-State: AFuF++lySo3E1A6YZ6rAKKzfTuVEXzAej0o+gIfDjS16e3VOnSPx46yU
	857W2EqH2nlGWLjiTpRySF//5EHoA6lcgFnZ+5V/nmWxNOKMYn/rm47ELwbpx9xMANL1M9uTSOw
	qrfaGyKln2MkB7is39be8v8KCg1FPpXg=
X-Gm-Gg: AYBFou1ihU6l1SaN75ZdetmpGmO4t5q/XMHwORGvq3Yt5/lpXqhgGoL5M2EevO/gFS7
	uXi/mOhv9I7in60t+jDO75sKiOS0cQOQ2xsD1CUZYZ9kMAdAiV0Ek1Icphd9rzSJyGdre/MTKeL
	EZ9v3/Ch8yuxWQBGgtC3caTz/HN6pOtH1+OqJhM86V+3rLZR72LBrqQjucsWOG5S9cMTRoqInZO
	Nt8Id6fyLthw+2jFZ7zuZ/5YzzjrnJilGkhpUsRWUqB12yw2/YP9OQMoQ5UueTX432rh3YVDR9r
	rKhywYLt5frGLcBFrH6HsQRvg5XcWt5fDTwj/EGwOcTe7Jfr2KyahFv0
X-Received: by 2002:a05:6512:3ba8:b0:5b6:183c:5c94 with SMTP id
 2adb3069b0e04-5b8b66525c1mr2236156e87.50.1789660036136; Thu, 17 Sep 2026
 08:47:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915195223.3331909-1-qwe.aldo@gmail.com> <8eef80c6c8d21e863c5a3721b1ae681fc4ccf54f.camel@dubeyko.com>
In-Reply-To: <8eef80c6c8d21e863c5a3721b1ae681fc4ccf54f.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 18 Sep 2026 00:46:59 +0900
X-Gm-Features: AcwNN1W8Hxz9umrd0xiz0nxXV4xs0ZDavlInPR_CBX7SqfB6dwEpospt6ft_-2s
Message-ID: <CAKFNMok804k_g2CHXfrn0LaOY38r8FtMnAk1kRc3YeZ=omCoag@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: validate segment number in nilfs_sufile_get_suinfo()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 4:06=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Tue, 2026-09-15 at 16:52 -0300, Aldo Ariel Panzardo wrote:
> > nilfs_sufile_get_suinfo() subtracts the caller-provided segment
> > number
> > from the total number of segments without first checking its range.
> > If
> > the requested number is greater than the total, the unsigned
> > subtraction
> > wraps and the function may process segment numbers outside the
> > filesystem.
> >
> > Cache the total while holding the metadata semaphore and return no
> > entries
> > when the starting segment number is at or beyond the end.
> >
> > Fixes: 6c98cd4ecb0a ("nilfs2: segment usage file")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> > ---
> >  fs/nilfs2/sufile.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> > index eceedca026..573646c5f7 100644
> > --- a/fs/nilfs2/sufile.c
> > +++ b/fs/nilfs2/sufile.c
> > @@ -870,10 +870,14 @@ ssize_t nilfs_sufile_get_suinfo(struct inode
> > *sufile, __u64 segnum, void *buf,
> >
> >       down_read(&NILFS_MDT(sufile)->mi_sem);
> >
> > +     nsegs =3D nilfs_sufile_get_nsegments(sufile);
> > +     if (segnum >=3D nsegs) {
> > +             ret =3D 0;
> > +             goto out;
> > +     }
> > +
> >       segusages_per_block =3D
> > nilfs_sufile_segment_usages_per_block(sufile);
> > -     nsegs =3D min_t(unsigned long,
> > -                   nilfs_sufile_get_nsegments(sufile) - segnum,
> > -                   nsi);
> > +     nsegs =3D min_t(unsigned long, nsegs - segnum, nsi);
> >       for (i =3D 0; i < nsegs; i +=3D n, segnum +=3D n) {
> >               n =3D min_t(unsigned long,
> >                         segusages_per_block -
>
> Looks good to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Hi Viacheslav,

Please take this directly.

I also agree that this change makes sense, and my local test results
are as expected.

However, please drop the 'Cc: stable' tag since it does not cause any
fatal issues at the moment.
If a real-world problem is found or reported, I think it would be fine
to request a manual backport then.

While acquiring information on out-of-range segments due to
wrap-around is indeed possible, sufile is also a metadata management
file.
When accessing out-of-range areas, it simply hits as a hole block and
returns empty data.

Neither memory overrun in user space or kernel space, nor
out-of-bounds block device access or information leaks will occur.

Well-behaved userland tools read segment information based on the
statistics obtained via nilfs_get_sustat(), so no problem will occur
(the difference in behavior was visually indistinguishable).

Therefore, I modified the nilfs-utils to perform ill-behaved calls and
tested it.
Although out-of-range non-existent segments were displayed as empty
data, no critical issue that compromises kernel stability occurred.

At present, it does not appear to meet the basic criteria for stable
backporting, so when backporting, we need to be able to organize and
demonstrate the reasoning why it is necessary.

Thanks,
Ryusuke Konishi
