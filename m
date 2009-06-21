From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [NILFS users] [PATCH] nilfs2: fix hang problem after
 bio_alloc() failed
Date: Sun, 21 Jun 2009 21:34:09 +0900 (JST)
Message-ID: <20090621.213409.32665554.ryusuke@osrg.net>
References: <20090614181313.GA16597@homero.springfield.home>
	<20090619.023455.111674749.ryusuke@osrg.net>
	<87ocshvo78.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751850AbZFUMe2@vger.kernel.org>
In-Reply-To: <87ocshvo78.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: users@nilfs.org, andi@firstfloor.org
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org

Hi Andi,
On Sun, 21 Jun 2009 13:08:43 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:
> >  
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 22c7f65..e8f188b 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
> > @@ -1846,26 +1846,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
> >  		err = nilfs_segbuf_write(segbuf, &wi);
> >  
> >  		res = nilfs_segbuf_wait(segbuf, &wi);
> > -		err = unlikely(err) ? : res;
> > +		err = unlikely(err) ? err : res;
> 
> It's very dubious gcc does anything with unlikely here anyways.
> They typically only work directly in conditions being tested.

I got it. I'll rewrite the first bugfix so that it just removes the
unlikely directive.

-		err = unlikely(err) ? : res;
+		err = err ? : res;


> >  		if (unlikely(err))
> >  			return err;
> 
> Also gcc generally considers conditions to blocks that
> return unlikely, so it's actually superfluous.

Thanks, I didn't know this.  I'll take in this, too.
 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.

Regards,
Ryusuke Konishi
