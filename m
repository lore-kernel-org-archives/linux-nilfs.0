From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: improve inode allocation (was Re: [PATCH v2] nilfs2: improve the
 performance of fdatasync())
Date: Wed, 24 Sep 2014 01:35:05 +0900 (JST)
Message-ID: <20140924.013505.1831094490963391096.konishi.ryusuke@lab.ntt.co.jp>
References: <542164C1.7090504@gmx.net>
	<20140923.214701.237540042662663531.konishi.ryusuke@lab.ntt.co.jp>
	<542181ED.606@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=VV8bN+alQEVGQJA0/Zc5fLQtxGw+/coOvr3cIpYKxMQ=;
        b=jxTxAUjb0gHJMMRuyXPJYU2Sy0SS4kU51/1lPs/M5GINal/smrI8/VMR84XuuRXEyr
         pm+HmPURgwtxL/cXEYW07trdIuAujdZLu5MTHiIOHYTRAG77TNfug75a2lfgLq9qFRfB
         Ol2OEpRLPXpKWqjEZcjiVxDteyemzgfVAXBEtwn4lNX0x1iCn5AnLHMAOPJyMrCSrhem
         5JS0+K+4fQ19dKALAcOBdA5BRSZvlugGpXO8wV+rR3WSnUMb45AOK7CksHpIHIOP/KIK
         IW8rWrHKiIw+Cboc+5sIDvlOzx73viLkomXRGg27z8TWXt6aH6dxVsJT9a3as5nSK1lI
         2mlQ==
In-Reply-To: <542181ED.606-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 23 Sep 2014 16:21:33 +0200, Andreas Rohner wrote:
> On 2014-09-23 14:47, Ryusuke Konishi wrote:
>> By the way, if you are interested in improving this sort of bad
>> implemetation, please consider improving inode allocator that we can
>> see at nilfs_ifile_create_inode().
>> 
>> It always searches free inode from ino=0.  It doesn't use the
>> knowledge of the last allocated inode number (inumber) nor any
>> locality of close-knit inodes such as a file and the directory that
>> contains it.
>> 
>> A simple strategy is to start finding a free inode from (inumber of
>> the parent directory) + 1, but this may not work efficiently if the
>> namespace has multiple active directories, and requires that inumbers
>> of directories are suitably dispersed.  On the other hands, it
>> increases the number of disk read and also increases the number of
>> inode blocks to be written out if inodes are allocated too discretely.
>> 
>> The optimal strategy may differ from that of other file systems
>> because inode blocks are not allocated to static places in nilfs.  For
>> example, it may be better if we gather inodes of frequently accessed
>> directories into the first valid inode block (on ifile) for nilfs.
> 
> Sure I'll have a look at it, but this seems to be a hard problem.
> 
> Since one inode has 128 bytes a typical block of 4096 contains 32
> inodes. We could just allocate every directory inode into an empty block
> with 31 free slots. Then any subsequent file inode allocation would
> first search the 31 slots of the parent directory and if they are full,
> fallback to a search starting with ino 0.

We can utilize several characteristics of metadata files for this
problem:

- It supports read ahead feature.  when ifile reads an inode block, we
  can expect that several subsequent blocks will be loaded to page
  cache in the background.

- B-tree of NILFS is efficient to hold sparse blocks.  This means that
  putting close-knit 32 * n inodes far from offset=0 is not so bad.

- ifile now can have private variables in nilfs_ifile_info (on-memory)
  struct.  They are available to store context information of
  allocator without compatibility issue.

- We can also use nilfs_inode_info struct of directories to store
  directory-based context of allocator without losing compatibility.

- Only caller of nilfs_ifile_create_inode() is nilfs_new_inode(), and
  this function knows the inode of the parent directory.

> This way if a directory has less than 32 files, all its inodes can be
> read in with one single block. If a directory has more than 32 files its
> inodes will spill over into the slots of other directories.
> 
> But I am not sure if this strategy would pay off.

Yes, for small namespaces, the current implementation may be enough.
We should first decide how we evaluate the effect of the algorithm.
It may be the scalability of namespace.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
