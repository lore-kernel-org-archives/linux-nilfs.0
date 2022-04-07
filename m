From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 17/27] block: use bdev_alignment_offset in
 disk_alignment_offset_show
Date: Wed, 06 Apr 2022 23:20:22 -0400
Message-ID: <yq1bkxdinq1.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=m/EtCka1eaYsLn4wuLA71mCTmTy3QS19BJ8BeeqSuOU=;
 b=ZPHXH9uSshBLgJPOxwZdazVTI+3fnYybLxHdKrsDfbz5gkyocWDiaMS5jDrpJhY6dH5t
 e3roP2aEvv+YiJGGj3Z3QpMrYYwBTf9bl4ClquniFhHPfEJr4qm2Ds/oGFYCcZW7QCdw
 vQNumMDNVOrEzJbwGs4lvvr1Ud3XtzCYD36ZWDl8nKE3T0bnZudKB6NDXQ2OkGYiGJ/r
 DBND1X6o67sgshKOphRvOHMKUI7ve5ERUZzP10He02rnpHiV9o6r9EN38BXG5yjXwQQz
 Y28XuFlAWl8LJodhIZpPSjsQxEVlq9XeTW3ytrox3m87QG2hyIs+lG1EQs5JwJqYG3i/ SQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/EtCka1eaYsLn4wuLA71mCTmTy3QS19BJ8BeeqSuOU=;
 b=lOBRSf50M7+euaHqSQJt/7bPr18Dmc+z+Fqe83qmUYBLJJ/bEGizprCo/oEl8XGt6mapacdyPV+3KGVKaLZ8is3TCEoJBoJgCZfZbSxXHItPhMnaVteE3B4spY8AJHFfSKMwrv0MJPLGFcP+6oYuxKa0fqqZkuzccC+75hZgJGM=
In-Reply-To: <20220406060516.409838-18-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:06 +0200")
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
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org


Christoph,

> This does the same as the open coded variant except for an extra
> branch, and allows to remove queue_alignment_offset entirely.

Also fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
