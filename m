From: Ryusuke Konishi <ryusuke@osrg.net>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Wed, 25 Aug 2010 02:00:10 +0900 (JST)
Message-ID: <20100825.020010.163254582.ryusuke@osrg.net>
References: <20100824153214.GA25897@infradead.org>
	<20100825.012012.179486471.ryusuke@osrg.net>
	<20100824164216.GV31363@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100824164216.GV31363@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, npiggin@kernel.dk, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Tue, 24 Aug 2010 17:42:16 +0100, Al Viro wrote:
> On Wed, Aug 25, 2010 at 01:20:12AM +0900, Ryusuke Konishi wrote:
> > So, my implementation issue here is how to free dentries and inodes of
> > snapshots like shrink_dcache_for_umount(sb) does for a single
> > namespace.
> 
> Use d_obtain_alias() to allocate roots of unattached subtrees.

OK, I'll try that.

Thank you!

Ryusuke Konishi
