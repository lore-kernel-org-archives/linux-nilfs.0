From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] vfs: create a generic checking function
 for FS_IOC_FSSETXATTR
Date: Wed, 26 Jun 2019 05:11:33 +0100
Message-ID: <20190626041133.GB32272@ZenIV.linux.org.uk>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
 <156151633829.2283456.834142172527987802.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Sender:In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rH4OF0GHPClOZ4K9k6rCWew4+MWIr6v83apdz0y+Mu4=; b=Ak2tnFKQVG4SP3Qp/bHhalEFc
 059qSb2TZBycHGyWpbPPR+uvra8QGSwsHLQSnAOHGK5QTTeF3B7za34nIMuaPnp6YyIWuSDZ5g/eG
 18xBDkDC96PN6Hnuy0Pu0+buTH1L1Ha9HZoL+3VaQuSi+cQS+Ytwd2cD6DiIC7egh2xVo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Sender:In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
 Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rH4OF0GHPClOZ4K9k6rCWew4+MWIr6v83apdz0y+Mu4=; b=ATLP4+HuRwmNLtUvFNJRV+wdHP
 N8J71OgmsL4aaFnsk71skhCpxCABLHydFuFEdw2c420H/JZqJt6ekwsd9qy4+gteoTthda47RXLlN
 zK59WQoNq+fLuyWCZS8RmBbDdK4ChAxq7UjMvZYRHskOfRcUgHC020YY+tjdW+oWCEms=;
Content-Disposition: inline
In-Reply-To: <156151633829.2283456.834142172527987802.stgit@magnolia>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@infradead.org, linux-btrfs@vger.kernel.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 25, 2019 at 07:32:18PM -0700, Darrick J. Wong wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -373,10 +373,9 @@ static int check_xflags(unsigned int flags)
>  static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
>  {
>  	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> -	struct fsxattr fa;
> -
> -	memset(&fa, 0, sizeof(fa));
> -	fa.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags);
> +	struct fsxattr fa = {
> +		.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags),
> +	};

Umm...  Sure, there's no padding, but still - you are going to copy that thing
to userland...  How about

static inline void simple_fill_fsxattr(struct fsxattr *fa, unsigned xflags)
{
	memset(fa, 0, sizeof(*fa));
	fa->fsx_xflags = xflags;
}

and let the compiler optimize the crap out?
