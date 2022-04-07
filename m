From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 19/27] block: remove queue_discard_alignment
Date: Wed, 06 Apr 2022 23:21:43 -0400
Message-ID: <yq1zgkxh93c.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-20-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MwpJLE0ch36RZGcSE+/AeVbeOa9UnzSlj2os7foWWmM=;
 b=BpVrgP7pZM2rYu5nt2t4F2ysbF7RJDV+g9efkP5dlSDOob3JAcqdY2u9AXbeQp1X2+Im
 vMrro2GAz9Ynd9mCgwOafDJ8CRk2pV9i43l+iHJewXJYg1reuA2CVL00+vBPMQnjuau5
 vzUTtYMpLEyWtLwkvvwVt2k+Hw7QsrY5PMlkAensS6qqS7A4356N8aS5Cr2bs1Z9EJbK
 5xbQEKdb9oE2mcV1Jk/OLsVAQA2qfyM1kNXeP24E9wfqVwsb76trveL/s5sMReitLnLP
 t/FS7582ACLN0GXLcJvvOyLgj6pvU3LQW5g+LfnQ+fEkQa9/g0dqfQwTNTetZHI1MdxE 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwpJLE0ch36RZGcSE+/AeVbeOa9UnzSlj2os7foWWmM=;
 b=tMcNZkT5xkLgKFbWVgLhopqHkckF7XJnf18ykVhh+q1o39W9Ccu73TKumF/tHb6zkFnfB9v2K9ZOK8Xvk3i50Hao7ter1Wg/aUZkU/cRwOMOd0Ly6EPFjQkFesTlm9k07ftmb2F+sM5bFg7FaDa729P2e/lXrqSSrpiBTn4PWiU=
In-Reply-To: <20220406060516.409838-20-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:08 +0200")
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

> Just use bdev_alignment_offset in disk_discard_alignment_show instead.
> That helpers is the same except for an always false branch that
> doesn't matter in this slow path.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
