From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: time-shifting
Date: Sun, 07 Aug 2011 23:19:59 +0900 (JST)
Message-ID: <20110807.231959.212685724.ryusuke@osrg.net>
References: <4E3CEF72.1070303@evert.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E3CEF72.1070303-yfx6isLFVcpeoWH0uzbU5w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: post-yfx6isLFVcpeoWH0uzbU5w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sat, 06 Aug 2011 09:38:26 +0200, Evert Mouw wrote:
> Hi,
> 
> Yesterday I played a bit with NILFS2 on ubuntu 11.04. It was quite easy 
> to use, but finding previous versions of a file is still a bit 
> complicated from a user point of view.
> 
> I read a bit about ext3cow, which is currently not actively maintained 
> anymore. In one of the papers on ext3cow, I read the following:
> 
> Other disk file systems provide coarse-grained access to versions through
> the creation of namespace tunnels [Hitz et al. 1994] or via mounting 
> separate logical volumes
> [Strunk et al. 2000; Soules et al. 2003]. Some disk file systems provide 
> no interface
> to versions, restricting versioning to internal use only [Rosenblum and 
> Ousterhout 1992;
> Seltzer et al. 1993].
> 
> In time-shifting, ext3cow introduces an interface to versioning that 
> presents a continuous
> view of time. Users or applications specify a file name and any point in 
> time, which
> ext3cow scopes to the appropriate snapshot or file version. The 
> time-shifting interface
> allows user-space tools to create snapshots and access versions.
> 
> Ext3cow: A Time-Shifting File System for Regulatory Compliance
> ZACHARY N. J. PETERSON and RANDAL BURNS
> ACM Transactions on Storage, 1(2), May, 2005
> http://www.ext3cow.com/ext3cow/Publications.html
> 
> A usage scenario is given in a screenshot:
> http://www.ext3cow.com/ext3cow/Welcome_files/example1.jpg
> 
> I don't think using the "@" symbol for such thinks is a great idea (I 
> sometimes use it in my filenames) but the ability to use regular tools 
> to access old versions of files is great.
> 
> I think it would be really useful to have access to previous versions of 
> files without having to go through checkpoints or snapshots of the whole 
> filesystem / partition. So having something like lshistory or lsversions 
> for specific files would be great. It could output the versions, the 
> checkpoints where those versions are available, etc.  Maybe direct 
> retrieval of old versions (cathistory?) could also be possible using 
> such a path.
> 
> Of course the architecture of NILFS is different from ext3cow so I don't 
> know whether this is even possible. Something like a data structure 
> linking the different verions of some inode must exist before this can 
> happen. Just an idea, though.

If memory serves me right, ext3cow allocates an inode every time its
file is changed and a pointer to the previous inode is stored in the
new inode.

At present, nilfs does not have such per-file pointer to past
versions, so actually it's not optimal for file history lookups.

We may be able to do indirectly by adding a new field to on-disk inode
to keep a checkpoint number in which the inode lastly changed.
However, the new field must be updated every time garbage collector
thins out the previous version, -- this may complicate things
unacceptably because the current nilfs is designed so that it never
overwrites in-use blocks except super blocks.

Apart from these implementation issues, I don't feel the "@" symbol
semantics is odd, though it can come under fire from related kernel
developers as a violation of namespace semantics.


With regards,
Ryusuke Konishi


> Thanks for your cool stuff!
> 
> Evert
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
