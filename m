From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 10/61] xarray: Change definition of sibling entries
Date: Fri, 16 Mar 2018 15:00:02 -0400
Message-ID: <20180316190001.56clqrub6gy6lzh5@destiny>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-11-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uuAQ5LHP2J2TtYlsQZWQco+P1TxU74toR075q7kOwsM=;
        b=NoWV8+PXAKFpvrqJYDgCuD2Tw8SAtRyyf9/PKjt+oYW7CjKYGAwvGupSq3FvmGnEPo
         M+1V+5EFmanm68XSkIDGPv14p98uenedH7j68LWlpP56VrZi1h/9LBbCNvMELaahTc7W
         7Y2jmw636+Ns7wHjVLQjAIkkbz8rjXLCdzQCtZKn141ZpejyyQxZSP0xTQvcZuI4aMy9
         xvDvA0NDDGYZV/3Ec/JfLMouU1fB40BOUW+ju8cqpSFGSoO7m9O5TkWDrprIYCS6g/HE
         q7Cg2bllI8mOPwtzJO6DAuIwN6eKh54A/z7IeMng+OS71LfHowlD/XbKATpM62WqBlao
         RnCw==
Content-Disposition: inline
In-Reply-To: <20180313132639.17387-11-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 06:25:48AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Instead of storing a pointer to the slot containing the canonical entry,
> store the offset of the slot.  Produces slightly more efficient code
> (~300 bytes) and simplifies the implementation.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  include/linux/xarray.h | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/radix-tree.c       | 66 +++++++++++------------------------
>  2 files changed, 112 insertions(+), 47 deletions(-)
> 

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
