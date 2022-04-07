From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH 03/27] target: fix discard alignment on
 partitions
Date: Wed, 06 Apr 2022 23:14:35 -0400
Message-ID: <yq1fsmpk2jw.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:In-Reply-To:Date:
	References:Message-ID:From:Subject:Cc:To:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Owner;
	bh=JB2kvT7L07oBsKV87yuvSdoGh/I3GY9vodfjhhqe0/A=; b=I2bHM5mQuZVSGLWy0F2R0EhURs
	ocW1NUdHdpcY4wIFJOLYWlOI1V81JlQXM23aRPJ+gIxwxywdWIp+VU6XZgaQINjg1eS/lej/96t95
	cLk4MNcoqyvh9JbsJK2OXCTgJI6vSOTnIF2L2QhLRpqqSbuHIV/jHjrCQYCNc6s9VLTE81k8v4Ugc
	F836fxTaV39aBLXYqc+gFay0pP/522GXB4XsbfiVXaknQf57kObBm9/7DKHQia1XnG09yKKDMTVM8
	5bLSArZhxIwkNIr7h2JQGoeoDQITH5wk+ACXYRTvC5fLr9BnXA9M8sXYsQwBC9uy4FY9am6ADC9P2
	GHJgTMRg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/V0Fwxr5Zm+y2aUbPU9s25E9VnsikKMkCQTHQ7fjVfw=;
 b=i5FMU2e8LcZtJnTYkwV6E8F1CmXHTpq432Z3UWXvhHLaaqaB1qLy6grINx2kAbYvfYer
 SN8+/U4jQlO+0tJQjU+RPhn990QZ+/KevL2vFVzK0vh6BtHNWBUaW3rP8TJIRu5RxPuv
 5q2FGGgnsw+BcWFF1Ul8Va26S+QruBwCczAAZMsHEiODM474wY/Lvn/qpjgofktuHQbB
 rQLE30y5Jj2kFRYSzXmvZ2Kccneww/aRTF0VL25SLIHueHK/uGvY09oouCorc2CXAmuQ
 F+gCGaE5kiQpxNaK/oVtrj9/VdkTmpTFEg/S0107fuEBTxgj0Cf4xnG1niTDoPoQ1Vjv dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V0Fwxr5Zm+y2aUbPU9s25E9VnsikKMkCQTHQ7fjVfw=;
 b=eAUxHlJe9dYjSx39nvRTqPMnjkc8ntSDSTlBA/YnG45Q86Uzz9W4anDsjmFExxI1AkFiVdGg9+f5xOEQGGa/wWlpAf4FhZuqEND5u7spmQS8Pk+9zF2P7zUDPeb0EJIuMcTWbIQd4f5YhGwoDsPmrUuRlVkXD23e+HEZ083OZy8=
In-Reply-To: <20220406060516.409838-4-hch@lst.de> (Christoph Hellwig's message
 of "Wed, 6 Apr 2022 08:04:52 +0200")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org


Christoph,

> Use the proper bdev_discard_alignment helper that accounts for partition
> offsets.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
