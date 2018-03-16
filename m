From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 11/61] xarray: Add definition of struct xarray
Date: Fri, 16 Mar 2018 15:05:33 -0400
Message-ID: <20180316190531.kpepu5eaimnnixf5@destiny>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-12-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9GlgshM77ETIthoEs9EEVZtqy2s06k8X9oKsjRvYRT4=;
        b=grFkYknYPgaiU87yXSD93PMP/HzDpXFYqLNQL8VzJOHjWeVJFYxnnIdL7P4bLvKdTH
         1agcoldWgEkz/7CbdxoejiUkRwEu9zIzBfbanX/8JZaezNwjAR7hX79tC5bkbTajRYD2
         jfKhUw1qhzfexJ4MhFqGtp4psAhXKG2/mW57PeL9iB/CDnXqVGFzYjqSynn7tGKqQytd
         ftDA9+hfRsbFPLTRZjtsdHCQQl7qn+mCmIOM2iMDGozTZ12sfAculcWf3v9/BQVu3ZNU
         h4lWvZ5Xow6VCjCqmvCZZaZg7NhCDtYQ3sB8DALAX3ZxnV2bM0sKYJW6Dg3BXnj2RihQ
         veQA==
Content-Disposition: inline
In-Reply-To: <20180313132639.17387-12-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 06:25:49AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> This is a direct replacement for struct radix_tree_root.  Some of the
> struct members have changed name; convert those, and use a #define so
> that radix_tree users continue to work without change.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
