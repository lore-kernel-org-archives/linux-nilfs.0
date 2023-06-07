From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 16/31] block: use the holder as indication
 for exclusive opens
Date: Wed, 7 Jun 2023 10:49:55 +0200
Message-ID: <20230607-umtriebe-absicht-0b2232e4f212@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=+DwSgaof5Ff9Diex7RS3TTV47dYszHEJKASYIHN3t9U=; b=S11Hix1EMFF+x4kzTQsWNrJB/B
 mCAiFK1F9Bo6ml9O4sPUTNTryTuvZVp2Tc4f9ZP53SX/Yl5W/Ucw0HF4uQJ21yVpUcxaU09VaOtPs
 zPr29+RvUxKC1l3C2SADIxLtvNSRmrL7A1u9Cp3qmjj971enm0cQOpipfmxndqtkDvzg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=+DwSgaof5Ff9Diex7RS3TTV47dYszHEJKASYIHN3t9U=; b=iGjNSBZCI/NpNQDjWmhxgl/VSL
 f7THhh/+6SIX8uuEqDdttfsLB2SW2dSG0KYIHQ5swBAi2SK3ygG3V0rhLpjHjyP0QaE7kaQo6waHS
 FBSLIi/oNj3NXukOty8Ypegp3qB5dqiJY7mEp0SmJhNhE/i/yXq6oIQj9YZNpWrgNOqM=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1686127803;
 bh=PZjCdaHviY+RVqpZkaQVixpnvUVrPR62Zf8+mzHD1uk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=psgkq590ELlnR3YewhzuAje3f6nLqAdxD2ks0a0ex7l9AURvWbDqzYkAaTTfQ3LRh
 lbjVPemFfDSDVxbPW+yVAYbVlRK2mYcGkDU+s9QomicwFqaBsiwabN/y6C+B9XbF7a
 TUp8gIDqcrYKdDf1/ALLYLXJICKJabskE/hFOC/X2WxRVUqsCWuBbuBtyCKTR3JcP5
 UshWyePpXwuCBpPQlRL5oU0JjL5XQDDGrzAY9Q4EpVcVDZmW/DwUYrjmVOzW63Jixr
 ioDpPQD0ktu/OZfW3TlmJmEpP8gCBlQwrZ8iPtiqN0Aky+ak3ORBZqrV1HDSve4xiN
 ZX/3XM7Ql6s/w==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-17-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, linux

On Tue, Jun 06, 2023 at 09:39:35AM +0200, Christoph Hellwig wrote:
> The current interface for exclusive opens is rather confusing as it
> requires both the FMODE_EXCL flag and a holder.  Remove the need to pass
> FMODE_EXCL and just key off the exclusive open off a non-NULL holder.
> 
> For blkdev_put this requires adding the holder argument, which provides
> better debug checking that only the holder actually releases the hold,
> but at the same time allows removing the now superfluous mode argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
