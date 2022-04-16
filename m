From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH 26/27] block: decouple REQ_OP_SECURE_ERASE from
 REQ_OP_DISCARD
Date: Sat, 16 Apr 2022 10:28:49 +0800
Message-ID: <ffa14a07-b8f9-828e-97bc-cf7a2099bab5@kernel.org>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-27-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650076142;
        bh=64fC476XAzTfqTSPn+hnDLb+pMKn+pGg/cu9T2ZYoeo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YR2swQd5bHjAFWTiUHuzi2CBAoBviVOC618ZH6KrZjKGz54+nb14CQuuZA/rg7rT4
         HOUGUM1/um4+uLyDQbz+2PZe7eFGngBlsNfmtF55BEnpI8SeGgAW1TB9RPEF0hZ/gu
         wadS+mRuD6cvw4fVgc6pYN09yVoj6blhm7pLMwx6SJQPqerB95uO3eDsfGVZkI1tAT
         ypjbfbxn7+bT/FWjnusepnTR0gEoGRsC/NgAvlwAmFKhGsjLJGRbec9W3gsrNwS1xO
         /N5W0GD6Xr6BMAFslHSxbnYfv+w/HrqJWAmw3dvOKrGV8WDuaNAVrqQjvW1ASku3np
         CHDdJgFxl65YQ==
Content-Language: en-US
In-Reply-To: <20220415045258.199825-27-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, Coly Li <colyli@suse.de>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-raid@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>

On 2022/4/15 12:52, Christoph Hellwig wrote:
> Secure erase is a very different operation from discard in that it is
> a data integrity operation vs hint.  Fully split the limits and helper
> infrastructure to make the separation more clear.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com> [d=
rbd]
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com> [nifs2]
> Acked-by: Jaegeuk Kim <jaegeuk@kernel.org> [f2fs]
> Acked-by: Coly Li <colyli@suse.de> [bcache]
> Acked-by: David Sterba <dsterba@suse.com> [btrfs]

For f2fs part,

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
