From: Nick Martin <nickm-gdz6ECn1J1HQT0dZR+AlfA@public.gmane.org>
Subject: RE: read error on superblock
Date: Tue, 24 Jul 2012 20:05:37 +0000
Message-ID: <13570C57CF6BB244974937874812B3BC285FE18C@P3-Exch-MBX01.p3corpnet.pivot3.com>
References: <20120724.090604.40913934.konishi.ryusuke@lab.ntt.co.jp>
	<1343111197.1982.32.camel@slavad-ubuntu-11>	<31237317.NQxpWWcrpc@coil>
 <20120725.014653.38326039.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120725.014653.38326039.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello All,

I see in this thread, what I think is a misunderstanding of the role of the disk drive in the face of a hard read error.
The drive cannot simply map an unreadable sector to a new sector based on a read failure.  
If the read has failed, the drive does not contain the correct contents for the sector.  
The read failure needs to persist until a write is received for the unreadable sector.
When the write is received, the new data can be written to a good sector and the sector map adjusted.
One of the jobs of RAID is to reconstruct the data from other sources and write the correct data back to the same sector of the drive allowing the drive to do this remapping.
If you are not using RAID software or hardware, there is typically no way to reconstruct the data.

If the read error is correctable using ECC, the drive does know the proper contents for the sector and could choose to re-map it, but likely will not do so.
This could be done without reporting the error to the host system.  
It is my understanding that ECC errors detected within the drive are not at all uncommon.
If the ECC can correct the error, the valid data is typically returned, and the drive moves on to the next request.
If ECC cannot correct the error, the first thing the drive will do is attempt to re-read the media.  
If it is able to read the data the next time, even if it had to use ECC to correct it, it will still return the valid data and may move on to the next request.
At the file system level, a slow read would be observed, not a read error.

The behavior of the drive firmware is vendor specific.  Sometimes it is configurable.  The behavior of the firmware will vary across different classes and generations of drives even from the same vendor.
Drive firmware that makes up its own data and remaps the sector to correct a read error should never be sold by a reputable drive vendor.

The origin of the bad block table in the file system pre-dates drive hardware sector re-mapping.   
When it was not likely that writing to a sector whose contents were previously unreadable would result in being to read that sector back again, then it was a good idea to not write anything there in the future.
With modern drive technologies, it is likely that a write to a previously unreadable sector will result in being able to read back the newly written data.   The value of a bad block map in the file system is now minimized.
In addition with hardware and software RAID technology now available to everyone, many volumes will never in their lifetime, return a single read error to a file system.  
Errors are hidden and corrected at lower levels.  The file system observes perfect media, or in catastrophic failure of a RAID system, media offline.

I recommend assuming modern storage devices and subsystems, and focusing development efforts on file system issues that remain.

Thanks,
Nick Martin

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ryusuke Konishi
Sent: Tuesday, July 24, 2012 11:47 AM
To: dexen deVries; Vyacheslav Dubeyko
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: read error on superblock

On Tue, 24 Jul 2012 09:52:18 +0200, dexen deVries wrote:
> Hi Vyacheslav,
> 
> 
> On Tuesday 24 of July 2012 10:26:37 you wrote:
> > I am afraid that it is not so good from the end user point of view.
> > 
> > First of all, the message "mount: /dev/sda3: can't read superblock" 
> > can confuse user. The reason is bad sectors inside the volume but 
> > user is informed about impossibility to read superblock.
> > 
> > Secondly, it is possible situation when it really needs to use a 
> > volume in the case of presence of bad sectors. And I think that 
> > users can expect such NILFS behavior because of declared reliability.
> > 
> > Unfortunately, as I can understand, NILFS hasn't bad blocks table 
> > and can't process situation of bad blocks presence on volume 
> > correctly. It means that NILFS interprets bad blocks as exceptional 
> > case. But from my point of view, it makes sense to interpret bad 
> > blocks as usual thing and try to work in the presence of ones. For 
> > example, fsck potentially can check NILFS volume on bad blocks 
> > presence, construct bad blocks table and save it on the volume.

NILFS does't have sector-based bad blocks table, but it has an error flag on the segment usage file (sufile).  If a segment is marked 'erroneous', it will not be allocated.

At present, this doesn't work together with badblocks (mkfs.nilfs2), nor the recovery logic.  However it is applicable for this purpose if needed.

> > I suggest to add "virtual" special file for bad blocks description. 
> > It can be described by inode in ifile and all bad blocks can be 
> > described in DAT file as parts of this "virtual" special file. So, 
> > as a result, NILFS file system driver will have bad blocks table 
> > which can be a basis for excluding bad blocks from operation and 
> > trying to survive in the not good device environment.
> > 
> > What do you think about such idea?
> 
> I believe bad sectors to be thing of the past mostly; any decent 
> harddrive (probably also any decent SSD) should re-map them after some 
> re-reads. Some data & meta-data loss is possible, but overall the FS 
> should be accessible again.

I agree with this opinion.

If the sector-based bad blocks table is sorely-needed, it is worth considering, but at least it should be optional and not mandatory.

But even it's well implemented optionally, it still looks overkill because most recent hard drives internally have alternate sectors and most recent flash based drives have own remap mechanism.

Moreover, how the device corrupts is deeply depends on the nature and configuration of underlying block device.  In this sense, in-device or in-driver solution looks better to me.

Badblocks table is about to become a thing of the past, it's almost stuff of the floppy drive's era.

> I have no idea why my particular HDD did not re-map; perhaps it just 
> takes much longer than I gave it.
> 
> As a point of reference, XFS does not do bad block management either; 
> however, the partition driver of IRIX does bad sector management -- so 
> it is implemented one layer below the FS.

Yes, If we implment some kind of redundancy mechanism in the FS layer, it absolutely should reflect how the the data integrity should be enhanced in the FS layer.


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
> "all dichotomies are either true or false" is a true paradox because 
> it's paradoxical only if it is a paradox ;)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" 
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
