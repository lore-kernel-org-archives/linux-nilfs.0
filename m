From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 06/78] xarray: Change definition of sibling entries
Date: Tue, 26 Dec 2017 20:21:53 +0300
Message-ID: <20171226172153.pylgdefajcrthe3b@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-7-willy@infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iIwUwjCmg2zMO0A87ZUP/x5CBI2R/vlzxj8wSlVhcnA=;
        b=nkGLArK0P3kXXLDGABXDPS74IGPMlvMKsFM+pQdf1kNHVK4fT7tsJXhyzozQyRHzAC
         jK3yGF7+T2+HtQbcNFy/AXJxFMAt5MHiXKR+3mRegqql3vDjIur88QtoKNRHpOG8Movg
         zN/AkZGljmDRqOfzJExv+xws6C1KK1JUOHUEq6ugTenCmVxiRalUUEwBcvWS+hyP757b
         baVkE1gjYELvfOTMI2AsiiOUHKgM2ter3ZIGzVqB0+7VV9iQHj2jCp2bMUilcxp76Hlh
         1iUFeo2W6HkrE3YRCyiVXrGkJ3Pb69/N1wndYWYe0sa00guxfMC6LY7OeZi3jNJXen7H
         iiWA==
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-7-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Dec 15, 2017 at 02:03:38PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Instead of storing a pointer to the slot containing the canonical entry,
> store the offset of the slot.  Produces slightly more efficient code
> (~300 bytes) and simplifies the implementation.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  include/linux/xarray.h | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/radix-tree.c       | 65 +++++++++++----------------------------
>  2 files changed, 100 insertions(+), 47 deletions(-)
> 
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index 49fffc354431..f175350560fd 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -49,6 +49,17 @@ static inline bool xa_is_value(const void *entry)
>  	return (unsigned long)entry & 1;
>  }
>  
> +/**
> + * xa_is_internal() - Is the entry an internal entry?
> + * @entry: Entry retrieved from the XArray
> + *
> + * Return: %true if the entry is an internal entry.
> + */

What does it mean "internal entry"? Is it just a term for non-value and
non-data pointer entry? Do we allow anybody besides xarray implementation to
use internal entires?

Do we have it documented?

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
