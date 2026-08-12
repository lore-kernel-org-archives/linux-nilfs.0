Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE76412C15
	for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786574152; cv=pass; b=Z6DIGFohlQGKg766EjzPlrRQfPF2vFgeBw4hydKvV1lhHiefNthMCpsvJM7JBOzQyP1DpKE/PLEQsoIBAG8OvoVsdoHwcNzvTohD2JLy5Ny0cJDzH4T5XbKPNVJPtGkfxtbjBIuijb5uwdC1j6beTnbqfDj/EqQFwpyqd5NjhKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786574152; c=relaxed/simple;
	bh=XBtfCUZM4Z9MokOc0RnrVmWkdPYRIPype7rhWltePJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NK9MjJsUlYx4NYHEVCxLIuyK2jkyuuG7RISbbmMcV6ft4gfYofvQQ8SzLgFOPxrE6oMI2mboAQTE4Pgg8gEIZMJdd9ZCLqhQeNnBEXiyTf9sYCfiA7Bkn1+tCINa6QDEU++ZMFUBBBsknKoJlMOOZ8dgKPF1Qn1mB1xNBlbns/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DR/5KBhb; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DR/5KBhb"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6679d88abdcso2446785d50.2
        for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 15:35:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786574150; cv=none;
        d=google.com; s=arc-20260327;
        b=DxAe7VozXwaILXsPrLwWoYb3Z1IyYoramMXVSKtoxYP4JZSYe70Zt8hFOtDVj7ZkvQ
         2tre2RUIdMk/XEyljkF2HAKHFWpOfitCr45iHJEIgoinF/1zhDoU3j44srw2qf3lgSOu
         YAT5pz9ORhp/SYn0Ll7AP5eIMOB8XX0ZfJ0W4CQ7w4yo3/rx5snbDMnpSfD4DtvJOad9
         WGOz6hXz3ZJdErhmaKGRrUeBvVLrd12muSDqnT5Nh5UPrmhbzyaJZUcXXFgSVaQ79NN8
         dLraiZyGPcNibkXsaq3s8cgBBXwhaHeFTkvM6/EurEjaoCxJhF4SVCldorGrIAwowNGP
         xWiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xPFhYpYz44bCMeCCXzJP9sZEpYNf9oMMJbpv0EJdICY=;
        fh=s4z6tQZs6ghx7xydK7+dZmZWGcWmzjv2/mFs/8jq1GM=;
        b=XvB60DwvtDvPKRmVQLjuXkjHFhEhxRhWc/BnZVew87jb9BbdmVuQHUmBt1zSqRAL1A
         TXzoQEfd7iypvN7G54teujpp8pJsawTl7v8pDGsmDSCD1x6caeSS7cYGQqkBLJ3rIUC/
         pepfoWLp0RytQZdIOtlVLODbwEUiPHtvaonkRqnkl/bX8PesUuvCVL5h+PVHIZ5TMTTQ
         tTKpeQwhA4vQvSPgjifRcjPoN91D0b9eaFpv/lHgaWPsQGnv5pm/NTtoFHwL+PqbAir1
         kf75o/I58GN5duj/p55WhMXayrhis75nQr2/4/CvF6fwQzGQmopaTsJcDeSjp1IV7ggv
         2Tuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786574150; x=1787178950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xPFhYpYz44bCMeCCXzJP9sZEpYNf9oMMJbpv0EJdICY=;
        b=DR/5KBhbUGFSmkzYvUKru1hxAHW2vgVDiMENMrwcfAgY1xBCxjbgKYE0gyfHUsOLrR
         lo7X99aElbY7l3wcgJAnhCrNFKRPg8K2oTwYV/0Ne1QsP4np+QDyKPHm8E98xWRhiGww
         NaQHXXBNm8GGd7klpbSZlu4rTXlcaFYK4dFmyMsxuWPD+2OI0jEixKX2UJiT9mtDd1FT
         kLgsNu2i52hlcHjXP7Ef2hsWd3rkFmr7BuRcwqQvhD+VlUSbOPYER6UaB9iQyg7fQn6B
         JumUYLM3bCLGBqtY/WGYzGoKzWYTDFvGV89+qgGdVISfC9D/aimj9IGJEeCQ4eEVW83Y
         L27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786574150; x=1787178950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xPFhYpYz44bCMeCCXzJP9sZEpYNf9oMMJbpv0EJdICY=;
        b=KBKeqLr1cVX2QjQyaG3sDxg/DxDMJzPjKWJVvIYFMvNbM4nEm4sXZvC9zQPpfxOT5L
         XuIYewSGZNNHWZC8eMedaxTIjm0gyZxxS+lQwzJjGFnyaX60TWHw8GKrZM+rxpUkMT53
         vjAqFugsMkjNm4EoYDrIOitp6oD91f0rVSHmNQ7pYxpdPdKs3fA3qek3kJmR0+Gy4Kmi
         ydCdW5uKqKoaIO+qcpnihPl1Myji2Qks+ZvDJpo0BiokkBGRqHZSCYNpAJzsXEiVYKG0
         S4fLo373Vbr2O/UVETQmJ5sfy0RCUvZFqZPy8bBtInl+r9+yiS9VjXIpizGovERlQvSN
         mv2w==
X-Forwarded-Encrypted: i=1; AHgh+RqRoGQCuSGz/WMKP/reL15a4o1mTe0zPIPS1SRZo5oWWjvDHGQOgWEang3bOUI5ojebaJm+MwiytziLfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHRin31fLVkPDj/XwwtdPcaG7ph9jouRIX5p6nX0cekChHqnVx
	5KnPhM2Te+DA30AeIGiLfu0Cwmp/ABx9GmlpH5Sl/Z/9yBXgab2K2RIHg0u0JesiuE8AWSLDNKa
	GJUogRrsBoyBQYiN+5pAdNnLF0JAepTM=
X-Gm-Gg: AR+sD119/JKPUMwAkI3OFV3ECm8gk9VvdCS+YATFiyaRYkYuhtZLEwqd3r/SlD1T7UZ
	srYxsUxa4JFNtOasGRnm6Ka6ASkDJQLRMu3zQdjdvwI6VgVkRMkFXGCZc27UVB44N8raJERJ8If
	xl3Udw6nDyO9fK2n19zakoFXH6JXeMFtq3EeSiNoq8B9XNojTUHZrRauaB0fuDjYnoPSA1GGYak
	ITXVB8f/8Fuf7dqtTyTTnPj1dJzAEilnZJZcmquf654aJw6Dqtdz5HjyIpki/H/jc+17yn8gVFk
	bwSFthBkMc4P0fPoS5wZ9dvypnUv+mMRhCaKDLWBFRkvvc9ikDhaqYV2IyZeZvmAsA==
X-Received: by 2002:a53:e199:0:b0:667:ae8a:5207 with SMTP id
 956f58d0204a3-66c515c3b7amr607866d50.26.1786574149231; Wed, 12 Aug 2026
 15:35:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812221154.1119137-1-slava@dubeyko.com> <20260812221154.1119137-3-slava@dubeyko.com>
In-Reply-To: <20260812221154.1119137-3-slava@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 13 Aug 2026 07:35:30 +0900
X-Gm-Features: AUfX_mww-8m1GsEa6bytF5cXbgG39r3jREMYVtIcsdtM96z0eg3fGRZ0tVpLnow
Message-ID: <CAKFNMokYNKF3-gQ1SctOqNJ6YfQAG=7khKRZGLYOpCmY63j2Rw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] nilfs2: switch O_DIRECT to iomap based operations
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: hch@lst.de, brauner@kernel.org, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, lilinmao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 7:12=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> The patch eliminates blockdev_direct_IO() from
> nilfs2 entirely:
>
>  - nilfs_file_open() now sets FMODE_CAN_ODIRECT explicitly, since
>    permission to open the file O_DIRECT was previously implied by
>    aops->direct_IO being non-NULL.
>  - nilfs_file_read_iter() dispatches O_DIRECT reads to iomap_dio_rw()
>    using nilfs_iomap_ops; everything else still goes through
>    generic_file_read_iter() as before.
>  - nilfs_file_write_iter() strips IOCB_DIRECT and falls through to
>    generic_file_write_iter()'s ordinary buffered path. NILFS2 cannot
>    perform true direct I/O writes: new blocks are delay-allocated and
>    only given a real disk address by the segment constructor, which
>    works on buffer_head lists, not iomap. This reproduces today's
>    actual behavior: the old nilfs_direct_IO() already just returned 0
>    for WRITE.
>  - nilfs_direct_IO() and the .direct_IO callback on nilfs_aops are
>    removed.
>  - drop the unnecessary "select LEGACY_DIRECT_IO" from Kconfig
>    in favor of "select FS_IOMAP".
>
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> cc: linux-nilfs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>  fs/nilfs2/Kconfig |  2 +-
>  fs/nilfs2/file.c  | 42 +++++++++++++++++++++++++++++++++++++++---
>  fs/nilfs2/inode.c | 13 -------------
>  3 files changed, 40 insertions(+), 17 deletions(-)
>
> diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
> index 7dae168e346e..0a5ace60e6ab 100644
> --- a/fs/nilfs2/Kconfig
> +++ b/fs/nilfs2/Kconfig
> @@ -3,7 +3,7 @@ config NILFS2_FS
>         tristate "NILFS2 file system support"
>         select BUFFER_HEAD
>         select CRC32
> -       select LEGACY_DIRECT_IO
> +       select FS_IOMAP
>         help
>           NILFS2 is a log-structured file system (LFS) supporting continu=
ous
>           snapshotting.  In addition to versioning capability of the enti=
re
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index f93b68c4877c..30dd8e5ebe5b 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -10,9 +10,12 @@
>  #include <linux/fs.h>
>  #include <linux/filelock.h>
>  #include <linux/mm.h>
> +#include <linux/uio.h>
> +#include <linux/iomap.h>
>  #include <linux/writeback.h>
>  #include "nilfs.h"
>  #include "segment.h"
> +#include "iomap.h"
>
>  int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int dat=
async)
>  {
> @@ -133,20 +136,53 @@ static int nilfs_file_mmap_prepare(struct vm_area_d=
esc *desc)
>         return 0;
>  }
>
> +static int nilfs_file_open(struct inode *inode, struct file *file)
> +{
> +       file->f_mode |=3D FMODE_CAN_ODIRECT;
> +       return generic_file_open(inode, file);
> +}
> +
> +static ssize_t nilfs_file_read_iter(struct kiocb *iocb, struct iov_iter =
*to)
> +{
> +       struct inode *inode =3D file_inode(iocb->ki_filp);
> +       ssize_t ret;
> +
> +       if (iocb->ki_flags & IOCB_DIRECT) {
> +               inode_lock_shared(inode);
> +               ret =3D iomap_dio_rw(iocb, to, &nilfs_iomap_ops,
> +                                  NULL, 0, NULL, 0);
> +               inode_unlock_shared(inode);
> +       } else
> +               ret =3D generic_file_read_iter(iocb, to);
> +
> +       return ret;
> +}
> +
> +static ssize_t nilfs_file_write_iter(struct kiocb *iocb, struct iov_iter=
 *from)
> +{
> +       /*
> +        * NILFS2 lacks direct I/O write support: fall back to buffered w=
rites.
> +        */
> +       if (iocb->ki_flags & IOCB_DIRECT)
> +               iocb->ki_flags &=3D ~IOCB_DIRECT;
> +
> +       return generic_file_write_iter(iocb, from);
> +}
> +
>  /*
>   * We have mostly NULL's here: the current defaults are ok for
>   * the nilfs filesystem.
>   */
>  const struct file_operations nilfs_file_operations =3D {
>         .llseek         =3D generic_file_llseek,
> -       .read_iter      =3D generic_file_read_iter,
> -       .write_iter     =3D generic_file_write_iter,
> +       .read_iter      =3D nilfs_file_read_iter,
> +       .write_iter     =3D nilfs_file_write_iter,
>         .unlocked_ioctl =3D nilfs_ioctl,
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl   =3D nilfs_compat_ioctl,
>  #endif /* CONFIG_COMPAT */
>         .mmap_prepare   =3D nilfs_file_mmap_prepare,
> -       .open           =3D generic_file_open,
> +       .open           =3D nilfs_file_open,
>         /* .release     =3D nilfs_release_file, */
>         .fsync          =3D nilfs_sync_file,
>         .splice_read    =3D filemap_splice_read,
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..cbe9658ae065 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -257,18 +257,6 @@ static int nilfs_write_end(const struct kiocb *iocb,
>         return err ? : copied;
>  }
>
> -static ssize_t
> -nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> -{
> -       struct inode *inode =3D file_inode(iocb->ki_filp);
> -
> -       if (iov_iter_rw(iter) =3D=3D WRITE)
> -               return 0;
> -
> -       /* Needs synchronization with the cleaner */
> -       return blockdev_direct_IO(iocb, inode, iter, nilfs_get_block);
> -}
> -
>  const struct address_space_operations nilfs_aops =3D {
>         .read_folio             =3D nilfs_read_folio,
>         .writepages             =3D nilfs_writepages,
> @@ -277,7 +265,6 @@ const struct address_space_operations nilfs_aops =3D =
{
>         .write_begin            =3D nilfs_write_begin,
>         .write_end              =3D nilfs_write_end,
>         .invalidate_folio       =3D block_invalidate_folio,
> -       .direct_IO              =3D nilfs_direct_IO,
>         .migrate_folio          =3D buffer_migrate_folio_norefs,
>         .is_partially_uptodate  =3D block_is_partially_uptodate,
>  };
> --
> 2.43.0
>
