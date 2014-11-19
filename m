From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 1/1] nilfs2: Deletion of an unnecessary check before
 the function call "iput"
Date: Wed, 19 Nov 2014 09:09:54 +0900 (JST)
Message-ID: <20141119.090954.206625370231465945.konishi.ryusuke@lab.ntt.co.jp>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546B4E19.8050405@users.sourceforge.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=F2HIQ5/5FehXTIrdAJol2OHVib7LYsjeq+kewRUFbbg=;
        b=M+jGGY/095xwnI8H3KgIgqJe2DN3n3+7M5MwWf6tfC9eF0fLyFsAh0QH9D9NNv93Pb
         oa/Q6MePm54voT6nWEc4TlOd+8fdQE2kXfyjdHnL0O1aWjsxGIqBQoUYaAf7dRfsg1w3
         6Wkpq4NAzYZ+R3WOaAhrLr/OTRnOqhaI7ZK9gKDcSRwzgJi6menCbHWty5zawUb0iuIc
         OWHr/7PNPWA/JozVGtDUOHvmj5DFTeI/pU9H3vtwZ1OV9srO4XTDb6tYlntIxXFNQde5
         RfjBTUIm9gb9GuC4HXXjnuD3V7OeYI7GxFW4ZnLCdMdJWyJlt6zQeGzWcNx2DQZTisEd
         0PgA==
In-Reply-To: <546B4E19.8050405@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-nilfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr

On Tue, 18 Nov 2014 14:48:09 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 18 Nov 2014 14:41:27 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied to nilfs2 git tree.  Thanks.

Ryusuke Konishi


> ---
>  fs/nilfs2/the_nilfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 9da25fe..69bd801 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -808,8 +808,7 @@ void nilfs_put_root(struct nilfs_root *root)
>  		spin_lock(&nilfs->ns_cptree_lock);
>  		rb_erase(&root->rb_node, &nilfs->ns_cptree);
>  		spin_unlock(&nilfs->ns_cptree_lock);
> -		if (root->ifile)
> -			iput(root->ifile);
> +		iput(root->ifile);
>  
>  		kfree(root);
>  	}
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
