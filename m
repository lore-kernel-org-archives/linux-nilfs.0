From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 23/31] mtd: block: use a simple bool to track open for
 write
Date: Wed, 7 Jun 2023 11:00:16 +0200
Message-ID: <20230607-exakt-fahrzeit-31037992dd33@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-24-hch@lst.de>
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
	List-Owner; bh=/FsUsQ7CWG8eKJ8Y1Yaac+nghnP65Mt5dYqo5Y9Rlj4=; b=aO0jrUrMWugggh
	Zh0hjoVEgsTq0JhXXZfq9xe4mA/smptinoWckPYgXBUWJooKJtqcWc7UyihYTZkYMctNX6ovQCbH/
	7ajJagWXnyaHpkH217ILLPtLSKA42bUKOahOkwsYNF28lYaoQfyieQiFTmteig5AM2V7dEhmZiEIR
	Q3qyz7lz4XRNGAHOlOwqxZkXohF9D4Ry83/DxcfVPLJ2UE4Bo3VCY2caNp4cBs1MUVNJzmgP1aQYM
	UfYV8PQe9fiIWNWtgNCSteSEJTV3qGv7r6tJJo8pbtaK+Z7rhf5An3YxCHE1GoQykyRO6cXwFE2Jx
	LSw8w7agKaqc/UhZBFNw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128424;
	bh=M5xM1l9LuXkX4mSzz59D4IdQFYmmNTr6OfgkeVyfa04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkgRvGgC50EeuypHe3xl97j+bK6/ZhC9326XXBYH1ZIWYaQ5jbu1O85bi3HGmv9M+
	 hZ2SFMqNmWRyraR3Jgx4RRg8awjy8xDqCx+4vNdQpqr+khy+3Nr2thG3oUeGWCmFLy
	 XyvLCHm2vTS/PPKFg0NhX/7Rvav0gZ/EJtvHCBmt00R9oRm3Ttf4E19bdvBrMVREuf
	 /zBjY37bjH2obx9yTShQpHDAYvGzclq+GoqwGhXKZinmsKkN75qgYYwu5ZHTg6eiYP
	 J5jVActoZkfoLY/PBMoBsxKMx6RMvbVXquwF1Lct1mLaflpQuIgCkcbVYTKwI3tb6X
	 079ePZ3MnBG6Q==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-24-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:42AM +0200, Christoph Hellwig wrote:
> Instead of propagating the fmode_t, just use a bool to track if a mtd
> block device was opened for writing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
