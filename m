Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A7D13790B
	for <linux-nilfs@vger.kernel.org>; Fri, 16 May 2025 06:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375759; cv=none; b=vBUSRl/LkI1u4X8UpldLxQGQaXAiw6F45mnJpESR9eUnImQ/wRp4IvywntIKmrZaVTgLxN+2vKlYdzF3hBMgp2D8b/svSp/QHSuMNHoyTAhbmc9iqj5FuuQUUxjl5qFKMMPiyGGlR7Gkud1FpQklOoeVeaIdoq8zhTV/A7/y74g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375759; c=relaxed/simple;
	bh=4Cany9qcmFKGhCbyfDyNt3RZ/8bFXM95R40klqLngMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r5WkQ2/oO2gtftBIchKMuKMRvnR8r4xum5dIDqfQCsY8xAvGlwnNA6kP3QGnN1hhgW8NgLFqCzSxgQVvrMPrwJ+6ctWCmWZKgQ0RsChTOOFaID0vosagvMImF72WgY3gN4vRmfgrolcDHIw+QIL1cKAqc54rA+t2YpdN37DXoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8spAMYg; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8spAMYg"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-327fa3cece6so17446481fa.3
        for <linux-nilfs@vger.kernel.org>; Thu, 15 May 2025 23:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747375755; x=1747980555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/hDlIc4ETq4HtLLHnbra49PG4YD/5wj0OT+OfXpZBw=;
        b=g8spAMYgTJ7WeVnJX0cE0+guO+X0Y+ZLwTeC/vHaMxcRDTcGFb8d9y59Ww1TxHVTov
         8H+yz7BJEkNapdiMCW6gI5d32zhu0SgH7cndpeKHsjWGOvijZOgVpscqhG22otQnS8Pm
         4FBjIWnTEnLAqy1xU8+l3mA2zmvAmSSsus0LRAsBni7tOqr9Rx3OIJhYtI3FhnTQn5yi
         gu2l9m56NxOVUAA10CQWyfvAoTb1LWtp3s9hbGP5lfmjeSxPtXZVwlE+3hvBpn9fsCz6
         nf0GL3PmCG8fCJci5PEiZFbnoOglv3fP+/lzvQKZArM3oSv6CnJIBaGUPYdrqjl9vsls
         vWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747375755; x=1747980555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/hDlIc4ETq4HtLLHnbra49PG4YD/5wj0OT+OfXpZBw=;
        b=vwygZel1yEQCwy0z2C3l/MYgu9kXfehGQI99MF7XIljiFTIvAQ/qIRxvsxHIB/VLGw
         3J/KjH+foEfxrAvcbFPVv/spnBu2sIns8Uja6D5nUJ73WDIX6USbtdVeMrOnRy4eknUz
         /rRn4tjeJtCpZdObJPrXfW9vd5hIMZlysCdAwG2JIy4jiWJvL75/Nyq6WNNe5cFaFlsb
         kjXwYceaia1/4lYQIFcEodSiyDD8qZ0hxYh6SNAA+lwiCT4hzXCb68z4RLeug2Pg9bDU
         fiugOEm8iw7kDMto7i5kMAJMGefj4d/McIPj3a5+yKX+hzxXN0ZmkjdXpE/kNcgaSwzs
         /vGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvNEIoqoqzMz7/CFf4o/pipOdleIXpKaVCe0TgyLR8lxqTD1HTmTcQyvYurvDQ7xUsXSpEHpXpOkNvEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/vTSbr/iYHHSVX197clFmpHSziTt9jG6StkYosr/KxrPXcOx
	Cm5hDXj+uaAcf2b++imrXCFLsVygm7fNXnhjEtrfOmx8FeThZ5faMwD5YRLJLP2DenJh0mzUaWJ
	2uNhvpjItRWjVFPQUMX3a5a/kotdCNZk=
X-Gm-Gg: ASbGncscJpztwi9cYXPB+mRUTuKI5yBhIWRuDcZy3YZQQ8FEUhj97bXdja2VN7/M4vM
	+5C2HmNo2IvLVZNpDhMM0fnWtO98paQM26RjyHUkrjGvAvj8AYugbArA8QLPKtGjrlgUw/vMEes
	8xAjGAVU4h3iyyRSYZXzZPmtYNif2L3UN+Jg2ReAssjImVkArZaIatv5gjIRBVRJL3SFk=
X-Google-Smtp-Source: AGHT+IGcmXu3d8t8FS/tEk8LenT1vcX5ZlB9u18SZBMBrccRyktbtn24erjavYk2zO6MEMudjGKRFXTCp9yyVy6Q+8A=
X-Received: by 2002:a05:651c:f0a:b0:30b:ed8c:b1e7 with SMTP id
 38308e7fff4ca-32807728eb8mr5658721fa.18.1747375755082; Thu, 15 May 2025
 23:09:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508054938.15894-1-hch@lst.de> <20250508054938.15894-7-hch@lst.de>
 <CAKFNMo=nQ7e99ubGmB_9myjSmHxmUJ+XEoknRGF=fMuzJZMPNg@mail.gmail.com> <20250516045554.GA13127@lst.de>
In-Reply-To: <20250516045554.GA13127@lst.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 16 May 2025 15:08:58 +0900
X-Gm-Features: AX0GCFt2x2Fwummb7z57skDQHhhT200qWHD8tF73obiHcgvN7QkN1-8aPnQlTRw
Message-ID: <CAKFNMokf7ZnArq74+pxWdqQnT2_Do8K=MGO5nW7NwQ70n0VhwQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] nilfs2: remove wbc->for_reclaim handling
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 1:55=E2=80=AFPM Christoph Hellwig wrote:
>
> On Fri, May 09, 2025 at 01:16:36AM +0900, Ryusuke Konishi wrote:
> > > Since commit 013a07052a1a ("nilfs2: convert metadata aops from writep=
age
> > > to writepages"), nilfs_mdt_write_folio can't be called from reclaim
> > > context any more.  Remove the code keyed of the wbc->for_rename flag,
> > > which is now only set for writing out swap or shmem pages inside the
> > > swap code, but never passed to file systems.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Yes, the parts removed in this patch look like dead code now.
> >
> > So far, no issues have been detected with the previous conversion, but
> > even if it turns out that something has changed in that conversion and
> > needs to be fixed, I have no objection to this cleanup.  Feel free to
> > add:
>
> Can you queue this up in the nilfs2 tree as it's independent of the
> previous patches in the series, and the last one can't go in until
> all dependencies have been merged anyway?

All right, I'll handle this patch so it can go into the next merge
window separately (though it will go through the -mm tree anyway).

Regards,
Ryusuke Konishi
