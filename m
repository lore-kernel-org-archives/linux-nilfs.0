From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/27] target: pass a block_device to
 target_configure_unmap_from_queue
Date: Wed, 06 Apr 2022 23:07:07 -0400
Message-ID: <yq1lewhk2wm.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F3x6P1kenH1Hm7uyRz1muMBaUZJEydwA1QWe1BNT6dc=;
 b=cfJmdlT0b28dv1IZ57X77wNW/0fqQIlICfwO+w21wI/1c0lHpUBi2zuV+EXoHxuLCx9+
 gzqua7rNKLsJh19hOfS/0zBGvCfkCYy2lrweCkMd8JtuJNhLctuWbAoww6EZ2zply3JC
 ZIqbDi1nv88R8J2m5pMK46KWih6U/y6utEmvmiAxqETsgHdTNSMNSF/VAFFXPW5xmymY
 5RqSgSb60kNgdK+p1lDvCcexMmB0yW/JWqgG+vd6dul2009SoBlCouO+lunuW/I1DRXe
 dOiSjL78iwHW23gE+ZvYCuXRRyi57NDTPg+ynkS2WqJlrCVV/u5tO5CQddADUltB1K3M dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3x6P1kenH1Hm7uyRz1muMBaUZJEydwA1QWe1BNT6dc=;
 b=N2cSI0L09BukAAC2ZOhx8qz0NNNe89edzYFU8Lh//FiCv7KyzXtkTUF06NH7q3cG/ftto95agMLQfKat2F8KX1qQeVJcG6DjvXQsplX2Xi3h+93pjoauE8hqRXxIIDcnc980ndgEcHjUtm/2hTkzz81u8UYXtss6nYLKbcgIdLw=
In-Reply-To: <20220406060516.409838-3-hch@lst.de> (Christoph Hellwig's message
 of "Wed, 6 Apr 2022 08:04:51 +0200")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org


Christoph,

> The target code is a consumer of the block layer and should generally
> work on struct block_device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
