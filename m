From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] vfs: create a generic checking function for
 FS_IOC_FSSETXATTR
Date: Wed, 26 Jun 2019 08:43:02 -0700
Message-ID: <20190626154302.GA31445@infradead.org>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
 <156151633829.2283456.834142172527987802.stgit@magnolia>
 <20190626041133.GB32272@ZenIV.linux.org.uk>
 <20190626153542.GE5171@magnolia>
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
	List-Owner; bh=G3T8Xo3Jak9o4HNdG+z7LyikCnZoqGeuuyfmLa8mkaI=; b=ghi6yFk3P9QqXx
	5VkdWwABwCRjzHnPW1A9t2t20N8lsS+f50zFVuJFWG8260KKYTBMi4EOhTzvMHSmFlc3YlRZZu0Mh
	dL7w7VGJG0odlag4nrN7+Z1VswmeyLmYHMe/eq8drADCm0p5k4AR/ME9vggEVOda9zgzf49zwIf8m
	uFZlHpKzSiBGFpk9cvFZKY7LU0l0bB/t0CX+2VjnP7Z/3eoaNRYYlFPgrhyJIp2obDRl2e+tbApjC
	HI0t6uSgs+SGx7t32joDu6TkR7nxoNxSWOwAJB8r6+Fmr53bSZxfwwZ6oNmdgqqzHDLaqD3czBA0u
	0JIOSiBe2Piyfo1ucNYQ==;
Content-Disposition: inline
In-Reply-To: <20190626153542.GE5171@magnolia>
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@infradead.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 26, 2019 at 08:35:42AM -0700, Darrick J. Wong wrote:
> > static inline void simple_fill_fsxattr(struct fsxattr *fa, unsigned xflags)
> > {
> > 	memset(fa, 0, sizeof(*fa));
> > 	fa->fsx_xflags = xflags;
> > }
> > 
> > and let the compiler optimize the crap out?
> 
> The v2 series used to do that, but Christoph complained that having a
> helper for a two-line memset and initialization was silly[1] so now we
> have this version.
> 
> I don't mind reinstating it as a static inline helper, but I'd like some
> input from any of the btrfs developers (or you, Al) about which form is
> preferred.

I complained having that helper in btrfs.  I think Al wants a generic
one, which at least makes a little more sense.

That being said I wonder if we should lift these attr ioctls to
file op methods and deal with all that crap in VFS code instead of
having all those duplicated ioctl parsers.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
