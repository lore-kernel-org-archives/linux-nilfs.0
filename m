From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/31] ubd: remove commented out code in ubd_open
Date: Wed, 7 Jun 2023 15:08:27 +0200
Message-ID: <3e04efc2-f9dd-0675-1fac-fc3903b1fbcb@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-26-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=zvtsjkmcFCxrzBD4hpSzVtFEO9+a4OC813/8tdPvvIU=; b=fX0c0ABq4LShCp
	th6IFqJEU43crQC+S5U+Ylo/3lTgo5PweWqdzhGJeMHkmkk6jdhN6OIlRYVDN6RFtYpSWhQN3qDc2
	Qxv7KX+BvipVbNa7XJn6C3OHRNJ2+u6XUpZmt3WCYZ1Sp5LyitBfSykCyl1747VzVEZvm1U8UbZnt
	LAD4GBnIA+xU0CbOINv4cWHM6hzUG2lQybND9VS874P6WVliPtB2N/4jWebpEZiu3ftVEUHPnLGWN
	x/MbhMt1I88fwKrGw2SM4bfvWSakgDiwkxMZcQNc6Jx8+F027q8n85geQjI0qMf65c4jfNUA1Gbe0
	vKjRsAGbG4A/ZVXhKn7w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686143308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7c7WodeDtNpjUczv8+eIXLuhq9h/8jtLxSsWcXS9gw=;
	b=D/C4L04h1rP5J6hr6cun6vBK1odWkxm4oiZ3+bCIB7YS8rxty7MHJVgSr5cBIKVyaVc6/j
	V0wu45NO4rPRln1DVSrmcF2j9Xl9WQIoXFic5XkOpuGmPgiadhgaVNlNLy3EtOWtfwwsjK
	uhbIcWet01WVarqPebK8GrhUkjxtklM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686143308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7c7WodeDtNpjUczv8+eIXLuhq9h/8jtLxSsWcXS9gw=;
	b=+m+dsjXNA1CdOA3mnKYfSUl/F0sOFe+7d2pbdstHXWNJuYW/QJaxyTdqFGeyeFk1FL9aSU
	R2uX+N06szza/bDQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-26-hch@lst.de>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kerne

On 6/6/23 09:39, Christoph Hellwig wrote:
> This code has been dead forever, make sure it doesn't show up in code
> searches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/um/drivers/ubd_kern.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
