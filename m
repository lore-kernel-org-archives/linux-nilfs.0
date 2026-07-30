Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E29F439321
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785418313; cv=pass; b=hD1pD/RDTKJdTetjHkki5JYGyzoU7CTi4psYeMc82rYgOUfEznRXxfqX1ozcPUdPlTgiCkT2O/hUtsuZFHs7EVmSx9Rle2ib/58eJPNMlQdt2i6snMzqn3HvgLb1qRLtYoH1/UduaCpTL/wrlSeZ/iZcOjyMy5+Al9AH6QMPc7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785418313; c=relaxed/simple;
	bh=XtsIeZeFk1zC4NA2+HNqpGOQpVjbEoWkj5z397B7teA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OqSb0gx9ossKfagxLIoXn92ggkfSO9YSz0X9cD+1Qft+PBGs0Wc/VEZ4HGhliGAR5nQIjHtdPLuLs+cLstBvuu5xd1TpTkylcHN50TlwKYUDgSiSA2sFbI01Hl/Dhtm55JMZ9psUM1nMf9BsoVUIOv+xTyGpxvW8myq6Lp4/AI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dteACLJL; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dteACLJL"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39c74c469e8so13516691fa.0
        for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 06:31:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785418310; cv=none;
        d=google.com; s=arc-20260327;
        b=JtMvHwDE55jOwGrpV5o7CNoFPHJArf7VXXCMufz5h9ACcMlaRxg9EZgHDbOJkaACXO
         fqoXmz9s1HLShsjM76Jel6tsZ05YRoiYiSwKEOQfVeMIoaSo3VGwQWXwisEOrXZUkHX2
         /JbDPSxSuBiotGKk9oq4LKpUqDjXhm3MNztcuUNb1qwCgE4waalRrSNQi5k2Oel1/mEi
         DW5oNvd1tyUtAwxYkTMTpdo4vPIT+BXSoJOrh+bTg6XTTmYv8jd8ReZ3nHE0KD6Fepbu
         thn6yk/++WN55RWh+yXFa1UrG1BiKafbtX3jslW5ARNpc7wgv8AFVovGCD+IrI893HmG
         BrcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wxa9hLaozLeU8kbclIzUv6BtOuJqfwfUIAKrXcFIxqc=;
        fh=0uQtmGTnTXhuMwizTAmROG7u1tOeWDPunlF/2/C3gso=;
        b=c8rTNe/fsB78LItxBQhb5eBFzgTepktquPKilSdIx/ok8SJO1o7IQx6wppY53BckBQ
         xQbDCjbTzSq1ha4svFt/HW5F47jWqOKkH2ffm7zHnJoCfN5Z1m4J4dBskAw/cAQAZDHt
         oq8rGzSur3KRJemnAmLgc2ob8WQtU8NlszBqMU31yRZmOyl05xxxJEPeUAFjB3CQ5wLN
         h0h6SIi/znW7DV0K8gBhQ9WHBZSf+pK7JPpDVCNJFE1JFlUQ489gw5Df1t2dKBTGmMaS
         go9A5HUzkzJkoW31vedWkNDgxKs7r/k84zKRZUgXFmOo7FC/XcG0fxCiA5mER4ARFKMP
         xmFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785418310; x=1786023110; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wxa9hLaozLeU8kbclIzUv6BtOuJqfwfUIAKrXcFIxqc=;
        b=dteACLJLrv/SGV530h1ojhSMtEw+rZLXmngyI1Iotuneue7RQDi8z9agLQe+8xhr5A
         /DV8fVbUsWziR5vmiNtWPKyLRaug5BCYiDWQNIUHSrgq9s3k5KIJXKKr21BD6ilX7lrx
         LUDYMHhhm5bMHnHRrCKljkxfmHQO2NYlBccdoJHlUDQH7pfV4R4bB7GDK5wRcKpz51pg
         EbC3OQ2JNUMtJuaB/zmnRKtrnpJZ9BmYR8PHFUA9Q7wFIws8BF3TwvsighOgFjN1tKGu
         oDDAv6Vsi6R3icX/plyGk5BQEY0b0y5QIs80iSnm7TvnjKZ+LGdX+Y3ZOfKDm0Bptk11
         XtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785418310; x=1786023110;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wxa9hLaozLeU8kbclIzUv6BtOuJqfwfUIAKrXcFIxqc=;
        b=oBh1WyE/22FWS/2Xaf3mg/67vmszdLX7l+2/10Qpa6cRlpH7nvZeHX6K2UQ6XdKLV4
         62kV5I/6iERUBT5dOl0DUVso6z44aMLx0Pon4cXCDiB1Ej3ctmYFC7KNB1fegIiY9StO
         4Oog/K0QiAAB4YVwDyuldRtsUnHk1IyPYbuLutNBtS9rT96gcc6Nb8nSZffABaUh8gmX
         8YOF13XL+RFWSYtMrarpcE5/Wbg5mRvP000+8/CUTLwRa8jcMybiXNObVqywXsrmfrcq
         HEy4VtYa4ZigwP9LGhL2NJlJX+indQCVBoM/nwp/clxop+CzKgcC+pXKqugXaNVB8pKm
         NLxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRVr+TAenk3MqvRCpxotdEHvHCSbL/GfPq8ELTqfcgQVx81DYN6SsvLrQ+rp8KL5Jrb8ZbXAFLr084pQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9KVkGFyICdYclxPaV+ZvogWRYoMp0wW+s6tubKq2dtLyenkBn
	77IbJtuUnBlBvrYuLEjw1K/F8hNZNyFVzdKB9MVInYc8HZEHT2Sn4YEikc92qvXT11nevj4CcrD
	OeGz3d0w3z6Hk7JooJV/EnYmE571o3DtRxbhK
X-Gm-Gg: AR+sD12TzD+Pm01/rKBGYDnGpZvaJNzXorzYLnRoqLwzJc9tgVCYLa1vaoA9JDwvpWK
	KgkZRkYvG/rgjTzWT319kvgjXOkV3oKA4DPZV+L9YaRpNnSYshsQ+In0tuj/viBoKGYx/gi48nr
	QQJoWdoL418/psz22lUGuZAiUIemqdtj6rWY5+rC3FGtKvjkFy46RSfLspxEB9oiCajo6M2w0Il
	E1xgkpL9sO/yYIprK5XFdoj+Pmlq+E4VZqeMApCKQlRX/Wz8A5CTNyP7AEqGiOmOtnAgpn4x3T7
	TMIiOOf27e0J2A4Y4znl/Y2ciutP9E7kxgU0JttVULKw2w==
X-Received: by 2002:a05:6512:108d:b0:5aa:8822:c946 with SMTP id
 2adb3069b0e04-5b2db37ec16mr526593e87.48.1785418309865; Thu, 30 Jul 2026
 06:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730120105.2746192-1-wangjianjian3@huawei.com> <20260730120105.2746192-2-wangjianjian3@huawei.com>
In-Reply-To: <20260730120105.2746192-2-wangjianjian3@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 30 Jul 2026 22:31:33 +0900
X-Gm-Features: AUfX_mz3jbH-xWt2-d9XAV2j4KM9zXgbDDsTxMf-VIW4E_MHKy9b8WtNf9AnPLk
Message-ID: <CAKFNMo=_QiAVYgqCggCqVBBwC4F+g4cOWgS=Nt=AAghda48gAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] nilfs: check new inode's nlink when rename
To: Wang Jianjian <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 9:32=E2=80=AFPM Wang Jianjian wrote:
>
> When rename, if new inode exists, then its nlink must not be zero.
>
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> ---
>  fs/nilfs2/namei.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index e2fe95de3d71..db171789a316 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -397,6 +397,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
>                 struct folio *new_folio;
>                 struct nilfs_dir_entry *new_de;
>
> +               if (new_inode->i_nlink =3D=3D 0) {
> +                       err =3D -EFSCORRUPTED;
> +                       goto out_dir;
> +               }
> +
>                 err =3D -ENOTEMPTY;
>                 if (old_is_dir && !nilfs_empty_dir(new_inode))
>                         goto out_dir;
> --
> 2.34.1
>

Wang Jianjian, regarding this patch - much like the previous one - is
this fix related to a Syzbot report?

If so, could you please include the appropriate Reported-by and Closes tags=
?

Also, please ensure that the filesystem name in the patch title is
"nilfs2" rather than "nilfs" (kernel patch title prefixes generally
follow the filesystem name, nilfs2).

As for the patch itself: rather than using a stopgap measure to check
i_nlink inside nilfs_rename, could you investigate the root cause of
the inconsistency? If there is a flaw in the checks when reading the
disk inode or a race condition involving link count handling, that is
what should be resolved.

Additionally, you are returning -EFSCORRUPTED for filesystem
corruption, but nilfs2 does not yet utilize this return code.
Following the established implementation pattern, when filesystem
corruption is detected, you should report it via nilfs_error() (which
logs an error message) and return -EIO (while I agree we should
eventually switch to -EFSCORRUPTED across the board, doing so here in
isolation would create inconsistency).

Thanks,
Ryusuke Konishi
