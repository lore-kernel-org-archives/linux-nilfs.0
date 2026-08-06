Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14FE306744
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Aug 2026 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021651; cv=pass; b=YGpPeD165uPnetZbNAfKYMxBrJ8px4SKAEZNK+adTV9dYXFMYAd3hyxCb7PNE0l7fFj9Zcp/jg05SyPVWuhWyWoT8Mp13FsWoShsd3WOSuHHc6D8mc65UIoU+GFifBlsscSHD8TQ1ywm0HnuS0aNYqjTTZGXht8iH80PBY+uqfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021651; c=relaxed/simple;
	bh=TKhVWuVVWY+Xpecn36OkiAhDAE36ztzEO4wgmkmXS8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AI0N5CjriKkI8TjXOXMTJxZ798O+WY8/UqWSBJnHhrsjHEmzyslghO+n3fjGU5iu7cmeAkYcrEhO/py7uOp8Xwb/G0RaIF8e9qGPBamMcadOUZvYiVQfBdOXHsil0+HhRPfZrQT5ZjS1P9aY9/RaGgTBIqtLoh+zPLvV5+KMFVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLBjpEA8; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLBjpEA8"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39f75e0a2f1so15472791fa.2
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Aug 2026 06:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786021647; cv=none;
        d=google.com; s=arc-20260327;
        b=rcM513DYh0xsv2zkCD5ocyrjgZyD7X87a7fFiyZ4wg9WvOFEUpRouSW7or6JsZObw0
         j4+aeko6d/KHBMHdK4QwXbqrrXtDmhem49Pz5FImYevVb0ZcAhMmp+TE/ToHih0HKzPs
         /Xgc4PW2xiBoJ14zggmvljLbS7xDmAFChSfd6Ow1nQgrgZUa8RMumWeyMZrf0jkWDFca
         O3/Qeomrz44W8IaqpUg44S8U4xz+OdlHuTmtnCN+LMZH74gSOu1KmrHTnOezkfUkj7cY
         Q5Dsa2WpuzVGpmhnrPDECjw9AsroBbLkDXp91MIohflsdxIWvyyBYSi8xhOR0YZQrD6n
         JoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z0hCT/tlHD7+9Kwz58DUmWiCJrv9s8Ys7lkrWYkYo0M=;
        fh=tA6ur8DNHdNL/xaxJZstORR9nEl87pqhX6ac1BkMZ/w=;
        b=N1Fg0D9eJ20akSYWaI+bigwCg1zdFIuHN0SfgoL0YPJEIfGYdLhsBEhpxgx9gwJBmw
         L55C9BL7ptyAqcQWg9k+ZvyHJ1tfRz7/iQubiNwmPwz9a0GTdIhrmbA8k1gYSbcfVDgk
         nb1dMntQ+D7LvWc2r1MQRfhYZu/E5dKaxJCN5fjCHDRb6ytVwmn96zSTzT/Euq59hct/
         MNSx51DLeyFUjHBak25WrdmyKXcxaub1uWkle7tBeetCVXNqR/IEkIw4pRakC8RH3j9u
         S4zO1XktQrhtZbdGUpOJVF0NweGmAlcly6QSdt6Yyw789sLig4Uq+puxJleqnIDTFA3h
         nXwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786021647; x=1786626447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z0hCT/tlHD7+9Kwz58DUmWiCJrv9s8Ys7lkrWYkYo0M=;
        b=aLBjpEA81JcR9gJWfcK0ezD/uwWGb+Cxc282MnlR5C62Nws4iC8A0eDfdiKiafBnSK
         kpOXgXF/kAudb5MaG5XUgiB9foVlBh7y3wH78w8fLnzi7irm3Tc2KhqXi4kBofhFUw9h
         yhia0g3mTqLAuwEW1nBiOfcceAVSSN2PU1Yk6YMwLM+dgwVkR3E6oMTF6dxRVrsii6Ta
         3j6AzsdTG2uzdrE/5fBWxDicn+mKxg18jwuMLnWorYP5K1vsm98Y8rMTycIj3hCwy5U7
         uqqgHmmZSE2zZmoTnUMmjGlImyk1t/qLK9houdkX0ORn1R6TL2o01LMH0rjX93d2hydD
         +UsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786021647; x=1786626447;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z0hCT/tlHD7+9Kwz58DUmWiCJrv9s8Ys7lkrWYkYo0M=;
        b=T46rRxqxkAuMRfvY08LesF77gIK59wcilWpCvQr02Ds/MDCzYLEpr5YNFVMl3BRN7X
         G0HpkK/jpe3EcjRrv75iNLf6RVOcNlflv5+ZlCzmsCByAhV14wShanny3WCyQvQdRVHC
         R3ShvrV42P778nY+W+4jSdqUZxkyPmF26CPCiugEsha35VRwDBTWqN4GrSzwtGlP79mq
         xftNwAfbdTIuy3p5+ff/f2Xy2AOXqAKX7e3/nt5ZrKZv4+FMvLjDRoj6mhN87nAnq94a
         JzvoVTb/kVAol5wRz4hqiG0ZEIR08YJtkT83AA9UYeSlMP1ZBSea+AUXhCcv/xVJstNv
         n3Aw==
X-Forwarded-Encrypted: i=1; AHgh+RpO3htvo0ylIWmswI+AmaZLxe9tZwGXZ6vyV0ikKmPth8QF/UmwojDv9CpMQNfRqMLWzsKRG9a/eTpdlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdNxoG+5gOTbNaSKHcgAAKTaFGyeGIPYhNplK6zESrEJ9QL7j0
	IFbzPADIn64GWl0+Mb1oFypeBJKDSuA7o2+C5TRHRKz+N8leG+NJ8uKY8I2niGOGqlzi8CytwT7
	TPdYcC14D1+JVAhsxda+FMYcH8KV+EoY=
X-Gm-Gg: AR+sD13/Q+LXv3uSNehp7w96+r8mWbFjDEPVLgy1Vue8BpC+JEr01v4TKl+5VhxySV+
	Ka9x2O+UyawS3SSLWDjccQNK75Ujh/YG2UVC+e9K+/15xRh3e51ehNjkGrTcQ96N1MLjGWF3Uu6
	jgYro+0nfhQRUvN2P++GGtWPiKaFNzd+StoVWBxbeQqcoaZiU7MTWCOtc3yxE/QKUkXLeOPHYow
	TBn+Xb5510Hdp7328/+jOHDeQncmCezIuvvq9CqnKU6t4QVOWzrpQx8u9HZBC0ohr80Ajl/EjIt
	sCeOKNRUnKd1qFJQVU9ZVCvIybaQmrb6N/5T/onNq/pSiQ==
X-Received: by 2002:a05:651c:a38d:20b0:39e:ed52:cfdf with SMTP id
 38308e7fff4ca-39fbb26b25emr13425871fa.20.1786021647237; Thu, 06 Aug 2026
 06:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806090311.32633-1-konishi.ryusuke@gmail.com> <20260806125841.966577-1-zhanxusheng@xiaomi.com>
In-Reply-To: <20260806125841.966577-1-zhanxusheng@xiaomi.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 6 Aug 2026 22:07:10 +0900
X-Gm-Features: AUfX_mz4yQ1jCOdsk4UQ_x_Zj6IVXbjcB1iym85pmec5RKGcRuUACEsT-Ah81ww
Message-ID: <CAKFNMont6edvb=_Rw-XwYU0krYVDgg+UzeVz2JR_azGFhrfq=w@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: suppress false positive WARN_ONs for sufile after
 an FS error
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	syzbot+5957361606d7b750b874@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 9:58=E2=80=AFPM Zhan Xusheng wrote:
>
> On Thu,  6 Aug 2026 18:02:00 +0900 Ryusuke Konishi wrote:
> > +#define nilfs_sufile_warn_on_error(sufile, err)              \
> > +     ({                                              \
> > +             int _err =3D (err);                       \
> > +                                                     \
> > +             if (unlikely(_err))                     \
> > +                     _err =3D WARN_ONCE(!sb_rdonly((sufile)->i_sb),   =
 \
> > +                             "unexpected sufile error %d\n", _err) ? \
> > +                             -EIO : -EROFS;          \
> > +             unlikely(_err);                         \
> > +     })
>
> The warning-suppression itself looks right to me: WARN_ONCE(!sb_rdonly)
> only fires when the fs has not degraded to read-only, so the false
> positives from the log writer go away.
>
> But I think the value the macro evaluates to is not what the kernel-doc
> above describes. The last statement is unlikely(_err), and unlikely(x)
> expands to __builtin_expect(!!(x), 0), so the statement expression
> evaluates to !!(_err), i.e. 0 or 1, not _err.  So the macro returns:
>
>         err =3D=3D 0        -> 0
>         not read-only   -> 1   (documented as -EIO)
>         read-only       -> 1   (documented as -EROFS)
>
> For the WARN_ON() replacements that discard the return value this does
> not matter.  But nilfs_segctor_truncate_segments() consumes it as an
> error code:
>
>         ret =3D nilfs_sufile_warn_on_error(
>                 sufile, nilfs_sufile_free(sufile, segbuf->sb_nextnum));
>         if (ret && err !=3D -EROFS)
>                 err =3D ret;
>         ...
>         return err;
>
> so it stores 1 rather than -EIO/-EROFS, nilfs_segctor_collect() then
> returns 1, and the "err !=3D -EROFS" preference cannot distinguish the tw=
o
> codes.  That seems to contradict both the kernel-doc and the intent to
> "return the error code appropriately".
>
> Wouldn't ending the macro with plain
>
>                 _err;
>
> do what's intended?  The branch hint is already provided by the
> if (unlikely(_err)) above.

Thanks for pointing that out, Zhan Xusheng!

You are absolutely right; it was just a simple mistake on my part.
I'll make the correction and submit a v2 patch.

Thanks,
Ryusuke Konishi
