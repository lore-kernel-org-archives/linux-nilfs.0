From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 12 Oct 2012 11:10:32 +0400
Message-ID: <1350025832.2026.43.camel@slavad-ubuntu>
References: <20121009105239.GV28032@wloczykij>
	 <1349784514.1921.9.camel@slavad-ubuntu> <20121009135833.GX28032@wloczykij>
	 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
	 <20121010073912.GA28032@wloczykij>
	 <1349870593.1889.107.camel@slavad-ubuntu>
	 <20121010220331.GA27763@wloczykij> <1349938258.1908.3.camel@slavad-ubuntu>
	 <20121011092300.GB27763@wloczykij> <1349950320.1908.11.camel@slavad-ubuntu>
	 <20121011180332.GE27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=JqAKcHB/urZHSVcwC2ap3NdZM+FdUlpewIgyn02rFWU=;
	b=gHiCE7fPeAH0mp4/N8/7rOkdHnqXSTq0JfuyM0bxJhBNGWffTOMOXjJNPPZ+E1q4UFSuOCU63/Nnu4fIsxbEi7rm3iZPYFqRjrZZYN00U00sglO9BaOMLwYpJQbQne3X;
In-Reply-To: <20121011180332.GE27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Wed, 2012-10-10 at 22:39 +0200, Piotr Szymaniak wrote:
> maszyn ~ # nilfs-tune -l /dev/sdf3
...
> Filesystem state:         invalid or mounted
...
> Filesystem created:       Fri Aug  3 08:37:06 2012
> Last mount time:          Thu Jan  1 01:00:01 1970
> Last write time:          Thu Jan  1 01:00:01 1970
> Mount count:              56
> Maximum mount count:      50
...
> Number of segments:       922
> Device size:              7741636608
> First data block:         1
> # of blocks per segment:  2048
> Reserved segments %:      5
> Last checkpoint #:        1873
> Last block address:       734128
> Last sequence #:          358
> Free blocks count:        1150976
...

First of all, it is possible to see that file system was not unmounted. It was 56 mounts but during last mount superblock was not updated properly. It means that it was sudden power-off, kernel crush or superblock wasn't flushed because some reason.

Moreover, last mount time and last write time are strange. Usually, these fields have real time of last modifications but you haven't so. File system creation time is defined by means of mkfs utility but last mount time and write time are defined by driver. So, maybe it is a slight superblock corruption.

Thereby, there is some probability of primary superblock inconsistency. Could you share raw dump of second superblock that is located at the volume end? Moreover, could you share dumpseg of next segment after last sequence # (namely, 359) and before of it (namely, 357)?

On Thu, 2012-10-11 at 20:03 +0200, Piotr Szymaniak wrote:
> On Thu, Oct 11, 2012 at 02:12:00PM +0400, Vyacheslav Dubeyko wrote:
> > On Thu, 2012-10-11 at 11:23 +0200, Piotr Szymaniak wrote:
> > > So I should dump block 743205 and 734158? Ok, but I'm not familiar with
> > > blkoff.
> > > 
> > > ie. blkoff = 2, blocknr = 734205 it means the dump should be block
> > > 734205 and (blkoff = 2) next two blocks? If this is correct then this
> > > should work, right?
> > > dd if=/dev/<device> of=<dump> bs=2048 skip=734205 count=3 (not sure if
> > > dd counts skip= and count= from 0 or 1)
> > > And similar with block 734158 but only one block (blkoff = 0)?
> > > 
> > 
> > Sorry, I confuse you by blkoff mentioning. The blkoff is logical offset from file begin (for example, from ifile begin). You need to take into account only blocknr.
> > 
> > It needs to dump block 743205 and 734158. Your superblock's content informs that block size is 4096 bytes.
> > 
> > For example, dd if=/dev/<device> of=<dump> bs=4096 skip=734205 count=1
> 
> Block 743205 is empty:
> maszyn tmp (: cat dump.743205
> maszyn tmp (: hexdump dump.743205
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001000
> 

It is bad. This block should contain root inode description. So, it is clear why you have such error message during mount trying.

I think that it needs to understand how deeply destroyed metadata files in last checkpoints. In dumpseg of #358 segment you have description of all blocks for ifile (ino = 6). Could you check what blocks are empty and what are not? Could you share results of checking ifile (ino = 6) blocks for all checkpoints that are described in dumpseg of #358 segment?

It needs to find in previous checkpoints valid ifile block (not empty) with blkoff = 2. Could you try to find? It needs to make dumpseg of previous segments and search not empty block of ifile (ino = 6) with blkoff = 2.

> Block 734158 attached.
> 

Block 734158 contains root folder (ino = 2) directory entries (bin, boott, dev, etc, home5, lib, media, mnt, opt, proc, root, run, sbin, sys, tmp, usr, var, test.318) as I can see.

Thereby, I can distinguish two problem: (1) file system recovering and (2) issue investigation.

Could you save raw dump of corrupted file system in untouched state for further investigations?

I think that the reason of such situation is absence or not proper flushing of dirty blocks. The question is what the reason of it. I can see several possible reasons: (1) hardware issue, (2) kernel crush, (3) file system issue. Anyway, it needs to describe the issue reproduction path for understanding the reason. Could you achieve reproduction of the issue and describe reproduction path?

With the best regards,
Vyacheslav Dubeyko.
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
