From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 19/31] scsi: replace the fmode_t argument to
 scsi_cmd_allowed with a simple bool
Date: Wed, 7 Jun 2023 10:57:57 +0200
Message-ID: <20230607-lider-beilegen-479e8cf3bf53@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-20-hch@lst.de>
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
	List-Owner; bh=Wa/rV+545v9HFF8PvH5yJhpSoplAyqKdtSoVGh5bUWk=; b=CuudFJ5kP2SE+3
	XKDb1t5i1ayi8vwg+1t2zH5TNmioQTqAnEUx/UeTF5gLnT7tCJczSpviOx4rPzVvXw7KFhryV8utK
	S5GLRCjcsnPPO3zQkMUEQwkJfBwHG2qN5xJLxaMcNuxTYNaia7Zt+AD7tbm64n2eWPY4RomyscvCB
	zxeH8fgmuVowsLAcKbz3g5z/VxC8ipuY9iZVtLMrXbOxRmIu5f9nZiHBKBVFZexA8MXk4/CdBCLL7
	6nUdi6inW6RWk3RVe1umC0VJiQYrd+UWF5EIxzof0Xj5s9yuU4yXq9qQEuzaVdiHyIaXMQlCJQoSr
	hTFhowuPBqJVkUJySZng==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128285;
	bh=SIZ+eCgOkog+Q4s3tUge5LH3sx300bb23Eun6BFPrew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYAEqX6oV7TKK7FpSkgUsEVya9xhUy/JPhJiRGLYoOYHWT1I2ULOK7XHs64TXfoFn
	 mK0rDwRkYd2/GYZAlZLwNyS+CJKOhsomUkO8JCiKie8dl/BRiOTeonBmS4PvPu6ieF
	 sVIi5srBClDyYqHINc4pZYt7suQ3BTKRABwS7pHU3VKKSKaLzQS0g/VYlh9aDEEczz
	 eubVSLgoReF59GWwxGcQxODeBBcSFZ44sZs5+J+yLbcDPSbVuucJrs8YJ3B1hEkc9m
	 wEFyAXRiqWDpxiHtJcXt54WBqY8AcSWZsAoORertZk2ph2t6aW4EyYiUKsHKNUhrA8
	 yd5W3CUGhJ54A==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-20-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:38AM +0200, Christoph Hellwig wrote:
> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
