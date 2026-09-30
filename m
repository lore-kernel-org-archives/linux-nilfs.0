Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D434DE717
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 12:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772832; cv=pass; b=W0DRIxMjlFLc3SikJITEtq3W8JV8T684pjSx2UwJyUmWLC9n5mR4lGPBtgX0EFxBHlJrXlsMH2nbDqTyardrE1tbaP/ozeQ7omxiaFin+lUgW+LPWnr0IdNoasHamPPg3s5Hxin41Dfyv68SVwQiGdN3VzzRTxRcDk/8wtMpio0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772832; c=relaxed/simple;
	bh=HtRYA/oIx1HZyxPQEdtvE7C5ErCCXkfBilzfxi70F8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAZeUAZFW/pzBcTYBLbDgTKfOMXjd8aJrNGMSHDm6DwBoXhOXFjLItE/K9bmNY8YMMd5+tcjvDMki43cHxihLACYXXxpVYYJJeqsY3gwnc6QVUtOumM/Ne/3de8o2WN1fIHheVGrUlTQQOgGKkUZEFM7Gx/l+q13V5opyVJ6Mis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GmHvy0pU; arc=pass smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GmHvy0pU"
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-881d9da69b1so1283718b3a.0
        for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 05:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790772813; cv=none;
        d=google.com; s=arc-20260327;
        b=sigoDGvwnDb1kfpdPkI2ryBmspib6IOHVmEM6Gq/IYjVvVzQKx7nFLY1COnQcPvvbS
         gIcJ6QmpbVyUJ3lbi0pGB80iKLEBrsnY/Nqd4OOEFofASCgkA+rsVnYYpSjCQDckxUO9
         ZL/pljKk4w8c2oMXX8yMdqASpKJR3Imx4Yb2dpaVakcFelpta5FjLqvg0FfVA+xeayIQ
         YXZGnZ2OFt/ZqY5oRhwEuLxqLY+xlSv1NrFSG6vyzZcjQPQ0On+SH9JmmS3Iq/QIyssB
         TkF2budjpgpELP9hv5bNBKgaQxK4b25Fn3uiJ8xVO5EgzUF5TV4w+coTfalixxMF19l1
         CXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3r2op7ustej8Hq87+A4jSKMFiZmknu+8/Rwrib1XfR0=;
        fh=hrA1YNV5e97FwkDtWAikycnjIGlAmVt+TUXuUNPwyNg=;
        b=dUt6RuUwwnVVw25noPJbyz9+Na2xriZJqFlGMVgLQHxPZWXpa57JexpT6OWGAiy/xN
         acaoS+/UOJl6tFLhagKqxMQdgqxI0kqlo6psZtQz+6QVK5GowytNNAR1Dhsjg6OiwKky
         B5aXwTMll9w9Ce2l807l/8oru3lIPjt2fLhY4fapCN0onAp/jzzjGIPI52sJz31HfFHo
         ki/JRy7Wfq5461z83rmZuoDryZLQnRAi5ANWqeUznb2vTISHATPc0Z6GnaCDGtj5++1R
         bgJY/6I9MvCXyuuwFETcRptmpstyUBQUtZT6z3waMCm+4SmF2ewzsxkE+2GPZ+HyF/wP
         BEOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790772813; x=1791377613; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3r2op7ustej8Hq87+A4jSKMFiZmknu+8/Rwrib1XfR0=;
        b=GmHvy0pU2k81tlDca4jDmT+iuZVT2vFdbmdcnMsKnEp0ayHC2hTrDnvIVdNTLO9NwA
         A2M0Ee96ZJYAoPA+44iCYGgUxCLuzWVu+A8HMcwGhKdtlmsYYpKI41snHZHy6HMREGP7
         UYvspUU5qLIU0IJUw+niqdXiUmv8zUEj7+qWdJ2hQb6bW1NhwHvmqP6kmhUJDZiXg1xT
         UByQvOqmGXQvQMQUMy1knKl28VIK5mzOcSkAwrvXYHaJAE/5xts0y8g9PyHyl2kGftE5
         8bBA8LZiSRwQXk8xdJISjbh2L1LKwFtp9WEji97UJbR/VQBZZXJH9XiWNP4+AUSBmV5M
         7tUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790772813; x=1791377613;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3r2op7ustej8Hq87+A4jSKMFiZmknu+8/Rwrib1XfR0=;
        b=fHYZPpPlkKMOaf77P6jskDOoNtYnjPTvnZQJf1e+WuYnC4EHm0D0wboHv1/qoh2jGB
         hA2kwSR+f03b3oiWqEmXbsgTknXb6qf4G17erEkM7gEcWwvjii/17uCjHFKnbYc1ICwZ
         /9+1Rl+dDpqs5AP2ufN7AsJgSw6++0YrAmlBpUYhlA5IUbdk+ULF6mmxFk/DlqI66F6G
         3IATVVUxvwaR4N3yfX6fwGyNddRQkKNwP7fd5jti4clGyrxqEp/OVfZjihNi4WE0KIsP
         FHxAyqHq2pRgmNgpFihZy74W08KX6KerMq3FmN3bILo1BqsoabTrOEOuhWaIT7kU5xfw
         DFoA==
X-Forwarded-Encrypted: i=1; AKwUvBwsQNzqKsF+W6VaDT9oyJ2r4AjjjGXm7ej55rVVv8OQDOTQ+RGdYRCi4xaS8OUhrGSnUJE/ddm4BrdAxg==@vger.kernel.org
X-Gm-Message-State: AFuF++nTnAA46lRBRMDm+2gWYOhCUMSPwY6e/sQPUYFdX+V5N7BS+tEY
	KkeQrPPtv0IGjP15IOrpVIQpX+j6QgUm36w+fg55/eb3y+w8u3sY1+35MxS+FsOtR+6pCTU9zDf
	ChKHmM24uiVhLrpRyGl61cOCoJm7/wlc=
X-Gm-Gg: AYBFou1LvMMbSYqUQIErvwTpso/MREvShbz5p4csKlaNYdn+wiraEObeqfznBnH2aqP
	f9qGfUvB5YehQVDR/zxup9YXKgC+Fx5qq8nnASdCfPZ9l2X6YLjqYW5YHAy922isQZg9JLf3l8e
	yCK4im46ReYUMi65BERCif0TznAW6Z9hQzf3WJU4mW1NyVw8jFe5G9frBjfYJvmBxJ8HMbEeyL3
	yP1CHep2gu43aXYfYm39kIHp4rNzUqoxQEqjKRCYvEgaHxJve3rtiCcpn0CR/2op3LYWw9SwkDN
	5xk1lRaSoNExXhQgP4SSPUyS7YWTfhCLNBtfq/fnbL8FWAFIqCYIOlGnZLI8sJJrDls=
X-Received: by 2002:a05:6a00:1c9c:b0:84e:909:ac03 with SMTP id
 d2e1a72fcca58-8874be0efa2mr954145b3a.10.1790772812901; Wed, 30 Sep 2026
 05:53:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com> <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
In-Reply-To: <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 30 Sep 2026 21:53:11 +0900
X-Gm-Features: AclHuK9iKpcox0wF2tWtnN9se_xMgeGzwMlGkHWlEThdT0amhytrF9npSbMsCdo
Message-ID: <CAKFNMonrWx8cftPWFYHwEcttezFqPpbycA9=y8mXaMcoQ2jKpg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] nilfs2: harden dsync recovery and readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 9:10=E2=80=AFAM Jake Labelle wrote:
>
> Hi Ryusuke,
>
> Sorry for the late reply, busy getting the flu =F0=9F=98=84. I've put you=
r
> review comments from v1 into the changes below.
>
> While reviewing fs/nilfs2 I found two robustness issues with corrupted
> (or malformed) filesystem images, both dating back to the initial merge
> of nilfs2:
>
> Patch 1: roll-forward recovery replays dsync logs without checking that
> the designated inode is one of the types that actually have a bmap. A
> log entry naming some other inode type leads nilfs_get_block() to an
> uninitialized bmap and an indirect call through uninitialized memory.
> With the patch, mount of such an image fails cleanly with -EINVAL.
>
> Patch 2: nilfs_readdir() parses the directory folio at whatever offset
> llseek left in ctx->pos, without snapping it onto an entry boundary the
> way ext2's ext2_validate_entry() does.  dir_emit() can then emit bytes
> from a bogus entry, reading past the end of the folio.
>
> Both patches were tested against current mainline (arm64): each issue
> reproduces before and is resolved after, and a mount/list/create/write/
> fsync/remount/read-back pass shows normal operation unaffected.  This
> was initially reported through security@kernel.org; per Greg K.H. and
> Ryusuke Konishi it is being resubmitted here for normal public review.
> Reproducers (small Python scripts that generate the images) are
> available on request.
>
> These patches were developed with AI assistance (Anthropic Claude) and
> manually reviewed and tested.
>
> Changes in v2 (per Ryusuke Konishi's review of v1):
> - Patch 1: also accept S_ISDIR/S_ISLNK (not just S_ISREG), wrap the
>   check in likely(), return -EINVAL instead of -EIO.
> - Patch 2: hoist nilfs_chunk_size(inode) into a local chunk_size
>   variable; expanded the comment on why chunk-aligned offsets are
>   already trustworthy without a chain walk.

Hi Jake,

Thank you for sending the v2 patch set.  I hope you are recovering
well from the flu and that I didn't push you too hard.

Both patches now look good to me, so I will run tests locally and aim
to forward them upstream as soon as possible.

Regarding the offset check derived from the pos field of struct
dir_context in nilfs_readdir(), I somehow confused records with chunks
during the initial review and gave you an incorrect comment.  My
apologies for that.
As you reinforced in the comment, your first patch proposal was also correc=
t.

Thanks,
Ryusuke Konishi


>
> Jake Labelle (2):
>   nilfs2: reject non-regular inodes in dsync recovery
>   nilfs2: validate directory position after llseek in readdir
>
>  fs/nilfs2/dir.c      | 33 +++++++++++++++++++++++++++++++++
>  fs/nilfs2/recovery.c | 17 +++++++++++++++++
>  2 files changed, 50 insertions(+)
>
> --
> 2.43.0
>
