From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: delete unnecessary checks before brelse()
Date: Fri, 19 Aug 2022 17:42:57 +0900
Message-ID: <CAKFNMon7N0NAHNoXuH7JzwqbO_we95X+2MFi2tHf3OPs_uygNg@mail.gmail.com>
References: <20220819081700.96279-1-chi.minghao@zte.com.cn>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4KV0yn/NjRr9fnRDAYkJx34PxHIonAhhduVl0Tj79jY=;
        b=JPnTRyWRLSemO6XZp+7Bv4/ixzq0eGuPc2U7h/pFfbYZ8UAqOs9vTiLTH+GMbD9F1X
         hFB2rVyFMuU6bS6EiActsOd7FAxUYxTUc+i/+IKXajnr7wGfVBYwHkLCZvsuO8W5AJjn
         qq8iobjiRmqFZ/tMnsLWTc0xrODUqjhG2yse5Dkn/KXzP58f9Assveoi1HoOzbY8To8D
         969FWlun4z4ShSBcQL28vUHxB2u4Kiq4n9O75ckRQwUOhD86FXPEirF6spINAgzQ0Kfz
         IGHOXa7MCg6WmqItyPyTiJYw0O8WLooPlEyXZZl9Ag1JUjzfeETxaxR8WJTaJswZZvnK
         hS8w==
In-Reply-To: <20220819081700.96279-1-chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Fri, Aug 19, 2022 at 5:17 PM wrote:
>
> From: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
> The brelse() function tests whether its argument is NULL
> and then returns immediately.
> Thus remove the tests which are not needed around the shown calls.
>
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  fs/nilfs2/btree.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Will apply, thanks!

Ryusuke Konishi
