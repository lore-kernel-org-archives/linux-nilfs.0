From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] nilfs2: fix hang problem after bio_alloc() failed
Date: Sun, 21 Jun 2009 13:08:43 +0200
Message-ID: <87ocshvo78.fsf@basil.nowhere.org>
References: <20090614153256.GA4020@homero.springfield.home>
	<20090615.030245.104791670.konishi.ryusuke@gmail.com>
	<20090614181313.GA16597@homero.springfield.home>
	<20090619.023455.111674749.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754880AbZFULIw@vger.kernel.org>
In-Reply-To: <20090619.023455.111674749.ryusuke@osrg.net> (Ryusuke Konishi's message of "Fri, 19 Jun 2009 02:34:55 +0900 (JST)")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, users@nilfs.org

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:
>  
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 22c7f65..e8f188b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1846,26 +1846,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
>  		err = nilfs_segbuf_write(segbuf, &wi);
>  
>  		res = nilfs_segbuf_wait(segbuf, &wi);
> -		err = unlikely(err) ? : res;
> +		err = unlikely(err) ? err : res;

It's very dubious gcc does anything with unlikely here anyways.
They typically only work directly in conditions being tested.

>  		if (unlikely(err))
>  			return err;

Also gcc generally considers conditions to blocks that
return unlikely, so it's actually superfluous.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
