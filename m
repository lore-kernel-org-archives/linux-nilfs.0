From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sat, 13 Jun 2009 22:52:40 -0300
Message-ID: <20090614015240.GW30412@blitiri.com.ar>
References: <20090614013211.GA22552@homero.springfield.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758372AbZFNByU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090614013211.GA22552@homero.springfield.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leandro Lucarella <llucax@gmail.com>
Cc: linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, users@nilfs.org

On Sat, Jun 13, 2009 at 10:32:11PM -0300, Leandro Lucarella wrote:
> Hi!
> 
> While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
> sometimes they got stucked in D state, and the kernel had said the
> following message:
> 
>         NILFS: IO error writing segment
> 
> A friend gave me a hand and after adding some printk()s we found out that
> the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
> fail, making it return NULL; but we don't know how that causes the
> processes to get stucked.

By the way, those bio_alloc()s are using GFP_NOWAIT but it looks like they
could use at least GFP_NOIO or GFP_NOFS, since the caller can (and sometimes
do) sleep. The only caller is nilfs_submit_bh(), which calls
nilfs_submit_seg_bio() which can sleep calling wait_for_completion(). Is there
something I'm missing?

Thanks a lot,
		Alberto
