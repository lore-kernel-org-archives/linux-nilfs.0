From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 30/31] block: store the holder in
 file->private_data
Date: Wed, 7 Jun 2023 11:24:55 +0200
Message-ID: <20230607-verjagen-weise-4fb3d76a6313@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-31-hch@lst.de>
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
 bh=ki87ibK1tm2wqzFPMXWkJl7nWoKXWybi7GQjVNJ+V5M=; b=ZjIO6bkRaa1ZmDrTOpogSEifkU
 QIg7lMsIWJoKqSvHejjt5qSR5mBLoqgbsI84wBUbIkJsAi+adXOEH0579YOLwMCLv4ngma4yXW6Js
 /RY9agB/W2wRLQogEsZRzXj+6dQnjgA/9Uzl3EJgPU0KJoueFUSzc2GYZ+Wnv/R9GKQA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ki87ibK1tm2wqzFPMXWkJl7nWoKXWybi7GQjVNJ+V5M=; b=ReDYx2pORTSR71+3KoGqERQDIA
 +G2OL++JZwNbosGKrO8Mpd6XyPndbtf4a2eI5384/ionOci/1kVj2dYLXFCHwYdkSpOlaIibcrwI8
 g+T+UJ6R17/4sU2jB0ru4xpczUDIbYmawQ0uR70IRJlRCQm6j6FGTkOpxThPYI3I7XJA=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1686129904;
 bh=PVPEiqQnbOrHGRENvLEdaR/nzeey8b8ZshNSuWbTzrk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ALdNOSLUKbyG4MtN9g4NY65h2phNBq7vkw8myPQgpJG2PzaM8f/SVslVCmF/QOc3T
 Bwp8JuH17KAppuZAf9ArpxZTmb2lgZ7cED8j2ebPZYTj2IOo1Pq/kE6GkpjP2srCxN
 XuLDkhy5x7omz7gFdxwTAPV7lc6Gdyrkd5NATTyExP7JIaWtEnHvRju/P8W1jwC/ZQ
 pgr661S3TGnNa0/R8XJs7I9augkFB3fO/k2xICj9Rw66l5DVIPYSNCIJVnNMEfjw+Z
 gguliFEjC8Gq4dp0LyuKCQZnO9AA7rkPsqLnWoRqyaIZ4YpfwuJwZivsVp2KmUYvZJ
 O4+xhtnOR9qOw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-31-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:49AM +0200, Christoph Hellwig wrote:
> Store the file struct used as the holder in file->private_data as an
> indicator that this file descriptor was opened exclusively to  remove
> the last use of FMODE_EXCL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Feels a bit odd to store the object itself but anyway,
Acked-by: Christian Brauner <brauner@kernel.org>
