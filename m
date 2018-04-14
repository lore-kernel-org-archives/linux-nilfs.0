From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 00/62] Convert page cache to XArray
Date: Sat, 14 Apr 2018 12:50:30 -0700
Message-ID: <20180414195030.GB31523@bombadil.infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
 <a27d5689-49d9-2802-3819-afd0f1f98483@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZwcKqHzvHJLeQKoEGCqB4plRrJGW3SSNnK4Db7+6m6E=; b=jSh2RA9yYKVvrraIm79CQZDhe9
 W6ajtIWIFJbXle0Vb8ex281tSGUPFietjRglLjM56Deah/auFXWwvwV/8Dq0HSjPsRaHu+U20R+Vk
 V0vtZoSjoYj4hL+JgkrXeFU9fgvud5Pme8nq+Q/BZeEnHmlwpXXirAzr+LmR3W50XOF4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ZwcKqHzvHJLeQKoEGCqB4plRrJGW3SSNnK4Db7+6m6E=; b=f41nJGCLAGj4XyPchHW2Vhgn8n
 beNBss84tSfviQIkLo3CWmdtnAypfIj73/WZaZLyl1+nWG4mX1NU9he5GM+dZNTIii1tDnSL/yo0z
 A22H3OK8dATsftTxQkayzgdmOzk7e78kwx6jBDZlvrzTZgTCL/8zc7kX5Xg6qPLd9RDs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZwcKqHzvHJLeQKoEGCqB4plRrJGW3SSNnK4Db7+6m6E=; b=PztPaRRpL6BM6yv+BTIoq7ehN
 1zLuidDPh084Sq3x5bLVTEpn402Z8F+leTw0LyVXPG5gzh4dMEMMY8wJE6UxEjR4k8+EkczIwWFO4
 Yt62UTAqmlbPvzAHOpXCGAaGGMI20VYsKbMObppOXk4fvTeglSlQn3jVoMwi9Eu4EJ5wj1Kd84M4V
 VbMk46Jc/NtQMqJxsCAoPXHzur0VSsZQlUBlfbMh06bKi9Ed3r9ykUofVFyR3Fv4iePwu+Coep5nC
 Dxd7ABiav5xtKFbzkKQ5EvonRT2QgQTA7Yys1emTspcns4sWDZaAMf4lh0sed2MFBj6pgBSZjmbuB
 lGRDsxujA==;
Content-Disposition: inline
In-Reply-To: <a27d5689-49d9-2802-3819-afd0f1f98483@suse.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Mike Kravetz <mike.kravetz@oracle.com>

On Mon, Apr 09, 2018 at 04:18:07PM -0500, Goldwyn Rodrigues wrote:

I'm sorry I missed this email.  My inbox is a disaster :(

> I tried these patches against next-20180329 and added the patch for the
> bug reported by Mike Kravetz. I am getting the following BUG on ext4 and
> xfs, running generic/048 tests of fstests. Each trace is from a
> different instance/run.

Yikes.  I haven't been able to reproduce this.  Maybe it's a matter of
filesystem or some other quirk.

It seems easy for you to reproduce it, so would you mind bisecting it?
Should be fairly straightforward; I'd start at commit "xarray: Add
MAINTAINERS entry", since the page cache shouldn't be affected by anything
up to that point, then bisect forwards from there.

> BTW, for my convenience, do you have these patches in a public git tree?

I didn't publish it; it's hard to push out a tree based on linux-next.
I'll try to make that happen.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
