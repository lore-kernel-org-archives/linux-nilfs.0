From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mkfs.nilfs2 -b 1024 -B 8192
Date: Thu, 14 Mar 2013 10:40:45 +0400
Message-ID: <1363243245.2089.11.camel@slavad-ubuntu>
References: <20130313071453.GA17072@grill.lan>
	 <1363163101.2540.28.camel@slavad-ubuntu> <20130313142726.GA3328@thirty.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Jzedb1tvcELqFdoqZAPGZhDiqcH12gpdVQomSe1IIwE=;
	b=fYIV7/Py+3OdyQlhZwo2NQzDNRxgiFT2fEBx6khpU0L2RzFuDTM4865fNAg+gw+XuhGUqHn96J7/DPouffLgHUAKLODK/q/bNh2kRmPrNEuwd8PQdtNEQyQFlsf9anrk;
In-Reply-To: <20130313142726.GA3328-9gBkq9fxGAp+urZeOPWqwQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anthony,

On Wed, 2013-03-13 at 14:27 +0000, Anthony Doggett wrote:
> Hi Vyacheslav
> 
> On Wed, Mar 13, 2013 at 12:25:01PM +0400, Vyacheslav Dubeyko wrote:
> > ...
> > Sorry, I don't clearly understand. Have you READ-ONLY FS issue only? Or
> > have you kernel panic? Could you confirm what situation you have?
> 
> I did indeed forget to say what happens next!  Future mounts would
> always print "NILFS warning: mounting fs with errors", so I'd always
> throw away that partition and restore from (tar-based) backups.  I've
> pasted a little more detail on what the "ntest" filesystem looks like
> below.  Looking at it, it looks as though the recovery might have
> removed all the errors (by rewinding far enough), but would that
> reliably be the case on a filesystem full of data?  Even if the GC were
> running at the time?
> 

As I understand, you had issue with remounting file system in Read-Only
mode (because of "NILFS error (device dm-3): nilfs_bmap_assign: broken
bmap (inode number=21)"), firstly. Then you tried unsuccessfully umount
file system in this state. I think that the message "NILFS warning
(device dm-3): nilfs_segctor_destroy: dirty file(s) after the final
construction" means that you didn't flush modified (or created) files
during umount. So, it means that you lost content of files. And,
finally, you can mount NILFS2 file system with presence of errors (I
think that it means some corruption of metadata). As a resume, this is
not good situation. Factually, this is a dangerous situation for user
data.

> > ...
> > The "flush kernel thread" issue is complex issue. The nature of this
> > issue begins from architectural solution of b-trees and DAT file. After
> > unsuccessful trying to elaborate simple fix I concluded that a clear
> > solution can be extents support implementation or adding special
> > metadata structure for GC operations. So, I think over about starting
> > implementation of it. But currently I hesitate about what can be a
> > better for start of implementation.
> 
> Oh dear.  I do hope that you find a simple solution!  Where is the best
> place to find out more about the flush kernel thread issue?  (Is there
> an issue tracker?)
> 

You can get more details about the "flush kernel thread" issue in the
thread: http://www.spinics.net/lists/linux-nilfs/msg01476.html

With the best regards,
Vyacheslav Dubeyko.


> Hope that you do manage to reproduce the "broken bmap" issue easily
> enough.  I shall have another go at reproducing the
> nilfs_btree_propagate issue reliably.
> 
> Thanks,
> Anthony
> 
> [  811.211974] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [  816.448465] nilfs_direct_assign: invalid pointer: 0
> [  816.448487] NILFS error (device dm-3): nilfs_bmap_assign: broken bmap (inode number=21)
> [  816.448494] 
> [  816.466784] Remounting filesystem read-only
> 
> Then unmount (umount doesn't return: have to cancel it with Ctrl-C):
> [  856.917108] nilfs_direct_assign: invalid pointer: 0
> [  856.917123] NILFS error (device dm-3): nilfs_bmap_assign: broken bmap (inode number=21)
> [  856.917128] 
> [  856.917294] nilfs_direct_assign: invalid pointer: 0
> [  856.917305] NILFS error (device dm-3): nilfs_bmap_assign: broken bmap (inode number=21)
> [  856.917309] 
> [  856.917473] nilfs_direct_assign: invalid pointer: 0
> [  856.917483] NILFS error (device dm-3): nilfs_bmap_assign: broken bmap (inode number=21)
> [  856.917488] 
> [  856.917660] nilfs_direct_assign: invalid pointer: 0
> [  856.917670] NILFS error (device dm-3): nilfs_bmap_assign: broken bmap (inode number=21)
> [  856.917674] 
> [  856.917689] NILFS warning (device dm-3): nilfs_segctor_destroy: dirty file(s) after the final construction
> [  856.917694] 
> 
> Then mount once again:
> [  974.586969] NILFS warning: mounting unchecked fs
> [  975.088956] NILFS: recovery complete.
> [  975.089763] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [  975.090152] NILFS warning: mounting fs with errors
> 
> > lscp /dev/mapper/unencrypted-ntest
>                  CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>                    1  2013-03-13 11:20:59   cp    -           12          2
> > lssu /dev/mapper/unencrypted-ntest
>               SEGNUM        DATE     TIME STAT     NBLOCKS
>                    0  2013-03-13 11:20:59  ad-          12
>                    1  ---------- --:--:--  ad-           0
> > sudo /sbin/nilfs-tune -l /dev/mapper/unencrypted-ntest
> nilfs-tune 2.1.3
> Filesystem volume name:	  (none)
> Filesystem UUID:	  942d2231-5ea5-4430-96e3-4913917efddb
> Filesystem magic number:  0x3434
> Filesystem revision #:	  2.0
> Filesystem features:      (none)
> Filesystem state:	  valid,error
> Filesystem OS type:	  Linux
> Block size:		  1024
> Filesystem created:	  Wed Mar 13 11:20:59 2013
> Last mount time:	  Wed Mar 13 11:23:44 2013
> Last write time:	  Wed Mar 13 11:27:33 2013
> Mount count:		  2
> Maximum mount count:	  50
> Reserve blocks uid:	  0 (user root)
> Reserve blocks gid:	  0 (group root)
> First inode:		  11
> Inode size:		  128
> DAT entry size:		  32
> Checkpoint size:	  192
> Segment usage size:	  16
> Number of segments:	  255
> Device size:		  2147483648
> First data block:	  4
> # of blocks per segment:  8192
> Reserved segments %:	  5
> Last checkpoint #:	  1
> Last block address:	  4
> Last sequence #:	  0
> Free blocks count:	  2072576
> Commit interval:	  0
> # of blks to create seg:  0
> CRC seed:		  0x8a46fd5b
> CRC check sum:		  0xd431caf2
> CRC check data size:	  0x00000118
> 
> > sudo dumpseg /dev/mapper/unencrypted-ntest 0
> segment: segnum = 0
>   sequence number = 0, next segnum = 1
>   partial segment: blocknr = 4, nblocks = 12
>     creation time = 2013-03-13 11:20:59
>     nfinfo = 5
>     finfo
>       ino = 2, cno = 1, nblocks = 1, ndatblk = 1
>         vblocknr = 1, blkoff = 0, blocknr = 5
>     finfo
>       ino = 6, cno = 1, nblocks = 4, ndatblk = 4
>         vblocknr = 2, blkoff = 0, blocknr = 6
>         vblocknr = 3, blkoff = 1, blocknr = 7
>         vblocknr = 4, blkoff = 2, blocknr = 8
>         vblocknr = 5, blkoff = 3, blocknr = 9
>     finfo
>       ino = 4, cno = 1, nblocks = 1, ndatblk = 1
>         vblocknr = 6, blkoff = 0, blocknr = 10
>     finfo
>       ino = 5, cno = 1, nblocks = 1, ndatblk = 1
>         vblocknr = 7, blkoff = 0, blocknr = 11
>     finfo
>       ino = 3, cno = 1, nblocks = 3, ndatblk = 3
>         blkoff = 0, blocknr = 12
>         blkoff = 1, blocknr = 13
>         blkoff = 2, blocknr = 14
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
