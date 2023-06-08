From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Date: Thu, 8 Jun 2023 11:04:44 +0200
Message-ID: <20230608090444.GA15075@lst.de>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-7-hch@lst.de> <ZH+6qd1W75G49P7p@equinox> <20230608084129.GA14689@lst.de> <ZIGVn9E9ME26V0Gn@equinox>
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
	List-Owner; bh=WryMWEQVtX1CjnFl0zm0G5QnT+hONfH+tRXT4YewD1M=; b=Ravvi6hv868g16
	OXg6CJaR0AVb0+9YTCbPx1fviKONPKYhfDvpR7VKbscuKRL/yToDaoPHAyW0mTden3R6wWZX1yCFC
	rliHoWLMRMGS8my03So9nT1VgfH1LTTZ7nLsYWokQgNc3HyJSKu4AMO909NHjZ6N8EEVE6sacHgAf
	xNoObMLP6SZvkDK3mVWOLG2BTTzdmGdUHo+p0CghydSUHtb8IOGiDqS+z8EUU3LyvGPAvcbwkFDIO
	2UOtZrMCvyjTVz8oprudVJI16Y+8m3/Cj6yAxT4HOCbJUPTl39d4sgv6GLfWRjf6BGKynHxVgnylP
	h4hTV6/ZaFwMt2s97iCA==;
Content-Disposition: inline
In-Reply-To: <ZIGVn9E9ME26V0Gn@equinox>
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
To: Phillip Potter <phil@philpotter.co.uk>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org

On Thu, Jun 08, 2023 at 09:47:27AM +0100, Phillip Potter wrote:
> Yes indeed - I was under the impression it was appropriate for a
> maintainer to signal their approval of a patch to maintained code using
> a Signed-off-by tag due to their involvement in the submission process?
> Apologies if I've got this wrong, happy to send Reviewed-bys by all
> means.

Signed-off-by is for the chain that the patches pass through.  You add
it when you apply or forward the patch.  Just give me a Reviewed-by
tag and say it shold apply to patches 1 to 6 and I'll add it.
