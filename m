From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can I recover my nilfs disk partition and a few other
 questions?
Date: Wed, 08 Jun 2011 21:24:45 +0900 (JST)
Message-ID: <20110608.212445.137356715.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4D724@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E4D724-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 7 Jun 2011 12:03:14 -0700, Zahid Chowdhury wrote:
> Hello,
> 
>   I have a setup of a partition on a SSD with nilfs on it all running under
> Centos 5.5 on a x86. With some heavy amount of writes to the nilfs partition
> the power was accidentally cycled. On bootup the nilfs partition reported
> the following errors:
>             NILFS warning: Checksum error in segment payload
>             NILFS: error searching super root
> 
> I worked around this by modifying the nilfs kernel code to remove the full
> check in load_segment_summary (i.e. basically just check the segment summary
> and I made it further towards recovery of my data). Now, I have encountered
> this error:
>   NILFS warning: Checksum error in super root
>   NILFS: error loading super root.
> 
> I am not comfortable changing the code in nilfs_read_super_root_block
> without feedback from this list. I am okay if I lose some of
> the data at the end as long as I can recover most of the data. Some
> questions I have are:
> 
>  1. Why cannot mount allow one to mount from an earlier checkpoint on a
>     previous segment if the super_root for the latest is corrupted, or
>     am I missing something? Does anybody have a mount that does?

Actually, recent versions of nilfs do this automatically.  On nilfs2
in recent kernels, one of two super blocks points to the latest
checkpoint and another points to its previous version.  And, if mount
from the latest checkpoint failed, it will fallback to the previous
checkpoint.

Unfortunately, the centos nilfs2 module is pretty old (recall it's
based on the 2.6.18 kernel), and this feature is not supported.

>  2. Is there any work on a fsck for nilfs? Even if it is very pre-release it
>     might help me to recover my data?

Yes, we have a tool to manually rollback the checkpoint.

It is available from "fsck0" branch of nilfs2-utils-devel git tree.
Please try the following instructions:

 $ cd your-work-directory
 $ git clone http://git.nilfs.org/nilfs2-utils.git
 $ cd nilfs2-utils
 $ git fetch http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0

   -- This will download fsck0.nilfs2 from nilfs2-utils-devel git repo.

 $ git checkout fsck0
 $ aclocal && autoheader && libtoolize -c --force && automake -a -c && autoconf
 $ ./configure
 $ make

   -- These steps will build fsck0.nilfs2.  You may need to install
      libtool, autoconf (-2.6 or later), and automake packages.

 $ cd sbin/fsck
 $ su
 # ./fsck0.nilfs2 <your-device>


>  3. On a accidental power failure I considered nilfs to be the most robust
>     on a SSD - am I wrong in my appraisal.

We usually do not need the above fallback mechanism with two super
blocks because nilfs updates pointer to the checkpoint in super block
only after the checkpoint is actually written to disk.

However in the real world, some devices violate this minimal semantics
related to disk write order.  Thus, we had to add the fallback feature
for further reliability.


Regards,
Ryusuke Konishi


> Any help is much appreciated. Thanks.
> 
> Zahid
> 
> P.S.: nilfs-tune works well on the partition:
> 
> nilfs-tune 2.0.22
> 
> Filesystem volume name:   /writable
> 
> Filesystem UUID:          0ba44621-5e7c-40ad-8087-b9493765e419
> 
> Filesystem magic number:  0x3434
> 
> Filesystem revision #:    2.0
> 
> Filesystem features:      (none)
> 
> Filesystem state:         invalid or mounted
> 
> Filesystem OS type:       Linux
> 
> Block size:               4096
> 
> Filesystem created:       Tue May 24 17:12:08 2011
> 
> Last mount time:          Fri Jun  3 19:07:49 2011
> 
> Last write time:          Fri Jun  3 19:08:35 2011
> 
> Mount count:              715
> 
> Maximum mount count:      50
> 
> Reserve blocks uid:       0 (user root)
> 
> Reserve blocks gid:       0 (group root)
> 
> First inode:              11
> 
> Inode size:               128
> 
> DAT entry size:           32
> 
> Checkpoint size:          192
> 
> Segment usage size:       16
> 
> Number of segments:       1316
> 
> Device size:              11046551040
> 
> First data block:         1
> 
> # of blocks per segment:  2048
> 
> Reserved segments %:      5
> 
> Last checkpoint #:        1893038
> 
> Last block address:       712887
> 
> Last sequence #:          200747
> 
> Free blocks count:        1939456
> 
> Commit interval:          0
> 
> # of blks to create seg:  0
> 
> CRC seed:                 0x298bad54
> 
> CRC check sum:            0x5e92199d
> 
> CRC check data size:      0x00000118
> 
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
