From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 0/7] vfs: make immutable files actually immutable
Date: Tue, 25 Jun 2019 11:03:26 -0700
Message-ID: <20190625180326.GC2230847@magnolia>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
 <20190625103631.GB30156@infradead.org>
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
	List-Owner; bh=mc0LoJ5L37N3SSmGEyk5IUCDaKMeRddj+4DfgESUVJg=; b=ir2x4SShIg17to
	JLgQiTUwnekA33z54GUzclizO/vdC6HT2/KnMm4MifQfdBhtLu0IFp/O3mxy69K1pkepGqr45xoko
	Bgk0C9Z28PiOLC8/zrsKRs4EkpxxlVF8W4AR1yoasb0Gbr8G9jpY/ko+7EBuh5QBVcrgJF9MkI69m
	s5YtCMfSoTDJsTxqOiJiFbLeruFQySvzIUWHAVoVjbXUH7DH8u19XwnBSPdvleqSPOYVVw5Do6Vgs
	qhPWlo+rXBrjLVWTdFTqBF3oHROKN/7DKtclF2frNfbNAFSKRQxYYGwiiXPp7maGPluOdbdEuw//w
	KYzyS9mmILTt16qgPvLw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=q3PQ3FdT4Cu9ZFxkmPMEB5w+ChSGz6mW1jtUBkoDAvw=;
 b=ksyT2XyNq/sBFuNf0kcEOahW5dSfpRm2xoyvLHIl5Mejyeb4JLMflOsVy5quxvpN67j2
 IsKXQAf1HGSoM5FioAjK6ozKyUInygd/ml7l4zpRXtxh/UWz20oKY/FTMlcYaDZBA7N9
 MY/zMgGVdosxoetsazUmPfKqNstqSPWvasVhjypJJqeFcHhDaP62mxpCpMaNSfCtaBX3
 JdFoGt472fc1h8ZFinUmpgHsBMZcZBqagXk/T9NnnQ5VQ3pfbtpwxQaYR4yLbxZKG58n
 MOx1qf1doyupoPytNdwt2e/QYdozJOX4KCvtmdKWmiW/VFWoTbAzfyslOGA2S3jKu5TS Qg== 
Content-Disposition: inline
In-Reply-To: <20190625103631.GB30156@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, linux-mm@kvack.org, clm@fb.com, adilger.kernel@dilger.ca, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 25, 2019 at 03:36:31AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 21, 2019 at 04:56:50PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > The chattr(1) manpage has this to say about the immutable bit that
> > system administrators can set on files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > Given the clause about how the file 'cannot be modified', it is
> > surprising that programs holding writable file descriptors can continue
> > to write to and truncate files after the immutable flag has been set,
> > but they cannot call other things such as utimes, fallocate, unlink,
> > link, setxattr, or reflink.
> 
> I still think living code beats documentation.  And as far as I can
> tell the immutable bit never behaved as documented or implemented
> in this series on Linux, and it originated on Linux.

The behavior has never been consistent -- since the beginning you can
keep write()ing to a fd after the file becomes immutable, but you can't
ftruncate() it.  I would really like to make the behavior consistent.
Since the authors of nearly every new system call and ioctl since the
late 1990s have interpreted S_IMMUTABLE to mean "immutable takes effect
everywhere immediately" I resolved the inconsistency in favor of that
interpretation.

I asked Ted what he thought that that userspace having the ability to
continue writing to an immutable file, and he thought it was an
implementation bug that had been there for 25 years.  Even he thought
that immutable should take effect immediately everywhere.

> If you want  hard cut off style immutable flag it should really be a
> new API, but I don't really see the point.  It isn't like the usual
> workload is to set the flag on a file actively in use.

FWIW Ted also thought that since it's rare for admins to set +i on a
file actively in use we could just change it without forcing everyone
onto a new api.

--D

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
