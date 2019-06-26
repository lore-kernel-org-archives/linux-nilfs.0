From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] vfs: create a generic checking
 function for FS_IOC_FSSETXATTR
Date: Wed, 26 Jun 2019 08:35:42 -0700
Message-ID: <20190626153542.GE5171@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
	<156151633829.2283456.834142172527987802.stgit@magnolia>
	<20190626041133.GB32272@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2018-07-02; bh=Oq8KDAKUJ1147KjlZXzvsHtnXm/X6h773R0OC3VLRKw=;
 b=ue5XjCeHdVl6gB4VboMqFtA5XfVBMF6DIGGxNi8oGyyqVMfWYQ6jZF0lC5V26EWcuiwl
 P6XaLLfwfDlalo/lWdFZ6mZDRR1QJExLB4y1Z/cvOwj0d54zRxU9oo1EWDJbOXbImKE/
 45QAtZrLrion7f1Oyx7D8BrwEeotVa92+0miCOKks465z8rRr2ZkTWZkVCE3/Mh2H1/E
 /SYwMBuJJAPyV+hd+E4L0MmBCS/JRTx1dPWMgvdtMiqNfYhCU18AEIzOUM0hIDF1cO0G
 qc2ubo7+Q7I0TYclMOIKlbeNVRiH9YXpx3cRBxIWFvvy3syAS/g0THx5XeMjwjNI2es1 mg== 
Content-Disposition: inline
In-Reply-To: <20190626041133.GB32272@ZenIV.linux.org.uk>
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@infradead.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 26, 2019 at 05:11:33AM +0100, Al Viro wrote:
> On Tue, Jun 25, 2019 at 07:32:18PM -0700, Darrick J. Wong wrote:
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -373,10 +373,9 @@ static int check_xflags(unsigned int flags)
> >  static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
> >  {
> >  	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> > -	struct fsxattr fa;
> > -
> > -	memset(&fa, 0, sizeof(fa));
> > -	fa.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags);
> > +	struct fsxattr fa = {
> > +		.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags),
> > +	};
> 
> Umm...  Sure, there's no padding, but still - you are going to copy that thing
> to userland...  How about
> 
> static inline void simple_fill_fsxattr(struct fsxattr *fa, unsigned xflags)
> {
> 	memset(fa, 0, sizeof(*fa));
> 	fa->fsx_xflags = xflags;
> }
> 
> and let the compiler optimize the crap out?

The v2 series used to do that, but Christoph complained that having a
helper for a two-line memset and initialization was silly[1] so now we
have this version.

I don't mind reinstating it as a static inline helper, but I'd like some
input from any of the btrfs developers (or you, Al) about which form is
preferred.

--D

[1] https://lkml.org/lkml/2019/6/25/533
