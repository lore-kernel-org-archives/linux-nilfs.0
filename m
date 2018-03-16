From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 08/61] page cache: Use xa_lock
Date: Fri, 16 Mar 2018 14:06:35 -0400
Message-ID: <20180316180633.e755emgeeovo4ddq@destiny>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-9-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RHuFI8QVQdm2T+L10ptgMT2PtVygX9tQoxpyTnpp/Vg=;
        b=CHL1XcWJ+OgigMMjUaSeWeBcphgCJsdiDpkwY3pnjzgq+d40IL2rk7Tr1CPrTLNEE6
         o/nUJX8Oi1a+f8VM9gNpPTH8YOR676ykDn8AdwVCi56Il7JvpX4Via9Y3z7f1ZRN1ee5
         t6XyOJmIGJwgKjPqEWJbQkpsxj6wmkRoVlWl4sjysnDGqZ6S1gYUatdUrucbvADgwpLj
         wlHVoENcVwG9E3DPPlIy7/ReyN/HEsL3fvQkgbfJua5/YZPwlZhc5b2bUEZ1ZWVmO6XZ
         sJW0Oi0mZPTAFCQjBJtER62l/hLvxPDVq/USdUjqbak6lniW+0WlPrGFj7z4Wugvb4Ol
         miPA==
Content-Disposition: inline
In-Reply-To: <20180313132639.17387-9-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 06:25:46AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Remove the address_space ->tree_lock and use the xa_lock newly added to
> the radix_tree_root.  Rename the address_space ->page_tree to ->i_pages,
> since we don't really care that it's a tree.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> Acked-by: Jeff Layton <jlayton@redhat.com>

Man my eyes started to glaze over about halfway through this one

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
