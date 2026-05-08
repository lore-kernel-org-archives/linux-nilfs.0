Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1002F8EBB
	for <linux-nilfs@vger.kernel.org>; Fri,  8 May 2026 02:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778205952; cv=pass; b=FFDyOlLZmehHHUgdHeWfxvt6nVQ0+9tALsigVJNjwNtZoXGIIIIY/84KAiaYUeNnYiEhYG6RntpC2JI6Ss+9NQDiM0ToFIavCSCRqEWF3lpJpjWAp2hHEHLW5j0Owx25HHvHOwH3zUWoozBmC5WCcQPJtSc32v/8HBjlgjMnotk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778205952; c=relaxed/simple;
	bh=XEEddZPEg09kFgMZPR0sAnExWe+x70XjsU2Y7LpAdmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oT5HEYfoFCfALhszuqO87C+s68ixnbUkYuqL//n/fIiEXsky106F6VsO6c9itfXB37REejQd+XjbjNbCKFopUtFMn3xaarWTh8+5m734xESpDYrmzVcX7By2c/DQBuDR5D/tQDRe4eBHpJbCDILz4kvFkswibfUJuYCuCD+fEZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bo1LZnTY; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bo1LZnTY"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a887ebb416so1440337e87.2
        for <linux-nilfs@vger.kernel.org>; Thu, 07 May 2026 19:05:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778205949; cv=none;
        d=google.com; s=arc-20240605;
        b=SkD/ZfTnxJkGenndSyXpulaL53iPtaEgbCWBSFDyCK2cGD4PxDKzV8+1r1kSjJYcVH
         iMWYX731meHbBIsaK0BIp/sm69PvAEz95WELPacdn83eDbiE55LBp5ZdtzbZ6DUOny/l
         JEI1m/ifMK4lYfBXQeF3wsAXOkA9B9c7knUjwBAoNeNFg/i86DyCKUK9KY6t8X0/3X2I
         HvmyHNTH4SzGiBOMMXyA2sE+ZkWPnuL4OtPaWkeqnJPyCuGn3cEckWhUrvTsODcaEHSq
         tbtmE/86JEV5xKqC7R7eZszjqy+3c0jX/yDXufZd8DAdJBstvBdtbwlz3vd8lbwI21HB
         x5Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7eHo6xZr5QJ6JNnugPl4PzR974/FR6n1ywC1BL9X7G0=;
        fh=YcCfF2JHYZfcfxTySBv/sk2ZsnARCoozXw+pN+Tv8AA=;
        b=QEpT8SRbk+JZLUwQdiiep0RoArWmN9FIE1esQnQsvZGsEUByaiR49yZmzoTnsdkEm8
         EdIrBRpYMeA/dV1lFMnbsPrV4euT4XD95eC8Ct3nyi3ssVESxfhHGY4NZRa2/u9qUmW6
         GavKb97g8khTTFMdISaxtTtFs8xZwLmSPgHH05LHTAAsSoWlXtgOa9645vUG4zdCsiHu
         O3dj3YXkYH0pXNv4JclzvgyQm2xw406vZqhZVzfNHnCIxXpJMkEZVXN9fGq9Nj1azbnK
         8fqaK7SzsB6DyN46oQF3Hnm0GQ1zGm/e6NF6siiMeDGFG1hdm0sr/G2VhVcnq/HF99RG
         qPKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778205949; x=1778810749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eHo6xZr5QJ6JNnugPl4PzR974/FR6n1ywC1BL9X7G0=;
        b=bo1LZnTYZKZPh10isEKXGzhIJx/Ek+Khcd0V1+1zCpN+RfPhfkc/3tDzi6LJZv9tWu
         7yt9zTLeF5pSfw6ssO5O/nWx8Qj7lHY0qc6Q6VpZFVRIJEka9jgPadqFtRyXVzRVhAC8
         S+WO6H86+bCiOOO02k2KkEAoBXPJQkP+pqRrt9DjoMWZxu00GvUrQIqynP7IaEH40Ncq
         0QqXBvDBoiO+qCkGRhAxJRsyiGv/4CwOnB2g1OyG2eNZ3f/rN2yKdtWRXCDfOICrJOcf
         1SDc1LsInJjztNu1PMHYNypMichSv3g0OaXqJTl/kY8FRTS3MdPcApvUvNSkSEboHSeH
         51Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778205949; x=1778810749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7eHo6xZr5QJ6JNnugPl4PzR974/FR6n1ywC1BL9X7G0=;
        b=pTSoWAFENRFJQwXm3XLi7vF02/tXSLJ+qC5jYPkjSFM9rC7NDZi/Xd99+rm5dr275w
         frvTNwObqlC+80e2V90bE0ogWPJAvh4nQCMm3qgZ9fQLSwrUZGYUgcxMiYb5VTozNyN/
         /JdWCMOGrtjZzN6porP8O7hSdg45edpONeJckR3FS6tN9cGXMm9NK5kHcUtMADUQnBh2
         a3lIvd39ZbNx7SPlaJ31MPvJRcWelmx3lAqUPNrY+ydHwc8HTkfRTfuGVyARwUvSJ+7P
         YnXzZZz2UFUmQcgDJlK3eWhelI6FRCBR5Qvo6kIjZKsOIT3ST6IcKGdmP8WyH0yzKfG4
         3zfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8TJRsWIciqzvUuLYY8ItGEV4Kn0p/DzF6yvYaPpOLjC6LX84GUlS+h7GrUlFySmjdaNAFuC0niGv7X3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGqoAtDzEq8p97EvpTBWgwPa7XIK2btl2DlLU10hkOu8XC7jvp
	ko0g74jm4p7wWJ7sSwJWSzxRPCDpFhwNC38JPGj2S3vM+IuRRhNcJp0BJbK3BC+KLgpgmcZY45Z
	etQiTGci4QXEIHXHW+IPobmcbK+P54Qg=
X-Gm-Gg: AeBDiesYEOvnyKk7fnB19/T/I1M14yNTZzZsMvW9bIsk4RVCxitJMTD43/+bIEnzxuS
	ywXQLsFmQfce1Ek48tVUDnBLLy442EGVd7iscnOVyWp8n9WHzptLFtWp9hl20sgP+V3vOABP0Rj
	cz+Yu6p4jcxVkIGwtseVUPnVko0ivWyQ8zEBcFevWtYTukuQ5VXNdTXhcfRRiTUkOyXIW7b4O+f
	C0uUO0AR6G0uC/z9XMRkSLzI2ai5nfnTrbAUiFB4V2eu4UrwjA6NGO+KdCJDWMYhryuxl9JOlEJ
	ouZSbuzsqmtjTAl5tzs=
X-Received: by 2002:a05:6512:b82:b0:5a4:d4:5c5a with SMTP id
 2adb3069b0e04-5a887ce65d4mr3567058e87.28.1778205949194; Thu, 07 May 2026
 19:05:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507155021.941895-1-shuangpeng.kernel@gmail.com> <bdc4f9e52d007cc4fc4ab6832906f7381d22013f.camel@redhat.com>
In-Reply-To: <bdc4f9e52d007cc4fc4ab6832906f7381d22013f.camel@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 8 May 2026 11:05:31 +0900
X-Gm-Features: AVHnY4Lquum231v-nlW1X22zQJHNrvDF71xggNF1sOZq-_aI7GDoqJfSq7EPn_A
Message-ID: <CAKFNMo=57tDvSecrxGETJYLr2JNZAZ5HYSJqNwFV5dywJ7L5ng@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix backing_dev_info reference leak
To: Viacheslav Dubeyko <vdubeyko@redhat.com>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 6:41=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Thu, 2026-05-07 at 11:50 -0400, Shuangpeng Bai wrote:
> > setup_bdev_super() already initializes sb->s_bdev and takes a
> > reference on the block device backing_dev_info when assigning sb->s_bdi=
.
> >
> > nilfs_fill_super() takes another reference to the same
> > backing_dev_info and stores it in sb->s_bdi again. The extra
> > reference is not paired with a matching bdi_put(), since
> > generic_shutdown_super() releases sb->s_bdi only once.
> >
> > Drop the redundant bdi_get() in nilfs_fill_super(). The single
> > reference taken by setup_bdev_super() is enough and is released
> > during superblock shutdown.
> >
> > Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate the =
mount code")
> > Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> > ---
> >  fs/nilfs2/super.c | 2 --
> >  1 file changed, 2 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Viacheslav,

Could you please apply this directly?
I have also verified the fix and confirmed that the Fixes tag
correctly identifies the origin of the leak for backporting.

Thanks,
Ryusuke Konishi

> >
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 7aa5ef8606cd..893a504cb80c 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -1070,8 +1070,6 @@ nilfs_fill_super(struct super_block *sb, struct f=
s_context *fc)
> >       sb->s_time_gran =3D 1;
> >       sb->s_max_links =3D NILFS_LINK_MAX;
> >
> > -     sb->s_bdi =3D bdi_get(sb->s_bdev->bd_disk->bdi);
> > -
> >       err =3D load_nilfs(nilfs, sb);
> >       if (err)
> >               goto failed_nilfs;
>
> Makes sense to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.
>
