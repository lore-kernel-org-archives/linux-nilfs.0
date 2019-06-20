From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/6] mm/fs: don't allow writes to immutable files
Date: Thu, 20 Jun 2019 17:52:12 -0400
Message-ID: <20190620215212.GG4650@mit.edu>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
 <156022837711.3227213.11787906519006016743.stgit@magnolia>
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
	List-Owner; bh=utsYJGVG+VYqlXhB1E6pacQ6OCBQ6c9J1kRG1uaj9+4=; b=Og/ffOEO9Pzo+N
	KloLfFrXWxz0PD1/m3gV9+/CZlEoKBw/uDyVisKglywrlS9rf386kO80LhPyDRmF20ISM26usR4l8
	AVSI3s+/AacBkzbLJAY+2STLW68EM2ftCO84M0A5nRwWScTDRXl4JbxPGYinTkbLNu/fdfvS043oK
	ok6i+Ym5N+63/+X2jRO4j6SHymlKjs4G9ZUTFKE6pAcklyJBfZne6DTcuVpJfm1XEUX/YiQH8Mtlw
	tU+Z1+S/26TRRqk0qE/9aDRTHw7dJvGhi9y9d5G8TqactDmMCeq2wHBQvWjU6yJE0vbc3Q3YlYv2+
	b2U2Z35mJW9yyTcxGgqw==;
Content-Disposition: inline
In-Reply-To: <156022837711.3227213.11787906519006016743.stgit@magnolia>
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

On Mon, Jun 10, 2019 at 09:46:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Once the flag is set, it is enforced for quite a few file operations,
> such as fallocate, fpunch, fzero, rm, touch, open, etc.  However, we
> don't check for immutability when doing a write(), a PROT_WRITE mmap(),
> a truncate(), or a write to a previously established mmap.
> 
> If a program has an open write fd to a file that the administrator
> subsequently marks immutable, the program still can change the file
> contents.  Weird!
> 
> The ability to write to an immutable file does not follow the manpage
> promise that immutable files cannot be modified.  Worse yet it's
> inconsistent with the behavior of other syscalls which don't allow
> modifications of immutable files.
> 
> Therefore, add the necessary checks to make the write, mmap, and
> truncate behavior consistent with what the manpage says and consistent
> with other syscalls on filesystems which support IMMUTABLE.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I note that this patch doesn't allow writes to swap files.  So Amir's
generic/554 test will still fail for those file systems that don't use
copy_file_range.

I'm indifferent as to whether you add a new patch, or include that
change in this patch, but perhaps we should fix this while we're
making changes in these code paths?

				- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
