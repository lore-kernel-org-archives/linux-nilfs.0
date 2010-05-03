From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] nilfs2: fix sync silent failure
Date: Mon, 3 May 2010 14:53:13 +0200
Message-ID: <20100503125313.GC27497@kernel.dk>
References: <20100503.210048.267730124.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100503.210048.267730124.ryusuke@osrg.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>

On Mon, May 03 2010, Ryusuke Konishi wrote:
> This is another fix for the silent sync failure related to sb->s_bdi.
> 
> The commit 5129a469, which was merged to -rc6, let me know this
> problem.  I'm sorry that I was late to realize this.
> 
> Nilfs uses an own get_sb callback, and needed to set s_bdi for itself.
> I confirmed this patch made ->sync_fs() called as intended.
> 
> I hope this is sent for 2.6.34.  Please let me know if you have any
> comments.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

Linus, will you pick this one up, or do you want me to merge it and send
it your way?

-- 
Jens Axboe

