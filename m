From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Making Nilfs ZAC Compliant
Date: Sat, 28 Feb 2015 03:50:28 +0900 (JST)
Message-ID: <20150228.035028.199686803538457302.konishi.ryusuke@lab.ntt.co.jp>
References: <3764420FCC841C4DAE85E3B76FC61A773BF05FB6@wdscexmb03>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=cTKIvwt/59As6+pVjJPiqXJ3erZDAqvD9a1rYvz4T2E=;
        b=tZnoHm9MFN/vyyJiOU3cR5tC4hs/FzbsI0w+MULFNdGQjkHC/msO2aQ+w6eR0b7nZf
         75D/5P2jP2QnwuqIywO811vkBXw3EGO1f/z3qlF6UiMykTiqWUgEqIXc+ISvQfnaBn9V
         20Df6EIsugbwlkXWvx18stoZD4bNaAqv5wlgn7nCZ2nj+b3noTSouOQq0KRl2cXfoL3Y
         ZPaMAp9isut5KNfzi9IWvSuD3TvMaRF/P8v7ATqzdFgt961oJmn8C+5MGpTf4l5mtSXm
         ZrXAWo9odjwiio49SGqAsqaXTz+iQnjfMmCrBteeIs00dvUFCLN0C3aBltA1mttLBIjE
         l8dQ==
In-Reply-To: <3764420FCC841C4DAE85E3B76FC61A773BF05FB6@wdscexmb03>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Benixon Dhas <Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 26 Feb 2015 19:54:48 +0000, Benixon Dhas wrote:
> Hi All,
> 
> We are trying to make Nilfs work with a SMR Device which adheres to
> Zoned ATA Commands(ZAC) Specification.  One of the restrictions in
> the specification is reading an unwritten part of the Zone(Segment
> in Nilfs) will cause a read error.
> 
> We observe that Nilfs does not write a complete physical segment(we
> use 256MB segment) always. After digging in the source a while we
> figured that this is due to the fact that Nilfs requires a certain
> number of minimum blocks for constructing a partial segment
> (NILFS_PSEG_MIN_BLOCKS), which currently is 2.  So we see some
> segments where the last block (in our case a block is 4k) is not
> being written to.

For recovery and GC, NILFS needs to insert one or more header blocks
before writing payload blocks.  Inevitably, the minimum size of a
partial segment becomes 2.

> When some utilities like garbage collector and dump segment reads
> (May not be an exhaustive list) a segment it tries to read the
> entire physical segment. This causes read errors in the kernel and
> hence retries for the last unwritten block in certain segments.

The recovery function of NILFS also needs to read entire physical
segment.  It never reads unwritten blocks if the file system was
cleanly unmounted, however, this is not the case for unclean shutdown
or panic.

Worse yet, if it gets an EIO from the underlying block layer, the
recovery will fail and the mount system call will abort.

> In an attempt to solve this problem we were trying to figure out if
> we can write some dummy data to the remaining unutilized blocks in
> the segment. But we are not sure what would be the best way to do
> this.
> 
> Another solution we had in mind was to figure out all places where
> segments are read, and modify it to prevent it from reading
> unwritten blocks. But we feel this might be more complex solution
> and might impact performance more.

Looks like sufile is available for this purpose.  It is maintaining
how many blocks are written for each segment.  You can see it in the
NBLOCKS field of the output of lssu command.

One restriction is that this metadata file (sufile) is unavailable
until mount system call succeeds.  The recovery code cannot use it.

> Please advise us on the best way to solve the problem. Also what
> would be architecturally a best place to fix the problem.

Writing dummy data to the dead space for SMR devices looks better to
me because it's simpler and the performance penalty seems not so high.

But,
What will happen if an unexpected power failure hits the device ?
Does that cause the file system to read unwritten blocks ?

If so, it seems that we need translation layer to hide these issues,
or a new error code or a new mechanism to make it possible for file
systems to know/handle them.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
