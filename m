From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] vfs: teach vfs_ioc_fssetxattr_check to check extent
 size hints
Date: Tue, 25 Jun 2019 03:58:55 -0700
Message-ID: <20190625105855.GD26085@infradead.org>
References: <156116136742.1664814.17093419199766834123.stgit@magnolia>
 <156116140570.1664814.4607468365269898575.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=fkuU0940eX9RJyr8+U8GX1APHsu/HfzMPyI8l+MPmVw=; b=m8KvVAks+FIIlM
	hF1IZyU/J3XLUz9B9HRBV5nNAoQ0OEzr1bnSAT340uFc/vVcM7VEZhJql09pciqZwed5ARqVIZlpV
	DohB2/Y85zcy2JOxuOi4vhgt2Kxcp8FkXiy5EIp4wml0huZLyoT6cqQbAAX5C2h9alaMW/168muR+
	ptDNYW+nU15DL5tNrLzfzbCCaU+qtYdz75Y3G6N8jVpyCLslG+WC7HKxCy2b7byPL5zI/jWmEEdbu
	e09EbC1tMlJGKicoDwuEhuDgaHjMg+QPO60YcQ6OAHEj9kIqfrGMPhAD4zO5Ru/CY4lJ//CYmvtMt
	CMDwPeuVPzsx/9QoO6xQ==;
Content-Disposition: inline
In-Reply-To: <156116140570.1664814.4607468365269898575.stgit@magnolia>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 21, 2019 at 04:56:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the extent size hint checks that aren't xfs-specific to the vfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
