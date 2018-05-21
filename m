From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v11 53/63] dax: Rename some functions
Date: Mon, 21 May 2018 03:11:39 -0700
Message-ID: <20180521101139.GA20878@bombadil.infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-54-willy@infradead.org>
 <20180521044236.GC27043@linux.intel.com>
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
 bh=rNw8F93eKMAqetGpvS6mofG0ekjUDi6pS5jr/jUq0gM=; b=bF5cuNeGq/Ll8EB9KSJs+pjqlN
 oHR8jLSSX3TLNNeLMss5nEt1GLxMSi/DAXvLT3Sq7TrTFyu1H56iXhuxxw5to6NrPxsHleM5fAsJV
 ncjwS8SgAht/grOg1yKrSteCUfXmZ4jnQe9jP67AOc8zAnyimMrYWiiif5Z3MyWTmr/A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rNw8F93eKMAqetGpvS6mofG0ekjUDi6pS5jr/jUq0gM=; b=Ms6CLehFjuo6YwBoOcU9a4Nv3D
 AIhog1rLFXGyr5p2Jx5WG3/3vGQaxOW+aLPEIi8+d/wuPjxHdWiWCK8AtWtN6i2R+vcqDiwY1v66Z
 j6ABXEVvDMjrL/Fiy5V5lmS7AbDijou21b2nXwzDn5kqKNWOr3xrwqVby7MhUXQcMFB8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rNw8F93eKMAqetGpvS6mofG0ekjUDi6pS5jr/jUq0gM=; b=pwso5acVVyowYRJ18eklHUxY7
 ndl1iq2VxPfvVUT2Iuit93JiKB7QU4xmVAwMgk1tfoULj02UN7pXtGN4mbSHRzcr9MVfaN+jooPOV
 R123UXHL0rNJJERxffUavZsuZY3a3SH7Yx6Pa6WMOGZBRYtZwttf1vo4wjDcDY7C2JROPniI5pDTH
 xR+W0g8LQrgl2mtXQrU1gHrwkM6/x92rhfDaPzeKb/MyA1tSdOoWQE3sSArw9C+SS1VNix2LKgIL8
 WG4NkHX1Fyp3NfzYMjvr2kBPu/NnQJFG+z+vj19SqF0N8vq7xcUSLkDtpwnYZqKrM4EOUSJonKW4I
 MLLv9jRaA==;
Content-Disposition: inline
In-Reply-To: <20180521044236.GC27043@linux.intel.com>
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

On Sun, May 20, 2018 at 10:42:36PM -0600, Ross Zwisler wrote:
> > -static void *dax_radix_locked_entry(unsigned long pfn, unsigned long flags)
> > +static void *dax_mk_locked(unsigned long pfn, unsigned long flags)
> 
> Let's continue to use whole words in function names instead of abbreviations
> for readability.  Can you please s/dax_mk_locked/dax_make_locked/ ?
> 
> I do realize that the xarray function is xa_mk_value() (which I also think is
> perhaps too brief for readability), but in the rest of DAX we use full words
> everywhere.

I find the current DAX code to be _so_ wordy that it obscures readability.
This particular instance isn't a hill worth dying on; I'll change it.

> > @@ -1519,15 +1517,14 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> >  
> > -/**
> > +/*
> 
> Let's leave the double ** so that the function is picked up properly by
> the documentation system, and so it's consistent with the rest of the
> functions.

This function is static.  I think it's worth keeping the documentation,
but making it part of the exported kernel API documentation is confusing.

By the way, nothing at all in fs/dax.c is picked up by the documentation
system today.  We should probably fix that ... did you want to look at it
or shall I propose a patch to anchor it somewhere?

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
