From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3 0/29] block: Make blkdev_get_by_*() return
 handle
Date: Fri, 25 Aug 2023 15:32:47 +0200
Message-ID: <20230825-hubraum-gedreht-8c5c4db9330a@brauner>
References: <20230818123232.2269-1-jack@suse.cz>
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
 bh=X1l9n2w2msxg9FKnzsUG71D//GbSOHzJh48SLsQSHc4=; b=HaeTgtvivHY5OaeIKK2XpHCFKD
 gc8qTe552BQ5/VXJt2CVprqdGMsqyWwZ7VXbo8LoEiRfV5jSDvVm1mYPx/nrL5VUiX4DKxHeTmZ1B
 6RGyE317hByuMlHoSByWLDO/NZk+QS0hXqAq57EYyl8Iv1grbdH8Pi5Qx0/3ifApP+PY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=X1l9n2w2msxg9FKnzsUG71D//GbSOHzJh48SLsQSHc4=; b=ISWkOXhMv3w58DYMwUYJ+GlVZv
 jcqdJ8t8MiCl+iynN0KIXeXXplBTtx6AcmEOBiHkl5RcsHA1etzrAVatx7l1xmxFzjhRBWFtB2xyC
 6HzxaTArZBWrRp9/Juadapy4FBp6w5dMsH1it3adz20a4lF7tjhppIkuyc2pJrnIsfRw=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1692970379;
 bh=T3WCgKJR+2I3SNciRzSe5NGE9AO6KZcdR6qXwGAgd9M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=BOzM2QQ1MZDAriB3IMOamPdHV+2S3m2FC6tyT1pwI/9DF+WhlbPxDXE6fFDwe1gQn
 nTHB+ewwdyxJVq1cwfq3lRDi07qJcCHvh+nPPtQwtyRFhMG1ktBk1+a5CxpNbFHlMo
 Es+8l14bPK+nfmT+9Vs7IvZUfkPWFzk8wOkU0sT7FJdKR3BT4c1FwZN9woHNBuu5tc
 jHLMCNsuGW/YHncoWpwLVgQ93zfRJ93+ghRIza8tLelTozCObl43Fv+mmuqvzrkB+C
 SdJZ6/x4IFa4j6NBHHUKQ0uLY4RqtzEgYesuRGMfUi0q6xmwPRpi/3TpKuwt6YF2IT
 8BYUF/YAoocgw==
Content-Disposition: inline
In-Reply-To: <20230818123232.2269-1-jack@suse.cz>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org, Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org, Gao Xiang <xiang@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, Kent Overstreet <kent.overstreet@gmail.com>, Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>, Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.

On Wed, Aug 23, 2023 at 12:48:11PM +0200, Jan Kara wrote:
> Hello,
> 
> this is a v3 of the patch series which implements the idea of blkdev_get_by_*()
> calls returning bdev_handle which is then passed to blkdev_put() [1]. This
> makes the get and put calls for bdevs more obviously matching and allows us to
> propagate context from get to put without having to modify all the users
> (again!). In particular I need to propagate used open flags to blkdev_put() to
> be able count writeable opens and add support for blocking writes to mounted
> block devices. I'll send that series separately.
> 
> The series is based on Christian's vfs tree as of today as there is quite
> some overlap. Patches have passed some reasonable testing - I've tested block
> changes, md, dm, bcache, xfs, btrfs, ext4, swap. More testing or review is
> always welcome. Thanks! I've pushed out the full branch to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git bdev_handle
> 
> to ease review / testing. Since there were not many comments for v2 and
> Christoph has acked the series I think we should start discussing how to merge
> the series. Most collisions with this series seem to happen in the filesystems
> area so VFS tree would seem as the least painful way to merge this. Jens,

I really do like this series especially struct bdev_handle and moving
the mode bits in there. I'll happily take this. So far there have only
been minor things that can easily be fixed.
