Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57EB3AA51D
	for <linux-nilfs@vger.kernel.org>; Tue, 10 Mar 2026 13:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147714; cv=pass; b=GIWXPJIdbhXxju3/XO2JcqTHJs5KfA/MwPtFU5CZXkFEKjHaxQO2viJeVDG488ujqQiROt//vZgg2qzmXI2rOxpBMKkrUHJRlTEM1EOw2XyRhI28zAFSqixS6iASrjhPLN4uSsEG8uDBeT+tAUXEKIKqvK6qbJCnArblpGluy8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147714; c=relaxed/simple;
	bh=80A4i9KCVIM2d8s6pDs7ug1BHJ5YHRI8JuOyIT6WgPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hMB1vP5Eq6QzYG3bn4fesLUeLoTTAc46q9oNxzFy+qDXse2dZjCwWfqw8FpH08lTdtVh/So9S5tBuWy3mtgciAsJoJdOBdPY+6W4vK4DyEBoyVbaEkbOt13sguxQCTtDEArHw1OB4+rXPwJK75mdMnA9eOoJ39IEUdgE+KJmVC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsB+25vM; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsB+25vM"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a13d6a2d7bso3678018e87.1
        for <linux-nilfs@vger.kernel.org>; Tue, 10 Mar 2026 06:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773147710; cv=none;
        d=google.com; s=arc-20240605;
        b=YAsZgntR3YGy/4o9J+4mgXXer3yc9EcMWsl/8D+A77K/f/ZE3Ms0Bblm51K2FjY6+s
         HXSgu6A9bSw24X7czfJqtnKVaoUtCUbJ3qPrIIdpKWnmxRwHoJXsGjzWI1dQr0p/JAQK
         8mOEtV9c4D7grQyuYgKt+cpDTnscY7YJmEILH7ymFwtf2uYoqCYh5KJvNzyTaOjfY/Py
         1O4+w56q68Syd7tb1jWp6dYpGw8FLIcE+q+H88xxfV6Dqcj/HgbvmbKkjilW7z5+kWKP
         Jvx9wN9MfFMIct11Stxp1srQuflBMGO4pPaf12t18oY9Nv9W/ZprS+Bmjoh2RToSFHf9
         ODwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HmXy9GuoY1W34b++DDgqfMop+biZa4H7WtjxNpBzCHc=;
        fh=DJCGwdfNGekcyxGDL0zq7NqQCW0RxorvyyW2TqAyPvs=;
        b=PH13iuYT9OMCrI62okiS/ufz7VNw78zy+Bnq0R705d74+N4EaKCmHS/ucYyVrVLS5G
         xXGjk/dHj/Soq+mHHDJh93GhamQil0/GTSlYvtrP7ZEgWt5Yv8M9vRIfdISd3+kJp3Fy
         RtUEbWSohsOHK43kGUE65NB4QRU+oixjM+9MSs251J8DDb0IGKR1Ma/IjtqXQ2XAG+g4
         Iy2RQoGyE0FcOAqDcfFVb+wJPeaJqOi6pPk1ttWT8B4pYujozsdqvIT+tZvSD8eAJiU+
         YlvtfpW2JoCLtLDLkRkvKd3XmTIoqYj427Ln1h0chPiS9k5FAcsoke4z3NpaYm/QENNN
         OATQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773147710; x=1773752510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmXy9GuoY1W34b++DDgqfMop+biZa4H7WtjxNpBzCHc=;
        b=JsB+25vMbEuHjklEfrkhYeJI+Jj36/q1XG+wdh958FhWGtyxMFPPbajXy2F2tQEhWE
         LLtCG5auEInB/I2wqsSSfcSfoXsHAsc/THg400rlBXcfrlfqj6WLANZWK9NGZZiwX0Qf
         YIz94CMUJiC+8zcu8Jk4SWS+sOF6WO014qGsgMvVl5gLDMGpIRfHr4NDrXxX9HX4LLZo
         huJRZXXU+Hl2sx5+evqsvXVGYFxULXozKUerR0gmTLKuP8NqaRfHIMPLwn4jAyhdKN2I
         /gqK1f6wW3ZoCOE4q1parxyPTDynJqVKNQAVgYpStf0E1iZriPO+DbrVLv4OPVODHIzn
         yYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773147710; x=1773752510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HmXy9GuoY1W34b++DDgqfMop+biZa4H7WtjxNpBzCHc=;
        b=QnPA8z0XYFlrJbHK2APE9FNwjgRPqE0I1+1ZZzbm5rpahr5TOed5vNMko5mvbUf4sU
         kL99yA0AkGsOpXekbRDQGsN4CM/Pt/jyiBE+fkkYocTTHCD5ibY36f75tx9zTGwfD2mS
         I8idjbsZUk3SxHqekNrpbzHrQcVXhrL2RQjwvE1O7zEBoTwzxbGVQnCDr3ErNb3lKrpb
         RMkK6J1YXtKtzFOqczwGlN9qou9FLLmi/APFzQQue/1kGr37+Suy4IjrhtAuaLpYk1sD
         OXhiTDjoMl/TJVh8CKhpcVoPCl6OMvyJvzML7k2asQy+CwcNiIg3c7NgTQ3+VM77QO27
         aNag==
X-Forwarded-Encrypted: i=1; AJvYcCV6wWqbm4epN+j2u11ph8CGtfdeKbCsDe162GRAIzTBIUZ6hPJehPGkVzMqXFDYNfdgh84kR/IpjNCptw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvnK+GmC+QsQ23dzjirPcuQ9jMbfXT0RE5CI42QVg72eaokRuB
	8boPLgIHN6gNTaMi85mpLkRpYshtW/1iQGEzLr+2GHynERlU+FEa39O2F9Z8TpC0M5C0D9wV5Jk
	qJvzmnYcvaFOBlQG9w03VY6cEJWKqemQ=
X-Gm-Gg: ATEYQzyShXcADU72v24/yOr4vtor+rTyNE1JG3BuAYUu4mw8bsX1hLYy0T+2rRIBL1h
	I9LcLK1aiqb7i8RwQeXHWB+PnQHT4a10aAzboSopvLInVpImDD8yVAHeqczxvru6OalqcPaEz8e
	4qk63iEnWAoDOeQNNeRyiHLuK3Xx6O+NGLuU8VwdsHdm2afPtZJk8G8VFYOg4vkmznckQT+9EZL
	1+t220F1xt9qkPNHQiTAKEYRfhkQTMzOCv3sUs/7oj0oCqckhtlaDCs4wZsb7wgcxLjjTdNmCGZ
	HnlXLCDpX/bbvqJvOU0=
X-Received: by 2002:a05:6512:67db:b0:5a1:1de6:bc66 with SMTP id
 2adb3069b0e04-5a14e48a613mr874536e87.18.1773147708096; Tue, 10 Mar 2026
 06:01:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-iino-u64-v1-0-18422a053b04@kernel.org> <20260310-iino-u64-v1-1-18422a053b04@kernel.org>
In-Reply-To: <20260310-iino-u64-v1-1-18422a053b04@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 10 Mar 2026 22:01:31 +0900
X-Gm-Features: AaiRm53VuLCINpkeyLwgGa3qyn5MXOBgR8oSJIecEGpm5hN3ZsL6dTvldvEDd5w
Message-ID: <CAKFNMokA0NrTT-iXzhoN0XVJtWQF4+SytZNefseEsGi++LxseA@mail.gmail.com>
Subject: Re: [PATCH 1/2] nilfs2: fix 64-bit division operations in nilfs_bmap_find_target_in_group()
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 8:44=E2=80=AFPM Jeff Layton wrote:
>
> With the change to make inode->i_ino a u64, the build started failing on
> 32-bit ARM with:
>
>     ERROR: modpost: "__aeabi_uldivmod" [fs/nilfs2/nilfs2.ko] undefined!
>
> Fix this by using the 64-bit division interfaces in
> nilfs_bmap_find_target_in_group().
>
> Fixes: 998a59d371c2 ("treewide: fix missed i_ino format specifier convers=
ions")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202603100602.KPxiClIO-lkp@i=
ntel.com/
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thank you.  The conversion seems reasonable.

Ryusuke Konishi

> ---
>  fs/nilfs2/bmap.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index 824f2bd91c167965ec3a660202b6e6c5f1fe007e..4ce9a93149a5af13bc215cc18=
77a757e2c6cf49b 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -455,11 +455,14 @@ __u64 nilfs_bmap_find_target_in_group(const struct =
nilfs_bmap *bmap)
>  {
>         struct inode *dat =3D nilfs_bmap_get_dat(bmap);
>         unsigned long entries_per_group =3D nilfs_palloc_entries_per_grou=
p(dat);
> -       unsigned long group =3D bmap->b_inode->i_ino / entries_per_group;
> +       unsigned long group;
> +       u32 rem;
> +
> +       group =3D div_u64(bmap->b_inode->i_ino, entries_per_group);
> +       div_u64_rem(bmap->b_inode->i_ino, NILFS_BMAP_GROUP_DIV, &rem);
>
>         return group * entries_per_group +
> -               (bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
> -               (entries_per_group / NILFS_BMAP_GROUP_DIV);
> +              rem * (entries_per_group / NILFS_BMAP_GROUP_DIV);
>  }
>
>  static struct lock_class_key nilfs_bmap_dat_lock_key;
>
> --
> 2.53.0
>
