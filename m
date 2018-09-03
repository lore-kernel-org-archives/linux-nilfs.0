From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Sun, 2 Sep 2018 21:49:49 -0700
Message-ID: <20180903044949.GB17856@bombadil.infradead.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xssHXQ9TFloh+QLsqre9b/6qtjcnjcD+GmpNadCPBy8=; b=kdjpFoLhERhb+vRc5Q0eIQW3j
        z0vSd1/ZcKFUP+es+fIToqFeu91wUiH8P6FOsh4Kqbado7YmKAl3CCaepb41ezMbxDEjg76gwSlmH
        k2DX/X9LVIAmJUi3cwDp9Lg2L26CMzyqyxnATSU/ecpE2DJcSAryNfyyknUlMtaOc9o892kY1/yym
        vc7YRU1Uc9THwUxGu8WQcEm8WaQtyPL51gGZYSj5hZB61BZjBMX9PaOqk2f8yT76/rbKEi/5+hAcd
        V3pwSXPDjauTMjVr1S6YdkiQGjidVZu8vyiHPdMK34gnGmJRg7VO+bJr79S9Bsx3zF+JWdXjwrtX/
    
Content-Disposition: inline
In-Reply-To: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca, axboe@kernel.dk, darrick.wong@oracle.com, ebiggers@google.com, pombredanne@nexb.com, agruenba@redhat.com, gregkh@linuxfoundation.org, kemi.wang@intel.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org

On Thu, Aug 30, 2018 at 10:55:47PM +0530, Souptick Joarder wrote:
> +vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			 get_block_t get_block, int *err)

I don't like returning both the errno and the vm_fault_t.  To me that's a
sign we need to rethink this interface.

I have two suggestions.  First, we could allocate a new VM_FAULT_NOSPC
bit.  Second, we could repurpose one of the existing bits, such as
VM_FAULT_RETRY for this purpose.

> -int ext4_page_mkwrite(struct vm_fault *vmf)
> +vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)

I also think perhaps we could start by _not_ converting block_page_mkwrite().
Just convert ext4_page_mkwrite(), and save converting block_page_mkwrite()
for later.

