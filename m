Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD701803E;
	Sun, 11 Aug 2024 19:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723405315; cv=none; b=kZmxAtLxQFfrhe5UJIth8gYHL9TSj2XsaN3TiFfbvalP1sJqJOCsDFFxIOzyVqhMmyp+qU+b7v6ZX43Adah0dNbh8xUnRi+xyXLOHdNoueUVv+aoq439YhXu0gjdYIMNa5hwKeyTluRsikHZzOt/W63jyZmGU7eqkfqmhzDwhy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723405315; c=relaxed/simple;
	bh=YyQd/yA86a2aU6mq6hOdKt6lyRtO14DZQVwjCPI74I8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U9iHQROJ4ZQ1l5CgdxBb1oI2hKYH0kQ2gg/H4Nz6sJC3adZKDkJpFDCrHSnxdqvh0XcA/I4+iaTRkIwHgxcbW/2lJeOu2Nrpeif4/++P0CzbYSE/hxokb1GcqRfH7OpZVwG1jmRaN3pYpIqqK+JwWwzHgPlI2mxIYBi/H3HVqOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaJGlbXJ; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaJGlbXJ"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-530e2548dfdso3758807e87.1;
        Sun, 11 Aug 2024 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723405312; x=1724010112; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14/7lz43ghojpFaVsYu905V4R9qFCjIVkgYPqIp9GLE=;
        b=eaJGlbXJ+6Y3gfRwrvr4qvPWP8GZS+qnKHACwFXmUJrTEvJFgVKj9uiDv1OIUG8xTZ
         DTqi2qJcCxsTACYDbAqeCXJaJIo6SJFc5dm6xeRFa3+ABuvHa2FAtVWxo0YH2Kkcln0/
         oihZoVVzvQgMBKst3QABWAnx3QJuw+6rjiwwUSLnvyrysL1smPTSIuyazlf+Jk3+O7th
         rSZgE9eHSVdVdW8tjsO9leZNdqpz1KeBkkGxCg3p2LieiIm3q9TTkO7LQbkZIs3XRJ8Z
         COXEkPuCQoW+jOiYCs/xQOamSBfqHSE2vgkUvE4oaFFHAN4JqErE49cGxCAiWYMCIvfs
         Ybew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723405312; x=1724010112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14/7lz43ghojpFaVsYu905V4R9qFCjIVkgYPqIp9GLE=;
        b=n90DMGxV0ubP8ea16YLz3/rct+B/TmfPk3kR6WXwl8Kz0z/WtkAejJn/m6E7cDfdhi
         RXRAQuiK0EFo/DEDOpCz+3d9Fzp/OKubfg0rHkdg/PxZzEIm8d7cr68cUU6akOulysy8
         y50rzuZqB1z9KkOQo6N96a+/rBUdC0TouuE4KMCIQsk2tx60ZnzK2JwAuvOnY+UfQpN6
         oe7UiT3b0fAS3lFbP9wohKl8u1cULkGeRCVfyGUix7Y1jodTsv23+sY+EJ7gfEvqobe/
         6wnsrrpoqXqG5tuMcAwu3b3dOXGqqG12wOpR6hs0R38ZUCFHl376kFbacf46WirZl2Nd
         +P/A==
X-Forwarded-Encrypted: i=1; AJvYcCVVeGqioY6wFk9UKyLmntgydPAi3ZoI7wZWJgheo46LJVrtS4X6anBUedYG6mVXY+obsxIut6Qcf8+TcQ+6IBl/F3yS4CQ/A2sC58hB
X-Gm-Message-State: AOJu0YwNF4nq+3JpLPBucS0ZblLIsJD5ce+yyzWXqk3e6TUxhYkW4F0j
	Psk5UDtuUGbM85OBY/Dlt/B53cvUt19rg4hajMLPed+4lFtzyaTCFakXDMKrMOJnWq1AV5Y+XcY
	ND3x5x906U7w51o0GEczy/Ft9yiCdCOVB
X-Google-Smtp-Source: AGHT+IHG1A/8PQZEOXPP2N8wBlJRy3/YRr/GCA+ScfvLOZReFEmVn/Z3uOCFmATrorjThuefzry+F3onEIm+iVcIMlM=
X-Received: by 2002:a05:6512:2346:b0:52f:368:5018 with SMTP id
 2adb3069b0e04-530ee9dcad6mr5392121e87.43.1723405311574; Sun, 11 Aug 2024
 12:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807230742.11151-1-konishi.ryusuke@gmail.com>
In-Reply-To: <20240807230742.11151-1-konishi.ryusuke@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 12 Aug 2024 04:41:35 +0900
Message-ID: <CAKFNMomFfeeXmeATyG2jARXqvodms+P89TPmcxF70MWdPz2_wA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix state management in error path of log writing function
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 8:07=E2=80=AFAM Ryusuke Konishi wrote:
>
> After commit a694291a6211 ("nilfs2: separate wait function from
> nilfs_segctor_write") was applied, the log writing function
> nilfs_segctor_do_construct() was able to issue I/O requests
> continuously even if user data blocks were split into multiple logs
> across segments, but two potential flaws were introduced in its error
> handling.
>
> First, if nilfs_segctor_begin_construction() fails while creating the
> second or subsequent logs, the log writing function returns without
> calling nilfs_segctor_abort_construction(), so the writeback flag set
> on pages/folios will remain uncleared.  This causes page cache
> operations to hang waiting for the writeback flag.  For example,
> truncate_inode_pages_final(), which is called via nilfs_evict_inode()
> when an inode is evicted from memory, will hang.
>
> Second, the NILFS_I_COLLECTED flag set on normal inodes remain
> uncleared.  As a result, if the next log write involves checkpoint
> creation, that's fine, but if a partial log write is performed that
> does not, inodes with NILFS_I_COLLECTED set are erroneously removed
> from the "sc_dirty_files" list, and their data and b-tree blocks may
> not be written to the device, corrupting the block mapping.
>
> Fix these issues by correcting the jump destination of the error
> branch in nilfs_segctor_do_construct() and the condition for calling
> nilfs_redirty_inodes(), which clears the NILFS_I_COLLECTED flag.
>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_w=
rite")
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> Hi Andrew, please apply this as a bug fix.
>
> This fixes error path flaws of the log writing function that was
> discovered during error injection testing, which could lead to a hang
> due to the writeback flag not being cleared on folios, and potential
> filesystem corruption due to missing blocks in the log after an error.
>
> Thanks,
> Ryusuke Konishi

Andrew, please stop sending this patch upstream.

I found a problem with changing the error path in this patch in
another error injection test, so I would like to create a revised
version.

The other two bug fix patches I have sent will not be affected.

Thanks,
Ryusuke Konishi

>
>  fs/nilfs2/segment.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 0ca3110d6386..8b3225bd08ed 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2056,7 +2056,7 @@ static int nilfs_segctor_do_construct(struct nilfs_=
sc_info *sci, int mode)
>
>                 err =3D nilfs_segctor_begin_construction(sci, nilfs);
>                 if (unlikely(err))
> -                       goto out;
> +                       goto failed;
>
>                 /* Update time stamp */
>                 sci->sc_seg_ctime =3D ktime_get_real_seconds();
> @@ -2120,10 +2120,9 @@ static int nilfs_segctor_do_construct(struct nilfs=
_sc_info *sci, int mode)
>         return err;
>
>   failed_to_write:
> -       if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
> -               nilfs_redirty_inodes(&sci->sc_dirty_files);
> -
>   failed:
> +       if (mode =3D=3D SC_LSEG_SR && nilfs_sc_cstage_get(sci) >=3D NILFS=
_ST_IFILE)
> +               nilfs_redirty_inodes(&sci->sc_dirty_files);
>         if (nilfs_doing_gc())
>                 nilfs_redirty_inodes(&sci->sc_gc_inodes);
>         nilfs_segctor_abort_construction(sci, nilfs, err);
> --
> 2.34.1
>
