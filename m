Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B282136351
	for <linux-nilfs@vger.kernel.org>; Mon, 21 Sep 2026 03:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961561; cv=pass; b=ZKqzgG/tCV+3+7hv79Ps+tjv5JHIkKyrRmhD85m0sTJbwEYyb9GMO4oECCAs2R8c67CqM0oy1pwny/qIND7V1t7MESROCRkqs/mKeM41cBS+75efH+m3SfE/z9bR0g/qfDWooBCZfr6IpmL/ANZCv+qwP0Kr/Z080OcKmQUVeSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961561; c=relaxed/simple;
	bh=Tn1DcNUBiAuClZYqSqBZ88jUyppc2jXwxeH8hByKWcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gYpkCa3B47OEyUX3pEFAbHSvzgR9BslblOg4DXUpNZrvMY8Gz7SXcjiA9/IT7mT1WIpKIOkH5hmvjyuOXf3wHeoIyeH2PfebKpQfiTb8rX+TB9zYEMQwXYyR3lUV0w8jCt/8fgUvyrVeX7GYs6tExPEgpUDhAuhu1Ih52KMrjCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1jlsRlx; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1jlsRlx"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a5919af2eeso22257231fa.3
        for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 20:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789961557; cv=none;
        d=google.com; s=arc-20260327;
        b=Y/Dhhq5IZfyeqiUZU2rj+uDnNdNAQcW0oP5dKQcYU/TQtB/PWjU88r5hk1D+QGWiV9
         OpfheX8UpoODh3ZqxySqFpz4tOMyqOaU34whxzx0eJQ4lbc9oixvUL7smXlaiqqZmd1A
         3ZQDcQAyiCgPedsVEPTP+ydD1SO0kdq2R4MBTugXlBlJUJmBdyehhlm0PFbxNM/50y04
         x8V899z521VNAYSOY/OLgAyHELAyz9sRHhy2U0y9wrEqN7dcbzDaSIuz/dgxBHQd0xwT
         FA8QCmbROKgELXSjhqK8eey96p9t6aqa4YINvFmNsMpkiXaZUd40hhYT2+FBoMSfjG+b
         PeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oj1u6aVeBnceP3UlUHmxTCqWnZRFEUlpDWjZkUtcmP4=;
        fh=jLl68OpOxNx8VlfOtUKuGcO4paqMaRw0a3bcpyJ1Efc=;
        b=e6zUwFZZ5Ao187YzXaRHwLSA/J+2h4p/wFHY9BbQyDY7obw+WRW+F1NDLPyqFVuJQn
         sFX3cFxlU7MYauz2AN/YWLFZPiW4GOP+CetsyXphd51Sfv45ixLvjFEsbHO5MDaa5hrj
         Xm8FvA/EFGSDQqgfs88ugE++jDcAKrCjs4O4W7Rho2t/PG7s53ONjz/aR72m2PObKWES
         sOmtLtlK/6PIXw5Vu6byCsSAQIIBUvPmbJkBCE4qwdCwGRc/v79ytaPTycxWyAacNctL
         Y9EHMxQVguVpFYYhBOsYzd8zhj+PLEO49Svd2+hf3oK0pXH8TtJ/I1iy4kSQ+LZHiFQ2
         E6Fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789961557; x=1790566357; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oj1u6aVeBnceP3UlUHmxTCqWnZRFEUlpDWjZkUtcmP4=;
        b=Z1jlsRlxGYBG+ywzfChkwYFrUax6T4OB08Jop9kzzhSMCXQE7XVFzlRWQyQ7hSiXXR
         2CeITujZMXgnZf/WrAiXS0e6BN0CNF/gRYR1afpN6JKLp1KDkguiKQdZpMyhOp5YZGvD
         PfjSKuHnSae6OWRyBeb5PAVCXCshJZp7NGBo+W3jf/P/BWl0cLEVdVH/a0I0Lyjptchd
         76/zuaTrqZ6wgYQ/3G+ez2f7ML+b4iOyTld7011NUCu/D7v44T/xOy0UHkpA6rddbTyG
         pyP4LK6wuiVJCsSSnwbbXQuxfgj5R6baXuOVq6ZfRG5I8M4ZvI/UJJt97WQmkeC6Zk5D
         0Hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961557; x=1790566357;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oj1u6aVeBnceP3UlUHmxTCqWnZRFEUlpDWjZkUtcmP4=;
        b=wTTZHtouB3g7tWR21O5Exwm2d4LsV+uDv+VJHWLRyOnS/LsuY2gX7Mp7M1bJkb9wh8
         rFCe7Y4IqlPwJONZXZX9RQy+oipdYHgcwQu1i5s8OoXRsSRx8Zk6nq6vzD2aQI5X/Kfr
         sHnfZzPG52KzuG1Y5U2jqbNx9Y5XQeWJTDxOwQHvo80Zaf7MFOPg2t110l7vdFNJImiK
         goiCgz7rUi79h/4ZKBRK9fnCvkcK7p9VIRC60eDDHqQ/vWIJKodWpAmClT9TubWyeNWt
         1AeBxdw6pr5opQL9JTUTw+pD0oE9EiDc3Fn9Y8kmrvvOVKfE4tV1U1U3Bmypl0R0NTAY
         ZIog==
X-Forwarded-Encrypted: i=1; AKwUvBz6iMtbYDUAKqRCBqFDWq14TS5PUHyrqq5qYxDksMsQEsAi0+CXNMoarOm9UiO2BPusspkD4NRuCH+tqA==@vger.kernel.org
X-Gm-Message-State: AFuF++nvMnS54xLqw+oUuW9tpgYBf3arp+TuGy5DUCK3Uk0XJA3cYNdM
	jeEZyJ4JIjtXzYhUZvBIly7J4UA3dsxFp5fvT+HcYSQxD+/DeMjIkljs/k7Hyw1aDQakHV0G8xS
	yh6laHMnQFfwvbewTvA15YV4ok7iHiXfdb/32/Ls=
X-Gm-Gg: AYBFou0IQkd3nBqKLiaXJwcJBxLAP3dKBcCCC5ZvFe9TcN7cwkuH2DSrwkl5J51uTPD
	bRj9BdsS+Xz4Gke4UTMd83vR7/BXWhvHSNb8olVqZKsorsgLuvvzqCptBAZed7w0re5szLJG96L
	VlqrxZHXLdC18W5lctvuu9YcbkN6F66htJbL7guBd2iT150uYWGhr8DDAmMDS2coBYW3LHUIvoA
	ZOWeL6/ukzITquvywxgjbobtLYhveDUbW/5Ykp+xck0XlqAqsa9rG4+ZzunNT3JWlgtuAH9P7Ri
	BbYo1Zsvq7r35NJdm7COEtU2auM7N7TREMzQkDJQs8TJ8tYa5+sY1gdExFRPgnsvkTg=
X-Received: by 2002:a05:6512:3a8d:b0:5b0:11b4:fd7f with SMTP id
 2adb3069b0e04-5b8c183378cmr2644982e87.10.1789961557135; Sun, 20 Sep 2026
 20:32:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com> <20260920205533.426028-3-southampton.jake.labelle@gmail.com>
In-Reply-To: <20260920205533.426028-3-southampton.jake.labelle@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 21 Sep 2026 12:32:19 +0900
X-Gm-Features: AcwNN1UVa0nMxsBXi0Hs3alrN2tJ0WkZttgTFj285G7LMsJDxGM5mCEtjPeVJRk
Message-ID: <CAKFNMokSzC5+=ZMBJgaG0aQqC4xQ1Bk-MWhOEA4T69g5sptT+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] nilfs2: validate directory position after llseek in readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 5:55=E2=80=AFAM Jake Labelle wrote:
>
> nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrary
> value via llseek, as an offset into the directory folio and parses
> whatever bytes sit there as a directory entry.  A position pointing
> into the middle of an entry -- or at unused bytes of a corrupted image
> that the page validator never inspected -- makes dir_emit() copy up to
> 255 (name_len) bytes from a bogus entry, possibly reading past the end
> of the folio and returning unrelated memory contents to userspace.
>
> Snap unaligned positions onto a valid entry boundary by walking the
> rec_len chain from the chunk start before parsing, as ext2 does in
> ext2_validate_entry().
>
> Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
> Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
> Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
> ---
>  fs/nilfs2/dir.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 8b53802b6..bc8cb21c7 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -231,6 +231,21 @@ static struct nilfs_dir_entry *nilfs_next_entry(stru=
ct nilfs_dir_entry *p)
>                                           nilfs_rec_len_from_disk(p->rec_=
len));
>  }
>
> +static inline unsigned int
> +nilfs_validate_entry(char *base, unsigned int offset, unsigned int mask)
> +{
> +       struct nilfs_dir_entry *de =3D (struct nilfs_dir_entry *)(base + =
offset);
> +       struct nilfs_dir_entry *p =3D
> +               (struct nilfs_dir_entry *)(base + (offset & mask));
> +
> +       while ((char *)p < (char *)de) {
> +               if (p->rec_len =3D=3D 0)
> +                       break;
> +               p =3D nilfs_next_entry(p);
> +       }
> +       return offset_in_page(p);
> +}
> +
>  static int nilfs_readdir(struct file *file, struct dir_context *ctx)
>  {
>         loff_t pos =3D ctx->pos;
> @@ -254,6 +269,18 @@ static int nilfs_readdir(struct file *file, struct d=
ir_context *ctx)
>                         ctx->pos +=3D PAGE_SIZE - offset;
>                         return -EIO;
>                 }
> +               /*
> +                * ctx->pos comes from userspace via llseek and may point
> +                * into the middle of an entry =E2=80=94 or at unvalidate=
d bytes of
> +                * a crafted image. Snap it onto a real entry boundary
> +                * before parsing, as ext2 does; otherwise dir_emit() cop=
ies
> +                * name_len bytes from a fake entry, reading past the fol=
io.
> +                */
> +               if (offset & (nilfs_chunk_size(inode) - 1)) {
> +                       offset =3D nilfs_validate_entry(kaddr, offset,
> +                                       ~(nilfs_chunk_size(inode) - 1));
> +                       ctx->pos =3D ((loff_t)n << PAGE_SHIFT) + offset;
> +               }

Hi Jake,

I understand your point that we need to handle file pointer
misalignment caused by directory seeks.

However, since directory entries have variable record lengths based on
name length as calculated by the NILFS_DIR_REC_LEN() macro, couldn't
the pointer still land in the middle of an entry even if offset is on
a chunk boundary calculated from nilfs_chunk_size()?

Shouldn't calling nilfs_validate_entry() be done only during the
initial check (checking offset directly derived from ctx->pos) and
when offset is not on a page boundary (i.e. offset =3D=3D 0)?

Also, as a minor nitpick, instead of calling nilfs_chunk_size(inode)
repeatedly, could you declare and set a local variable named
chunk_size at the beginning of the function and use it?  (Although the
compiler probably optimizes it, doing so makes the code cleaner from a
readability perspective.)

Thanks,
Ryusuke Konishi


>                 de =3D (struct nilfs_dir_entry *)(kaddr + offset);
>                 limit =3D kaddr + nilfs_last_byte(inode, n) -
>                         NILFS_DIR_REC_LEN(1);
> --
> 2.43.0
>
