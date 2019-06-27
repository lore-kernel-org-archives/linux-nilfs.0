From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] vfs: create a generic checking
 function for FS_IOC_FSSETXATTR
Date: Wed, 26 Jun 2019 17:19:26 -0700
Message-ID: <20190627001926.GL5171@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
	<156151633829.2283456.834142172527987802.stgit@magnolia>
	<20190626041133.GB32272@ZenIV.linux.org.uk>
	<20190626153542.GE5171@magnolia>
	<20190626154302.GA31445@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2018-07-02; bh=3RIuIjkmytr4LdQPjbeXjjO+I8ml1GjrbbnuVW2fUkI=;
 b=mFy2rFIElbloS2eQdeitVvZsR98qqYW+a+bVq+dNyd53Ep/w/z9A1y5eaYNO6BRAril1
 TDY8wW46hbmQY/E0uwp4wen+OlAGo/EDM9j27re/EuILsqVrhDgAdPhOCUy9ldVeVHrp
 3u0FR2amtdGRFAY/5Y5qrECMV8NCH/zL49FJpGXNxpBKYVYrUwttlxr3dwr+kCOP4Bpx
 1qYUrwyjBPVe2I2YxwZLyZNvsK6X3eQD1Cf/0RX5JWlbhLV9V7mOnesj4eY06eS/VVrT
 +3gb+5IRI37nVjOlVAOLLIfdBBXFcegEiTMcyeqGTPM61N1Yjs1seksSxIp9OslvDQ9o SQ== 
Content-Disposition: inline
In-Reply-To: <20190626154302.GA31445@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 26, 2019 at 08:43:02AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 26, 2019 at 08:35:42AM -0700, Darrick J. Wong wrote:
> > > static inline void simple_fill_fsxattr(struct fsxattr *fa, unsigned xflags)
> > > {
> > > 	memset(fa, 0, sizeof(*fa));
> > > 	fa->fsx_xflags = xflags;
> > > }
> > > 
> > > and let the compiler optimize the crap out?
> > 
> > The v2 series used to do that, but Christoph complained that having a
> > helper for a two-line memset and initialization was silly[1] so now we
> > have this version.
> > 
> > I don't mind reinstating it as a static inline helper, but I'd like some
> > input from any of the btrfs developers (or you, Al) about which form is
> > preferred.
> 
> I complained having that helper in btrfs.  I think Al wants a generic
> one, which at least makes a little more sense.

Ok.

> That being said I wonder if we should lift these attr ioctls to
> file op methods and deal with all that crap in VFS code instead of
> having all those duplicated ioctl parsers.

That sounds like an excellent next patchset. :)

--D
