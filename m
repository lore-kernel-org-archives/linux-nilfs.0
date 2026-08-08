Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3E30DD2F
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 23:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786233082; cv=pass; b=WTtwj+9xlcuvSEwDTEWySFpfxF5XOdu578jQcNXOXc9sBP7TEEo7sVbqk8MAoxWq37f1qqfD5I5hR1Sb5a9Ik1wtmH6j5uiMJLglDZ9R8jSHHKQR7lSb3uICSkSvWSYkA4IM5rnh9LSE89WZTJD27W6GsAMEAriBq7fiW9g0Aws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786233082; c=relaxed/simple;
	bh=X/4GL697DIpdRLh2JolYFh0Xvpfh0iDY1+pv9hSlcss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U56hgeP1UvxT5FH51wDjTfwSCTw+imRr6k9lO0FbPkJLQ5hwDnJQPjFNCVKGFsF4y/PhwDOpSi8oI+qnBoZ3t/ImPQon8AGKlxdiWyobXZeRQig5wH06zAhbGxCVGhhBfFcoX9VVJO5tQBsEvQXWlmZiLX7lnHZAsE0QU/MeT4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sh8KaKSW; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sh8KaKSW"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39f9d4bed90so26228231fa.0
        for <linux-nilfs@vger.kernel.org>; Sat, 08 Aug 2026 16:51:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786233079; cv=none;
        d=google.com; s=arc-20260327;
        b=SA+uDhNEw+R5C/1bKk3DRRflzXIuPiv8d3KYo5XsAMrlgS8u+uCpLFdRz+qch0JTc5
         ZhvCmnPUojjbQJhrZFZDG/NNRCmRaU8LDRzZJnNeN3zpLiUPLDeIWgk6DRvCEXGJ6Xec
         q9XpOErrNC/p17ubByFCvAawhVQI/oTd24o45WK5M1xWrvj8hsOAATlDtGKJRyfxJFMo
         4RRiAsVAQCsNyM6qO1eip5PQ26lmqUaediAcL7IWhycKiHF/jBjyX0TwEVnDf9FAE8+k
         yHv29Wlxq7smIMbM0PXAjXc1XKtFZfCLWdWK2cvFOTDYDLQ0s4v6GS8FtUhOX6f3A5Uo
         9dFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0EI/7cdTrv+pUiQdbGaU4idt8hz2XXFh5kbiSCgsyCQ=;
        fh=k2c64mmI9tc2FbLivCq/smIU/WlszcCB1iH0LKwxAJ4=;
        b=puMybWHeXsKJ0PCrFmXW0Dtkk00R/5Zt+6RxtsBR9HXpzFY2hdV05csimoWqJN1zV0
         xN+6nmL+toRNV3TbvKoUSFFtIWABZG1nYQV7o2YdJ/dXUjiEK849XANky6zjm4YZ+C8U
         8M3w6j4AWbOVl9VB69RRdZXZ6FpWWiVgoYan+o6PfOvSz3yOGVuLf7O83YN9yK3cFN75
         fAdRYXKkr6efPyG2YwZJl98u3s7JskZrj1cxSrQLMASWMVP2Fp6jo53A+kA553xeGv5z
         Y6SP4NW2RDQBgSvlBVeRxGP5wLZ4hLxWVRMoeiaIrAajCkKeLPwZ6CQXXElfxe7Bff8n
         qGKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786233079; x=1786837879; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0EI/7cdTrv+pUiQdbGaU4idt8hz2XXFh5kbiSCgsyCQ=;
        b=sh8KaKSWQCVETf+JqFd3hYxiU1b/Nw+u+4RpAMCM/0Iomd0/kbJw9Db4QNPyRqISPz
         c2rTGDga8w68t9H6kxCD6wRqPW+Eqin88t2d8OL5a/SoyxXRMoOEL/4fM0rOuKddCRD0
         VIUTeVIN2Qp/e+C8ii9rj2SGfeixBecCVSRXvLkPWFuwSgn4AjSDL1Q8C9BH6D89fJ7L
         UnTIq9D7b7Jo2butvnC5L/dzpsBvbW5e7U0PyvIDoQ/u44m+9979Yox/54AJtv/jyXrV
         jpjItNLsRVIBuXFatujVhDxif/r1qEePABItkRUS59UJg+k/SWpouBeNlvozXENzye73
         BB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786233079; x=1786837879;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0EI/7cdTrv+pUiQdbGaU4idt8hz2XXFh5kbiSCgsyCQ=;
        b=D6L+y9PV+noPPOSDbUfR/eMdYil8D/k6fxVbWRingOkASqv7hRjxFPqgeVVQAZ2nsY
         styBkxI/wOFLT+988A0HqBayBHrwMErCRsSItf/opBclzxSzAVmU6Wt+GDRkD1JMW5xH
         PSVRcdoFsTP1E7t9UojvZE9ihdMFtd+vaeSMkubvFa5c5ygNqq2pr9ciG+a3KP2amylk
         uYJ/IXxXrk6S1BX1FErUcmCp8uouKANjQ6fRcCOAPj8kexYXskp/cfR454pm7Gne6RXK
         xv0iGRteYS6aljZTpiI6uWHOHyZggcrxF+5g2M+z11p+qFClq6Li4jkpuWoQ+eaQyqcV
         oDJw==
X-Forwarded-Encrypted: i=1; AHgh+RpALtBmobLq/S+JId1RAi11N/lujB1zfL0Jibe4qgtWqI7iTTyqXm1vN6h5HrumBrlWE6rin1SwXcQAJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhqOuiYD8b04PMnvvT4BeKNW5fEGfCCQsXymMb68hyItDmialK
	ZtXvhrSHiTVll1BJsjOXEpmPWrn6kJMPciIF4iVjKihPdFIE/KyIjqxfFgSRjZwg6uRNugj681P
	UFkI/Kw6kJYDhW65hO94NvmGxXZ3ibz4=
X-Gm-Gg: AR+sD107XWL0jUkt0Xs4I8ILzD70NCtrCrBF0kMc0DzxQVHbpaXybUg2wQno35AydJp
	NyAOoJDK+BJzyPLFGOQ6ho2iUn/gv/Hpo9DeBYcxuHB3gAci3gVvUzh4aH6z3+802loJE9o+wGn
	C1QFb0y/9F+Q8qrTyE1RH++FA9kWFFjAbodCSOp2oFwHCTQoBrCnW9lW4C731Goxa6ttOu9bj5/
	HbDd24BfSGzpOLDEsVd3363jSndCDPr/UVbUEDIZ5wWnfN7eNSGz/KFYmaFGpA0/z9q6hu2gnAp
	aNuMfK6tdz2sDm7wl0ozSy64pv/q1h1MuDZcmgP501Divw==
X-Received: by 2002:a05:651c:150a:b0:39a:c1dd:5399 with SMTP id
 38308e7fff4ca-39fe8461201mr11982351fa.7.1786233078738; Sat, 08 Aug 2026
 16:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808003523.2760509-1-slava@dubeyko.com> <20260808003523.2760509-3-slava@dubeyko.com>
In-Reply-To: <20260808003523.2760509-3-slava@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 9 Aug 2026 08:51:01 +0900
X-Gm-Features: AUfX_mwvQ3IKbHIJ3MMQqTH9pNa9TgYyTxYyCM0XMxMS9Y8cSH8SIlDIbLcdMLg
Message-ID: <CAKFNMokwaRf7e1yzYBNAxpHhvMZCsEzeqc8L066OaJRfS4b4zQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: switch O_DIRECT to iomap based operations
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: hch@lst.de, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	lilinmao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Sat, Aug 8, 2026 at 9:35=E2=80=AFAM Viacheslav Dubeyko wrote:
...
> +static ssize_t nilfs_file_read_iter(struct kiocb *iocb, struct iov_iter =
*to)
> +{
> +       if (iocb->ki_flags & IOCB_DIRECT) {
> +               return iomap_dio_rw(iocb, to, &nilfs_iomap_ops,
> +                                   NULL, 0, NULL, 0);
> +       } else
> +               return generic_file_read_iter(iocb, to);
> +}

Among the tests that used to pass before the iomap conversion, I found that
running xfstests generic/418 and generic/465 now fails with a "broken bmap"
error, causing the filesystem to remount read-only.

This happens because iomap_dio_rw() is called without holding the shared
inode lock.  To prevent this race, I think iomap_dio_rw() should be
protected as follows:

        struct inode *inode =3D file_inode(iocb->ki_filp);
        ssize_t ret;

        if (iocb->ki_flags & IOCB_DIRECT) {
                inode_lock_shared(inode);
                ret =3D iomap_dio_rw(iocb, to, &nilfs_iomap_ops,
                                NULL, 0, NULL, 0);
                inode_unlock_shared(inode);
        } else {
                ret =3D generic_file_read_iter(iocb, to);
        }

        return ret;

Adding this locking resolved the failures in both generic/418 and
generic/465 in my tests.

> +
> +static ssize_t nilfs_file_write_iter(struct kiocb *iocb, struct iov_iter=
 *from)
> +{
> +       /*
> +        * NILFS2 cannot perform true direct I/O writes: new blocks are
> +        * delay-allocated and are only given a real disk address when
> +        * the segment constructor writes them out as part of a log,
> +        * which works directly on buffer_head lists rather than
> +        * through iomap. Fall back to the ordinary buffered write path
> +        * for O_DIRECT writes.
> +        */

Also, regarding this comment, following Christoph's suggestion, how
about simplifying it as follows?

        /*
         * NILFS2 lacks direct I/O write support; fall back to buffered wri=
tes.
         */

Thanks,
Ryusuke Konishi
