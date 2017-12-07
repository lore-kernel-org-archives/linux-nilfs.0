From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Lockdep is less useful than it was
Date: Thu, 7 Dec 2017 14:39:56 -0800
Message-ID: <20171207223956.GD26792@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
 <20171207223803.GC26792@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=TODkRhrHbXsuc7LuZNfKQKyRlS1gb2a+xLMMgPNYUaY=; b=M9ASXs7dsPSqTG8P4egBBHdYX
	8HUldASEmdH8qVSt1hG0oJxSxddXamPoWXdylY9MxyejHLVXlX5AuHTlnRaN7HElTrR8sptpV7E4B
	zSgpFN76Rs5RCZgdrzFTquSIBP6txXxkEBWmPccJuHz0k+A2Q8D+1YKdj+TAWvkx5C9+A0HVfLnDg
	fkEg4rn2ulnQ5kKLY8mU7yeX+poQ74fcnaf6qORnSIeLzWCOQqLvsfOaVMqlxe12Bc6AAF8jF4EdE
	9X6zuaZ/sChLhTdV/FvIyoIMj0xfpnX653x1Zg5Q5o8n7CEXPvFc3iD+fah7S2jIe/q3TV9XFmes2
	yiQtjX40Q==;
Content-Disposition: inline
In-Reply-To: <20171207223803.GC26792@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, byungchul.park@lge.com

On Thu, Dec 07, 2017 at 02:38:03PM -0800, Matthew Wilcox wrote:
> You need to get LOCKDEP_CROSSRELEASE off.  I'd revert patches
> e26f34a407aec9c65bce2bc0c838fabe4f051fc6 and
> b483cf3bc249d7af706390efa63d6671e80d1c09

Oops.  I meant to revert 2dcd5adfb7401b762ddbe4b86dcacc2f3de6b97b.
Or you could cherry-pick b483cf3bc249d7af706390efa63d6671e80d1c09.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
