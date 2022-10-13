From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for konis
Date: Fri, 14 Oct 2022 08:06:43 +0900
Message-ID: <CAKFNMonU3aVqwRdxyFefBJMg0-XC9j8bE-qYZ-9xx-4--NdkGg@mail.gmail.com>
References: <20221013214638.30933-1-palmer@rivosinc.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a5ykvIMx9PXDw/XbQTEsr1TUV23I2THVBFGAGMxhGXA=;
        b=UfwjEZiN368Fnrmu/LyULdyFVi4rljZMl8+CKtolWmF63TXFiB/dRMvcer1DaELOFp
         BvFChJx/iI29Tqu0uzlVGt8fT8zRrpG6HgPOPN8vf0Pe//wDruZzzgQ/e90HnCgKCZyf
         qGpkVKKHTLUbpHiOmVvQTHS7PwfvwI8Ew8E/BWYpdDeIglq4VdhJmErvGTxdX5F5XzMk
         uwe7njsQ2eZzIkVbMye/FKOBALS2oCP/ZcS32I+s2y1XD1lD3FhYXOLL3GhsJQxuna0s
         DBHuSNNvo39rq7y2jdC7yLDKbvAEI2wGL4XEuAy5zjOIBEAKPieL61b/egcb+xVPrB7z
         Fk0A==
In-Reply-To: <20221013214638.30933-1-palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>

On Fri, Oct 14, 2022 at 6:49 AM Palmer Dabbelt wrote:
>
> Github deprecated the git:// links about a year ago, so let's move to
> the https:// URLs instead.
>
> Reported-by: Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
> Signed-off-by: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
> ---
> I've split these up by github username so folks can take them
> independently, as some of these repos have been renamed at github and
> thus need more than just a sed to fix them.
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d118acdce8b8..c9c396e2d8a0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14363,7 +14363,7 @@ L:      linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  S:     Supported
>  W:     https://nilfs.sourceforge.io/
>  W:     https://nilfs.osdn.jp/
> -T:     git git://github.com/konis/nilfs2.git
> +T:     git https://github.com/konis/nilfs2.git
>  F:     Documentation/filesystems/nilfs2.rst
>  F:     fs/nilfs2/
>  F:     include/trace/events/nilfs2.h
> --
> 2.38.0
>

Ah, that's right, it needs to be fixed.

I'll pick this up unless it's decided to apply similar fixes all at once.
Thank you.

Ryusuke Konishi
