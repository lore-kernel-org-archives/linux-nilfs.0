From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 14:24:53 +0100
Message-ID: <20100824132453.GU31363@ZenIV.linux.org.uk>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <20100824074844.GH3948@amd>
 <20100824.211931.233007881.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100824.211931.233007881.ryusuke@osrg.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke@osrg.net>
Cc: npiggin@kernel.dk, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Tue, Aug 24, 2010 at 09:19:31PM +0900, Ryusuke Konishi wrote:
> > It just needs some helper function to do the non-sb related init
> > stuff for you.
> 
> I'm seeking the way to make that special type of inodes hold a valid
> sb.  If it's not feasible, I think nilfs should not borrow inode
> object and should define just enough structure instead.

For fsck sake, just grab an active reference to superblock for the
duration of GC and use _normal_ inodes...
