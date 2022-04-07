From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 18/27] block: move bdev_alignment_offset
 and queue_limit_alignment_offset out of line
Date: Wed, 06 Apr 2022 23:21:03 -0400
Message-ID: <yq15ynlinou.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-19-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=U+fTrz9scjvUlmcuDEtUdP2MIqdifGmBnbiweLe7F2I=;
 b=YUMdnGZuzek/W+HawPDaaLfxI+Yo6VABZTXVZ6R8VbQc924wt04u0sirTy2Iwmbk9FVl
 /OpgKryhR1e3Y84u35EcxlrfG+CRudZayKtWXhZ58oLzkQVqUhknU/gQ/BTvDtmjSP/l
 Ke+S1e7qTo6WD0F3OCHx47/sHT7F9R8sfpJ9Uy2hQ3h1SeOp7P1QTjGq79xi+8LNUyVf
 PTMBYdQrUC/zUulYntbR8hQfeiAXG7mrqrQYIpxuy9v6IPl+ojNDqwos11kNCNNxNXPb
 iccZ7AYkq/524guLzOsAePFN112wVNxb5djErynah9vV1tKNLr9L9K2gHlamHeLCIRcw sw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+fTrz9scjvUlmcuDEtUdP2MIqdifGmBnbiweLe7F2I=;
 b=n6+ILMx/lQ/iZCxB/hOJR8YGSZRIaZea8Df09jCCjgZ8OlXeLUbalIT+V4dXlarVBJdC4RZsLkoypik2s6KdONmO38tGRXYkPsTC1TzEiO0A4DzLQxgc0lMVLjNjMI2zzGUAUcp5oSRB1jswVpBmemVd+7n8AVKTahlyd6OSe4w=
In-Reply-To: <20220406060516.409838-19-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:07 +0200")
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

> No need to inline these fairly larger helpers.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
