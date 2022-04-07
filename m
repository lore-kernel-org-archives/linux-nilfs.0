From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 21/27] block: move {bdev,
 queue_limit}_discard_alignment out of line
Date: Wed, 06 Apr 2022 23:27:40 -0400
Message-ID: <yq1k0c1h8w3.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-22-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jtZFiukrDrNaKwudMOYgmK4y6ZDoL7W+5uSf9uS4Pw4=;
 b=syOONMklItTPSXz7KtfaCFVFE5ivjGKYsK8owDdJX+p3veRe56GBeWrYdskEry8eGz2Z
 c9zdGKmBs2gZ2XoUbepmD7qQNBxG6tQ5j2ZUx60TtC8+OdqTmLjVFPsmu3BiSk4h2g9t
 iWHcR7KAWHZCsLBwzDWPwabAUA3V8+/vKC252bPJ1HkIMYaLe74IPGnWTpuUh6GI0b2P
 Tje7hyIT9B3Go36b+Kc8u8F/RbQoq1L2rEe93W5y0GZpNb9PLi1p1XDiIvz+wyNt01yZ
 eONd83VdVCQnI483aopIRy7FIm9GO4/Z/SyF64TYHe5SJpXrPVZUZw5fskMd8zi7M+Az RA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtZFiukrDrNaKwudMOYgmK4y6ZDoL7W+5uSf9uS4Pw4=;
 b=vuBysj3Y0/+eXCH5ZS/chYtrN3+muZXWmhOCpB/xsf7NoXSCf/3vEpQMNch5Ur9r6rsK34Pi20wMCNJ29aTdL6uEEu7WI0Vqq9dVOFtbU00VQcA24EjTcgcb42dwOk/rwLYGr0OH620LYgGh1VqJ8BpFXmGir4EOIwE5J6IregM=
In-Reply-To: <20220406060516.409838-22-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:10 +0200")
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

> No need to inline these fairly larger helpers.  Also fix the return
> value to be unsigned, just like the field in struct queue_limits.

I believe the original reason for the signed int here was to be able to
express -1 for sysfs. I am not sure why I didn't just use the misaligned
flag.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
