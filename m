From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v11 54/63] dax: Hash on XArray instead of
 mapping
Date: Mon, 21 May 2018 03:25:24 -0700
Message-ID: <20180521102524.GB20878@bombadil.infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-55-willy@infradead.org>
 <20180521044756.GD27043@linux.intel.com>
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
 bh=7AJgEeNDIBHHUZXJ3mq8quqXebknEr0bs/FtKi3Pdmc=; b=MbLkVtbDm8aP5bs0gOSSdNike1
 /WfVwztiAOFItgMgI3gStH+dSb6ClSgc2C80Q/BkAl7mv1L/Ye5M9MUxyBEBifsadz7JycYGH2dD1
 WrKNoiIxR9BXa40Q/YBePAKYSpDtLj5SozNzu4RpyekqzIGtTtgP5rb3My1E9nwCwXKo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7AJgEeNDIBHHUZXJ3mq8quqXebknEr0bs/FtKi3Pdmc=; b=EJ3yv789SId3ssYg/v83H3Cy/b
 S2BuSG0IJG+Uozd8iaAENEiuz/C9MIs5zOiaEv8//7LUalaAno4KXPziFKh01oJT2ERiur2l+tzS5
 v7A3xR7wGV7nVQkkH/gYguE76goXQA2RN+7MebQVfjR2g34XvljJODNjivXNIZxpJR7w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7AJgEeNDIBHHUZXJ3mq8quqXebknEr0bs/FtKi3Pdmc=; b=rVgucm4shjP8A0SpJyszNxSpn
 AZvkxGSnPNxIzcIrZ8TLqK0WhKrfh7fwn2asZaTwuYGx4n4KtL4ESFd2aE+YpZ+gyfdV0PJDtI/9y
 rBtiktbqUCtZ7+sPgXL+Q33y/pnGx0jtRNBq1/497dH01F5+ttOv6DmUXEIqzHXzWy/5i4BFHi/BF
 OJtlg5SKe00ptDF+4f4J9q9jG1Wmk2h6QCoDXUmyt2KQFv9y8F7VVHGrLUikp6rexY+ptR825z+kT
 ZuuUdhEkFEj2c0emXiS2cclFv6vYNGz3B/4siI+h8mPeQegjoPMVMHQw7KVG6A05Ngmjk8fcagwVv
 JfaiqOOOg==;
Content-Disposition: inline
In-Reply-To: <20180521044756.GD27043@linux.intel.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>

On Sun, May 20, 2018 at 10:47:56PM -0600, Ross Zwisler wrote:
> On Sat, Apr 14, 2018 at 07:13:07AM -0700, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > Since the XArray is embedded in the struct address_space, this contains
> > exactly as much entropy as the address of the mapping.
> 
> I agree that they both have the same amount of entropy, but what's the
> benefit?  It doesn't seem like this changes any behavior, fixes any bugs or
> makes things any simpler?

This is a preparatory patch for some of the changes later in the series.
It has no benefit in and of itself; the benefit comes later when we
switch from dax_wake_mapping_entry() to dax_wake_entry():

static void dax_wake_entry(struct xa_state *xas, bool wake_all)

This switch could be left until the end; I can introduce dax_wake_entry()
without this change:

+static void dax_wake_entry(struct xa_state *xas, bool wake_all)
+{
+	struct address_space *mapping = container_of(xas->xa,
+			struct address_space, i_pages);
+       return dax_wake_mapping_entry_waiter(mapping, xas->xa_index, NULL,
+			wake_all);
+}

and then cut everybody over in the final step.

Or I can just explain in the changelog that it's a preparatory step.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
