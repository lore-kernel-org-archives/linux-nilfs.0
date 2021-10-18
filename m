From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: don't use ->bd_inode to access the block device size v3
Date: Mon, 18 Oct 2021 11:41:22 -0600
Message-ID: <163457887855.397824.18265513445295974558.b4-ty@kernel.dk>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qLOjd0XBTgNB6PyT/azLzYqk1pAiNcBYGjkEFHfKgY=;
        b=ZE5P9Htq137UIuHXfQNwUAIKhDIMd9qrsf2igHVAQuchPEiM5CYAiYWAoanrP3BRK5
         +/zJf8ePrK0Jj6aFsn7k0tzQbJ4NIDDMS4qGg/dQVgP7xeIzNbMsehSUes1emc0Oq6i/
         b6ICW3jovK3RTwBeONavI1LGEeT5qNNyH2iVw4n2pIKcaseVQByWqsfKNZFTjpPf5UvA
         tpNrRtk1mQcQRK3VxXa7JqUP3X1jxKk0Yj8Qmo4sy3Salsx557cd92uesoLNkG+Oovkp
         2TGEAb9D58ouYeCPhAyavPDnIjaxSOtdxSB7Ig/cShPev5FkLkYvoHlXTljZivC8+XlA
         UOcQ==
In-Reply-To: <20211018101130.1838532-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-nil

On Mon, 18 Oct 2021 12:11:00 +0200, Christoph Hellwig wrote:
> various drivers currently poke directy at the block device inode, which
> is a bit of a mess.  This series cleans up the places that read the
> block device size to use the proper helpers.  I have separate patches
> for many of the other bd_inode uses, but this series is already big
> enough as-is,
> 
> Changes since v2:
>  - bdev_nr_bytes should return loff_t
>  - fix a commit message typo
>  - drop a redundant note in a commit message
> 
> [...]

Applied, thanks!

[01/30] block: move the SECTOR_SIZE related definitions to blk_types.h
        commit: ac076a376d4c1fa7f01bedad76bab96a981b7464
[02/30] block: add a bdev_nr_bytes helper
        commit: 449c780f68d9adbab2373c996d4341e61c088685
[03/30] bcache: remove bdev_sectors
        commit: 519070e1b8411c93b483fb50511c9d5d7932f62a
[04/30] drbd: use bdev_nr_sectors instead of open coding it
        commit: eee1958b9a7b912fff33319e5737d861703c3a47
[05/30] dm: use bdev_nr_sectors and bdev_nr_bytes instead of open coding them
        commit: 34d7526093779e26c1a281992c7e91662f3afa85
[06/30] md: use bdev_nr_sectors instead of open coding it
        commit: 1a70a0364bbbf29eab22c9fa4b3d71087df940a5
[07/30] nvmet: use bdev_nr_bytes instead of open coding it
        commit: d61ec9eeaa161c6e385f4adebc5d671bc5290687
[08/30] target/iblock: use bdev_nr_bytes instead of open coding it
        commit: 30de91d3df67291093736890b7496620d5025df9
[09/30] fs: use bdev_nr_bytes instead of open coding it in blkdev_max_block
        commit: 011bb9476ef8f9867330e2bce22cf124d034cd33
[10/30] fs: simplify init_page_buffers
        commit: 957c50dd8af9945fde3a3fb6c8baf5d638ef3177
[11/30] affs: use bdev_nr_sectors instead of open coding it
        commit: ec003894a9db3858165dd61fb4cabf9a402aabe0
[12/30] btrfs: use bdev_nr_bytes instead of open coding it
        commit: 167a1c754eae512e45de682e2cb4ea05f080fda5
[13/30] cramfs: use bdev_nr_bytes instead of open coding it
        commit: cdf881e14aa127c7602110d208b3412b1412c1ab
[14/30] fat: use bdev_nr_sectors instead of open coding it
        commit: 4513b8c903782c4f3963172d81414e08f48a0317
[15/30] hfs: use bdev_nr_sectors instead of open coding it
        commit: 311b610de54a52c199e2a129da2c26ad5953edb3
[16/30] hfsplus: use bdev_nr_sectors instead of open coding it
        commit: 03b67c1de5d3b085360f3d6dcf37560f44e8cb4b
[17/30] jfs: use bdev_nr_bytes instead of open coding it
        commit: c1e80b87c3acd52817bea278310900ad2825686c
[18/30] nfs/blocklayout: use bdev_nr_bytes instead of open coding it
        commit: 6b1b53cf606d70dc6dd375aaaab42558cfe7e945
[19/30] nilfs2: use bdev_nr_bytes instead of open coding it
        commit: a24d8bcfd590de5dc4a9e806c9e76558676c2eef
[20/30] ntfs3: use bdev_nr_bytes instead of open coding it
        commit: 9242c8b0b4432b6929b030c729a1edd9d9116d4c
[21/30] pstore/blk: use bdev_nr_bytes instead of open coding it
        commit: 989ab34bd83f075efdae2cf6026cec0507374696
[22/30] reiserfs: use bdev_nr_bytes instead of open coding it
        commit: 8d147b3353c7fd853313521c4f66430d38d66391
[23/30] squashfs: use bdev_nr_bytes instead of open coding it
        commit: 8538360bb42955166d0073ffb6dff6a4b0caa4ec
[24/30] block: use bdev_nr_bytes instead of open coding it in blkdev_fallocate
        commit: 7ad94c3008a3f5e0ff8af1e3ff1c7061955ccec4
[25/30] block: add a sb_bdev_nr_blocks helper
        commit: 5793a4ebc76566fd24d7afdbcefb3311355fd077
[26/30] ext4: use sb_bdev_nr_blocks
        commit: 3a10af74c8f1d390857cf87648573bc4f157e4ca
[27/30] jfs: use sb_bdev_nr_blocks
        commit: cd8ac55f93923c65e18204c99b08a8c4cba3d187
[28/30] ntfs: use sb_bdev_nr_blocks
        commit: 8e2c901e6d1c97bf862514901beaae3e248655d8
[29/30] reiserfs: use sb_bdev_nr_blocks
        commit: 93361ef44a8931d281583ea9c608247fe8127528
[30/30] udf: use sb_bdev_nr_blocks
        commit: ea8befeb35c47cf95012032850fe3f0ec80e5cde

Best regards,
-- 
Jens Axboe


