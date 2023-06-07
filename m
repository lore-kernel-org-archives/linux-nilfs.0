From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 18/31] fs: remove sb->s_mode
Date: Wed, 7 Jun 2023 10:56:29 +0200
Message-ID: <20230607-fliehen-abwurf-56e4abb8cc2a@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-19-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=lbQ+kdVdX0BDaXL/E7ThhUXOvEQSgyIV4j0D1FH1cr4=; b=KUyDFUTT97De5S
	pwGP1YDU5EyT0BBCOnrXZdM7BS/v3ef2Z3JQ3rzWiyc+TvE06Os3O6yRNmE8xtQa2OrHFxqcrLutt
	kcnRAbrBhP0SDySZhm9D9T1Wv0GHlT+3dSQEV2ztHYGC+q60R5KclUD4BVaTYPd0B8N/2Gc6iKVSi
	0JBj6bFLPa1XuEvarD5hNHIprDeIxBwdHWxWQI1W3VEPfQN9g1WFLxfT0/YecwAWg7CR/vwP1o7k1
	+PLvpp/cbJt8tO15dQIdwrR6+l+KIxPyDDk/gdFUlxYfcOIZE9Ps8RjZIcFZPSwjMyVzNtU9d0aOr
	hFIGKbuv10CAW5+vaO2Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128198;
	bh=XuHwZ7uaJVjyv+iO/vUQkX77q29hjzoGO5w56uvjEOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DeEXqe9gjxY57lITqd/lXcoE1Ca1KQPvngcywi2EuF55EYz48E3pBAh+rBHch2qBA
	 ypy5YdNuEogegS0vPCR+mV99Mk5TjM1rLBF97+R9HX9ukYW6ykKDq2gqNInuZMB6Ay
	 XHzbm7kvaBLnWy14BEPIjrerESWXdSFPaBlrm0swncJDI/92I5eylBFX/moeEz7CG1
	 vaPZG0fzC0csi3IKOuDwjj7N745wxtG3agr3NgG0FuEl8trHhZ//gdGhKV06s6qy39
	 mpg9F8OAP6YYyEg/4+2k3U5GSd1wxRxtUnh4mR7ZFx9c5gnEAxwjVBNp5aPITn0SFx
	 tka8Sp1jBTEXw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-19-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:37AM +0200, Christoph Hellwig wrote:
> There is no real need to store the open mode in the super_block now.
> It is only used by f2fs, which can easily recalculate it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
