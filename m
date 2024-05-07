Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4A178C76;
	Tue,  7 May 2024 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715121923; cv=none; b=QzSv10iTAE5YTKKFmt9MF9ZggyvIfVoNMem0jonhfRlB+J0NG5IF1Jh/KDs7nDcXG4wnyoi5dTEj9LLMqXDu7D2+74EjiJup/ZWOD6YTVzhgivGlEvoysHzUSQI5pY3Jz48h/lHwmQgj21s5wG0jT6LSgD0JYdB9GxsrntSb+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715121923; c=relaxed/simple;
	bh=M6riJ2RRhLGhU3DFdXzMp1Z3chjKGRnYMD/q5uAIeMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h/buw4qUUPC+uIHgm+rLhq0XU3ht3eMQUyM84IRcvzs/wzDVYxPq4c26S6TuwZoRys/DvnH84iTd4OT0Yg3KBwnm8cJtB3UGkwBOwPLGx2i7NscmONrqmhRjkX4plMeKrbyA85f2TRCM4Sqw19TzPewUl865gdtiJKbAM9UJRyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=haC7J+wa; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haC7J+wa"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-51f1e8eaee5so207960e87.1;
        Tue, 07 May 2024 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715121920; x=1715726720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDN/+D4jbee8PODvmNc8vVasbCqf3e+IVaTnWie3dK4=;
        b=haC7J+waqTiA5WISMiu+Z04DbxGrIkBb5nu4GbEezJBAvnzVGwvYHJqW0xCy4R0qN5
         5M9yj4Aoyy55VxeCrIZviMGvKE+Dszt14TPxw8qFqFQbVZQrsAEtCNl6BBJAJD9dmA64
         NoukIZn7HbVayG8Ed8lXYjRJP4T3zlvEmD1KJDev2bPszZZI4ByXqtEDVFYiZL37v1/L
         rm9pKnIiWtsaLb7oTE6qSIE/t/BPxYbPfL3S34DHD74Jzk050H50FuIHBnN2claILGv2
         r/eIGs+v4tEZW2s0YD7ipx/ghtko1dD1s7AC0x3JFbooCrhYG9Rr0vYpezD2yBbvw1Ug
         n8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715121920; x=1715726720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDN/+D4jbee8PODvmNc8vVasbCqf3e+IVaTnWie3dK4=;
        b=S4o/hVSFlbAqBkHJSNgXAl6mBJyymEWOCCvaN6icGRu289VnrkAPfwKoplSkrmyH6x
         J1FlarT/UHqzJ97Z+tHLpj/KDS2VVDymOJgnBKGgtLVDKnZ1bm8oqyZQIgRUN/jn6jib
         egBIWN3SCdZ8S1fHKTrW5nnI1WwQyUwXcMUD9WTb798wbcqCRQCZnVJ17KhbqPc0Ul8o
         0hMahgiTFRSQb2VDcB3XmDBWwXS0v7XY0Xb2hiCTdIO/6j0JqEouhJxX+AEYsQIk8mhS
         FSA2MBMuRxAwiYiMsokxLeal+iqQ9gVrZ03TAGRwvo1jYaA6X7zs3FtI8Pw32OzDD30Q
         oFlQ==
X-Forwarded-Encrypted: i=1; AJvYcCURjOWmKxw5onlLX6QbOOguQiqNlwaO/N+eJx4rgLO3vcrBcrkCKEVG1YjtE0hOd8+Y/iKpR5oQSiZ6dtzcGrNxEzeAw63wfIRS+/ne
X-Gm-Message-State: AOJu0YzgIuUx48lGUYQuPp20kUF1bailNVDGGYJQJ17tHtdS9YiogOU2
	Fh5vVYQXp5vOR6IGL8Q5VnSCzd8ks1rfK7Qn3xuryhGDJEwJGfGFoVnWvd/AVXW7mp41GIGvz1/
	qFuA/IzgviIfH9jb5sP8TZhlSWbc=
X-Google-Smtp-Source: AGHT+IEl/j9hZBClES3NvfVHBWJUZPsWsAWfCAB4XPxGVeEHl6mWKApGMuYq3CW7CTtLoBAHB9593NeNhdLbenEgIas=
X-Received: by 2002:ac2:4c85:0:b0:520:19de:c6f4 with SMTP id
 2adb3069b0e04-5217581943amr267325e87.19.1715121919362; Tue, 07 May 2024
 15:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507-nilfs_btree_convert_and_insert-kdoc-v1-1-bab3514eb753@quicinc.com>
In-Reply-To: <20240507-nilfs_btree_convert_and_insert-kdoc-v1-1-bab3514eb753@quicinc.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 8 May 2024 07:45:03 +0900
Message-ID: <CAKFNMomG+GuKJ53WmdWFONtimhbanKU-B_ZTdt5sEFxcuYxJ3w@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix nilfs_btree_commit_convert_and_insert() kernel-doc
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 7:23=E2=80=AFAM Jeff Johnson wrote:
>
> Fix the following reported by make W=3D1:
>
> fs/nilfs2/btree.c:1871: warning: Function parameter or struct member 'btr=
ee' not described in 'nilfs_btree_convert_and_insert'
> fs/nilfs2/btree.c:1871: warning: Excess function parameter 'bmap' descrip=
tion in 'nilfs_btree_convert_and_insert'
>
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  fs/nilfs2/btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 65659fa0372e..8299839b5129 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1858,7 +1858,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_=
bmap *btree,
>
>  /**
>   * nilfs_btree_convert_and_insert -
> - * @bmap:
> + * @btree: bmap struct of btree
>   * @key:
>   * @ptr:
>   * @keys:
>
> ---
> base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
> change-id: 20240507-nilfs_btree_convert_and_insert-kdoc-7753c4a6e7c3
>

Hi Jeff, thank you for posting.

However, a fix for this kernel-doc warnings is already queued in the
mm tree (to be merged in the next merge window).

Please refer to the patch below:

https://lkml.kernel.org/r/20240410075629.3441-3-konishi.ryusuke@gmail.com
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=3Dmm-=
nonmm-stable&id=3D3da9b9650acc3a2a0c3d3f4542b93d4abe9da1de


Thanks,
Ryusuke Konishi
