From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] vfs: create a generic checking and prep function for
 FS_IOC_SETFLAGS
Date: Wed, 26 Jun 2019 08:30:36 -0700
Message-ID: <20190626153036.GD5171@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
 <156151633004.2283456.4175543089138173586.stgit@magnolia>
 <20190626040202.GA32272@ZenIV.linux.org.uk>
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
	List-Owner; bh=RhirxZjSvqD7Ft4ccZnOq4OxwiFIeiBI129bwjRfmiw=; b=FTyFlSsY0NLb+Z
	XIJugpym4dATs2ikUdH6H6uzwTuY2up3CSwn/kMiHzP12YJ/uY5ZWce03SeNM0MxEdBwLhpsxcyOb
	SKzBXBBWUG5KV7n37fM6gQhIV63tvxz/ohd3bigN6IYnAv+hdkuohkjbbWz3dXILDmhY8x+IOlQ90
	FcXILwo5fzXkLKTjRRvklQ9I7dlhpxX+VJfd5sinI0fhu3F0jUyhO40P9ZuZC+Cj44yTLupVyeRB9
	u6cw0BWLzJcUhmqzcyETZo6gqQu6oYF4qwkeENgtM/K56AxUbjjVlIKLYlMUj/urWfv9y0Jf1j9Qj
	rC6rZ1FOLGES84gRtioQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=YDGFAgA+UzOeA0RzbEZlqh20naHwE1ADD0yDq6Je8dw=;
 b=5SsxtbAHYwnkmxJULysm2KxZq5mbde0t3XyhzMeXSwZAo4FZC5HrtAbNxP4iKFNYt/kh
 Y7dWO5SaAbHINxAtS5d9huSJUKZX4sYaTFJweZpJSueupmjWstikFvfvx8fArqJIXvjO
 Fh9JhfPE1NlWZEUQ0i0vMF5uNs2kkXHzSSkRzf28Mylp3bBUyhO5LLLfnkC3dJTCGlix
 DdNr61pg6B1lXISHc2RzFLC5ZVBDGfKB2yuj2p08FMyCBdBANGMe381f0kogMmY2sp3/
 7q+Y/Qa9+RQG0rUGnPnm6o2EIm78XgGS2+4bIC9MSn2e1l50r41/Mdb5HkREd2b4yCqU EA== 
Content-Disposition: inline
In-Reply-To: <20190626040202.GA32272@ZenIV.linux.org.uk>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@infradead.org, linux-btrfs@vger.kernel.org, yuchao0@huawei.com, clm@fb.com, adilger.kernel@dilger.ca, Christoph Hellwig <hch@lst.de>, matthew.garrett@nebula.com, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, josef@toxicpanda.com, reiserfs-devel@vger.kernel.org, dsterba@suse.com, jaegeuk@kernel.org, tytso@mit.edu, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, jk@ozlabs.org, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 26, 2019 at 05:02:02AM +0100, Al Viro wrote:
> On Tue, Jun 25, 2019 at 07:32:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a generic function to check incoming FS_IOC_SETFLAGS flag values
> > and later prepare the inode for updates so that we can standardize the
> > implementations that follow ext4's flag values.
> 
> Change in efivarfs behaviour deserves a note.  I'm not saying it's wrong,
> but behaviour is changed there - no-op FS_IOC_SETFLAGS used to fail
> without CAP_LINUX_IMMUTABLE...

Ok, will do.  FWIW I wondered about fixing the orangefs usage too (using
an unsigned long uval to hold the contents of an unsigned int coming
from userspace) but ... that's their decision.

--D

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
