Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FAE15B971
	for <linux-nilfs@vger.kernel.org>; Mon, 16 Feb 2026 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771236157; cv=pass; b=UWxNEaPvBIzilh/SXBnS143ESIStZWHfMCbHbo/fdyUZpHNSSmeAMaIS1DXHBEewVvKeFuHzKTpeWGEEBOPmI8BM0DhhcxVfVsNU4Q3eWMFI95aZwquXa1k+0dSbAGuBfykhyQ5NPhUZR7M7SqCQdcX7IwOiBgoAnfU4WiaT5XU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771236157; c=relaxed/simple;
	bh=PP2ug3+ToD9NwcQFoGliHhs1xYjn97rQMrUocmTRDA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gSsSieEo/DzbvicZEfNIUItWo07pPP+pMkASUQVwBJEfXdQUQkeF8Z2UKsmG5NSJiqhCqbZb6gkt+nniPFb8j9BffOZY1D+jHO4pw65xgLN0gEM0lKqvXL7vCXnCrr3ia41iWOg0jtExzoEAf8jQ3kKTiBe80Hmrj/Evs6IUUAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NKbP6BSd; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKbP6BSd"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59e5ea93a1aso2483065e87.1
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Feb 2026 02:02:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771236154; cv=none;
        d=google.com; s=arc-20240605;
        b=OnJ/2IK+nhaVyD2Y77NH5vaDwAYvW8q4YUkxU8LlE5lq0DkVtY7PDw2nAlQx6snjze
         T4tR8DuDiFWtgj9axgpXjFBYGqCGPdPgALv0AzxenyvhxP3BqFyNw9pI94fGzqCiXv6g
         mWuAbagJw8TawCuok8UwtgnuFAXLiNwOttWu/s5HnD6FjZ2BWaqMMD7B6q1yH10OI8Hh
         5eDkMM9qrsTITptL4qqgTQCSZsaruBg3ZBzdSUnec2wIipEmhMtYaLeeTBB6PedMb0oO
         WA9G6iVFP1kmGfkoAqUmcRlV8MKwo1J24cd51jAD/Po8arMJA+8sCvC63WqVdP0pKH6u
         Awrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sDGjYeKXKvxlN/G34NJHTNTXSITum5R8GbL5eHEkWxo=;
        fh=rCj3LUeI6dOlppbnVWiqkB1KRFTA5iJgdLMdt5oNaNw=;
        b=kcpfpQE0SQ37Dko8LL8hb89J4dIV+wzjG5q8bvOehEYd8CD3zDAIIx9yf/tGeuIHTu
         E/dOP25aox4OnSDReSvSVQ/DLCJU8TwINncX68fSb40Yet1jw+qX1FCC69tdzByYyhbu
         zqyGf+4EUXriBANEqOZlJaQ/sCqZXCCXU2YrfUMIoqnD2Jx6PSA8ixVBO5bYm3E3IFa3
         LT9xkjLyi0wJ55KIUVM/TQWpE2d4NKxytexnNfFXfHCLRMH8CPrm3bAT1Kh+pawdNhTK
         QaSvlUOBwHWtdiCpu3+2xfTg/HiGV7zmooldHca8STIJPnqXGsVxKFR+t5jZ17ncmN+6
         qsZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771236154; x=1771840954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDGjYeKXKvxlN/G34NJHTNTXSITum5R8GbL5eHEkWxo=;
        b=NKbP6BSdTUmsRZjG2IivyhQ+0UYZ4LpzNfcbBro68iq5obdZFQ2QAEA+utuqzoTXy1
         rLmdn1xKZVkiVvIXCgES/SbzAB+NYZOIVeksZN49fAguaxhg8umHSIyneHxsiXtYapmb
         ah1nStNwpPqVadtjvol3RBh1/2g+M2E9FteyfZjRp6I9sov4MgNK19co0vaAGqzzJgXq
         nmRVpKEemX9fSQ43QfcxdTE+DxsmfEPW4Jy61magnDjncvw6aQ9K8yUMa0iC7Y/Asd2x
         2EsWwOu5onZnbNK1k9ebyg48vLCW0luyI4ZjYPHM2fN+/emkKP/pqHJO3Hv1xXrvNDr3
         OsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771236154; x=1771840954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sDGjYeKXKvxlN/G34NJHTNTXSITum5R8GbL5eHEkWxo=;
        b=srqWX3GmuMEUsw32ZBxNvJu7zV2olzZ5zSstEcRfmYQ52Gnkd3t0Oniq1poJDD8jwO
         qcTJjQ0dfDS3kZdt51SkWXUcuGvUvPJBgvoV3zhuBDIZz3lnV9PW9tB/yuj/6E0DvtrP
         mr21UYpqoKLT4zT+y1zRE6LO+PoxNO6Gby+/u/9Um+eRHqZVKn2yOvoYyKeeOHb53tCi
         mggoP0rhx7xyjqZC2JAIXe0gd2WyA/0lIs8Rleozfc8NYUj+R00PzTQQniDlK/TGKv5z
         KFwjjl0m6LmJ48H2kAtjYq7dlqIfRjnFJuP6/3i05SHJKWTBSEdDRKzl5jj4moyWfmvN
         8LgA==
X-Gm-Message-State: AOJu0Yz7PjkWMIf3LIJrWErgNoZ3YfHgMMgucOTN7750agQNUty3CBXD
	njOivImgDtNnvUgexfjeLrexNoZF3ZU8+5P3gKV9DY5bTWYoFKw+n6kSzt2VcFfGEr4bXVaXHVI
	flDutEaD8ViM7tAuRCjK/v8PtAWfNNHk=
X-Gm-Gg: AZuq6aIdZ7IFQbLz0Gh0rUhbF/hTBPCJMmLWicymGq0qysOO2EtXi2diOVcO5PL+fcH
	RxZK+W/H7TT2f4HOcqVpDq8FBW51gMAvlBTUdFKG1kaX8Xqy6D6NkaTmxaulWIZhxO9BrPrXcjN
	CZyd3SPorK2bYNzRDfbtuRYMC7nQ9uhNGXgMFtM6nFau1U+ktyF4nXy4qqxwWfSPF1BXyAiY2Up
	OdvIAa9bYxzWH01ZOSPuYORDgFKiKrDbqC/TzSrskpRPEFllOqq6Q7zDdf5lwVNjv1CFGctpGTL
	FZfrM2oOzz4FnG6SF8o=
X-Received: by 2002:a05:6512:3b9c:b0:59e:4d28:b16f with SMTP id
 2adb3069b0e04-59f6d358bfdmr1984962e87.20.1771236153737; Mon, 16 Feb 2026
 02:02:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260216092446.5596-2-ytohnuki@amazon.com>
In-Reply-To: <20260216092446.5596-2-ytohnuki@amazon.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 16 Feb 2026 19:02:17 +0900
X-Gm-Features: AaiRm50WXeIbFecBCKWbnqN9Rt-6_yW3z7fCoDmosAsfexOo13wJ74JNWU3gPBo
Message-ID: <CAKFNMomoo0CbBXZg1v59XU=3Yp+RkagkOk7DWaghzAWeFNvbnw@mail.gmail.com>
Subject: Re: [PATCH RESEND] nilfs2: fix i_xattr comment to note it is unused
To: Yuto Ohnuki <ytohnuki@amazon.com>, Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2026 at 6:25=E2=80=AFPM Yuto Ohnuki wrote:
>
> NILFS2 does not currently support extended attributes. Update the
> comment for @i_xattr in struct nilfs_inode_info to clarify that it is
> reserved but unused.
>
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/nilfs2/nilfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thank you.

Viacheslav, could you please pick this up directly and queue it for
the next cycle (with the following Acked-by tag)?

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

There's been discussion about removing the on-disk inode xattr field
to implement atime, so if it's no longer needed for that reason, you
can drop it.

However, since this is an on-memory inode field, I think it's okay to
leave the field itself in place until its handling is decided.

Regards,
Ryusuke Konishi

> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index b7e3d91b6243..41b8b42be21d 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -27,7 +27,7 @@
>   * @i_state: dynamic state flags
>   * @i_bmap: pointer on i_bmap_data
>   * @i_bmap_data: raw block mapping
> - * @i_xattr: <TODO>
> + * @i_xattr: reserved for xattr object (unused)
>   * @i_dir_start_lookup: page index of last successful search
>   * @i_cno: checkpoint number for GC inode
>   * @i_assoc_inode: associated inode (B-tree node cache holder or back po=
inter)
> --
> 2.50.1
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembou=
rg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlin=
gton Road, Dublin 4, Ireland, branch registration number 908705
>
>
>
