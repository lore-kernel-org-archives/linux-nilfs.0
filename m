Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795453512;
	b=v2M5dqWTd/bKuGmmZ4PIxoJYZOVqBIFbNspI8ER4ujGaT5pPK0wEsDuYR72tCokm15w8
	 89dx1fXR3uLgccMlfcGR7w7q6049aeRbIwZDDZlCZPJf/WJc1ik6hdogGPzBfrz6OY+lp
	 1HIo1BhBX4GWUeCnznpb9iz/VLpPK6ZJkEkL/rQtMc6WKhEm/sh/GiGzT17tViEA0xHV6
	 X+YWrUZswecnNNyKPQFX2+bIwmRdKwEXRMOqPOb7H2HEzTPem2YhnD/l+ZUqNIUKt4PUb
	 V6xVVqzQlsGvgCl6xGMXwnxG7MIzpyyMHTGTp7iQ1PjNBOd5Y7pSZRpMUe7dQjJDhQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gIo6r+IlTGcpmO+YqtWN+p8Vb41yHG75b/8fYfmBgxI=;
	b=TT8t3OQja9a650VSxeSsN3oFdFzZV4OpRbffR0VQaIwQ4Lh8PhYHE0nP4O27vQp6VYEt
	 ODYVw3dq24a0AT1PznEtMKf+4d+1qRsjUglX9mTQW8lLv+CZF0jI7k8Hh6NTTa/PBZnqA
	 Ug2OpeXYgAlr7HQGjkrK7+6ILt9auV1PQZX2AoZX2K8bSQWJjqlDbI/52IDHweX5zFVE5
	 SG00HyVw5R9k/sWcBx5e4BMcMJCQaXECH6mUgCiPhofy3GUqRnntN3WgcQsU6FYrMMmfF
	 dk83knACvSZcQTLy6yfKreS+ikDa/fo8VytLNvu1+tj4sJkb1XsB5zp0ESp5ogNUH4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wsz3TOv/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0392606A321
	for <linux-nilfs@vger.kernel.org>; Mon, 23 Nov 2026 17:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0392606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wsz3TOv/
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-492690dd5daso2688585f8f.1
        for <linux-nilfs@vger.kernel.org>; Mon, 23 Nov 2026 09:05:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795453510; cv=none;
        d=google.com; s=arc-20260327;
        b=YTAvYOXtTdux4/6a26jqGOhxyj6qRhlj5ED/KGHx6f+B5vnKdfg41fLlUxSPDfcYNJ
         nIVsiLGyFZscSMgqGK/U+u3nGA8GWYNaBE/3VoXbp76MBcS5teaYhlAutCUCtc3/5PkQ
         2GRThFz2qq6Jgl/u3G93tIdc9Lb+SFxi6rnx6aokR7JayEG+H3tRgwXBVDmN6pKjEHxB
         W1kt5CB2uLqJ7w7rQlD+Yq9/3RhHoJXAvgFpls1rTY86XJG9a69LQzOIV72XKsEt+XUs
         3oQPZ+uwW/veNEvobaE9RPfypgTFmXpghfb5KScje6qOJOtxgqCdKXBOzlW4CcMZ7jDS
         tIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gIo6r+IlTGcpmO+YqtWN+p8Vb41yHG75b/8fYfmBgxI=;
        fh=WTQZLrHXiDZq2G2g3VIJvo1s9QnpWpEvMl/rmpx/rWc=;
        b=AzM6WE3+kufVBzn3cj6uIbaqwZflnLA9P3DQrfQT0/JOcOZdj84Q/1oOLHAKSCrDbt
         hU2xqps9uXUsmQqrKS2b8j/W//qAJiaaBW4kK+0Jk9xOZTagqFkKp8E3/hB5UG77cX8B
         G1NN5QtEyu43bJG41o1kxGUqN3S4FAtmTYD/x5UmCxx0Pk5b20HLtH6fQqhjIvY5FPUg
         19lF00tidqKrKAcjNxF+vJWy7ZCojxXghVhXLL87IldMZvriF8u6LVngHng79TargBrX
         x5kveTiO5tJKbDZro4+Dcw7JFfUztS4vOQVzuApjVlDpQEDEnsE2h12pWBVwkrDqFZsd
         ts+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795453510; x=1796058310; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gIo6r+IlTGcpmO+YqtWN+p8Vb41yHG75b/8fYfmBgxI=;
        b=wsz3TOv/BRrOlNOqNq2C5+FRN80XKknBMidIRbfRskX9JSGNoXG/mNuJTBX5K6EIFG
         g9eVLPoJ8mELRNE/GKy6Pso04j85619UVhw7YBP53tnBRwKxsIGRmC/lskHHH5Titjpj
         KoV/boaaJ0jXAwGCtZXwq1IC16XuyQU4dAheztk6O+y1ZOW2BSdWbdcx1kavjV4l9hJv
         Wcqzd/ocSvDp9EAePiDcJL0iz9r+2fir5Ju9jjLY/oRJRhMmwZ3ZIZHLJGbiyZUlJsAW
         eex5QUG0RDtwuD+yD0HupiGcIxGNcyNG9cdwvlRuU1+tl7YFGsGLP0PvShIOEm7fhwQZ
         ER7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453510; x=1796058310;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gIo6r+IlTGcpmO+YqtWN+p8Vb41yHG75b/8fYfmBgxI=;
        b=tFBNzZ2Y/ZRTrm7y79woqEZ1e+AbiuwJrdmC/HPlRYmbNQOfigQWUVuy7KR8EEsE7r
         fOlC8dEfJxWTZp8HzVXhsCs8Bta/ymSPJvoBbvqQWrzgq54LISRT+3N1krqBmPV5iVy0
         wHiV/P+MqN7K/fi3J5EpUdggF421JqFYb3u4GOwHYl1erLo6GLbqUN6/1+JV3KrKmc7+
         YX0EpXxP3GUynE5UcPeOXUwJ27C5d5NVzVf8Smx3m0oXciVEuaXbA9IIIJukCSvXZChl
         hPdatgjUs34fw05g4zl5Vz+qg7rd/tFhLrl3ppmlBD1GHL6FI4rYecPOHBJ8qlCtz0+4
         LCpw==
X-Forwarded-Encrypted: i=1; AL+hErGSShRmJ3MzJk5IkcJCuCnwjJriUfpMHh0guqtmVn1JHNZV9AiTS79GN+CBiMVgVLikW0rrnXLYkW8CbQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+sb5rKP8llkNdaulfCeAJZbJOw2VLUzKgIxOi60HbuZPZ3BqGG
	+Y9aveRRma2doF/gxMtq1vU4GYracOKRbatrPddNkfvs63r0I526qSoUAaVYAvxKCoKdWZ0NbRs
	i2I/Tyd5EN0t2Le01kw2TIM3y4DzKPDM=
X-Gm-Gg: AZFdTZebB+sIQ1r6lwDU8KraSNw1minCdLSeLy8e99VMQWtGeGG/7rj8siTCEReYfeH
	zGAn6J0H7oRIzxB8zJjPTbkQi+ZYI3gY2okdnK8QIiGqcHVL0koAQ6OCjwKIWiTQ850sCSFkRl9
	dNptsmNosuiC5npN0W5y6MGsgRhH1x4UAW5UYumOUclxjA0owEGQgm0BlTAziUh8xw2wPaC0jIj
	7fJpcOWpelp56+Vvk/WdXF5aMtQdD1/A/Ii6K8s1SYB7QcwngwxeLa99Qg425G1x/Yh9EpWQhLj
	2Wi5jr7OTTXMj1Yuf22xSImmBPrfhWJBWHP6ShvxC7t3ouYKnnTixJYLtRGpcbxM7nlz8HU0V4H
	6TQfYGvm5iR4G1zkjhLyEYdfvYM75tmA9/zbNKw==
X-Received: by 2002:a05:6000:2c13:b0:4a7:9630:7b57 with SMTP id
 ffacd0b85a97d-4abb43dece6mr23714436f8f.44.1795453510025; Mon, 23 Nov 2026
 09:05:10 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122130247.2069007-1-hengyul@cs.unc.edu>
In-Reply-To: <20261122130247.2069007-1-hengyul@cs.unc.edu>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 24 Nov 2026 02:04:52 +0900
X-Gm-Features: Aa3M54qGyl-5nhX8w0MHT-aB71DD5ZloTtvWl-1mwjjKRU7JRZiwFoatqGxbJV8
Message-ID: <CAKFNMo=5c=TufoAFXfge_YDOF7RDXgetywO+6041k_xXhsFifw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: count new blocks that a short copy leaves dirty
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 10:03=E2=80=AFPM Hengyu Liang wrote:
>
> Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
> made generic_perform_write() fault in the source buffer only after a
> copy into the page cache has made no progress.  A write from memory
> that is not present yet now first calls ->write_end() with copied =3D=3D =
0,
> and copies again after the memory has been faulted in.
>
> However, nilfs_write_end() adds only the clean buffers of the copied
> range to the count of dirty blocks, while block_write_end() zero-fills
> and dirties the newly allocated buffers of the rest of the range.  The
> retry finds these buffers dirty, so the new blocks are never counted
> and nilfs_near_disk_full() does not stop the writer.  As of now, a
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
> With this patch, the result is:
>
>     write: 70217728
>     fsync: ok
>     70217728 /mnt/f
>
> Count the buffers that block_write_end() is going to dirty, including
> the zero-filled new ones, before calling generic_write_end().
>
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org # v6.14
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> I found this while comparing the behavior of different kernel versions.
> I used an LLM to analyze the problem and to draft the patch and this
> message, and I analyzed the result myself.
>
> Tested on nilfs2 for-next (8fef1a9dec7b) with KASAN and lockdep: after
> single writes (new, appended and overwritten blocks; cold, warm and
> unaligned sources; 4 KiB and 1 KiB blocks) dirty_data_blocks_count in
> sysfs grows by the number of blocks written, as on v6.8, and a nearly
> full volume stops such a write at the same size as on v6.8.
>
> A write into page cache pages that were read from a hole is not counted
> either, on v6.8 as well, because __block_write_begin_int() dirties the
> new buffers of an uptodate folio itself; this patch does not change that.

Hi Hengyu Liang,

Thank you for reporting the issue and proposing the patch.

Through reviewing your patch and testing with the reproducer, I
confirmed both the dirty block counting bug in nilfs_write_end() on
short copies and that your patch properly resolves it.

However, the short-copy handling in generic_write_end() and
block_write_end() was already present when nilfs2 was originally
introduced, and it appears that this bug in nilfs_write_end() -- which
skews the free space calculation and causes excessive consumption of
reserved segments -- has been latent since then.
I verified this locally on an older kernel using a reproducer that
intentionally triggers short copies via pwrite() from a buffer
straddling a readable page and a PROT_NONE page.

Could you please update the Fixes tag to point to the original nilfs2
implementation commit rather than 665575cff098, remove the kernel
version constraint from the Cc: stable tag, and revise the commit log
to state that the dirty-block counting bug has existed since the
original implementation, while commit 665575cff098 made it much easier
to reproduce?
Once updated, I will forward it to Viacheslav.

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
