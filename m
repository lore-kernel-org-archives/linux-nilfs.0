From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 13/61] xarray: Add documentation
Date: Fri, 16 Mar 2018 15:12:37 -0400
Message-ID: <20180316191236.jsmlnwgy76htz5fi@destiny>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-14-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uF2PMW1VOlC7AoZKKuw9dUzMdYbnEKuHnfQM/oq8L9c=;
        b=fd/U95HCcEWnnffGFocj5qR0fJt5LLHGXEy1SehT62G8MJuTa/qSbn6LAum65URNSE
         JBq+fg8uWMrJzQwx/8DYVB0vXmRBV7EnN4WUYhRQLFVwPlI49ex+t9Oj8g9xWEy6nbJS
         ZtdFKvEkgulPklS6fL1liJFccLagg6inlumtrqub3qkdK/qM42KAAG1tFLpwet6nVDdC
         W0w24rrA1BCf3DavQKWtX0DRaFJ45Suq8/di4scylIpfzwBQwk5A4Z1HfXIM29nrucGS
         OgAV9KOO0bUzpn9krR5pZdF5r1KoxtlXYuwOI7dMngX0b5OGvXUYpyeVBKHNidnwUGKR
         xcEQ==
Content-Disposition: inline
In-Reply-To: <20180313132639.17387-14-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 06:25:51AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> This is documentation on how to use the XArray, not details about its
> internal implementation.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

I'm just going to assume you know what you are talking about here

Acked-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
