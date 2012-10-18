From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 18 Oct 2012 16:29:51 +0400
Message-ID: <1350563391.2032.65.camel@slavad-ubuntu>
References: <20121010220331.GA27763@wloczykij>
	 <1349938258.1908.3.camel@slavad-ubuntu> <20121011092300.GB27763@wloczykij>
	 <1349950320.1908.11.camel@slavad-ubuntu> <20121011180332.GE27763@wloczykij>
	 <1350025832.2026.43.camel@slavad-ubuntu> <20121012103119.GF27763@wloczykij>
	 <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014204740.GL27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=zKuuu7abzoDMsJybZYKNk7dRaUO5+hMpDz4G0oa+r/w=;
	b=W4XzdYNneJmFm1i0Np1JZ/wmOdwNtEXtadfHwt/Ym6AJO1sEkPCfdJUKM80bsmTNDTsDinpSnX/5C3ez2kj4LkYcnxj+uKhkWhfC8Il93uq9n+eXPbxGmflRmMz/D3i/;
In-Reply-To: <20121014204740.GL27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Today I tried to reproduce the issue on the basis of my current
understanding of issue's environment. In other words, I simply tried to
simulate situation that we can see on corrupted NILFS2 volume.

As I can understand, at the end of issue we have corrupted NILFS2 volume
that contains empty block (blkoff = 2) of ifile (ino = 6) in last
checkpoint. This block should contain description of critical inodes (as
minimum, special and root inodes). Let's imagine that we have correct
(not empty) block with blkoff = 2 of ifile in previous checkpoints.

I tried to reproduce the issue on the system:
Linux 3.2.0-32-generic #51-Ubuntu SMP Wed Sep 26 21:33:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

So, I made NILFS2 volume and then to create several files in root
folder. As a result, I had the NILFS2 volume with several checkpoints:

                 CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
                   1  2012-10-10 14:38:35   cp    -           11          2
                   2  2012-10-10 14:49:59   cp    -          274          3
                   3  2012-10-10 14:50:05   cp    -          274          4
                   4  2012-10-10 14:50:12   cp    -          274          5
                   5  2012-10-10 14:50:47   cp    -         4879          5
                   6  2012-10-10 14:50:48   cp    -          630          5
                   7  2012-10-10 14:50:54   cp    -         2200          5
                   8  2012-10-18 10:54:19   cp    i            8          5

I can see from dumpseg output that I have block with blkoff = 2 of ifile
in several checkpoints:

finfo
      ino = 6, cno = 1, nblocks = 3, ndatblk = 3
        vblocknr = 4, blkoff = 2, blocknr = 5

finfo
      ino = 6, cno = 2, nblocks = 3, ndatblk = 3
        vblocknr = 10, blkoff = 2, blocknr = 275

finfo
      ino = 6, cno = 3, nblocks = 3, ndatblk = 3
         vblocknr = 16, blkoff = 2, blocknr = 549

finfo
      ino = 6, cno = 4, nblocks = 3, ndatblk = 3
        vblocknr = 22, blkoff = 2, blocknr = 823

finfo
      ino = 6, cno = 5, nblocks = 1, ndatblk = 1
        vblocknr = 29, blkoff = 2, blocknr = 13233

finfo
      ino = 6, cno = 6, nblocks = 1, ndatblk = 1
        vblocknr = 33, blkoff = 2, blocknr = 16975

finfo
      ino = 6, cno = 7, nblocks = 1, ndatblk = 1
        vblocknr = 39, blkoff = 2, blocknr = 26812

Firstly, I tried to reproduce situation without presence of any
snapshots in filesystem. I simply made such sequence of actions:
1. Check that volume is mounted successfully before any manipulation and unmount it (result was OK).
2. Fill the block #26812 by zeros:

sudo dd if=/dev/zero of=/dev/loop0 bs=4096 seek=26812 count=1

3. Try to mount the corrupted volume again (operation was failed with
errors):

[ 3294.873113] NILFS warning: Checksum error in segment payload
[ 3294.873122] NILFS: try rollback from an earlier position
[ 3294.877949] NILFS warning: Checksum error in segment payload
[ 3294.877954] NILFS: error searching super root.

4. Copy block #16975 (previous checkpoint #6) into block #26812 (next
checkpoint #7) and try to mount again (the mount operation was
successful).

Secondly, I tried to reproduce situation with presence of one snapshot
(cno = 5) on the volume:

                 CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
                   1  2012-10-10 14:38:35   cp    -           11          2
                   2  2012-10-10 14:49:59   cp    -          274          3
                   3  2012-10-10 14:50:05   cp    -          274          4
                   4  2012-10-10 14:50:12   cp    -          274          5
                   5  2012-10-10 14:50:47   ss    -         4879          5
                   6  2012-10-10 14:50:48   cp    -          630          5
                   7  2012-10-10 14:50:54   cp    -         2200          5
                   8  2012-10-18 10:54:19   cp    i            8          5

I repeated the same sequence of actions:
1. Check operation mount firstly in RW mode and in RO mode for snapshot
case (result was OK).
2. Fill the block #26812 by zeros.
3. Try to mount the corrupted volume again (operation was failed with errors):

[ 5572.280128] NILFS: get root inode failed

4. Try to mount snapshot in RO mode (sudo mount -o ro,cp=5 /dev/loop0 /mnt/nilfs2). The operation was failed with error:

mount.nilfs2: Error while mounting /dev/loop0 on /mnt/nilfs2: Invalid argument

[22911.845694] NILFS: get root inode failed

5. Copy block #16975 (previous checkpoint #6) into block #26812 (next
checkpoint #7) and try to mount again (the mount operation was
successful).

[TO SUMMARIZE]
1. I hope that Piotr can restore your NILFS2 volume manually by copying
block of ifile (ino = 6) with blkoff = 2 from previous checkpoint.
2. There are different behavior in the case of presence of snapshots and
not. As I can understand, in the case of snapshot's absence the recovery
code try to work but with no success.
3. In this simulation of the issue it exists some difference in error
messages in comparison with Piotr's report. But, as I can understand,
the place in code of error messages generation is the same.
4. I think that it is very unexpected from the user point of view that
the operation of snapshot mount fails in the presence of it.
5. Moreover, from my point of view, the impossibility to get list of
checkpoints (lscp) or segment usage information (lssu) in the case of
unmountable file system state is inconvenient.

So, I hope that this simulation reproduces the reported issue. Anyway, I
am going to investigate the issue more deeply in the environment of
described simulation, check correctness of such simulation from file
system point of view and fix the issue.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
