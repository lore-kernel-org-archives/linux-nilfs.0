From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 20/27] block: use bdev_discard_alignment
 in part_discard_alignment_show
Date: Wed, 06 Apr 2022 23:22:13 -0400
Message-ID: <yq1tub5h92g.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-21-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tAPmbbaCkvVZPvRGbdErqYJrUZb0QsK/3MVtxkvtM78=;
 b=U4YAcWA4jAisZZK//5B1Q0Bz/XRLUueeIrA8QtDqWbfRoJFt6ww6ZmEUob2Y/jy1sDg3
 VEi5fCC9yWTf3nvupLHm/YIzJPr7h7ZwuiJ+JTcuJZCb5CbP7NmlaLnAERPFAnOYbOYE
 +h9ql0/JQJboCoKu9y6jxoiL5yjQj1LOXIcN8Hk7tIedSgevMXYjg6UChMxtQr1PKZzU
 NtBFsW+j6C9r8V7FhFq+QTNg0BBhAXzF86OpyuXQw+KKI1flFf3QrS7/jbrHoGmM1fXm
 GO9VW1PZsX4FHp5zwhKsd0faRseJ8aBOcK7adMvInz51QRy6VmWGQG1Ss3Z2TSDrpSxd ZA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAPmbbaCkvVZPvRGbdErqYJrUZb0QsK/3MVtxkvtM78=;
 b=MRrjdMSLg06qPTU3S1SGeGQnPR2zAejXn14jAWS/xhEBAkGh8Oc9hT6qEzuPeQitZqKnTnE8YfcgmlrYrC06UJGXooPq++fgLAPl20rNvALQPvprAiZvRAXk1/H4MNoVbfWPC+3bcuo+ndYbontOUqr7e/eHqBypLrudSwOC5Vw=
In-Reply-To: <20220406060516.409838-21-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:09 +0200")
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

> Use the bdev based alignment helper instead of open coding it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
