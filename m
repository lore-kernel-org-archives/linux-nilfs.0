From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date: Sat, 19 Nov 2022 16:24:43 +0900
Message-ID: <CAKFNMokh1fQNyqVCMWoQVnRnXf65j__Op9p+a3Prz_qk-YnoVQ@mail.gmail.com>
References: <20221114040441.1649940-1-zhangpeng362@huawei.com>
 <CAKFNMomu3Sf4_QHOm=zXM-QiLaVxASpMqpjek0F3SQnXwje4KA@mail.gmail.com>
 <CAKFNMonXdyMw9mrQeGe_KtSfMDPSC_jNai8FZGceVyV9Nxw8AQ@mail.gmail.com> <422d9c54-a119-b2a2-f381-11f83af3d9ea@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pBdMJNbSH8U8r3sDotTSzBIJa9GdWBR9o8sXjNY/x8I=;
        b=QneZXLTu/TV8Zrw0Vs8fqN62kXxM0ofhET0pwOh3uIjPAu02hOdd4dXZXR2towYCV7
         VWNyqv8eRp/XSY5b26St/+ch2z/LJ7oxVk7pFbGvfmYe6TezAR/MUe1VhuAMk0gAJxZN
         KwtyG82Gj4zGut9f9xbX6YbI/EOYgG+3AqYvA1BpOLTYJzu+colIarHQKCJIPD3rfLT1
         qf1eEujz2HsYv43WdEJxsQJ/dbPjPGstEgPMxKJkS84D7inypvpN5D/104wNMaVzLxS4
         olGLbsCpb7a1L9cuCAaNIc/zlJp2TPc9orOCQUp0sWHpA0ppRQLPxJxTE90LslVyC+XM
         EW5g==
In-Reply-To: <422d9c54-a119-b2a2-f381-11f83af3d9ea-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhangpeng (AS)" <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Sat, Nov 19, 2022 at 3:38 PM zhangpeng (AS)  wrote:
>
> Hi, ZhangPeng,
>
> On Tue, Nov 15, 2022 at 3:39 AM Ryusuke Konishi  wrote:
> As for the current outlook, it seems difficult to eliminate
> duplication of the virtual block number, so I think we will call
> nilfs_error() as follows:
>
>         nilfs_dat_commit_entry(dat, req);
> +        if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
> +                nilfs_error(dat->i_sb,
> +                            "state inconsistency due to duplicate use
> of vblocknr = %llu",
> +                            (unsigned long long)req->pr_entry_nr);
> +                return;
> +       }
>         nilfs_palloc_commit_free_entry(dat, req);
>
> In that case, I would like to modify your patch and send it upstream
> as your patch.  Is that OK ?
> Or do you want to fix it more by yourself ?
>
> Thanks,
> Ryusuke Konishi
>
> Thanks for your advice.
>
> Please modify my patch and send it upstream.
>
> That is really a complicated problem. Duplication of the virtual block
> number is not easy to fix. It is necessary to prevent further operations
>  of the filesystem when the filesystem has a fatal flaw. I will continue
>  to follow up.

All right, thanks!

Ryusuke Konishi
