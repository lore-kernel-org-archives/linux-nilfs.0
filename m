From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu()
 in uapi header
Date: Sun, 7 Jul 2019 11:40:58 +0900
Message-ID: <CAK7LNAQMuZrDTX2-zynf=8gS1UqnygnMHoAfQr4wZ8uqEzd_qQ@mail.gmail.com>
References: <20190605053006.14332-1-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x672fZY9026926
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1562467296;
        bh=I0xyGzOgFAL5V9jjmDuVTuK7LMrU6TFfqca/VNGQTuo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wa5JxMcvVj6AgYUBS6WiwXAFtlJVgmEH9aDbiKUz3StwWul7EQ/BuZLEDgbmIGcal
         iXwUElIgnsU0rEcL9jzB3CmRHFrzy8+mjtZZg/2tMtUysqvuIuvQIt2kgzgDr/nMDi
         DvByIaq/7/Vj+UuAVPyiZ49Rb/PIF0UskKjJeVKcKVTXXn1KpWgs/MQybXO1Qgr/hN
         CavjsbmtKMg8jBhN8PjmSPSGASyRNTHWo3GM2pFyOig0a1LIYK7Tdb+eOz7QASqoNi
         /CGM85gPgxvf78QA/vFFFvX1GSyFA2uVFt0wdAUQvQLbDFPTSgKKFo2TGpIBr5R1Kl
         8bb9i1ZD0NjaA==
In-Reply-To: <20190605053006.14332-1-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

Hi Andrew,

Could you pick up this?

The maintainer of nilfs2 is silent, but
this is obviously build error.

Masahiro Yamada


On Wed, Jun 5, 2019 at 2:32 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> cpu_to_le32/le32_to_cpu is defined in include/linux/byteorder/generic.h,
> which is not exported to user-space.
>
> UAPI headers must use the ones prefixed with double-underscore.
>
> Detected by compile-testing exported headers:
>
> ./usr/include/linux/nilfs2_ondisk.h: In function =E2=80=98nilfs_checkpoin=
t_set_snapshot=E2=80=99:
> ./usr/include/linux/nilfs2_ondisk.h:536:17: error: implicit declaration o=
f function =E2=80=98cpu_to_le32=E2=80=99 [-Werror=3Dimplicit-function-decla=
ration]
>   cp->cp_flags =3D cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
>                  ^
> ./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro =
=E2=80=98NILFS_CHECKPOINT_FNS=E2=80=99
>  NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
>  ^~~~~~~~~~~~~~~~~~~~
> ./usr/include/linux/nilfs2_ondisk.h:536:29: error: implicit declaration o=
f function =E2=80=98le32_to_cpu=E2=80=99 [-Werror=3Dimplicit-function-decla=
ration]
>   cp->cp_flags =3D cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
>                              ^
> ./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro =
=E2=80=98NILFS_CHECKPOINT_FNS=E2=80=99
>  NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
>  ^~~~~~~~~~~~~~~~~~~~
> ./usr/include/linux/nilfs2_ondisk.h: In function =E2=80=98nilfs_segment_u=
sage_set_clean=E2=80=99:
> ./usr/include/linux/nilfs2_ondisk.h:622:19: error: implicit declaration o=
f function =E2=80=98cpu_to_le64=E2=80=99 [-Werror=3Dimplicit-function-decla=
ration]
>   su->su_lastmod =3D cpu_to_le64(0);
>                    ^~~~~~~~~~~
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
>  include/uapi/linux/nilfs2_ondisk.h | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilf=
s2_ondisk.h
> index a7e66ab11d1d..c23f91ae5fe8 100644
> --- a/include/uapi/linux/nilfs2_ondisk.h
> +++ b/include/uapi/linux/nilfs2_ondisk.h
> @@ -29,7 +29,7 @@
>
>  #include <linux/types.h>
>  #include <linux/magic.h>
> -
> +#include <asm/byteorder.h>
>
>  #define NILFS_INODE_BMAP_SIZE  7
>
> @@ -533,19 +533,19 @@ enum {
>  static inline void                                                     \
>  nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)               \
>  {                                                                      \
> -       cp->cp_flags =3D cpu_to_le32(le32_to_cpu(cp->cp_flags) |         =
 \
> -                                  (1UL << NILFS_CHECKPOINT_##flag));   \
> +       cp->cp_flags =3D __cpu_to_le32(__le32_to_cpu(cp->cp_flags) |     =
 \
> +                                    (1UL << NILFS_CHECKPOINT_##flag)); \
>  }                                                                      \
>  static inline void                                                     \
>  nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)             \
>  {                                                                      \
> -       cp->cp_flags =3D cpu_to_le32(le32_to_cpu(cp->cp_flags) &         =
 \
> +       cp->cp_flags =3D __cpu_to_le32(__le32_to_cpu(cp->cp_flags) &     =
 \
>                                    ~(1UL << NILFS_CHECKPOINT_##flag));  \
>  }                                                                      \
>  static inline int                                                      \
>  nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)             \
>  {                                                                      \
> -       return !!(le32_to_cpu(cp->cp_flags) &                           \
> +       return !!(__le32_to_cpu(cp->cp_flags) &                         \
>                   (1UL << NILFS_CHECKPOINT_##flag));                    \
>  }
>
> @@ -595,20 +595,20 @@ enum {
>  static inline void                                                     \
>  nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)         \
>  {                                                                      \
> -       su->su_flags =3D cpu_to_le32(le32_to_cpu(su->su_flags) |         =
 \
> +       su->su_flags =3D __cpu_to_le32(__le32_to_cpu(su->su_flags) |     =
 \
>                                    (1UL << NILFS_SEGMENT_USAGE_##flag));\
>  }                                                                      \
>  static inline void                                                     \
>  nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)       \
>  {                                                                      \
>         su->su_flags =3D                                                 =
 \
> -               cpu_to_le32(le32_to_cpu(su->su_flags) &                 \
> +               __cpu_to_le32(__le32_to_cpu(su->su_flags) &             \
>                             ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
>  }                                                                      \
>  static inline int                                                      \
>  nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)       \
>  {                                                                      \
> -       return !!(le32_to_cpu(su->su_flags) &                           \
> +       return !!(__le32_to_cpu(su->su_flags) &                         \
>                   (1UL << NILFS_SEGMENT_USAGE_##flag));                 \
>  }
>
> @@ -619,15 +619,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
>  static inline void
>  nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
>  {
> -       su->su_lastmod =3D cpu_to_le64(0);
> -       su->su_nblocks =3D cpu_to_le32(0);
> -       su->su_flags =3D cpu_to_le32(0);
> +       su->su_lastmod =3D __cpu_to_le64(0);
> +       su->su_nblocks =3D __cpu_to_le32(0);
> +       su->su_flags =3D __cpu_to_le32(0);
>  }
>
>  static inline int
>  nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
>  {
> -       return !le32_to_cpu(su->su_flags);
> +       return !__le32_to_cpu(su->su_flags);
>  }
>
>  /**
> --
> 2.17.1
>


--=20
Best Regards
Masahiro Yamada
