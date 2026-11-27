Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795787446;
	b=BxnMLwis5xUGA0kiNbEi2/GgfGfOX/Rjz1dj7ydg9l6CFM0rz1OjBOXgKO3Uu/ddnwYY
	 fyEXh/XrOvYr/EhXyhJJ2d4jGOwCDiHQcmHTQiNcxH0cxtI6+iJmpCvodeAALDiLxdGaT
	 tdqSEwqukCIxA2HY7xFWdNupbq6X7h4EknJ+c+gZZMDrF7897JZ1djQ1K3GQ1HTbrTC19
	 NxN6MYXh43T5UN//dbQ3+RFQyIF3r/CTkhxQITs5IEL41fJiXsqAMf5fGPdHJLCLVOnjS
	 Z80TuxnwacoaxUhuh3b6zywbFZwE6sphIQaX1pBaBkS7hiSPGDtQkhy2/j39f3O3+QA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ysUHtS1JOPVXZFvBA9BI4JkLMtkjsHgwftBio/O1qnk=;
	b=TLFfOUUJbRSRNfB3C7jh5xyXVLjMw9U7VBuCf+dxrCi6QsR8p0f67uF8l1l8Xc4l/IYd
	 jsoQXaX79oO6m0vndudyoMyEqi2VzSC98yBI9yv9lU0QPyRP627lR63QTHJHGl7iDsZyc
	 fcuJk8QZkStuEzwB9eczM53e1imfmkj8usfA1Qb//AJho80L6butjhbaLCVXRHLlusfJl
	 ybFg6u+RkdfhpYorts3VsIgxZaWj0bMutcxxpicQ4qPJT9YjkB8sgrxKungJ1pO/fw0FW
	 4VV2esdBSISQP/BinZyS1myMYprVphg1DyKMiqXNH1tVY62JnVyKaFJadMHC/PWVFhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AV0jqjYL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289C3606A31E
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 13:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 289C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AV0jqjYL
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so79721355e9.1
        for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 05:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795787444; cv=none;
        d=google.com; s=arc-20260327;
        b=qsNwzvtnN5fe79Gjy0wya5JayvEUzNe99Bp1rqFDbVt5ZJ4QqLyuXpLrHzLtUCD2Ql
         JJC/17XuNCG/pAVTZ5thcIZN/i409+DpZN9A5W+g3Qw4YumazFwBR2BPT0beD+okNdL+
         6Qxdzc2rM5EWk0RsVVlNnpchVt9wyKZ8kEwxeBV+f5koxoFYO+t5QpWz2uI4FXCr8UMd
         mSwt1h+N8AUUWWu/kG/81ew7I/Zt3HK2VhDV7fyzT4BHPqVv76YlCcaoZyDKzvyrDQq3
         o1BG0eZ5AR3JFYJG2zvCh5ikkV1Qq2ab06JY2A3za+xF/HWB+HF00MWu0OkJezQs1u8l
         +b5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysUHtS1JOPVXZFvBA9BI4JkLMtkjsHgwftBio/O1qnk=;
        fh=OAeTTo9qL+z+el8kLDNucGNIm+AwKB9Yt6U7cN55NP4=;
        b=Cl0/qfPwqdYl6P57g4m6+Nsyr2RhVZ4/mkbBQyy2FgJbxtds5x/QsI4MuRm6rZFDpF
         dsHuF8cCwFKZha2O1Ipkb0p+T6B+hvR1GfmYThvmXF1qfLBloT+Ba4+KVAidfsLpUMoj
         eDtcGB2xUZHGUjdkxgFOyT+0HVSpjkkuGhXEYBlyXRX23pYgC+CvDI6CcsY80iEPzBWG
         Ad9AT2FqQQNO0v5835W5lRqhOw1s8WDDqXoCg4PI7CS5TcPNWIuKLT0zEwDszjdWfTCE
         lyMJaZcu2syjuhag7Jn4zPW6rigt0w4UlcfYXys3cNCUFgvCFGetFWv3TEd2aEGCC4Ps
         D0kw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795787444; x=1796392244; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ysUHtS1JOPVXZFvBA9BI4JkLMtkjsHgwftBio/O1qnk=;
        b=AV0jqjYLqeALcIvCfDVGSgvYYooluOh0QXf2TSz0w8YlJrudlc/ZZGb2fTqLouH2jT
         zEqLRO/hYEN/rGwkzzDPlbn00372IuqE+4lj7nKMZh/paZ2LXlLJpRdsgCN3EALMQfLQ
         Gidzt9ospJcs80W7hnCbTTSY1M4gIRLgJmZk5QIrEtBB8GOzTMNgUGWzSCDEdPqq22pH
         gISeRQk/vk0CqUPgcssHrSkasEr7NDhQJzKpdRITakxCFzJKL6jdssPRyejkrj3ZL8iy
         xtYdIaNUTmIOMln7+ilzjUyevyqffL/3lsKvTxPI3gPn3bkScqlHr+QdzMFn6enFhmNL
         7KSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795787444; x=1796392244;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ysUHtS1JOPVXZFvBA9BI4JkLMtkjsHgwftBio/O1qnk=;
        b=efDO54tqyko7F7jzbpgWXN+5ic27Fjt0+kc8ixLOSuNmSZa4USH0t/tSPIIFZpOGuo
         iPHktMYZpTP8f0XKGIbcs5Pl6bOVVlIj2Suy9JIUQO8iFSb77T6jQ9pdD2YC1Vfszz5l
         i3C57Pil2nW+9mNNf5ob7hN596hfSiaaeWy5Tz8lchqrfbR9gtiGV4fyw84jBTkkfRIT
         J0UqIJFngpZyqgOBUbTuqH8vOgauPLMIvF0HJ7bdRVxYrnGOrk99NL2ZwJZP4QkGUt61
         N1dAe1MonaRfOTXKvborkSs0IiTcp+ZkwMim0imLhlba4oE7QmwlLYJUnxekmVNGTBb0
         M2OQ==
X-Forwarded-Encrypted: i=1; AL+hErEs/z6oXY10DH8p6xMOa6PhrrpM85a5KlRA+wQVe9RvEzuH9di6DOTVdxdgQIl16ux09boJfxz5VQ8N+w==@vger.kernel.org
X-Gm-Message-State: APuU4Z+d3jPPpRTZCgw8yODDWd99SxEztHhARU6DsF5QktvYB569w7YM
	l7UqgPFpadlbsI4UECU4mK5ffcZRvbA+pinTauefJOjStownHPpweinI+N2wgnI3U9Pz3X+pDz8
	GSZlsk2x6QHpwQfz1tJk6pwXREIhGvBI=
X-Gm-Gg: AZFdTZfxheK9EMEqT0sc0Vz3PKnYcj3c6+knTjLA+m3WUIQsryiPqI4pQgrnfhlk2pv
	fKWa8yYmRfea4N4jpImHmP29zHW1uUmG+5X5aZwZL+CtjaeqBUuuKwnAZGdub0Nk2CLeKdfBDUF
	CkJToEQdGNQqGk3LWg9UVbVENTUpXmvSaxkDs2+AIX2F0W4b357qlV7IVWtvvuY4fpR62G1q68d
	1yqM3vv9FThEYxtoo5aieuMfvvTTp394n3IHqFZXJ3pk9C+smbpIOy/4RDAtrCiqRtkfafdLwle
	LdLLrL64Fh0HMdjokvFWB1WbSQthcpA/9xzzTkTe8bj1gKlqKq8vsEbJpWp+zDQubidNNySsGag
	m1FQAmjsBzadmDBE31mg+XCIkR9JINVVN4IaqHg==
X-Received: by 2002:a05:600c:c168:b0:4bb:81b2:c801 with SMTP id
 5b1f17b1804b1-4bb889238f1mr488095845e9.20.1795787444164; Fri, 27 Nov 2026
 05:50:44 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261127095449.1379289-1-hengyul@cs.unc.edu>
In-Reply-To: <20261127095449.1379289-1-hengyul@cs.unc.edu>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 27 Nov 2026 22:50:26 +0900
X-Gm-Features: Aa3M54pzs9UePC4SrMtsV10dVkoP4V5gXL-8LG1IckG_dODnuERBCn5YN3An1fY
Message-ID: <CAKFNMo=7jdKJ=yZ5PMUfDk3GPW=KFD2GrmgqZJzN9z7q4p+sRg@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: count new blocks that a short copy leaves dirty
To: Viacheslav Dubeyko <slava@dubeyko.com>, Hengyu Liang <hengyul@cs.unc.edu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 6:54=E2=80=AFPM Hengyu Liang wrote:
>
> nilfs_write_end() adds only the clean buffers of the copied range to
> the count of dirty blocks.  After a short copy, however,
> block_write_end() also zero-fills and dirties the newly allocated
> buffers of the part that was not copied, which is the whole range when
> the folio is not uptodate.  The write is then retried, finds these
> buffers dirty, and does not count them either.  This skews the free
> space calculation: nilfs_near_disk_full() does not stop the writer in
> time, and the reserved segments are consumed.
>
> This has been the case since nilfs2 was merged, but it used to take an
> unusual short copy, for example from a source buffer that runs into an
> unreadable page.  Commit 665575cff098 ("filemap: move prefaulting out
> of hot write path") made it much easier to hit: generic_perform_write()
> now faults in the source buffer only after a copy into the page cache
> has made no progress, so a write from memory that is not present yet
> first calls ->write_end() with copied =3D=3D 0 for each page.  As of now,=
 a
> write from a fresh anonymous mapping is accepted far beyond the free
> space, fsync() fails with ENOSPC, and the file is gone after a remount,
> together with the other changes made since the last log was written.
> On a volume shared with another user, that user's fsync() fails with
> ENOSPC too, and the files and directories that user created after the
> write are lost the same way.
>
> The issue can be reproduced on a 160 MiB disk with this program:
>
>     #include <errno.h>
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <stdlib.h>
>     #include <string.h>
>     #include <sys/mman.h>
>     #include <unistd.h>
>
>     int main(int argc, char *argv[])
>     {
>             size_t len =3D atol(argv[2]) << 20;
>             /* fresh anonymous memory: none of its pages is present yet *=
/
>             char *buf =3D mmap(NULL, len, PROT_READ,
>                              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>             int fd =3D open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
>
>             printf("write: %zd\n", write(fd, buf, len));
>             printf("fsync: %s\n", fsync(fd) ? strerror(errno) : "ok");
>             return 0;
>     }
>
> and these commands:
>
>     mkfs.nilfs2 -q /dev/vda
>     mount -t nilfs2 /dev/vda /mnt
>     ./cold /mnt/f 256
>     umount /mnt
>     mount -t nilfs2 /dev/vda /mnt
>     wc -c /mnt/f
>
> Before commit 665575cff098 ("filemap: move prefaulting out of hot write
> path"), the result is:
>
>     write: 67518464
>     fsync: ok
>     67518464 /mnt/f
>
> After that commit, the result is:
>
>     write: 268435456
>     fsync: No space left on device
>     wc: /mnt/f: No such file or directory
>
> With this change, the result is:
>
>     write: 70217728
>     fsync: ok
>     70217728 /mnt/f
>
> Count the buffers that block_write_end() is going to dirty, including
> the zero-filled new ones, before calling generic_write_end().
>
> Fixes: 05fe58fdc10d ("nilfs2: inode operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> I found this while comparing the behavior of different kernel versions.
> I used an LLM to analyze the problem and to draft the patch and this
> message, and I analyzed the result myself.
>
> v2: as Ryusuke asked, the Fixes tag now names the original
> implementation, the stable Cc has no version, and the message says the
> bug is old and 665575cff098 made it easier to hit. No code change.
> v1: https://lore.kernel.org/linux-nilfs/20261122130247.2069007-1-hengyul@=
cs.unc.edu/
>
> Tested on nilfs2 for-next with KASAN and lockdep, also with the short
> copy from Ryusuke's reply (1 KiB blocks, source running into a
> PROT_NONE page): the dirty block count is right, and a nearly full
> volume returns ENOSPC instead of accepting more than the free space.

Hi Viacheslav,

This v2 patch looks good to me.  Could you please apply it directly to
your tree?

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>
>  fs/nilfs2/inode.c |  3 +--
>  fs/nilfs2/page.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/page.h  |  4 ++++
>  3 files changed, 46 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index b217eee57c36..dd0bed24972a 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -249,8 +249,7 @@ static int nilfs_write_end(const struct kiocb *iocb,
>         unsigned int nr_dirty;
>         int err;
>
> -       nr_dirty =3D nilfs_page_count_clean_buffers(folio, start,
> -                                                 start + copied);
> +       nr_dirty =3D nilfs_page_count_buffers_to_dirty(folio, start, len,=
 copied);
>         copied =3D generic_write_end(iocb, mapping, pos, len, copied, fol=
io,
>                                    fsdata);
>         nilfs_set_file_dirty(inode, nr_dirty);
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 857926da9f21..0dec7b5b27c4 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -481,6 +481,47 @@ unsigned int nilfs_page_count_clean_buffers(struct f=
olio *folio,
>         return nc;
>  }
>
> +/**
> + * nilfs_page_count_buffers_to_dirty - count buffers a write will dirty
> + * @folio:  folio being written to
> + * @from:   offset of the write in @folio
> + * @len:    number of bytes to be written
> + * @copied: number of bytes copied into @folio
> + *
> + * Count the clean buffers of @folio that block_write_end() is going to =
mark
> + * dirty: those overlapping the copied range and, after a short copy, th=
e
> + * newly allocated ones in the rest of the range, which it zero-fills.  =
As
> + * there, a short copy into a folio that is not uptodate counts as a
> + * zero-length write.
> + *
> + * Return: Number of buffers that the write changes from clean to dirty.
> + */
> +unsigned int nilfs_page_count_buffers_to_dirty(struct folio *folio,
> +                                              unsigned int from,
> +                                              unsigned int len,
> +                                              unsigned int copied)
> +{
> +       unsigned int to =3D from + len, end =3D from + copied;
> +       unsigned int block_start, block_end;
> +       struct buffer_head *bh, *head;
> +       unsigned int nc =3D 0;
> +
> +       if (copied < len && !folio_test_uptodate(folio))
> +               end =3D from;
> +
> +       for (bh =3D head =3D folio_buffers(folio), block_start =3D 0;
> +            bh !=3D head || !block_start;
> +            block_start =3D block_end, bh =3D bh->b_this_page) {
> +               block_end =3D block_start + bh->b_size;
> +               if (buffer_dirty(bh))
> +                       continue;
> +               if ((block_end > from && block_start < end) ||
> +                   (buffer_new(bh) && block_end > end && block_start < t=
o))
> +                       nc++;
> +       }
> +       return nc;
> +}
> +
>  /*
>   * NILFS2 needs clear_page_dirty() in the following two cases:
>   *
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index c3ba3468af5c..4ccd740966ec 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -45,6 +45,10 @@ void nilfs_clear_folio_dirty(struct folio *folio, bool=
 force);
>  void nilfs_clear_dirty_pages(struct address_space *mapping, bool force);
>  unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
>                 unsigned int from, unsigned int to);
> +unsigned int nilfs_page_count_buffers_to_dirty(struct folio *folio,
> +                                              unsigned int from,
> +                                              unsigned int len,
> +                                              unsigned int copied);
>  unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
>                                             sector_t start_blk,
>                                             sector_t *blkoff);
>
> base-commit: 8fef1a9dec7bf58a29bc8a7ee6909ab629401cd3
> --
> 2.53.0
>
