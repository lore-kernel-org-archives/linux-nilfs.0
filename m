Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77A1917EB;
	Wed,  6 Nov 2024 06:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730874120; cv=none; b=EvHziiimYY40wCciRd1VNtdUiE7Yknemtf25QkRWc6oOHDgh9mO2JTUunVsmEO+k2FZMRlCD+cHZj+TS3AKmpFYcUkRenB0EisXjBOheGtTrib5a4D1R5BOHOH4zrjKE088623PY57oZtViMM0jeqmP6LitY447MwBYznKsew5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730874120; c=relaxed/simple;
	bh=O/cUlyYRf4qBVOAkAVveGj+vqGwayVw5xDMV6YK9F28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCisbjWzj3LAnLmbZla+TBG7zDgb5xOmJ0OiX3cxFsQoaiRI3S4FcNWyd0DeADgheshs7pTTzVvRcFJo7xwv0/xOKwjGF1AVyU2gbNfPyurii/NZDjuzlIuv2Lf51UTLnVs/1bIl5MJ29c2Sna3NOntCq8pQX5/012xCPOu3TBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dlgup1Rs; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dlgup1Rs"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f4d8ef66so7767972e87.1;
        Tue, 05 Nov 2024 22:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730874116; x=1731478916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4RejKctGhgr2tUM2Ujce98Zo87UHbuwdHrfsjVKA58=;
        b=dlgup1RsY9pXYmhWSxskpLMAGmZGAjOfKHrbc3kLKWzgoy/f4v3sdn1+tZB+uBdKiu
         gc6mgzlVT9cAgmTtdegctlmPRzW3Wx7Wr/LXX34WoNRhdBlIhU4C+u2VVXUlE4V3sLis
         +JwwkkkzlRAcCURqVnOTrdwCjU/Ob4n6Dce9oTDvhTTD7pyxE+IN8WQ+6y+S6LrdixJv
         QlYLpaWoh98SrY3pvz8XvMjLxoggurGdTr3VNpmd0vBCYT4iT5AKaEvy4CTHlmeL9NOX
         bcyMXv3hPZKmI3T1dpyJtDxx4uWO3k0GxKp4eWeRRohvfcbJTaq4MalV8q1p53UnZeFc
         H+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730874116; x=1731478916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4RejKctGhgr2tUM2Ujce98Zo87UHbuwdHrfsjVKA58=;
        b=aae6B3ILV/4hvGUvzV1sEDR/NEed3E5+iviGk1p5fbKGvGWLoI4vb4D7LX5Zr9U+Yh
         /KRJwdB63ThNYDVBmocVU8khbvOeA+qaQ8eyYtVSUPahCtTmjzVhoY/vFUjqJnuVNGQr
         En+DvLpfB/QxBJ9oGg7upXgwnG7X/u3ii3Uq1V5SR2RtdaW7c1neyuqnqZb4uW/Mr2Zf
         Z9XhfHKrTHUeWnhO9iZkkPvlrQQcSKJc/3LHs2ryTHlcwzaggV0qZL2Mp958ceTT4CTM
         lxpbfVFe5dgXHSP7e2tP4jpDJke58AqZyS1aj63yvWKhgG5sTYowdpv8B4038agExNTP
         O7cg==
X-Forwarded-Encrypted: i=1; AJvYcCVBHugM2KQw/pvo1hkt+JgwCYj17HQIHM0FY3msD2Kiyx0nJBjwNCwaKw//t4Raa7I4w3cV9r9qzQ9qSuQ=@vger.kernel.org, AJvYcCW4ppNVbfYD9EDO7+rph3xkE4iVdtYwQf4aoRw092NokJpRUcg4Xodwje+G/iEXOmifOBmJysYoZ6CI1s8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbvAmlnejfUDVQ5JjRdNUko9oXujagVsbtLdGPRGwMn2GLytFl
	Dd59dtlQRzh3iAaLScQRCaqZUhmG/VlTdtflRykOYklnAEykgGGDN8h6iqve5mLFIIVW7vOwdOV
	ZsgUDleaxt/yv5/nNtE3/+H6Dq9c=
X-Google-Smtp-Source: AGHT+IEvKh+Sp7Huza/Zh9EGZQqBXB7TIVxq/oSWi8PtymfsjZO3rCvDcFIcAP7GwILu2ZplO+I2GPPor53N/xj2yP4=
X-Received: by 2002:a05:6512:2c85:b0:53c:7377:3338 with SMTP id
 2adb3069b0e04-53c73773415mr11432621e87.36.1730874116102; Tue, 05 Nov 2024
 22:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106020945.172057-1-sashal@kernel.org>
In-Reply-To: <20241106020945.172057-1-sashal@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 6 Nov 2024 15:21:39 +0900
Message-ID: <CAKFNMomd0cxe-hP0CoNH7ERvrPCDhz22sRs=8086-j3H=OqOxg@mail.gmail.com>
Subject: Re: FAILED: Patch "nilfs2: fix kernel bug due to missing clearing of
 checked flag" failed to apply to v6.6-stable tree
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com, 
	Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sasha

About 6 hours ago, I posted an adjusted patch to the list (and to
Greg) that allows for backporting of this patch to 6.6-stable and
earlier.

The patch is titled  "[PATCH 4.19 5.4 5.10 5.15 6.1 6.6] nilfs2: fix
kernel bug due to missing clearing of checked flag".

(or https://lkml.kernel.org/r/20241105235654.15044-1-konishi.ryusuke@gmail.=
com )

Normally, Greg would pick up the adjusted patch and apply it, and it
would be backported without any problems, but if the backport of the
adjusted patch I requested has been rejected, I would like to ask for
your confirmation.

If it is a misunderstanding, I will wait for Greg's work, but is the
process different from usual?

Thank you in advance.

Ryusuke Konishi

On Wed, Nov 6, 2024 at 11:09=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> The patch below does not apply to the v6.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> Thanks,
> Sasha
>
> ------------------ original commit in Linus's tree ------------------
>
> From 41e192ad2779cae0102879612dfe46726e4396aa Mon Sep 17 00:00:00 2001
> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Date: Fri, 18 Oct 2024 04:33:10 +0900
> Subject: [PATCH] nilfs2: fix kernel bug due to missing clearing of checke=
d
>  flag
>
> Syzbot reported that in directory operations after nilfs2 detects
> filesystem corruption and degrades to read-only,
> __block_write_begin_int(), which is called to prepare block writes, may
> fail the BUG_ON check for accesses exceeding the folio/page size,
> triggering a kernel bug.
>
> This was found to be because the "checked" flag of a page/folio was not
> cleared when it was discarded by nilfs2's own routine, which causes the
> sanity check of directory entries to be skipped when the directory
> page/folio is reloaded.  So, fix that.
>
> This was necessary when the use of nilfs2's own page discard routine was
> applied to more than just metadata files.
>
> Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gma=
il.com
> Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after re=
mount in RO mode because of driver's internal error or metadata corruption"=
)
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd6ca2daf692c7a82f959
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/nilfs2/page.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 5436eb0424bd1..10def4b559956 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -401,6 +401,7 @@ void nilfs_clear_folio_dirty(struct folio *folio)
>
>         folio_clear_uptodate(folio);
>         folio_clear_mappedtodisk(folio);
> +       folio_clear_checked(folio);
>
>         head =3D folio_buffers(folio);
>         if (head) {
> --
> 2.43.0
>
>
>
>
