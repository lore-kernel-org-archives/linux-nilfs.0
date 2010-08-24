From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 17:48:44 +1000
Message-ID: <20100824074844.GH3948@amd>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, linux-nilfs@vger.kernel.org

On Sun, Aug 22, 2010 at 07:05:00PM +0900, Ryusuke Konishi wrote:
> This is a patchset to remove own inode hash table from nilfs.
> 
> The current version of nilfs uses inode not only to manage regular
> files, directories, symlinks but also for some types of metadata and
> for caching file blocks relocated by GC.
> 
> The last type of inodes is called gc-inodes, and nilfs keeps them with
> an own hash table.
> 
> With this patchset, the gc-inodes will be stored in vfs inode cache
> like regular inodes, and the own inode hash is deleted.
> 
> I hope this would be helpful for the vfs scalability work.

This looks like a reasonable direction to me, and you would get
more of the benefits of the inode cache scalability work, but this
wasn't the biggest prolem for my series, because I'm not going digging
into the filesystems themselves.

The reason I broke nilfs2 is because it duplicates a lot of the
generic inode initialisation code. This really should go in core
code because nilfs2 does not own the generic inode fields.

It just needs some helper function to do the non-sb related init
stuff for you.

Thanks,
Nick
