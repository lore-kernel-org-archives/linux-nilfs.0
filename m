From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] nilfs2: set the mapping error when calling
 SetPageError on writeback
Date: Tue, 07 Mar 2017 22:46:12 +0900 (JST)
Message-ID: <20170307.224612.801707040634574055.konishi.ryusuke@lab.ntt.co.jp>
References: <20170305133535.6516-1-jlayton@redhat.com>
	<20170305133535.6516-2-jlayton@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NiDJZyjAfKFNriWegM/04ejTTxlKih2Tq28qxqDbqo4=;
        b=CPtGCKlpCluM7sM7ledhtzRWLUKC4uvh6XdPK83qw2h0QXZDrrqN+g7Hj2ACOPclcP
         J/PMACIkmFa+w3FG2gb7OwKbgYZw/RWBywofnuvRuQr4Uff2Q+jcMKZOh/4UGxoWEDad
         01YA9j/RJx4eNnpRCpXqgs0uNERVA4boMSWxFNUwK8ofaxaj2Sumis2gsJhp1lXZj9ot
         y46NKIXJp7uu9hIGnIWyl6e0wYvucMjovF3lDffYdX/6XDo+dbe1oyTkvWJKbHw3iKxp
         /+FxnsicKAY6Tvj7nsXkUXp8VgkdE8jwWCMokyeAyT1aIL2kgyM2TJhsfjWx1dnE48N1
         dgsg==
In-Reply-To: <20170305133535.6516-2-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Sun,  5 Mar 2017 08:35:33 -0500, Jeff Layton <jlayton@redhat.com> wrote:
> In a later patch, we're going to want to make the fsync codepath not do
> a TestClearPageError call as that can override the error set in the
> address space. To do that though, we need to ensure that filesystems
> that are relying on the PG_error bit for reporting writeback errors
> also set an error in the address space.
> 
> The only place I've found that looks potentially problematic is this
> spot in nilfs2. Ensure that it sets an error in the mapping in addition
> to setting PageError.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Agreed that nilfs2 needs this if the successive patch is applied.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/segment.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index bedcae2c28e6..c1041b07060e 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1743,6 +1743,7 @@ static void nilfs_end_page_io(struct page *page, int err)
>  	} else {
>  		__set_page_dirty_nobuffers(page);
>  		SetPageError(page);
> +		mapping_set_error(page_mapping(page), err);
>  	}
>  
>  	end_page_writeback(page);
> -- 
> 2.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
