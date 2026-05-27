Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191232566F7
	for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 17:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903995; cv=pass; b=OxExd7fM7s/ixa35p6XvSpIr+YOc7o2IH7iLh7s04O/u8Zu2TsZvIMB/gtNsHLMvslWv74RANdva8rWApDOeIOxqXLQuw2/Eh5wFZ4C3QLfGV+KvrpRU7HADNqpjBqUjs61uJCmgfiDOSrWmP35pjbPgn0P5zFB3Vrtflo4lDE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903995; c=relaxed/simple;
	bh=XR4W/++OHzgxJ1Ro/Ym0DhhScRtBbBgvnIqClrFK9Lc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g7oPIF6Cv1PX3VM8dd02znVpo3TIuI8aJrbp97ew3Qu2IxCyqfd2RI86DbwOLlHNDUQToGSoAddGSAon8joh2l0ovvlTC3o+8YJkBphnPF/caF44hVijYSeIUk88Nd1dCq/0G++X9kuiddoc3RgeOHfLT5zKiesPDa/Q4Ll0FAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ndQOjsX5; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ndQOjsX5"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa4b50e054so1182719e87.1
        for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 10:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779903992; cv=none;
        d=google.com; s=arc-20240605;
        b=SDBMoFO44wwncmg7Fjd6CNd97WrkDdhkPQvhCn81auVDTK0vMSYhtQPr84Z10Oj+K9
         VTPuxgv+yjUo2GhiDWRRNoEqvy+ZtxNZQy89/oDXuKO9N5v26jJ7km4Q7zwR2bk7kIQu
         9fP0nTevnpF0D20MRULYTvqkkCuvwcuDcvhDSe77PTGvfEetV0UAAI7Vs5m1zvr0zfBx
         Mi7eZrmxdilQXyfXCEcugfcQe1MJ+6+pyNdyknIKG1UpDRW2dEvIVS3rC/CIFRBDGxWp
         5+OfdjUvO8iyPRnwLfeiaeyCubD6SVYzQrVrILTwbbE/nRxO7Qz8gU1eFyNrTNqMtA8n
         Gb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VfE2G1C+qjhJUVcaQFjp7sQ3IUHnwp36WKLMQ0jJzsE=;
        fh=dohezSHaqG9STxUvuds6QBGSqH4MQ1BAu5c0vBDmHEs=;
        b=BKdgDLt3AehuZDH+HEzMwP8nzPi2H516Sw+yr2RAsJ1lWNTQgBXP8qOpRAMJxQIel9
         xxaH51tRfKhxSryDqlUbXhrw8ZDJkXYJq5uEVs6HiWBuCPMSSPu+5ZtS3fl9QqOJMFxx
         Dwubnau/pSPRGww3YA8ID/DbqmpEO1DfYp/p/FeF0wHOc1hf9SXMuXSuw0phoGdZcEON
         zsXjFH6x+YgHyBzi0zZvIuasnwhZS26Q4RCUDBakBF6DFTPxY7BPgQJ3ttFw5lZw0PSp
         xC5pqDRCKxzs7MlGMUcWovFDikO+UyUgVQsjn+AJLb0kpsDsQmO3gANnl5miA6113T8b
         0RFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779903992; x=1780508792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfE2G1C+qjhJUVcaQFjp7sQ3IUHnwp36WKLMQ0jJzsE=;
        b=ndQOjsX5ZHqonvENjWPugH8OJSEUhcsLZSRCQwsSUvAozXIEV/qbf23/cIIUopeIT/
         vmeeAmDYDssT4xUrPxyqJfLLlJmnNJULOiwYqkmbMZtIzGp950eyGfIOkGJJLvlnVjEL
         lmcbP1g+DZbmgvqINy+jjur0v8OkGZyq02sdZqAeps+E1jRHygQxvDZW/X9Y4G+HYB73
         o27g+fvzBGFwf9c7dvlf3KK5RJlBQ8Gs7eCmf7SEn4Hxl28jc9n0k51/ARm/6PPNVxG5
         BWoKBIxB7K6vAoErvEqDLJ+a8W/OH5qvwk5rA2WQ06GOmO/obZIOIHWWCfZFLJI3JFnF
         XlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779903992; x=1780508792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VfE2G1C+qjhJUVcaQFjp7sQ3IUHnwp36WKLMQ0jJzsE=;
        b=YiMyPEYHbgd21V4Lyy0DbEu3k503mjGzZy1t7Nh9KmVTm97oIgbZb8uNfvBg9Veys/
         tKJ6YlYc6frXZ9Oq0qJ3sB/60P0FcytyFq+NhWosn1WFCoujjXZAUWQb03MGWrDppLDZ
         3teGB5Cn8tYLQH9MI+yHtt7n8T6ZSe7h0QDSy9l5nJDu/Cp0/WLy03wEt1KyRjN8upVP
         WS3rYGjJCbRGRTwx11q1QmEFIJUdjb7nudOC/6UEfAnxDhaEnzDDKxGruTKIHKh8jaPd
         ONViAG0lNCrs9QcTma5QJ7LbvTyoDeEfhboxo2OtrDiCvqk+cb3p3jQZyIkWS4Y+9GJ0
         U4tw==
X-Forwarded-Encrypted: i=1; AFNElJ/UIQH3wPQn6HtVl7C7OjyyPn+h2WJ5XiH/rFfboJbHUy1YXHLzXfSNSBjCJ4X3qb3PP2EyvniwYS4x1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeLp3sgDFzblZjN1XarqxjzsuP6UNxpV89GxfGm5m+5R71ZzZK
	d0uBnwb0jZgNsMIL7yhkTgWUYFZIwxhzS1yDzQWhNGogBolXLu0TB3BZ5DrHIjcD+Vn25AnXdXT
	ZpGnhggPIrBjeL1nAb+n20birwCpG6pU=
X-Gm-Gg: Acq92OGsd6loNz3OvRdanLHxU3abX0mJ+G2Yb5sGkLrtjcB2O4H9ubLNM0T4hlmzWas
	bjKc38HYUNIZMJ6JPahNUblt+HdTNNHj4CzwomOvaBh+hjPwr4nyg418EUMuZ5A+xJUmc25Va0V
	wlivm9tRBHcIm2Yp1+d8DOFxvdhoAzFakagC4xKtpsOeRxJqeXUZM33EMWX7/b6kx/h5U//Pmfr
	IqoE66nIdb/Hc4qW6Ei/RBefQ8uUmgZKsiAs+ZszFyGGL2iN2tV/C1E5A/gcu2GbZ/MrH21SPkc
	y0/KUOmX
X-Received: by 2002:a05:6512:388f:b0:5a8:6eb1:2b6d with SMTP id
 2adb3069b0e04-5aa32314263mr5170397e87.9.1779903991981; Wed, 27 May 2026
 10:46:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525171931.4144395-1-willy@infradead.org> <20260525171931.4144395-30-willy@infradead.org>
 <19e4371075163ffa2168cb0ec934da1911e057d7.camel@ibm.com>
In-Reply-To: <19e4371075163ffa2168cb0ec934da1911e057d7.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 02:46:15 +0900
X-Gm-Features: AVHnY4KZNAmHInimcKr_ZQ-hmiqBOBejcKTpW8nKTepeMYPSX-ClbOEtsiDc-9o
Message-ID: <CAKFNMonfZ+VKyhKSWa6=0+hpKy+HtNmch2LV7KezhAgXAa2oDA@mail.gmail.com>
Subject: Re: [PATCH 29/34] nilfs2: Convert nilfs_mdt_submit_block to bh_submit()
To: "willy@infradead.org" <willy@infradead.org>
Cc: Viacheslav Dubeyko <slava.dubeyko@ibm.com>, "jack@suse.cz" <jack@suse.cz>, 
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"hch@infradead.org" <hch@infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2026 at 2:53=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Mon, 2026-05-25 at 18:19 +0100, Matthew Wilcox (Oracle) wrote:
> > Avoid an extra indirect function call by using bh_submit() instead of
> > submit_bh().
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: linux-nilfs@vger.kernel.org
> > ---
> >  fs/nilfs2/mdt.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> > index 09adb40c65e5..26043db677cd 100644
> > --- a/fs/nilfs2/mdt.c
> > +++ b/fs/nilfs2/mdt.c
> > @@ -148,9 +148,8 @@ nilfs_mdt_submit_block(struct inode *inode, unsigne=
d long blkoff, blk_opf_t opf,
> >       }
> >       map_bh(bh, inode->i_sb, (sector_t)blknum);
> >
> > -     bh->b_end_io =3D end_buffer_read_sync;
> >       get_bh(bh);
> > -     submit_bh(opf, bh);
> > +     bh_submit(bh, opf, bh_end_read);
> >       ret =3D 0;
> >
> >       trace_nilfs2_mdt_submit_block(inode, inode->i_ino, blkoff,
>
> Looks good.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
