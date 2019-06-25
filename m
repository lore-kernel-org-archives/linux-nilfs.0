From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] vfs: create a generic checking
 function for FS_IOC_FSSETXATTR
Date: Tue, 25 Jun 2019 10:16:16 -0700
Message-ID: <20190625171616.GB2230847@magnolia>
References: <156116136742.1664814.17093419199766834123.stgit@magnolia>
	<156116138952.1664814.16552129914959122837.stgit@magnolia>
	<20190625105725.GB26085@infradead.org>
	<20190625170248.GS8917@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2018-07-02;
 bh=eC7Uutoxm5lbfUcz3kepzKhFx9f973uvYaC40dK7Rhg=;
 b=FSs8lbJPOlAZ1HpwaemgV6RCFPGwU7tIi/Y1a0oruskAIhkveKieHlae84xgl4c42zVb
 CIPpIVbOyk/+buDvK7EvZkygt6MsPXNuAqR5N05DLkwdBHMLy1fdHr6k++iVO/wnK9Fv
 0gvHAaxSjO1feu5vIi5FgQQqPQ4COzscgKNEp75+qKVJHrRkPqQzt4Tq8RF15NY7mDFU
 s5q6Y8gTaoQ/jt5HN77mGEz9ApXJcwhyq6FLpoCDX4s+8IqEoXm8kzH6HZxOY+C86gy/
 VeDnZJgyfoFLkml9Q4Yz0j2gVv3GIYcKdY8uTXhkHqwsl9fzCpdh/FYSdTIf38rczSl7 Cw== 
Content-Disposition: inline
In-Reply-To: <20190625170248.GS8917@twin.jikos.cz>
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
To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jun 25, 2019 at 07:02:48PM +0200, David Sterba wrote:
> On Tue, Jun 25, 2019 at 03:57:25AM -0700, Christoph Hellwig wrote:
> > On Fri, Jun 21, 2019 at 04:56:29PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a generic checking function for the incoming FS_IOC_FSSETXATTR
> > > fsxattr values so that we can standardize some of the implementation
> > > behaviors.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/btrfs/ioctl.c   |   21 +++++++++-------
> > >  fs/ext4/ioctl.c    |   27 ++++++++++++++------
> > >  fs/f2fs/file.c     |   26 ++++++++++++++-----
> > >  fs/inode.c         |   17 +++++++++++++
> > >  fs/xfs/xfs_ioctl.c |   70 ++++++++++++++++++++++++++++++----------------------
> > >  include/linux/fs.h |    3 ++
> > >  6 files changed, 111 insertions(+), 53 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > index f408aa93b0cf..7ddda5b4b6a6 100644
> > > --- a/fs/btrfs/ioctl.c
> > > +++ b/fs/btrfs/ioctl.c
> > > @@ -366,6 +366,13 @@ static int check_xflags(unsigned int flags)
> > >  	return 0;
> > >  }
> > >  
> > > +static void __btrfs_ioctl_fsgetxattr(struct btrfs_inode *binode,
> > > +				     struct fsxattr *fa)
> > > +{
> > > +	memset(fa, 0, sizeof(*fa));
> > > +	fa->fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags);
> > 
> > Is there really much of a point in this helper? Epeciall as
> > the zeroing could easily be done in the variable declaration
> > line using
> > 
> > 	struct fsxattr fa = { };
> 
> Agreed, not counting the initialization the wrapper is merely another
> name for btrfs_inode_flags_to_xflags. I also find it slightly confusing
> that __btrfs_ioctl_fsgetxattr name is too close to the ioctl callback
> implementation btrfs_ioctl_fsgetxattr but only does some initialization.

Ok; it's easily enough changed to:

	struct fsxattr old_fa = {
		.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags),
	};

--D
