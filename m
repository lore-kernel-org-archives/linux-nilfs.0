From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Date: Tue, 26 Dec 2017 19:54:40 +0300
Message-ID: <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vKCfdd3gIv260S5loT4xjao+ZRqHBxT5I4CQ7RFl0yk=;
        b=oF2LzuMi7t4i2BnEt7zG8jyJwtZ10po+wyJEnefFLyIetz8/DXpAQxbMKQ2HaiU8JZ
         KEkSPh5GUnBEppSF00B4WwHhb/VKrPDIc7FH0WxD7E/3WITNqm9bbpekd6MOnsat5eLO
         g2I5L35keFdjFv9FbB4hS3sRNwVDK8XJap4Lf0Pmu4c2aUHkjU3jARYRCJJMACXT/YIK
         beuHimU9M6vI7k9pxgpIjMRKJr+rUyTtZ6la4X5mBibjxqdislSuPlC50x9qOWT2/JCI
         ilFl02C982c8jBNblu2fes8U/u3dlRp4PclIPPsYnA9nXNmlBVa8IbwuvdND0XdBwYI1
         e2zw==
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-4-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Dec 15, 2017 at 02:03:35PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> This results in no change in structure size on 64-bit x86 as it fits in
> the padding between the gfp_t and the void *.

The patch does more than described in the subject and commit message. At first
I was confused why do you need to touch idr here. It took few minutes to figure
it out.

Could you please add more into commit message about lockname and xa_ locking
interface since you introduce it here?

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
