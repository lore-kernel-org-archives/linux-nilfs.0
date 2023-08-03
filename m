From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 06/12] fs: use the super_block as holder when
 mounting file systems
Date: Thu, 3 Aug 2023 20:11:56 +0200
Message-ID: <20230803-zornig-drucken-7e2a53465a15@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-7-hch@lst.de>
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
 bh=uThKvCesp1pPRQ58CfmvaR6GJypGeJeD/7LXvjJ8S5k=; b=R+04NfVcwADpx2DVqc6EfW6dv4
 3VUgOIBgJ0xnC3KxLvI1wPDaiFefyfvmZnKj4jQoiV/kaUh4umVj/dWrCldeQWAGhJTtkwuKMiNAW
 5PuZJE7rE8hJBP1QyOMgC/ggIDS07FpuUovMs2ow2uG9/gxyc8M0+uhfREICxmjT0D7k=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uThKvCesp1pPRQ58CfmvaR6GJypGeJeD/7LXvjJ8S5k=; b=E7gSU/oDoY51j7I1BeoA4A6Z4b
 ceiRJ7NcJhkjOtwumVQrJmttnDoUCDxjJrfkeb2ROtMtUaAodYmBiIJX9FP6K2urHY2fNxaKiPt5I
 FyisfMBtLMWkRXUip59O6TBBpPo26ulXmbSWBeDl45KgXIOD7nFRAdKRDrIPMpsfNzQU=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1691086323;
 bh=FvE8CcpTg/rwFyIjkGKpbi4sVFpEPrWRcbOUHH0og0E=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pW7WFuTLRAPoN8tiK+U2RXIY2N8l9VIKhr4v5EuwvrjQjf3HdRQf7xbN68UZZ46zH
 SO1MA9DuRBFsu/t101HYGMhge4PpqCvyyFdCSiM6yxB5L2rIj/XJaXXMMh9Zh/Cuu+
 co+kKz1UN7oez5C8+giAJgZwdFug00bKSW2NUiG/NmUDxnk6vUU0SV5iwwzbS7c9PV
 ENMI160o/kjEUAuSQu7B0b9aiWQQ359FaQygUVE6PTlsN667YIfLe7I1yKSIAq18O6
 t1BukcVZsqtEKb564oyOfYihvq+7U4lXIKeLsRGPjRhjk5Iylovvs66qrt9tj6OKwC
 WUm7iF7kPoIZQ==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-7-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:25PM +0200, Christoph Hellwig wrote:
> The file system type is not a very useful holder as it doesn't allow us
> to go back to the actual file system instance.  Pass the super_block instead
> which is useful when passed back to the file system driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
