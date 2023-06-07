From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 29/31] block: always use I_BDEV on file->f_mapping->host
 to find the bdev
Date: Wed, 7 Jun 2023 11:23:31 +0200
Message-ID: <20230607-thermal-sohlen-1ff852d8a99d@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-30-hch@lst.de>
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
	List-Owner; bh=VdbiL1d5iz/lh4nP05g/urwa0ExwK9hGuwJog46Ybrs=; b=OqLdnIaqG0cK62
	YaORzyFxE7Y4fX8bxKtBv4c4//aG/QZxSOmnguvuAFbGl19DY1Da+fs+zKFeFlTJ7G32RANaCvJZr
	Kxbm5hxrjo5FRiYFeGERLqOydocNAwEy5DHXbjuOFoucLIG7mSDT/LxyArKwQkx9FaIxfOrEQQfvR
	H8FezWxLx0iqZqW01HfzrIQpvFxM0YcXsfxq1CsCtGfI4hRuC2znJ6voqePy1efBfXiG2SveFcA5J
	q0aLp/uSYGMK8i0XgVQSLPn/RPFojnf0Y/2ZoRyF74800jhaS7H5z4iT/yZ+3qenLg5tAtoT79fn8
	C5DGyLWti1JlJ2RGTUXw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686129819;
	bh=2dBZxelf4g0w/gdLM0HKDBqAqVXwuGv1PlJcXlPn9lY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FA37ryzewz3+4K4l8Ktr97eYBVVqBLv2pVXW0viLjV+m+r/uNhWaJUioMBllxDrcb
	 m/2rQlbq2vyk3xPBmVzj29M7JVrvLsSMjwUJJkNN8B6XdEYn5s49h4hyw6bLTtoi9p
	 EjTM+zpv2Dhmnnkhitfx/vj2brk5MHkYyJoQRtsq8+0xWW/1nK8yf7e6n1c+pCWVlV
	 C1XYMaOxwobfzPLR8thTUoG0bwIiC1DRhAZeaP57LjbKOs0qtf1boJvs5JbZewwmWa
	 ZNyTmf20EjV9XQz4d8qaTsyPbhurixlhBxn2jxz+gzDDr74A/rLls/VWc0tFau9VX+
	 GD8kCkpo5IuUg==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-30-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:48AM +0200, Christoph Hellwig wrote:
> Always use I_BDEV(file->f_mapping->host) to find the bdev for a file to
> free up file->private_data for other uses.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
