From: Ryusuke Konishi <ryusuke@osrg.net>
Subject: Re: [PATCH] nilfs2: remove BKL uses
Date: Tue, 06 Jul 2010 02:55:11 +0900 (JST)
Message-ID: <20100706.025511.266421917.ryusuke@osrg.net>
References: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<201007051650.23761.arnd@arndb.de>
	<20100705145324.GA5240@nowhere>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100705145324.GA5240@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: fweisbec@gmail.com
Cc: arnd@arndb.de, konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jblunck@suse.de

On Mon, 5 Jul 2010 16:53:29 +0200, Frederic Weisbecker wrote:
> On Mon, Jul 05, 2010 at 04:50:23PM +0200, Arnd Bergmann wrote:
> > On Sunday 04 July 2010, Ryusuke Konishi wrote:
> > > Nilfs has BKL uses in its put_super and remount functions, but none of
> > > them are necessary, just came from earlier push downs.  This
> > > eliminates the BKL uses from nilfs.
> > > 
> > > Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> > 
> > This looks good, but there is a another patch series pushing the BKL
> > into the get_sb and fill_super operations, which should be the final
> > pushdown for file systems. I wonder if there is a way to find a
> > shortcut on this so we don't need to add it first just to have you
> > go through the effort of removing it again.
> 
> 
> I could take his patch in the mount pushdown series.

OK, please treat this patch as needed.

I've forgotten the additional BKL push down patch and Jan's BKL
removal patch on nilfs, but yes, it looks omissible to add BKL and
remove it again there.

For now, I will drop my patch from my tree.

Thanks,
Ryusuke Konishi
