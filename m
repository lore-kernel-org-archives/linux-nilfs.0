From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 20/31] scsi: replace the fmode_t argument to scsi_ioctl
 with a simple bool
Date: Wed, 07 Jun 2023 21:17:42 -0400
Message-ID: <yq1cz264us2.fsf@ca-mkp.ca.oracle.com>
References: <20230606073950.225178-1-hch@lst.de>
	<20230606073950.225178-21-hch@lst.de>
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
	bh=BevKBuNxLWDyhUiYjt2zlqjEp1Yibc1syhKB7CiDipA=; b=lKdMIDUlcNC4wViEN2ZVYEhkVs
	zL3BSVp05xqQTN8NfwMk+6h01KkXeERjA/5UZ4OebTrUZZprKO66X8intqKtxYWVuQ/1f64pQ7YdI
	fEDLDonMCt4CmWEi2lieVjB3KXMdX9/HwakASY+hZJjWZzCsRtUF/2ruczNltt4HO1Y5e0LAjWcWq
	qy2D5hccF5EBEo9DD0jGk5ctNWGQKcJdNHi2jAa4j6G7KoOVcKrUE/EaTz/9bnW3aeHjOwje+8V+P
	qRV/EgWIyoxE3xrOZGfljkKbv1cv20/97JT+OL1zajVwpiwVvlt0T/LfNNgYPqVlUi2bHyxWZ2k/V
	yFs02QZA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=v4/CXlJ/iBy22vMpAp7g20FImsP9uXza8CjxceCn+7u8u1SZeK+aS/1jsQFbvJQgTx23
 8cJmTZky/ScfZHWmcj5hOAnoEsN/Q1PyxPSPsl+entrheXNxcaXwnjzAQo4jKZOQp4bh
 phUnMCBmuc2LNvabK0cjYJoTEoDIfMpYtkiEMpt40pyggrFxsQhwWoC8ohhvoQLPp+SF
 FSBxFDCHr1v+sHSGp7O6+XJcdtfwuSg8BvDx/2vj6V8r7OrqwHQdzBaSnrlNfK2YRvaN
 zuoDWXwqKSHoEEWa8qt+Nocv72u4ID3DNB/6FEhii8OWE7Tli/dUZB9DJI/o9IRFey2z Hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=XnamG+cZow3vCiLBE47Klt7Bl8LKFa0t2auFId2oMR53kybnv4W9qaIix2fHyxfOLp2HzdKXUxJIiTZC35n1fN7D1HK4ZRCNrecpNAPRNLaMqDpAmWUcbqKAIHbXmShhJ+88xB78hWaiyicnEL7IfOsc78YrYGS8D3xNvpgEYrM=
In-Reply-To: <20230606073950.225178-21-hch@lst.de> (Christoph Hellwig's
	message of "Tue, 6 Jun 2023 09:39:39 +0200")
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
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@l


Christoph,

> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
