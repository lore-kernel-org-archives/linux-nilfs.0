From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/31] cdrom: remove the unused cdrom_close_write release
 code
Date: Wed, 7 Jun 2023 14:12:06 +0200
Message-ID: <3ec907e4-be67-4c71-cc8e-7a4c3fc1ee49@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-5-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=QgjdG4eNLbGrp+7c8HYdT61joy8SwgE0kJ7U0Ns2PWQ=; b=jDnUXhZwJsh7A/
	yJ9052iRET0rvn8f4h5+fwQ4toWJILEvK8fwcG9g7WkPxFKZeHr8/X25SLhCRV9jf3qY7SNFdEhmw
	mV6yP/HcdxSEGqZlZiyUpCJgPMtnsTPPGtuVfgnIUkoMr2brrONnt2eJ99aXYCwhstMPNELvnCCfY
	zadETvAHK0PYIC/Bc3r5wUUiyF6f7fUe4hgODWbeclYq5Iy2kcKWrhlc5nFD7tSXU9pYTy6yKUWin
	Jlrcc6xUSTXrxiPpid1Bo9wi7Fa5Ake8YvH96ul1tYPOco0Fs5k1ttfIpA9ZLUKxQgnpTImQdx+fn
	AwtRUj2tI/JWlyB6y5bg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686139927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kSKCe8oZoyZMcDogEE/qE7Z6EBrzv4KI4NwCaOjIs4M=;
	b=svf7Imv4W+4g1nQDffBPgRp7fWxl/gstwchJWVNLRECMOZsV4tK1sRuhOanw3WTuF5Ulxc
	jJk9YW8nSaqkh/UcZBtnzEjtXdEN66kaIlMoisZktz0OL+uoJWBbRKmbXq4IF6n/+k111O
	B85jn6arlNKfMEJcrUwBTFhWWeSAHVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686139927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kSKCe8oZoyZMcDogEE/qE7Z6EBrzv4KI4NwCaOjIs4M=;
	b=umPE7TI+7bUBW+WS2fPqJZMRRu78DBaWAAuPSpQLR98tzOtUtySxDo0e6+OLeNaq2nJBN/
	J4qiH+7l/9rvhbAg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-5-hch@lst.de>
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
> cdrom_close_write is empty, and the for_data flag it is keyed off is
> never set.  Remove all this clutter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/cdrom/cdrom.c | 15 ---------------
>   include/linux/cdrom.h |  1 -
>   2 files changed, 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
