From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Sat, 04 Jun 2011 02:26:21 +0900 (JST)
Message-ID: <20110604.022621.01482278.ryusuke@osrg.net>
References: <201106031229.38758.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106031229.38758.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi dexen,
On Fri, 3 Jun 2011 12:29:33 +0200, dexen deVries wrote:
> Hi list,
> 
> back when I was using XFS, there was an option to put one particular piece of 
> metadata -- the journal -- onto separate physical device. The speed-up was 
> very significant, especially for operations on lots of files. For example, with 
> external journal removing whole kernel source tree on XFS would take less time 
> than on ext2 or ext3; with internal it would be much longer than ext2 or 3.
> 
> The journal was needed only in case of unclean unmount, as only then it 
> contained any information not applied yet; if the unmount was clean, the 
> journal contained no important information.
> 
> XFS journals only metadata changes, btw.
> 
> 
> My question is, would it be feasible to move some part of NILFS2 metadata onto 
> separate device for R/W/GC speed-up? 
> 
> Perhaps some of metadata could even be considered `recoverable' -- that is, if 
> the other device gets broken or lost, the metadata on it could be re-
> constructed from content of the main device.

NILFS2 is a log-structured filesystem and that means the filesystem
itself is a big journal.  My understanding is using separate journal
device has no merit of performance.

On the other hand, We may be able to speed up the filesystem by
putting DAT (disk address translation) metadata to a separate device.
I mean putting a full copy of the DAT metadata on the sperate device
instead of journal of it.

The DAT is referred to every time an off-cache block is read from the
disk, and is updated every time we overwrite or create some disk
blocks.  Even though the DAT is just a table data, the current NILFS2
uses b-tree for its lookup and writes them in a log like manner.

This is meaningless from engineering perspective and decreasing
performance due to fragmentation.

The same is true of SUFILE and CPFILE metadata, where the former is
keeping matadata of segment usage state, and the latter, checkpoint
list.

Putting original of these metadata on a separate device and journaling
it in the NILFS partition would have performance merits.

But, I think we have other approaches to think about before that with
regard to performance improvement.  For example, applying "extent" to
DAT seems much more effective.


Thanks,
Ryusuke Konishi

> Regards,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> For example, if the first thing in the file is:
>    <?kzy irefvba="1.0" rapbqvat="ebg13"?>
> an XML parser will recognize that the document is stored in the traditional 
> ROT13 encoding.
> 
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
