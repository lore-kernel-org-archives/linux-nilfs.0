From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 12/61] xarray: Define struct xa_node
Date: Fri, 16 Mar 2018 15:11:41 -0400
Message-ID: <20180316191140.gscdlmgnhnzjssdo@destiny>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-13-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XccCfNuK1m/zPHPD7A7F0QfHBd9d0UcFLKbAxafH0BA=;
        b=qiWjeY805Iu+zU1INR5JOPhJF8RGznL3ITMZWOi6e9NRiBUg+bncb84BXgfT7jM2Ls
         1qTvL7fKKg71wka3A5oALaacwt9EBqsyQtznzEJW74xwcv8m2tcOFxKkgPkIgbqBbq1p
         3ilHmQeQtT4/2Eis0K+TxxfVHpppsFUXrgM3tbtReK/tgQh60lnY+drecExE8OeBwbuA
         9ENYH6MzgWPwNekXbH30S8Wbr2xSB0eB7ldKvuzJYXbaaOZJxm7Y16tscN9FmDWT4fUv
         zM7mRwtDJR5PmYQ5F3jUAp0OupJyZYEgb8xTHzdtQhaKUmVI98PnhEVbUo6wfcfuwHkl
         ppDw==
Content-Disposition: inline
In-Reply-To: <20180313132639.17387-13-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 06:25:50AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> This is a direct replacement for struct radix_tree_node.  A couple of
> struct members have changed name, so convert those.  Use a #define so
> that radix tree users continue to work without change.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
