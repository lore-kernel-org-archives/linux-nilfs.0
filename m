Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF94C6C
	for <linux-nilfs@vger.kernel.org>; Wed, 24 Sep 2025 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758716346; cv=none; b=RNh/qa9iOqnYBkc00eerdmQHIrMGdCN9ASmQemMmVHfmTT87GIWuonYkltRlJ8eGTS4xBfiwqCCnsqjLVLcFutBpEKhIe12kbAjQIM8CnJ3jepWj7jjkWcn00asoGQhTGxn8DYyRFo0Q8q8Oxe8UUSjSdOeJP/2cR4RWIh2vj60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758716346; c=relaxed/simple;
	bh=TAObwE9kmytBPXBOSqBLKzuNHBV04FYjzO6uMK/yEhc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mPX5ku19fyWqZxKlPLbVtHsYPKfxgc1ku5ktC/qlgB7QGz3XNycvztwzoZT26Yfq67+gMfx8YjvUHreDQhRfrHcimBCQsX0KpObWE2ov3JGSRmLG2EqtBhFQvlYrpwUGBK81riinkb6mqFAxE2U2WVovl099tCNBb9UnOvO6Gr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctoQ0scU; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctoQ0scU"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57bb7ee3142so3369202e87.0
        for <linux-nilfs@vger.kernel.org>; Wed, 24 Sep 2025 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758716343; x=1759321143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Viin6TuBjIiAgZfSdR4TvqbJlDCKh1ntkn3hWS0V/fU=;
        b=ctoQ0scUJE+Jo/qe2Wp8X1CPl+F1hL2Z4EbamJQCY6OnY16RwlXW/UwNqoWbo8fJ2K
         H3/HRA7wgNhH9mC+WHE7EWPGSSfCGvIRNphcgO7nvX4PipcDlv1+UlEGrG0AkNedzJFy
         yv6dRvkVBXciQ20KbMYTr4VKitqNOx3CI80BnxKiDKYbcKkydy7R1Up7qhhwv4QSGkrc
         ekxEpnuEmrpvWdCs12iltDOOacJp8qpZFeB5lpXXkNeLjBqt+/SZePTxgi+0W2QYx2Xp
         dF26BugoTt5O2Xg5Qi6ujVfgV/lQrRqd9Y+FRP8GuJqiGO3ovb4qrUoRdSyS9jIoIQJ0
         NK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758716343; x=1759321143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Viin6TuBjIiAgZfSdR4TvqbJlDCKh1ntkn3hWS0V/fU=;
        b=YEpPoSpNbnlbhfxjFmB9aiJ+GakDzZhNKMqOH0cTwWWwu7LsymNZkOYnOW4oPn9Hul
         tTnb5kHRDcoBNdx+k6zd8JL+l3jhwSCPNmO/9vsLxK/66VOg68nYqN+SNiEuCf3EYLIm
         PEPdZc2LRCDPybEYd88jDNFWIKiugLIxSFV48DcJckfTLCT+AAXLn24E5kxhmFFErImj
         vYYte8IhAkj+FLY2zWBTYhiUbehWqwXtvc5thWkLS0Sva0o5ILAs6AYTlghTmX9LLIQh
         ofFOEcJhMnjeMafBVy0D5nnk5aZM2uTrqVHEjqT2Ak7Roa8YdA9CBUbLujFoYr82T2iJ
         SrVQ==
X-Gm-Message-State: AOJu0Yxvr0Bmk2m1yGZuAHDR8yqmJo98T5wA/kbzFoHB57l8tKWKSArY
	OmeGLiR0+6gpfykhR4J7xD21xw8RpWyTJssB4DSRorq04Yl4jZGmha4AnEFC2RlYk09smEiwEJo
	M3Ou2eHYRdL1WEavbvGW3S7AJplepXkqIgA+x
X-Gm-Gg: ASbGncv6BzTv6TRm/RvPSMfNSTKH252a4Lejgk6qsg818kJEemhgUQL3wp7dm6RJFnq
	tFOm8iDVfZ08kMN1yxty2NfzfZ8HGoetDhP1Ub3q9tLr0JLMVdJV2zqCrng9+f+s5yd0tqKjhm9
	JNoJKVccs3YTNMTEtQ1LfFPviYc9wH/kB0HHq8/p+aJnI8SdAGuDgYZo8IrHtzcM5akLjvByigw
	52vg750Gz/CODySJcXz0U8Wyx1Wh/784ylYwk8G+Q==
X-Google-Smtp-Source: AGHT+IH19KyEvVApP8Ygpl7PGIGjBWQEeNHARbTawPM6HHgmEIfzlGsjO8pj/xKYNhVCvX3w0gOzQQTIpznCq0dRwcY=
X-Received: by 2002:a05:6512:33cc:b0:57d:d62e:b205 with SMTP id
 2adb3069b0e04-58070dfa09dmr2192192e87.18.1758716342549; Wed, 24 Sep 2025
 05:19:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923120902.1844458-2-thorsten.blum@linux.dev>
In-Reply-To: <20250923120902.1844458-2-thorsten.blum@linux.dev>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 24 Sep 2025 21:18:46 +0900
X-Gm-Features: AS18NWCK3rkwobJwuTNUJVl58SJ2S98ySrw3W3vZ9WzHEoGhmsYxNHDOnQ1rRrE
Message-ID: <CAKFNMonHxWSxW72Af8F_3Mhx39iO5hgVKAhTjpHVKsTBOQ-Z8g@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: replace vmalloc + copy_from_user with vmemdup_user
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 9:10=E2=80=AFPM Thorsten Blum wrote:
>
> Replace vmalloc() followed by copy_from_user() with vmemdup_user() to
> improve nilfs_ioctl_clean_segments() and nilfs_ioctl_set_suinfo(). Use
> kvfree() to free the buffers created by vmemdup_user().
>
> Use u64_to_user_ptr() instead of manually casting the pointers and
> remove the obsolete 'out_free' label.
>
> No functional changes intended.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Thank you for your patch proposal.

This patch involves rewriting using vmemdup_user(), u64_to_user_ptr(),
and kvfree(), which to me appear to be equivalent transformations that
improve readability.

However, I would like to actually perform build tests in different
environments (to confirm in multiple environments that the typecheck
for __u64 in u64_to_user_ptr passes without any problems, and that no
side effects appear with the static coding checker).  Also, since it
touches parts related to the operation of user-space programs such as
nilfs_cleanerd and nilfs-resize, I would like to confirm that actual
device tests pass while changing the allocation sizes.

So, rather than rushing it into the upcoming merge window, please let
me schedule this to be sent upstream in the cycle after that.

If there are any issues, I would like to provide feedback.

Regards,
Ryusuke Konishi

>  fs/nilfs2/ioctl.c | 35 ++++++++++-------------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
>
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 3288c3b4be9e..e17b8da66491 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -49,7 +49,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilf=
s,
>                                                    void *, size_t, size_t=
))
>  {
>         void *buf;
> -       void __user *base =3D (void __user *)(unsigned long)argv->v_base;
> +       void __user *base =3D u64_to_user_ptr(argv->v_base);
>         size_t maxmembs, total, n;
>         ssize_t nr;
>         int ret, i;
> @@ -836,7 +836,6 @@ static int nilfs_ioctl_clean_segments(struct inode *i=
node, struct file *filp,
>                 sizeof(struct nilfs_bdesc),
>                 sizeof(__u64),
>         };
> -       void __user *base;
>         void *kbufs[5];
>         struct the_nilfs *nilfs;
>         size_t len, nsegs;
> @@ -863,7 +862,7 @@ static int nilfs_ioctl_clean_segments(struct inode *i=
node, struct file *filp,
>          * use kmalloc() for its buffer because the memory used for the
>          * segment numbers is small enough.
>          */
> -       kbufs[4] =3D memdup_array_user((void __user *)(unsigned long)argv=
[4].v_base,
> +       kbufs[4] =3D memdup_array_user(u64_to_user_ptr(argv[4].v_base),
>                                      nsegs, sizeof(__u64));
>         if (IS_ERR(kbufs[4])) {
>                 ret =3D PTR_ERR(kbufs[4]);
> @@ -883,20 +882,14 @@ static int nilfs_ioctl_clean_segments(struct inode =
*inode, struct file *filp,
>                         goto out_free;
>
>                 len =3D argv[n].v_size * argv[n].v_nmembs;
> -               base =3D (void __user *)(unsigned long)argv[n].v_base;
>                 if (len =3D=3D 0) {
>                         kbufs[n] =3D NULL;
>                         continue;
>                 }
>
> -               kbufs[n] =3D vmalloc(len);
> -               if (!kbufs[n]) {
> -                       ret =3D -ENOMEM;
> -                       goto out_free;
> -               }
> -               if (copy_from_user(kbufs[n], base, len)) {
> -                       ret =3D -EFAULT;
> -                       vfree(kbufs[n]);
> +               kbufs[n] =3D vmemdup_user(u64_to_user_ptr(argv[n].v_base)=
, len);
> +               if (IS_ERR(kbufs[n])) {
> +                       ret =3D PTR_ERR(kbufs[n]);
>                         goto out_free;
>                 }
>         }
> @@ -928,7 +921,7 @@ static int nilfs_ioctl_clean_segments(struct inode *i=
node, struct file *filp,
>
>  out_free:
>         while (--n >=3D 0)
> -               vfree(kbufs[n]);
> +               kvfree(kbufs[n]);
>         kfree(kbufs[4]);
>  out:
>         mnt_drop_write_file(filp);
> @@ -1181,7 +1174,6 @@ static int nilfs_ioctl_set_suinfo(struct inode *ino=
de, struct file *filp,
>         struct nilfs_transaction_info ti;
>         struct nilfs_argv argv;
>         size_t len;
> -       void __user *base;
>         void *kbuf;
>         int ret;
>
> @@ -1212,18 +1204,12 @@ static int nilfs_ioctl_set_suinfo(struct inode *i=
node, struct file *filp,
>                 goto out;
>         }
>
> -       base =3D (void __user *)(unsigned long)argv.v_base;
> -       kbuf =3D vmalloc(len);
> -       if (!kbuf) {
> -               ret =3D -ENOMEM;
> +       kbuf =3D vmemdup_user(u64_to_user_ptr(argv.v_base), len);
> +       if (IS_ERR(kbuf)) {
> +               ret =3D PTR_ERR(kbuf);
>                 goto out;
>         }
>
> -       if (copy_from_user(kbuf, base, len)) {
> -               ret =3D -EFAULT;
> -               goto out_free;
> -       }
> -
>         nilfs_transaction_begin(inode->i_sb, &ti, 0);
>         ret =3D nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_si=
ze,
>                         argv.v_nmembs);
> @@ -1232,8 +1218,7 @@ static int nilfs_ioctl_set_suinfo(struct inode *ino=
de, struct file *filp,
>         else
>                 nilfs_transaction_commit(inode->i_sb); /* never fails */
>
> -out_free:
> -       vfree(kbuf);
> +       kvfree(kbuf);
>  out:
>         mnt_drop_write_file(filp);
>         return ret;
> --
> 2.51.0
>
