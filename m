Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F7745FFAE
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776126; cv=pass; b=lYxHbqs6VBSQGNvrvr5I2sim/iOBAEVn+zFEqRqRBVLoFby6o1YOmhEgO9mxIZe5LkjvpN5muTZhWmACk/iqnIT8f+iRiwdcBn350BLHI/mLS0nCH9RLWlxtz4FcBf92LMKqkDVudToCoNv+k1JbiYpRjZEoIxHs679jY7w/oXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776126; c=relaxed/simple;
	bh=aBJqGufNUoE0R6bKvEMkvxToFMJ37x5PGcKhppcZNvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qL+sVY8agpsQjE++zq7AcWgtMoJFQirQ2Rk3cdVkFWhhIqMGgCmRD/q0rcdB23J53UK8wTe0KSNXq3rIWtKOUrFqSHSMViMxlgwPTL6hkjizx6Ml/E9vYNYLIekmK37w7/T9edHSxgm+Xl0ZCVLrwoEwLwaCHIQeRQgM1BPYkn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agZesLFC; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agZesLFC"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so29312655e9.1
        for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 06:48:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790776113; cv=none;
        d=google.com; s=arc-20260327;
        b=LjFS2z5y+WfwF9I37PIMvChTPk82r3MxLcXp4n/x9zKy15+cag6M7qiYuLuTAy6t3q
         JFEtQ9hoKj948PmxzhCZyrk9HKQ3/Z4qD4VO+AQs9+fQ3gQMDUca9ls1sb3IdIyrjxbD
         M0c2TQOHuT6gCGrNbPQT3a+xlS+2/IwTFpusJkKZDnZ6DvklYBR0w+lTSt5ROc4w/7HO
         6mWnB+nPLlt50d1hKLUg66ESWMjiBsrDlsfxjoH8UbO1j2RmCa+dD7DxCiwB8Q5h272l
         rCojKfKaM16wn1d9IcROo2kw1JIZQv2zObX3VIw0AzLNO6wMxws8ljhfm8xCUfaVoG3F
         NMxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JdtFMWnWznZsGOHKKkEJy9kEs/307y3dMWBkVyyDNMo=;
        fh=c7mAChRPZonYWi9wzDaKs9oLBviuRHIk/UvOnCOLI8Y=;
        b=NA5oTtBfMLoeqsN+NOYQLXbafLM2C7nZEQnrirUUvCO6pt8MUTvsTEtGjaFPNSebPd
         W/DLZc+1VsZhrlHEQ1DgzZLGREh48MwGzvdqKEUC2wjQpCBjxpS5NaVuHiK9DAue+3cw
         B3osVoCkaiswLT+RfFrKlLI3loA+imUKvk0lcrKv04czwmSA0QY458TxtJ9nGWnlibiF
         Xaqcruy0mGTmS0KJnUC1gxoBk/mYH36vNu5ZaJ7NVjPj2Ne3uizZI/iSA7c3/64dEfuD
         5VrfoQpPoxUndkmYhxQk8xndE1poM53wPuSTa6i7yU6+jbGZTH2G1ttviJka5w/WDD9s
         qj2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790776113; x=1791380913; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JdtFMWnWznZsGOHKKkEJy9kEs/307y3dMWBkVyyDNMo=;
        b=agZesLFClbJdlM9yDk7WkPV24ybaWIv1M23Ru6bLoLmh0pwKaahtrlu1lvh4IcWnYT
         VqUsvTcqKFIN7VqZyQs0BDBgsw8rQRhHfRwvbw04F7fx1VJ71dtcksQh5TZ37R6t/lPL
         FIvSACu6lf9JRQ6bUwMB4NUIO+RLmi1/b015R4Fi6fOAcTVMZ/JfU+tr+naLrxL21SUG
         BUmJohluYIp+COJZykJw6afAkuSRlOy+BQzYkuSPxn20YJNRx3yDgk0j6mXD0FKK81Jy
         HsPXfzRIGNH8GBFfhoLN3Dczw2X/JYDFWwO0KvSa9/Vc9WF/g8+o5dQT1dDQ/dtCeSO/
         FTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790776113; x=1791380913;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JdtFMWnWznZsGOHKKkEJy9kEs/307y3dMWBkVyyDNMo=;
        b=H2/ceJGggKwcHyayvVLGIJ+VCs4WoaNxiN23MJvLIa/uYB9daagF0n2fT2FFisNHRc
         E2jQmrGzFuY4bLU56pEmLYJ043CvXxL5wyUVATulB1+t/ew4toh1UPGLtViGHhe37jyn
         dfV6xwSlUz17Hq0k4jLwbqXqeias9ymqGXqJn3dPetlp8du33Y8wR5/URpN3wCrCh0M5
         Q4O+Ex846DthEqVdVWuqMAxj/fC9jVJeq7KVDCRvpUEvYQyoDjE2wDQsOgyjFlGPfFDz
         F8oZ+HmUZivwLAmZR2a8qQOaAZW4i44gKD1xbjdszjQRE8BZLKR2NlcOLos+8MRVSlF+
         ILyg==
X-Forwarded-Encrypted: i=1; AKwUvByF9bde8+t11kyYcYAzp6jSDMSUspWsbEWfgAu6SwzW3mAvx17U2shbfNcf9pSH08+xETSoXh2egvCMNg==@vger.kernel.org
X-Gm-Message-State: AFuF++k0rr8BoQ6y73Ne56IK+N+mFPiEjv4AjspxkOev5Wrn1lwMDQ6p
	z43hlpeemZZFl5FS+r63skKr7B5e/9YsPiirADP2f1j3EqPMjdWtVsm6QUgWRCW3m41tGGvgw/g
	9Tq78KhfAGiV1rIYAUQ51mHEVHGWMjGp1jxSPGc0=
X-Gm-Gg: AYBFou0osBbKoGtNNi85fxoDLKQvv27DUfCs9OKu8M1LvtoVdfDhxY9lCGppIc+Tbu7
	NVlXdywf/2V5mBUU5OAYiSQIEllW9mOg9ZFZtcM2Swmso56bsFE5fchDa/2BEkAVJVY/gKbYeX2
	KiWEXyROwPmbR3gIXxop8Paon6bhtyUJzgwySeoSVQoG3zYt7sQUupAMRszTdQY2M8Z70eCRNSR
	BH1jsnSEV0VK3Y1xfG92N0R+sx/fo1kVtX5xOjA+r8PDn/MdaTS1qTfvfsObFXOilD3b1QaC/F3
	4jBAgvYg31JthkoEdySVQLyIIeYJEbnMmKCl5jEpgJeRZkOQ7EuanlsAfGarA5cjyGo=
X-Received: by 2002:a05:600c:46d0:b0:4a0:5b:7bc0 with SMTP id
 5b1f17b1804b1-4a01afe758cmr26943195e9.21.1790776113249; Wed, 30 Sep 2026
 06:48:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com> <CAKFNMonrWx8cftPWFYHwEcttezFqPpbycA9=y8mXaMcoQ2jKpg@mail.gmail.com>
In-Reply-To: <CAKFNMonrWx8cftPWFYHwEcttezFqPpbycA9=y8mXaMcoQ2jKpg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 30 Sep 2026 22:48:15 +0900
X-Gm-Features: AclHuK-S_rGPswZrDv3Y9l2fN-0gIQSw25cSdNJYPrl2fsxqCDoq1U_KGUQm3L0
Message-ID: <CAKFNMondJQ62PTc1E9MGTjVDU+N1nLGKVTHQkKFEHf8vB7+FBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] nilfs2: harden dsync recovery and readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 9:53=E2=80=AFPM Ryusuke Konishi wrote:
>
> On Wed, Sep 30, 2026 at 9:10=E2=80=AFAM Jake Labelle wrote:
> >
> > Hi Ryusuke,
> >
> > Sorry for the late reply, busy getting the flu =F0=9F=98=84. I've put y=
our
> > review comments from v1 into the changes below.
> >
> > While reviewing fs/nilfs2 I found two robustness issues with corrupted
> > (or malformed) filesystem images, both dating back to the initial merge
> > of nilfs2:
> >
> > Patch 1: roll-forward recovery replays dsync logs without checking that
> > the designated inode is one of the types that actually have a bmap. A
> > log entry naming some other inode type leads nilfs_get_block() to an
> > uninitialized bmap and an indirect call through uninitialized memory.
> > With the patch, mount of such an image fails cleanly with -EINVAL.
> >
> > Patch 2: nilfs_readdir() parses the directory folio at whatever offset
> > llseek left in ctx->pos, without snapping it onto an entry boundary the
> > way ext2's ext2_validate_entry() does.  dir_emit() can then emit bytes
> > from a bogus entry, reading past the end of the folio.
> >
> > Both patches were tested against current mainline (arm64): each issue
> > reproduces before and is resolved after, and a mount/list/create/write/
> > fsync/remount/read-back pass shows normal operation unaffected.  This
> > was initially reported through security@kernel.org; per Greg K.H. and
> > Ryusuke Konishi it is being resubmitted here for normal public review.
> > Reproducers (small Python scripts that generate the images) are
> > available on request.
> >
> > These patches were developed with AI assistance (Anthropic Claude) and
> > manually reviewed and tested.
> >
> > Changes in v2 (per Ryusuke Konishi's review of v1):
> > - Patch 1: also accept S_ISDIR/S_ISLNK (not just S_ISREG), wrap the
> >   check in likely(), return -EINVAL instead of -EIO.
> > - Patch 2: hoist nilfs_chunk_size(inode) into a local chunk_size
> >   variable; expanded the comment on why chunk-aligned offsets are
> >   already trustworthy without a chain walk.
>
> Hi Jake,
>
> Thank you for sending the v2 patch set.  I hope you are recovering
> well from the flu and that I didn't push you too hard.
>
> Both patches now look good to me, so I will run tests locally and aim
> to forward them upstream as soon as possible.
>
> Regarding the offset check derived from the pos field of struct
> dir_context in nilfs_readdir(), I somehow confused records with chunks
> during the initial review and gave you an incorrect comment.  My
> apologies for that.
> As you reinforced in the comment, your first patch proposal was also corr=
ect.
>
> Thanks,
> Ryusuke Konishi

Hi Jake,

One small request regarding the patch metadata.

Both patches carry the following tag:

  Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>

However, since AI tools are not recognized as legal or copyright
authors, the "Assisted-by:" tag should be used instead of
"Co-Authored-By:".  Please refer to
Documentation/process/coding-assistants.rst for details.

You don't need to resend the patches for this, but could you let us
know the tag string you would like to use formatted for the
"Assisted-by:" tag?

Example:
  Assisted-by: Claude:claude-mythos-5

Thanks,
Ryusuke Konishi
