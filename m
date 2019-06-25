From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 0/7] vfs: make immutable files actually immutable
Date: Tue, 25 Jun 2019 03:36:31 -0700
Message-ID: <20190625103631.GB30156@infradead.org>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
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
	List-Owner; bh=sspP+UuC64sEWtTTpKuZJ5kVhOYwDxjdVeANElde/tc=; b=KSxmR8loDPEz9u
	gZZWXJdmOTwyTu5mxPMZmi2ilCUF6Y9MoxJnSH0NL4dgqApP+LMVc1s6pqv6vT+jnkmqurzsHR9an
	Klbw43I1EJL5A8kxJ4raCH/+LtQgA5PdI+YZ6IbCOLQxL47WBxZlBmjPZ6elXNOKfHqfzxj+T8chF
	FbRadk/qD9FJOeFV7Oarz41mX4H2+NUksi3SIUSjG++8a5Gnktb1aiq+b4GiNJhkmcbALvBjMC3BQ
	cV8PbjYyKtHjK2SP8Qo5aB8eBaUj1smUX4UkrT6Vk4UfJ0V9w6/xdnVFOitKhyKSVs6++rWo14lxo
	4LQbawZ3m94QH82fOcTw==;
Content-Disposition: inline
In-Reply-To: <156116141046.1664939.11424021489724835645.stgit@magnolia>
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
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, linux-mm@kvack.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 21, 2019 at 04:56:50PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The chattr(1) manpage has this to say about the immutable bit that
> system administrators can set on files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Given the clause about how the file 'cannot be modified', it is
> surprising that programs holding writable file descriptors can continue
> to write to and truncate files after the immutable flag has been set,
> but they cannot call other things such as utimes, fallocate, unlink,
> link, setxattr, or reflink.

I still think living code beats documentation.  And as far as I can
tell the immutable bit never behaved as documented or implemented
in this series on Linux, and it originated on Linux.

If you want  hard cut off style immutable flag it should really be a
new API, but I don't really see the point.  It isn't like the usual
workload is to set the flag on a file actively in use.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
