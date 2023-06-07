From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 17/31] block: add a sb_open_mode helper
Date: Wed, 7 Jun 2023 10:55:20 +0200
Message-ID: <20230607-ballverlust-notstand-c4f9b36c6af4@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-18-hch@lst.de>
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
	List-Owner; bh=auHhI++f8n6VmcbTJS5muz+J2IZKATQG9Q3Y2NgiWmk=; b=uJbEG0F0PlR6bV
	+vFaJCw+mc70qtsNFncSjVvWX66Q6sV+kDheQ9QXTKbdXkNbtXh/qTCr1y0QSdaVfZzU6ouxrZ/D0
	Y7M5x5eFIX/VlwmugXUjL8KVGIAuB+fGmxi3Z9+qIhHU5p7SfAGpuI1/eJYn709wtKDFyJ1RxpT3F
	qpn9nrY79XsDl5OmYRdM04QrZZjhCPK8SUWOB5IVJQ25Qi9clgRZ9ZHbbzFkoRhRX5DW8tHAhmEw+
	5+GDphqQMsNoyhqX+j8R3i/JeJTtwTThmjPXn4Ur/+8ejmrBZy2hSR49Xplvjg5OZNDEz8bg1RLa4
	fR+dl2BdlRtL89ekkVVg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128128;
	bh=FoyjSRZZap6QVtk4PUjAg/56aVYmk7Q/bKSVf+qsCpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lbLPSEzx5CHmJxbGbMCZtSL+WOgA+Ir+19+KzebHBOcStdriYooqRFCT5Z85L5SBQ
	 26HQ8bhocu6wvemqw13N0fGcVjMBRXTDOwCQLDmfzOEmX7ULrDVKcbEwQ6RgCJokv1
	 LwwrPIPH7Dy4Dqq3Z1/wJFPI+nCdq9XhVYQv9lER7EKMRobBVVmCazkd0VI6FPwQYd
	 0aqANlbYbCCg4IAbUW/09Y1bmFZmnmzbyNy0/ajwIsz0dA7ufP/Yer8+FEBJ0alkmD
	 C7h1CsWGU6uOFwKET7Igjn6D9mKWpSspjotrIzNqf/5Wvwq23wfp2KPy2h5RhLAsAf
	 pjxzISbJRmiew==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-18-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:36AM +0200, Christoph Hellwig wrote:
> Add a helper to return the open flags for blkdev_get_by* for passed in
> super block flags instead of open coding the logic in many places.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
