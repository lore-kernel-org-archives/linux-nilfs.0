From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 27/31] block: remove unused fmode_t arguments from ioctl
 handlers
Date: Wed, 7 Jun 2023 11:03:45 +0200
Message-ID: <20230607-umgewandelt-fabelhaft-5f3c72318a9a@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-28-hch@lst.de>
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
	List-Owner; bh=13ZUI4T7T53NQeZTEoJC00YvPLzln0eYUuc0lHg7eN0=; b=lqakQQgR6oVJZE
	Gomjq+1Ki0HtXchFPHOtLmO7JKo+w6tlGgs3b3koJa7+jckOjEt2QovRNji0tdJyh+uZ0ruEgSgD4
	qLvDBsDRw4/Y/sgz+27IlEsaoLGQGaYgB58aqWN7PrFDNXRrXjNR7rZPpE82Dez6gbzh9nMU61pE5
	vY5zg5gxrA56Z8CmGPk4BBuSsb6wbj2FrqtAUlB2aQzFXyuZ+vdflLVN2/FtyeZzR+qszwnZs3cA1
	2jhRncf0iLFmuTfsoRgaWVv7gWViuHJK6EeC1XozZPNnOtAxveYH+8XW9b9vNwWpFYYpJBvGSxpDw
	30u0eXyEBWnenpbOKwIg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128633;
	bh=Xf/4P91dRygUOBcu7Gf2FM/yIcNpKmxg81kLyQ/xABI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IN6GC1DPfELHi6cX+5K0wKVVtYJ3DXedGhjwgRx699RBFbnd08dZETxrlqxzpLWKC
	 ekLoBpbWyqE6gmBLFLtkaZYgr6+AIeoZpKwDTwgdWG99m14V2UqWKfwBTtVvgUBRu+
	 0e6TBWMLJuIbAlRNYxIXjylaMD7QGrfKMwVXHWPcJnjd57/ddsdyM/BmkOIIfzhzqD
	 30g5q2KZ4YvHf7cCwWG4eQIpdKajUy1CEU/O6AmKN2EBhjjDNdUAUDLCZCHrmIXgZM
	 kwBNuzs8INbYR7r2R62ZE/viyZfDvNDpkswXSRvBH+lz4n+zQ2vNlfy8TcF9REK4vz
	 k5N5wSWsZUJNw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-28-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:46AM +0200, Christoph Hellwig wrote:
> A few ioctl handlers have fmode_t arguments that are entirely unused,
> remove them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
