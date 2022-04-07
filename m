From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 15/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
Date: Wed, 06 Apr 2022 23:19:34 -0400
Message-ID: <yq1h775ins6.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-16-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nG3sI1771Qzwkix+7woUumXPeYpDKLLcIMXUM/nZXzc=;
 b=uCX4EVIMxM0btfDpTw5w1ew9bFLCrQilscmuwmVdRolfLJunbh9KT5j69VKpBFtOcJAq
 ObSXwXW1pjDG1XcmTA2ht9GIUnTTPukHcg63rNhtrS2pFvtUQU30jO65uVjIMPB7TAQ6
 M3z4ik2IbLzB7K5bswElc2TQSorNj2XqvboFkJ0QDgkOI0JlZpNXTZl+3TF/DJajXHTk
 8hGfsTiGys+WFrXr7iEbTTgcs7X+hTPGSqmMwHaLtKUw0KaZroaIflimn4O+OXx2aqdt
 +19y5fxddpLswZXH4y4t3+qmqVkl+7EYZAckUFjvjawOty9JLhF6oHbEW/rqImOgBjYX wg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nG3sI1771Qzwkix+7woUumXPeYpDKLLcIMXUM/nZXzc=;
 b=MLUZOxgb88Mde+78DEy0UZP5WVFusHEBbq/vjQIQIR8r4BS5W6s4Q8aQKGyXqKdDq+YD3vkzyihq8zM4+GZd7fMViQopAcLx4GHajrlD6Rr9AsisUc1bzBPWRbjcOU4KxtbcMR1Cp3oF+HFP8EV91//bwMu30rzG0ZlARgkOTv4=
In-Reply-To: <20220406060516.409838-16-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:04 +0200")
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

> Replace the open coded offset calculation with the proper helper.
> This is an ABI change in that the -1 for a misaligned partition is
> properly propagated, which can be considered a bug fix and maches what
> is done on the whole device.

Looks good.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
