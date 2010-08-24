From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Tue, 24 Aug 2010 22:58:58 +1000
Message-ID: <20100824125858.GA8072@amd>
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
Cc: npiggin@kernel.dk, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nilfs@vger.kernel.org

On Tue, Aug 24, 2010 at 09:19:31PM +0900, Ryusuke Konishi wrote:
> On Tue, 24 Aug 2010 17:48:44 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> > On Sun, Aug 22, 2010 at 07:05:00PM +0900, Ryusuke Konishi wrote:
> > > This is a patchset to remove own inode hash table from nilfs.
> > > 
> > > The current version of nilfs uses inode not only to manage regular
> > > files, directories, symlinks but also for some types of metadata and
> > > for caching file blocks relocated by GC.
> > > 
> > > The last type of inodes is called gc-inodes, and nilfs keeps them with
> > > an own hash table.
> > > 
> > > With this patchset, the gc-inodes will be stored in vfs inode cache
> > > like regular inodes, and the own inode hash is deleted.
> > > 
> > > I hope this would be helpful for the vfs scalability work.
> > 
> > This looks like a reasonable direction to me, and you would get
> > more of the benefits of the inode cache scalability work, but this
> > wasn't the biggest prolem for my series, because I'm not going digging
> > into the filesystems themselves.
> > 
> > The reason I broke nilfs2 is because it duplicates a lot of the
> > generic inode initialisation code. This really should go in core
> > code because nilfs2 does not own the generic inode fields.
> 
> Yes, that is what I want to do next.
> I really want to eliminate the duplication.
> 
> > It just needs some helper function to do the non-sb related init
> > stuff for you.
> 
> I'm seeking the way to make that special type of inodes hold a valid
> sb.  If it's not feasible, I think nilfs should not borrow inode
> object and should define just enough structure instead.

Like Christoph said, inode fundamentally has a sb, so a different
data structure would make sense. You really shouldn't be using vfs
for sb-less inodes, so therefore you should be able to use your
own type for this.

But for vfs scale, that doesn't seem to be a problem, the problem
for me is just where it duplicates inode init stuff.

