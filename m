From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: read error on superblock
Date: Wed, 25 Jul 2012 01:46:53 +0900 (JST)
Message-ID: <20120725.014653.38326039.konishi.ryusuke@lab.ntt.co.jp>
References: <20120724.090604.40913934.konishi.ryusuke@lab.ntt.co.jp>
	<1343111197.1982.32.camel@slavad-ubuntu-11>
	<31237317.NQxpWWcrpc@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31237317.NQxpWWcrpc@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Jul 2012 09:52:18 +0200, dexen deVries wrote:
> Hi Vyacheslav,
> 
> 
> On Tuesday 24 of July 2012 10:26:37 you wrote:
> > I am afraid that it is not so good from the end user point of view.
> > 
> > First of all, the message "mount: /dev/sda3: can't read superblock" can
> > confuse user. The reason is bad sectors inside the volume but user is
> > informed about impossibility to read superblock.
> > 
> > Secondly, it is possible situation when it really needs to use a volume
> > in the case of presence of bad sectors. And I think that users can
> > expect such NILFS behavior because of declared reliability.
> > 
> > Unfortunately, as I can understand, NILFS hasn't bad blocks table and
> > can't process situation of bad blocks presence on volume correctly. It
> > means that NILFS interprets bad blocks as exceptional case. But from my
> > point of view, it makes sense to interpret bad blocks as usual thing and
> > try to work in the presence of ones. For example, fsck potentially can
> > check NILFS volume on bad blocks presence, construct bad blocks table
> > and save it on the volume.

NILFS does't have sector-based bad blocks table, but it has an error
flag on the segment usage file (sufile).  If a segment is marked
'erroneous', it will not be allocated.

At present, this doesn't work together with badblocks (mkfs.nilfs2),
nor the recovery logic.  However it is applicable for this purpose if
needed.

> > I suggest to add "virtual" special file for bad blocks description. It
> > can be described by inode in ifile and all bad blocks can be described
> > in DAT file as parts of this "virtual" special file. So, as a result,
> > NILFS file system driver will have bad blocks table which can be a basis
> > for excluding bad blocks from operation and trying to survive in the not
> > good device environment.
> > 
> > What do you think about such idea?
> 
> I believe bad sectors to be thing of the past mostly; any decent harddrive 
> (probably also any decent SSD) should re-map them after some re-reads. Some 
> data & meta-data loss is possible, but overall the FS should be accessible 
> again.

I agree with this opinion.

If the sector-based bad blocks table is sorely-needed, it is worth
considering, but at least it should be optional and not mandatory.

But even it's well implemented optionally, it still looks overkill
because most recent hard drives internally have alternate sectors and
most recent flash based drives have own remap mechanism.

Moreover, how the device corrupts is deeply depends on the nature and
configuration of underlying block device.  In this sense, in-device or
in-driver solution looks better to me.

Badblocks table is about to become a thing of the past, it's almost
stuff of the floppy drive's era.

> I have no idea why my particular HDD did not re-map; perhaps it just takes 
> much longer than I gave it.
> 
> As a point of reference, XFS does not do bad block management either; however, 
> the partition driver of IRIX does bad sector management -- so it is 
> implemented one layer below the FS.

Yes, If we implment some kind of redundancy mechanism in the FS layer,
it absolutely should reflect how the the data integrity should be
enhanced in the FS layer.


With regards,
Ryusuke Konishi


> I guess it /may be/ possible to use Linux' `dm' driver in such manner.
> 
> 
> Cheers,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> "all dichotomies are either true or false" is a true paradox because it's 
> paradoxical only if it is a paradox ;)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
