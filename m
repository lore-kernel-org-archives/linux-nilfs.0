From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date: Sat, 19 Nov 2022 10:02:05 +0900
Message-ID: <CAKFNMomd9j3o1iQN6kyUoDcEKGwh34CqAjAWeF5g_s8eSEVX5Q@mail.gmail.com>
References: <20221114040441.1649940-1-zhangpeng362@huawei.com>
 <CAKFNMomu3Sf4_QHOm=zXM-QiLaVxASpMqpjek0F3SQnXwje4KA@mail.gmail.com> <CAKFNMonXdyMw9mrQeGe_KtSfMDPSC_jNai8FZGceVyV9Nxw8AQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rlT2eva1Dr7TgqfsYlKAOHQYOBdy4szmlJCNqoMCyFQ=;
        b=VOjf5eujWq+PJS0lBZYTm6+xd/PIrorMDmkkZd2vnoRpD7bMImm+QxBfUzg8df58CD
         HdiUNCD6Wv/nT0Up7oyVv+btfKbd3xEfTbOVRtkaT/2Mc3DdA0SEXH/WCHlsIDCtxyN6
         MvOmXtid5yJLdTuqSinNPUl0bjCSuF6es+Spu2SzrlN541I5MtRLjPAY23Apc1p0yLo2
         otd6nc+6j7/B9CAZS0DOz+EQVLKQjF9/hbSpgJoBwsm5fy1cuoRl3Ui+U/3TCyFLQFfL
         ZtGGdfe63mM+vVZA8ft0AV108A5JaXI58VpooQCtPAzLkAbMHxy61Iz3H8wNpIPFLsYP
         Ml8w==
In-Reply-To: <CAKFNMonXdyMw9mrQeGe_KtSfMDPSC_jNai8FZGceVyV9Nxw8AQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Zhang <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Sat, Nov 19, 2022 at 9:38 AM Ryusuke Konishi wrote:
> On Tue, Nov 15, 2022 at 3:39 AM Ryusuke Konishi  wrote:
> > On Mon, Nov 14, 2022 at 12:39 PM Peng Zhang wrote:
> What was happening here was complicated.
> There were two state inconsistencies in DAT:
> 1) A virtual block number (vblocknr == 6145) in the report, was used
> twice in a btree.
>     Because of this, nilfs_dat_commit_end() on that address was called twice.
> 2) For the virtual block number (vblocknr == 6145), the DAT bitmap
> status was free (second anomaly), and nilfs_dat_commit_alloc() was
> performed at the same time as the second nilfs_dat_commit_end() above.
>
> As I mentioned, when nilfs_dat_commit_end() frees a virtual block
> number in the bitmap of DAT, nilfs_dat_prepare_end() usually allocates
> buffer heads of the bitmap block and the descriptor block, and sets
> them to the request struct.  But, the above two anomalies overlap, as

> you pointed out, de_block is initialized to 0 by
> nilfs_dat_prepare_alloc() in the middle of "prepare" and "commit", and

I wrote it wrong, this should be ".., de_blocknr is initialized to 0
by nilfs_dat_commit_alloc() ..".

Ryusuke Konishi
