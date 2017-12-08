From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Fri, 8 Dec 2017 15:01:31 -0800
Message-ID: <20171208230131.GC32293@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207003843.GG4094@dastard>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=q8YnMhaB1nPfAQll0gag9FlStWyp6gz7WbRYgH47jK4=; b=LvUF1ibQVGs0K17HCSMW5UP6m
	JOU8hMlHpQyJEjRcYHsqpFLoIL3RhTlrLiHUVJs4vAGsK94At7t4xfaBGfpVmWwT3Z7r/EJP3C8LO
	jmRP5/jjZvnHUBk55UlDC+HzQ/LYnmDSvi6izMXyml/WRFDcpzjOd2v9A2BU4IaLK9ljQ0fHxnIO7
	M1urUdiEaB3s0tDQLmD/IBPylAj96IsZd1EayX4/YujB013W0oXPUcMLUHyveOUUeaKBoNp8F8BlU
	s3StpJ1AAxneoXXKHoMkHvZGR/CS1a/PUHTMcplSza4dEMHLoK1yE0ky+L0fyCQjOxrmFILfd5QzK
	yoF8vPSqw==;
Content-Disposition: inline
In-Reply-To: <20171207003843.GG4094@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 07, 2017 at 11:38:43AM +1100, Dave Chinner wrote:
> > > cmpxchg is for replacing a known object in a store - it's not really
> > > intended for doing initial inserts after a lookup tells us there is
> > > nothing in the store.  The radix tree "insert only if empty" makes
> > > sense here, because it naturally takes care of lookup/insert races
> > > via the -EEXIST mechanism.
> > > 
> > > I think that providing xa_store_excl() (which would return -EEXIST
> > > if the entry is not empty) would be a better interface here, because
> > > it matches the semantics of lookup cache population used all over
> > > the kernel....
> > 
> > I'm not thrilled with xa_store_excl(), but I need to think about that
> > a bit more.
> 
> Not fussed about the name - I just think we need a function that
> matches the insert semantics of the code....

I think I have something that works better for you than returning -EEXIST
(because you don't actually want -EEXIST, you want -EAGAIN):

        /* insert the new inode */
-       spin_lock(&pag->pag_ici_lock);
-       error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
-       if (unlikely(error)) {
-               WARN_ON(error != -EEXIST);
-               XFS_STATS_INC(mp, xs_ig_dup);
-               error = -EAGAIN;
-               goto out_preload_end;
-       }
-       spin_unlock(&pag->pag_ici_lock);
-       radix_tree_preload_end();
+       curr = xa_cmpxchg(&pag->pag_ici_xa, agino, NULL, ip, GFP_NOFS);
+       error = __xa_race(curr, -EAGAIN);
+       if (error)
+               goto out_unlock;

...

-out_preload_end:
-       spin_unlock(&pag->pag_ici_lock);
-       radix_tree_preload_end();
+out_unlock:
+       if (error == -EAGAIN)
+               XFS_STATS_INC(mp, xs_ig_dup);

I've changed the behaviour slightly in that returning an -ENOMEM used to
hit a WARN_ON, and I don't think that's the right response -- GFP_NOFS
returning -ENOMEM probably gets you a nice warning already from the
mm code.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
