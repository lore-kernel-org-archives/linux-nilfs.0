From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] vfs: don't allow writes to swap files
Date: Wed, 26 Jun 2019 09:28:31 -0700
Message-ID: <20190626162831.GF5171@magnolia>
References: <156151637248.2283603.8458727861336380714.stgit@magnolia>
	<156151641177.2283603.7806026378321236401.stgit@magnolia>
	<20190626035151.GA10613@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2018-07-02; bh=oYrFpsa7m38VFCZxdd8UBdtHC2a21A24EtIJKYREoCg=;
 b=jm8jqu9ruZ0MEtEIAH4kN/hgvN31119e8F/bImT0+fLkPBSVa+JeHUB3ar2Yoay3emFd
 fDg/Bc+rpRBTmobzpLO9zjW0cU7fpU/8F2DCpsoOcq7bWk2dN0+en9t2cizYXNBFITN0
 hqW38Kd4AjJi7vv3DgA0rWKShw/86YRobN8LHuC0e9FNAzJLYNAtNfqoPssKkh3Zc/uJ
 ElAjdCgai0LL2Sh42zqP+adecQ/OlgRFo24KCVUGneTIeenUbY3vgNVtbCZLpJloBOZ/
 FtYgL+HauZfd9RKS4wXV/w1Z3keELg9x/8Ky3qkIIzb7cUyhC49/Q76/Yi6/8mSeP864 zA== 
Content-Disposition: inline
In-Reply-To: <20190626035151.GA10613@ZenIV.linux.org.uk>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, linux-mm@kvack.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 26, 2019 at 04:51:51AM +0100, Al Viro wrote:
> On Tue, Jun 25, 2019 at 07:33:31PM -0700, Darrick J. Wong wrote:
> > --- a/fs/attr.c
> > +++ b/fs/attr.c
> > @@ -236,6 +236,9 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
> >  	if (IS_IMMUTABLE(inode))
> >  		return -EPERM;
> >  
> > +	if (IS_SWAPFILE(inode))
> > +		return -ETXTBSY;
> > +
> >  	if ((ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) &&
> >  	    IS_APPEND(inode))
> >  		return -EPERM;
> 
> Er...  So why exactly is e.g. chmod(2) forbidden for swapfiles?  Or touch(1),
> for that matter...

Oops, that check is overly broad; I think the only attribute change we
need to filter here is ATTR_SIZE.... which we could do unconditionally
in inode_newsize_ok.

What's the use case for allowing userspace to increase the size of an
active swapfile?  I don't see any; the kernel has a permanent lease on
the file space mapping (at least until swapoff)...

> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 596ac98051c5..1ca4ee8c2d60 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3165,6 +3165,19 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >  	if (error)
> >  		goto bad_swap;
> >  
> > +	/*
> > +	 * Flush any pending IO and dirty mappings before we start using this
> > +	 * swap file.
> > +	 */
> > +	if (S_ISREG(inode->i_mode)) {
> > +		inode->i_flags |= S_SWAPFILE;
> > +		error = inode_drain_writes(inode);
> > +		if (error) {
> > +			inode->i_flags &= ~S_SWAPFILE;
> > +			goto bad_swap;
> > +		}
> > +	}
> 
> Why are swap partitions any less worthy of protection?

Hmm, yeah, S_SWAPFILE should apply to block devices too.  I figured that
the mantra of "sane tools will open block devices with O_EXCL" should
have sufficed, but there's really no reason to allow that either.

--D
