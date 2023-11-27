Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fEADOI60"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9FD4B;
	Mon, 27 Nov 2023 09:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z3F6jPflKA7CV9g/z0Zysna6Er1+ye9+ehS/jCO/u4o=; b=fEADOI60am2EtmgBMr4NHsf+CQ
	D6KT4KK0fLG/Jd21lGQdivwm6oKcmRDEBg6RE2iezvel/kA1Z6nOuxlPPIo24z85kaJNpPr8G2xBf
	Ci7FiLFFafGhSadep+fLJUwuEN0CSb28b7DjZ0lNiITKWWlM+2uoJ7VRkbm34pgfSGdFCKva/idGn
	g6EA+LIvvbBpTiyda3n/vu93lUzg2mvkUnzKl2FOoxs6DKm8RCehzQdso3Ce6nkjUk2GyUooobm9R
	FH7Gfih40SyUZ+W1SaMzndW3kcynMVC8yU7A9PnXJ3PLQ/PE5F2ZAjAN+DXg1CRNAA1Zrf6+r+Afc
	YcJzLnMw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r7f5i-00BZzD-3Q; Mon, 27 Nov 2023 17:08:14 +0000
Date: Mon, 27 Nov 2023 17:08:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] nilfs2: move page release outside of
 nilfs_delete_entry and nilfs_set_link
Message-ID: <ZWTM/tns2JTd1YrQ@casper.infradead.org>
References: <20231127143036.2425-1-konishi.ryusuke@gmail.com>
 <20231127143036.2425-2-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127143036.2425-2-konishi.ryusuke@gmail.com>

On Mon, Nov 27, 2023 at 11:30:20PM +0900, Ryusuke Konishi wrote:
> In a few directory operations, the call to nilfs_put_page() for a page
> obtained using nilfs_find_entry() or nilfs_dotdot() is hidden in
> nilfs_set_link() and nilfs_delete_entry(), making it difficult to track
> page release and preventing change of its call position.
> 
> By moving nilfs_put_page() out of these functions, this makes the page
> get/put correspondence clearer and makes it easier to swap
> nilfs_put_page() calls (and kunmap calls within them) when modifying
> multiple directory entries simultaneously in nilfs_rename().
> 
> Also, update comments for nilfs_set_link() and nilfs_delete_entry() to
> reflect changes in their behavior.
> 
> To make nilfs_put_page() visible from namei.c, this moves its definition
> to nilfs.h and replaces existing equivalents to use it, but the exposure
> of that definition is temporary and will be removed on a later
> kmap -> kmap_local conversion.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>

Ah; I see.  This makes it more like ext2, so I approve!

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
