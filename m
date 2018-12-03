From: PanBian <bianpan2016@163.com>
Subject: Re: [PATCH] nilfs2: fix potential use after free
Date: Mon, 3 Dec 2018 17:14:55 +0800
Message-ID: <20181203091455.GA9038@bp>
References: <1543201709-53191-1-git-send-email-bianpan2016@163.com>
 <20181203.181051.1348099310050315226.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: PanBian <bianpan2016@163.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=Qpbfx
        09WsH0vUx9H/ZJVpKs7ntILqCAHmG4x4+GbK1E=; b=pulffLmJJjzQNiSl0ODUd
        GlelITUZbC3ZJbxi5YLcVIfTGKHvCozRVmOKeyVTk096WFEUkyn2MYxOdsF1mb8D
        i/OMFbyLHrY+SnbNDq5n0bepkU7PWEQDqFLTuX3wnVX8sd11x8OXiqh/y7tshx52
        2tvqpqRpD/qtw+PxXqXADM=
Content-Disposition: inline
In-Reply-To: <20181203.181051.1348099310050315226.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 03, 2018 at 06:10:51PM +0900, Ryusuke Konishi wrote:
> Hi, Pan Bian
> 
> Thank you for feeding back this patch.
> I reviewed this and am thinking this must be sent to upstream.
> 
> Did you see any kernel oops on this bug ?

Not yet. In fact, I found it with a static method.

Best regards,
Pan Bian

> 
> Regards,
> Ryusuke Konishi
> 
> On Mon, 26 Nov 2018 11:08:29 +0800, Pan Bian <bianpan2016@163.com> wrote:
> > brelse(bh) is called to drop the reference count of bh when the call
> > to nilfs_dat_translate fails. If the reference count hits 0, bh may be
> > freed. However, bh->b_page is unlocked and put after that, which may
> > result in a use-after-free bug. This patch moves the release operation
> > after unlocking and putting the page.
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > ---
> >  fs/nilfs2/gcinode.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> > index aa3c328..a24bb29 100644
> > --- a/fs/nilfs2/gcinode.c
> > +++ b/fs/nilfs2/gcinode.c
> > @@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
> >  		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
> >  
> >  		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
> > -		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
> > -			brelse(bh);
> > +		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
> >  			goto failed;
> > -		}
> >  	}
> >  
> >  	lock_buffer(bh);
> > @@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
> >   failed:
> >  	unlock_page(bh->b_page);
> >  	put_page(bh->b_page);
> > +	if (unlikely(err))
> > +		brelse(bh);
> >  	return err;
> >  }
> >  
> > -- 
> > 2.7.4
> > 
> > 

