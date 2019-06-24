From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] vfs: flush and wait for io when setting the
 immutable flag via SETFLAGS
Date: Mon, 24 Jun 2019 14:58:17 -0700
Message-ID: <20190624215817.GE1611011@magnolia>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
 <156116142734.1664939.5074567130774423066.stgit@magnolia>
 <20190624113737.GG32376@quack2.suse.cz>
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
	List-Owner; bh=XNgFrhhukkXD3yseIF2USTJcDRuTR71Ij8vpnLrvH58=; b=GE633nzUqqBvh8
	3CyQ7Iq+fz64LoZpqYJXRFpRtQCE71k0ci96z60IwT4OCKVf3U9Gv1gw09cOulAJNAoiXjURsML8D
	Fz7sYebHQn8JdpFSTBS4Y0sJKsLLXX6ABhRl2SL+aGf6JF2u2TKdl/qQD7PvgAkXLLN8rSWbdrIG9
	EJ3WBMi/yIKxhSBgXvMzaRxEzn9V80VdD8PF6QUex4AY1a/ZISNcqSEXhTQM7zOS48fg4oPPPO2kS
	e847r50CHUivxv2mnS8C6bwlmG/NU19kvQ1q+qQXPslc28/hs9eWQXOyTKmUXZKCuP3+PrfBQNZ9S
	xjtYN0oskHDnuysy3xKA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=JPBEqrnBb8FJilUCQCUmMJhL0pO+qsW2uzegjGEHDYQ=;
 b=vwSceTOFPnndaHyinJXnA0XxpMTF4zGHNj5lEs+w8XWiVL6ly7Z9VEVjJV4gnFgKkKwW
 B8SdZ4krsyR6f1E0FlYW5moxuEmjhgn85HtSg0z2oOp1hhMJdo3XOqpiHvEil1BlZ2KW
 PEGmAIadWWqhl9+AmMr5FDs139rF0no0szY6ZnskKVnUEMSG9PrJ5dCsFbIdJrY2zxiP
 3z4yfqHwUSqvLrreOnH+MDuEMhE8ElZOtQ8shgvbsZ/7FCLrYScc7NOmLBxChFYSaq/u
 gI1Rn+l+GOiLbqZED3Z1Od5UlWcckpvKqSJxtGUwwy+7uAnIrP4j5qb9NqSYBMPprys8 Qw== 
Content-Disposition: inline
In-Reply-To: <20190624113737.GG32376@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, linux-mm@kvack.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 24, 2019 at 01:37:37PM +0200, Jan Kara wrote:
> On Fri 21-06-19 16:57:07, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're using FS_IOC_SETFLAGS to set the immutable flag on a file, we
> > need to ensure that userspace can't continue to write the file after the
> > file becomes immutable.  To make that happen, we have to flush all the
> > dirty pagecache pages to disk to ensure that we can fail a page fault on
> > a mmap'd region, wait for pending directio to complete, and hope the
> > caller locked out any new writes by holding the inode lock.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Seeing the way this worked out, is there a reason to have separate
> vfs_ioc_setflags_flush_data() instead of folding the functionality in
> vfs_ioc_setflags_check() (possibly renaming it to
> vfs_ioc_setflags_prepare() to indicate it does already some changes)? I
> don't see any place that would need these two separated...

XFS needs them to be separated.

If we even /think/ that we're going to be setting the immutable flag
then we need to grab the IOLOCK and the MMAPLOCK to prevent further
writes while we drain all the directio writes and dirty data.  IO
completions for the write draining can take the ILOCK, which means that
we can't have grabbed it yet.

Next, we grab the ILOCK so we can check the new flags against the inode
and then update the inode core.

For most filesystems I think it suffices to inode_lock and then do both,
though.

> > +/*
> > + * Flush all pending IO and dirty mappings before setting S_IMMUTABLE on an
> > + * inode via FS_IOC_SETFLAGS.  If the flush fails we'll clear the flag before
> > + * returning error.
> > + *
> > + * Note: the caller should be holding i_mutex, or else be sure that
> > + * they have exclusive access to the inode structure.
> > + */
> > +static inline int vfs_ioc_setflags_flush_data(struct inode *inode, int flags)
> > +{
> > +	int ret;
> > +
> > +	if (!vfs_ioc_setflags_need_flush(inode, flags))
> > +		return 0;
> > +
> > +	inode_set_flags(inode, S_IMMUTABLE, S_IMMUTABLE);
> > +	ret = inode_flush_data(inode);
> > +	if (ret)
> > +		inode_set_flags(inode, 0, S_IMMUTABLE);
> > +	return ret;
> > +}
> 
> Also this sets S_IMMUTABLE whenever vfs_ioc_setflags_need_flush() returns
> true. That is currently the right thing but seems like a landmine waiting
> to trip? So I'd just drop the vfs_ioc_setflags_need_flush() abstraction to
> make it clear what's going on.

Ok.

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
