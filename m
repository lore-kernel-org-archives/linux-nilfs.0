From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] vfs: create a generic checking function
 for FS_IOC_SETFLAGS
Date: Tue, 25 Jun 2019 11:17:33 -0700
Message-ID: <20190625181733.GG5375@magnolia>
References: <156116136742.1664814.17093419199766834123.stgit@magnolia>
 <156116138140.1664814.9610454726122206157.stgit@magnolia>
 <20190625171254.GT8917@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=lmgK8Cm3Fl3Y68PjHL3I/TBSUBy/0hTgnkbGgtqK7rI=; b=hxhykK35JMbCnU/xE2C7qzuEaV
 rOV5q4BTxOqf0oHb5OBYUqGvMtq9yTd5dYqvkG+T963pod5BUorhRh8xdjCE89GCypdRzkuIKYPc8
 jPqVwPtcA8YibIt1/MBDGXoXFgg1F4TiS14C2DYDf8CB5K7sJentRH2SbRYbyO6nOjcs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=lmgK8Cm3Fl3Y68PjHL3I/TBSUBy/0hTgnkbGgtqK7rI=; b=ZQubl/kuEi7f3BiP7Wt9AM9kjY
 wbrXCe9MkuM9p7Neb0rOAcLjOrsQt5DNrD1S7vTEMESRQ6xHy4EPffi78YvPCCH91YNjq0YsowWB6
 kjCeqYBcpWIQaHhqnjqlzoO9b4UXNB6KQKvCBD9g2KganI6bf/9/TcrMijYzcHAjIPz4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=lmgK8Cm3Fl3Y68PjHL3I/TBSUBy/0hTgnkbGgtqK7rI=;
 b=sq8wRGFMDp2keeCzfEbQvRF23m4FZdHqzF6KTStnvsnqKgYJRFIybtKXIRJ/BkjACsOp
 VHjdfFdvkzl4/Qyds9SgcqVsToxzG/t5q2X6QJw92ykC0hsb2bCu0+1HnE8/vR1cKWgj
 9LAuCEvVM/6Q8BB9oO+b2Er0NdC/PFqDczBk7D1I2Io7k9QsIy4cloHAf7QWxHhbVscL
 fa9qlI7JJ3E8N38P1RnUBSFFAK1Ox9ur0vfVe7sOoxdIUQu71AdGqU2biDBGiUMsl2PB
 KOtGcPBYzfwUGEHU5Q7xPZKcvd0Ct/iT3yoSupbQ+ljJ3hcRKX4C0zF8TH1T/hnyBICA pg== 
Content-Disposition: inline
In-Reply-To: <20190625171254.GT8917@twin.jikos.cz>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: dsterba@suse.cz, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jun 25, 2019 at 07:12:54PM +0200, David Sterba wrote:
> On Fri, Jun 21, 2019 at 04:56:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a generic checking function for the incoming FS_IOC_SETFLAGS flag
> > values so that we can standardize the implementations that follow ext4's
> > flag values.
> 
> I checked a few samples what's the type of the flags, there are unsigned
> types while the proposed VFS functions take signed type.
> 
> > +int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags);
> 
> Specifically ext4 uses unsigned type and his was the original API that
> got copied so I'd think that it should unsigned everywhere.

Yeah, I'll change it.

> >  fs/btrfs/ioctl.c    |   13 +++++--------
> 
> For the btrfs bits
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> and besides the signedness, the rest of the changes look good to me.

Thanks for the look around!  I'll have a new revision with all changes
out by the end of the day. :)

--D
