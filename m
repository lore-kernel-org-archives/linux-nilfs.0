From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [NILFS2][BUG FIX][STATUS - February 7, 2013] flush kernel thread
 issue is under fix
Date: Thu, 07 Feb 2013 17:22:45 +0400
Message-ID: <1360243365.2065.81.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=5eU44T5kPv+UlaZlmfcVLc4S9Owr3pHkDKHLCUN+HEo=;
	b=OjaUJHYJQPRqPgHAS6beSvbNybL0tqO6JqrrUbJ0xASfMWR8cbrs0BJiJKPP1/lNY1Ei7ixKnpYl6pSZ0XmpHaD6tcv/ToBKsjEn9cLE/nd64aRuy/YiVSzpJ/VqJofq;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>, Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[REPORTED BUGS]
1. Flush kernel thread issue - [under investigation and fix].
2. A lot of NILFS: bad btree node messages (readonly fs) - [under investigation].
3. Odd problem starting nilfs_cleanerd due to an eMMC misbehaviour - [TODO: investigation].
4. Kernel panic in nilfs - [TODO: investigation].
5. Uncleanable file system because of time issue - [TODO: fix].

[UNDER FIX]
Flush kernel thread issue

SYMPTOMS:
You can see flush kernel thread that uses 60 - 100% of CPU time during 5 - 40 minutes.

REPRODUCING PATH:
1. Generate some file about 100 - 500 GB (for example, by: "dd if=/dev/zero of=<file_name> bs=1048576 count=102400"). The size of the file defines the duration of the issue reproducibility.
2. Try to execute "rm", "truncate" or "dd" command. In the case of "dd" it needs to use without notrunc option (for example, "dd if=/dev/urandom of=<file_name> bs=1024 seek=51200 count=10").

INVESTIGATION RESUME:
We have such visible flush kernel thread behavior because of flow of
dirty pages are marked as "for_kupdate" or
"for_background" (writeback_control structure) in nilfs_mdt_write_page()
and nilfs_writepage() methods. It is only called
redirty_page_for_writepage() and unlock_page() methods for such case.
Thereby, as a result, dirty pages return again and again into
nilfs_mdt_write_page() and nilfs_writepage() in the case of delete or
truncate operation.

But the reason of such issue is the nature of delete or truncate
operation in the NILFS2. Execution of metadata operations is protected
by pair of methods:
nilfs_transaction_begin()/nilfs_transaction_commit(). These methods use
semaphore for protecting of indivisible file operation. The file's
delete operation is a long operation by nature in the case of big files
because of necessity to use and to modify DAT file content. As a result,
we have to go through two b-tree - DAT file's b-tree and deleted file's
b-tree (that is described file's blocks). So, DAT file's b-tree and
deleted file's b-tree are located in significant count of blocks. Then,
we have situation when nilfs_bmap_truncate() operation needs to read and
to write many blocks for operation execution. Another threads (segctor
and nilfs_cleanerd) are blocked during this long operation (10 - 40
minutes).

I think that under heavy load I/O this situation can result in very bad
things.

DISCUSSION:
Unfortunately, this issue can't be resolved by simple fix. But I think
that in this case we can use the nature of the issue for adding a new
file system feature. I mean that, of course, we have opportunities for
some optimization of delete/truncate operation but, anyway, the nature
of the operation is to be a long operation. The duration of the
operation can grow linearly with a file's size growing. And, if we think
about delete/truncate operation as indivisible transaction then we will
have issue with segstor and nilfs_cleanerd threads blocking during
significant time (10 - 60 minutes) in the case of big files.

I can see only one way to make the delete/truncate operation faster and
safety operation for the case of big/huge files. The fundamental goal of
NILFS2 is to be reliable file system with opportunity to rollback into
some old state (snapshot). One of the possible technique can be not to
do immediately the real delete/truncate because it can be done by
mistake. It is possible to do by means of "rm" operation only moving of
deleting file into special folder that will keep deleted file for some
duration of time. Finally, such deleted files will be really deleted by
GC (or by special thread) in background. But while deleted file is kept
in special folder then it can be easily restored from this special
folder.

In the case of truncate operation we can save information about
truncation details only in the on-disk inode and to leave b-tree
temporary untouched. Blocks that were virtually freed during truncation
can be really freed by GC in background.

PLANNED:
1. To implement partial prefetch of DAT file's b-tree during mount.
2. To improve b-tree's nodes read-ahead technique for the case of delete operation.
3. To implement technique of "virtual" delete and truncate.

With the best regards,
Vyacheslav Dubeyko.






--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
