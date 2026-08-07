Received: from mail-yx2-f0.google.com (mail-yx2-f0.google.com [74.125.224.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7533A385D72
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Aug 2026 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122888; cv=none; b=gICoGyafyrsThGK1ednY/frAyU8L6lioUk0DnhEcGIBSinuBRGKkCnXXHyujUWskbUPJQI9eU7GJO5iRyvcG87Majdd0IA57U8md8fXtGW/pM064e63IK1q0nnhLVPPf8k29BBDVBsbZciCzacGt8TIN9MsAsz+3Iu+SeGzbTX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122888; c=relaxed/simple;
	bh=UVhsV75ihbywWjsloSF3Icy7qa4oEAqct3MpF/vDfO4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gLERMiLIhNXoYcv6LhcwWy16u1xYF91F9ya+FsosYkHaAcywX03kc5OQ01JWG02jSnrjirx0ss5DOWEGzRJL6lGffmgUwOiEB2wFVE5SiNHpHfHvVe4uxD/MmmvvaWgoWut9VclmidqOGLXdtVrYDdX9r5cwIp8qQQyZNphiqS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=LZTBnQP1; arc=none smtp.client-ip=74.125.224.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="LZTBnQP1"
Received: by mail-yx2-f0.google.com with SMTP id 956f58d0204a3-6698a3ed1ebso2419590d50.0
        for <linux-nilfs@vger.kernel.org>; Fri, 07 Aug 2026 10:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786122884; x=1786727684; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZLxRBVbGvCnp60zrp2Sul1gutiGFbsKktA9lgwN1CFc=;
        b=LZTBnQP169mz8GCNteAApWzcmyXQB0Kc7u5lxzgvf1CswBpq2QrK1OJKFwaORIZ2U+
         VPPZNM/uJYi53GTiyo88oqVxvBWsEsJUjFUGTOAbsDqRhrAtEjhlqdcZEKmriMfqYpaq
         YokRrjYE/iNfumLF1hQG31+R9DVRLIRtuXh2Z6Dw0W8bs/+IXZRZkjzl/0vW6WhHw3NL
         yQZBYbHCK07WLopE+9QvKpUPa1UXKrxocROQ1ZPcTm5RgvNQBjH73UXjJIvl5pdeZs6k
         cT0PqSC4hGoVvMNE2RAGdpmGTuKNvTzbEIj0eg1EKAr1hPoL1Wq00v4jHaJEPSYrXclA
         roGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786122884; x=1786727684;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZLxRBVbGvCnp60zrp2Sul1gutiGFbsKktA9lgwN1CFc=;
        b=lxF+lFdzpTltaiE7v7COkAgkqn3eOESBOUZcZ2oE9cDtnemWUqQb6oTlSgYdg4c8DF
         iehwk3FT+OTHNokB28YR9m3YWBAXSd9ujpdDIZ/olbKZkywngE/mpkU/MPLjzJG8ijHU
         QFVnKRVFtv/JZO/Sk1FbIuJBseIfQfgxiQu/x/Iq4UGYt8lFRbLd0Y7NWmt7r4TbVVc+
         KjmTL9REuqtgJcPmLDmQhljHEqIbKfDRrt5ZS1vexSV1bRPsEgoQBUrUeJkQ1bVzNwSe
         5RCAJus/aUJM1HcW5piWB095uHl1rGEszv9u5+7TGrNyIqYxIycqProwbmZhR+7UXLNi
         Edtg==
X-Forwarded-Encrypted: i=1; AHgh+RqY+fJ55+NBSSt2lWczjtlvR5WxJP2uce7GPjGnOeRoGTVmQC9Tq2Y35UBGxK1IqMz8oLWBg6jbE8NflQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yybw+PGlO/gvM52aq5mFqBMiKflmXBDVxvuxfkj9TnniE6YNz0t
	W0H2J1FRj9Y30gObewj0LMXni4fZZQXNicHuoIoNLvk6JrNjUuS55T+xuNOfvBo5MoE=
X-Gm-Gg: AR+sD12hXrgXACRVXVCK71qyPbtFPDpZkXwvIphEN8JM5HmQa/WiQs3UPVKdvDDrwG7
	ZNd5k6f7JXz/uYtxx27ETO8utiEjXoi5ya7n4fiJzDenFE+MlfdINaH4bPbE2txObb8d4tOH+qt
	v/NgqzRVLr0WFGDSGUcAUVUaflPXxcxgNABipXwiTlsZb65nOurwCUu7x/p0erL+i0vuffnpyvm
	+m7fSTQW3Svf3Fe4ZlADp3zc9jDvv7Rt3Ne7fsirae2cXpE5jdHWflKjpjufinvD7Wu5RxzKePJ
	wEJO9qEeVx8HfrGUjtxUOrH1QTzQrsuExQV96ZrM80XZnBr/zZTZHFWjZwQ0PCmfeiVg7HYyIdC
	9QnQ7nuENJfwjvpZLqTOR7qiGUpHB/UQE1KNbUlHI2v9fSGK6rfjWzrCf7BmoS0htDm/iJR1+JZ
	225x2gWk3s4zvP05gQu850UWbO2wixNY/UfxGv1KPPE7J0dCl16p+4vMA9LFhBKuTzWwLZvNhHX
	joEbVjRWpPCpXMXcWXICnubnhrbcx0n+kknvT+xnUe1abj45PuJtzc/0zwk+GTWnC0Y0QMJaW/N
	F4Thudth+ksV7fwA4DHrqhEvQG+DoU7MEMHzMEYl2yfsyDNtKKufcg==
X-Received: by 2002:a53:e052:0:b0:664:ed6f:4eb1 with SMTP id 956f58d0204a3-6699a9d55bamr11300400d50.16.1786122884325;
        Fri, 07 Aug 2026 10:14:44 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:891e:7b31:87a7:701f? ([2600:1700:6476:1430:891e:7b31:87a7:701f])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66acafbbd4csm1588784d50.17.2026.08.07.10.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 10:14:43 -0700 (PDT)
Message-ID: <a507775e591f4f7d7f953d36d8fc1b0d07afe1e1.camel@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: suppress false positive WARN_ONs for sufile
 after an FS error
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, Zhan Xusheng
	 <zhanxusheng@xiaomi.com>, linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+5957361606d7b750b874@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Fri, 07 Aug 2026 10:14:42 -0700
In-Reply-To: <20260806181433.43460-1-konishi.ryusuke@gmail.com>
References: <20260806181433.43460-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-07 at 03:13 +0900, Ryusuke Konishi wrote:
> After applying the commit associated with the Fixes tag, metadata
> file
> buffers can be evicted from memory even after being marked dirty.
>=20
> Consequently, operations such as rolling back sufile changes upon
> error - which modify the buffer and were previously assumed incapable
> of failure - can now fail.
>=20
> This behavior causes syzbot to trigger a WARN_ON check immediately
> following sufile function calls within the log writer.
>=20
> Resolve this issue by introducing a macro,
> nilfs_sufile_warn_on_error(),
> which uses WARN_ONCE to report unexpected errors only when the
> filesystem
> has not degraded to read-only mode, returning -EIO or -EROFS
> accordingly.
> Replace existing WARN_ON checks for unexpected errors following
> sufile
> operations with this new macro.
>=20
> Additionally, for nilfs_segctor_truncate_segments() - where an error
> must
> be propagated to halt log writing if a sufile operation fails -
> modify
> the function to return the error code appropriately.
>=20
> Reported-by: syzbot+5957361606d7b750b874@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D5957361606d7b750b874
> Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread
> after remount in RO mode because of driver's internal error or
> metadata corruption")
> Cc: <stable+noautosel@kernel.org> # Warning suppression primarily;
> will request backport individually if needed
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> v2: Fix nilfs_sufile_warn_on_error() macro to correctly return _err
> =C2=A0=C2=A0=C2=A0 instead of the boolean result of unlikely(_err), and a=
dd
> unlikely()
> =C2=A0=C2=A0=C2=A0 to the return value check in nilfs_segctor_truncate_se=
gments().
> =C2=A0=C2=A0=C2=A0 (Thanks to Zhan Xusheng for pointing out the macro bug=
).
>=20
> Hi Viacheslav,
>=20
> Please apply this for the next cycle at your convenience.
>=20
> This fixes an issue where a WARN_ON check is triggered by sufile
> functions within the log writer after the filesystem degrades to
> read-only
> mode.=C2=A0 This is a false-positive warning reported by syzbot this June
> (and likely reported previously as well), which can occur as a normal
> consequence after degradation.
>=20
> This v2 patch fixes a macro bug pointed out, where the final
> expression
> incorrectly normalized the return value.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/segment.c | 36 ++++++++++++++++++++----------------
> =C2=A0fs/nilfs2/sufile.h=C2=A0 | 28 ++++++++++++++++++++++++++++
> =C2=A02 files changed, 48 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 2189267894d2..5896fdae5669 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1433,7 +1433,7 @@ static int nilfs_segctor_extend_segments(struct
> nilfs_sc_info *sci,
> =C2=A0 failed:
> =C2=A0	list_for_each_entry(segbuf, &list, sb_list) {
> =C2=A0		ret =3D nilfs_sufile_free(sufile, segbuf->sb_nextnum);
> -		WARN_ON(ret); /* never fails */
> +		nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0	}
> =C2=A0	nilfs_destroy_logs(&list);
> =C2=A0	return err;
> @@ -1449,7 +1449,7 @@ static void nilfs_free_incomplete_logs(struct
> list_head *logs,
> =C2=A0	segbuf =3D NILFS_FIRST_SEGBUF(logs);
> =C2=A0	if (nilfs->ns_nextnum !=3D segbuf->sb_nextnum) {
> =C2=A0		ret =3D nilfs_sufile_free(sufile, segbuf->sb_nextnum);
> -		WARN_ON(ret); /* never fails */
> +		nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0	}
> =C2=A0	if (atomic_read(&segbuf->sb_err)) {
> =C2=A0		/* Case 1: The first segment failed */
> @@ -1468,7 +1468,7 @@ static void nilfs_free_incomplete_logs(struct
> list_head *logs,
> =C2=A0	list_for_each_entry_continue(segbuf, logs, sb_list) {
> =C2=A0		if (prev->sb_nextnum !=3D segbuf->sb_nextnum) {
> =C2=A0			ret =3D nilfs_sufile_free(sufile, segbuf-
> >sb_nextnum);
> -			WARN_ON(ret); /* never fails */
> +			nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0		}
> =C2=A0		if (atomic_read(&segbuf->sb_err) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 segbuf->sb_segnum !=3D nilfs->ns_nextnum)
> @@ -1491,7 +1491,7 @@ static void
> nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
> =C2=A0		ret =3D nilfs_sufile_set_segment_usage(sufile, segbuf-
> >sb_segnum,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 live_blocks,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 sci-
> >sc_seg_ctime);
> -		WARN_ON(ret); /* always succeed because the segusage
> is dirty */
> +		nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0	}
> =C2=A0}
> =C2=A0
> @@ -1504,28 +1504,32 @@ static void nilfs_cancel_segusage(struct
> list_head *logs, struct inode *sufile)
> =C2=A0	ret =3D nilfs_sufile_set_segment_usage(sufile, segbuf-
> >sb_segnum,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0 segbuf->sb_pseg_start -
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0 segbuf->sb_fseg_start,
> 0);
> -	WARN_ON(ret); /* always succeed because the segusage is
> dirty */
> +	nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0
> =C2=A0	list_for_each_entry_continue(segbuf, logs, sb_list) {
> =C2=A0		ret =3D nilfs_sufile_set_segment_usage(sufile, segbuf-
> >sb_segnum,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 0, 0);
> -		WARN_ON(ret); /* always succeed */
> +		nilfs_sufile_warn_on_error(sufile, ret);
> =C2=A0	}
> =C2=A0}
> =C2=A0
> -static void nilfs_segctor_truncate_segments(struct nilfs_sc_info
> *sci,
> -					=C2=A0=C2=A0=C2=A0 struct
> nilfs_segment_buffer *last,
> -					=C2=A0=C2=A0=C2=A0 struct inode *sufile)
> +static int nilfs_segctor_truncate_segments(struct nilfs_sc_info
> *sci,
> +					struct nilfs_segment_buffer
> *last,
> +					struct inode *sufile)
> =C2=A0{
> =C2=A0	struct nilfs_segment_buffer *segbuf =3D last;
> -	int ret;
> +	int ret, err =3D 0;
> =C2=A0
> =C2=A0	list_for_each_entry_continue(segbuf, &sci->sc_segbufs,
> sb_list) {
> =C2=A0		sci->sc_segbuf_nblocks -=3D segbuf->sb_rest_blocks;
> -		ret =3D nilfs_sufile_free(sufile, segbuf->sb_nextnum);
> -		WARN_ON(ret);
> +
> +		ret =3D nilfs_sufile_warn_on_error(
> +			sufile, nilfs_sufile_free(sufile, segbuf-
> >sb_nextnum));
> +		if (unlikely(ret) && err !=3D -EROFS)
> +			err =3D ret;
> =C2=A0	}
> =C2=A0	nilfs_truncate_logs(&sci->sc_segbufs, last);
> +	return err;
> =C2=A0}
> =C2=A0
> =C2=A0
> @@ -1564,7 +1568,7 @@ static int nilfs_segctor_collect(struct
> nilfs_sc_info *sci,
> =C2=A0							sci-
> >sc_freesegs,
> =C2=A0							sci-
> >sc_nfreesegs,
> =C2=A0							NULL);
> -			WARN_ON(err); /* do not happen */
> +			nilfs_sufile_warn_on_error(nilfs->ns_sufile,
> err);
> =C2=A0			sci->sc_stage.flags &=3D ~NILFS_CF_SUFREED;
> =C2=A0		}
> =C2=A0
> @@ -1576,8 +1580,8 @@ static int nilfs_segctor_collect(struct
> nilfs_sc_info *sci,
> =C2=A0		sci->sc_stage =3D prev_stage;
> =C2=A0	}
> =C2=A0	nilfs_segctor_zeropad_segsum(sci);
> -	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs-
> >ns_sufile);
> -	return 0;
> +	err =3D nilfs_segctor_truncate_segments(sci, sci->sc_curseg,
> +					nilfs->ns_sufile);
> =C2=A0
> =C2=A0 failed:
> =C2=A0	return err;
> @@ -1878,7 +1882,7 @@ static void
> nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
> =C2=A0						sci->sc_freesegs,
> =C2=A0						sci->sc_nfreesegs,
> =C2=A0						NULL);
> -		WARN_ON(ret); /* do not happen */
> +		nilfs_sufile_warn_on_error(nilfs->ns_sufile, ret);
> =C2=A0	}
> =C2=A0
> =C2=A0	nilfs_destroy_logs(&logs);
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index cd6f28ab3521..5888ed479c8b 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -10,6 +10,7 @@
> =C2=A0#ifndef _NILFS_SUFILE_H
> =C2=A0#define _NILFS_SUFILE_H
> =C2=A0
> +#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/buffer_head.h>
> =C2=A0#include "mdt.h"
> @@ -54,6 +55,33 @@ int nilfs_sufile_read(struct super_block *sb,
> size_t susize,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_inode *raw_inode, str=
uct inode
> **inodep);
> =C2=A0int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range
> *range);
> =C2=A0
> +/**
> + * nilfs_sufile_warn_on_error - warn on unexpected sufile error
> + * @sufile: inode of segment usage file
> + * @err: status code returned by a sufile function
> + *
> + * Even if buffer heads of blocks containing segment usage entries
> have
> + * been dirtied in advance by calling functions such as
> + * nilfs_sufile_mark_dirty() or nilfs_sufile_{alloc,free}(), those
> buffers
> + * can be discarded from memory after the file system detects
> corruption and
> + * degrades to read-only mode, which may cause sufile operations,
> including
> + * cancel operations, to return errors.=C2=A0
> nilfs_sufile_warn_on_error() is used
> + * to detect unexpected errors other than during read-only
> degradation.
> + *
> + * Return: 0 if @err is 0, %-EROFS if in read-only degraded mode,
> and %-EIO
> + * otherwise.
> + */
> +#define nilfs_sufile_warn_on_error(sufile,
> err)				\
> +	({						=09
> 	\
> +		int _err =3D
> (err);					\
> +							=09
> 	\
> +		if
> (unlikely(_err))					\
> +			_err =3D WARN_ONCE(!sb_rdonly((sufile)-
> >i_sb),	\
> +				"unexpected sufile error %d\n",
> _err) ? \
> +				-EIO : -
> EROFS;				\
> +		_err;					=09
> 	\
> +	})
> +
> =C2=A0/**
> =C2=A0 * nilfs_sufile_scrap - make a segment garbage
> =C2=A0 * @sufile: inode of segment usage file

Applied.

Thanks,
Slava.
