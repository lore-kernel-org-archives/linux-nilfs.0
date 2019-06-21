From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/6] mm/fs: don't allow writes to immutable files
Date: Thu, 20 Jun 2019 20:54:20 -0400
Message-ID: <20190621005420.GH4650@mit.edu>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
 <156022837711.3227213.11787906519006016743.stgit@magnolia>
 <20190620215212.GG4650@mit.edu> <20190620221306.GD5375@magnolia>
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
	List-Owner; bh=D4IFLkTtRkSTuVoj7eWSesTAqGqbH+qcDnt5GyBLnoM=; b=pFeqiXVGEPxFT/
	N17Nis0//ofu55TJjuwqMGWp/ibaf/Uqb+OpkyYjZ0TUqeel767PeD3NKKiAWRXjcYj5sym94xf2+
	AaikfGhyuIlECCodzVCjlbgIjAEqscw8H5h6vGF2tciurH3J9MA3HTmezNcbMAMPn8oDjkpJCfmr5
	nrfDFSY448QsbrByrdRfLfWqxtwFTxTjF9tuDu5qXBHUCth6mhGWcczXf/9unXOokzQvzqSBluugJ
	vU3R5sHB5mCrzko83bjMS76x9e7OuHwr1fZHrFLOqQW9eGJULChduEk24DRbRyBjTIhHdKna+c1/p
	9coSksaAkSovCKv+sZcw==;
Content-Disposition: inline
In-Reply-To: <20190620221306.GD5375@magnolia>
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
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, linux-mm@kvack.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, jaegeuk@kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Thu, Jun 20, 2019 at 03:13:06PM -0700, Darrick J. Wong wrote:
> > I note that this patch doesn't allow writes to swap files.  So Amir's
> > generic/554 test will still fail for those file systems that don't use
> > copy_file_range.
> 
> I didn't add any IS_SWAPFILE checks here, so I'm not sure to what you're
> referring?

Sorry, my bad; I mistyped.  What I should have said is this patch
doesn't *prohibit* writes to swap files....

(And so Amir's generic/554 test, even modified so it allow reads from
swapfiles, but not writes, when using copy_file_range, is still
failing for ext4.  I was looking to see if I could remove it from my
exclude list, but not yet.  :-)

> > I'm indifferent as to whether you add a new patch, or include that
> > change in this patch, but perhaps we should fix this while we're
> > making changes in these code paths?
> 
> The swapfile patches should be in a separate patch, which I was planning
> to work on but hadn't really gotten around to it.

Ok, great, thanks!!

				- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
