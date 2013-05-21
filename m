From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: fix issue of nilfs_set_page_dirty for page
 at EOF boundary
Date: Tue, 21 May 2013 23:23:45 +0900 (JST)
Message-ID: <20130521.232345.474507064.konishi.ryusuke@lab.ntt.co.jp>
References: <20130511.161226.27777706.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130511.161226.27777706.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>

Hi Andrew,

Could you grab the following bug fix and send it upstream ?

Thanks,
Ryusuke Konishi

On Sat, 11 May 2013 16:12:26 +0900 (JST), Ryusuke Konishi wrote:
> Hi Andrew,
> 
> This is the revised patch for the problem that Anthony Doggett
> reported and Vyacheslav originally proposed a bug fix with the patch
> titled "nilfs2: fix issue with broken bmap for the case of block size
> lesser than 4 KB".
> 
> I corrected the flaw you pointed out, and performed another round of
> tests.
> 
> Changes from the first patch are:
> 
> - Fix buffer_dirty check (set_buffer_dirty was mistakenly done against
>   already dirty buffer instead of non-dirty buffer).
> 
> - Add a comment to note that page lock is protecting the sequence of
>   buffer_dirty check and set_buffer_dirty from concurrent threads.
> 
> 
> Please apply this instead.
> 
> 
> Thanks,
> Ryusuke Konishi

--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix issue of nilfs_set_page_dirty for page at EOF boundary

DESCRIPTION:
There are use-cases when NILFS2 file system (formatted with block size
lesser than 4 KB) can be remounted in RO mode because of encountering
of "broken bmap" issue.

The issue was reported by Anthony Doggett
<Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>: "The machine I've been trialling
nilfs on is running Debian Testing, Linux version 3.2.0-4-686-pae
(debian-kernel-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org) (gcc version 4.6.3 (Debian 4.6.3-14)
) #1 SMP Debian 3.2.35-2), but I've also reproduced it (identically)
with Debian Unstable amd64 and Debian Experimental (using the
3.8-trunk kernel).  The problematic partitions were formatted with
"mkfs.nilfs2 -b 1024 -B 8192"."

SYMPTOMS:
(1) System log contains error messages likewise:

    [63102.496756] nilfs_direct_assign: invalid pointer: 0
    [63102.496786] NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)
    [63102.496798]
    [63102.524403] Remounting filesystem read-only

(2) The NILFS2 file system is remounted in RO mode.

REPRODUSING PATH:
(1) Create volume group with name "unencrypted" by means of vgcreate utility.
(2) Run script (prepared by Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>):

----------------[BEGIN SCRIPT]--------------------

VG=unencrypted
lvcreate --size 2G --name ntest $VG
mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
mkdir /var/tmp/n
mkdir /var/tmp/n/ntest
mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
mkdir /var/tmp/n/ntest/thedir
cd /var/tmp/n/ntest/thedir
sleep 2
date
darcs init
sleep 2
dmesg|tail -n 5
date
darcs whatsnew || true
date
sleep 2
dmesg|tail -n 5
----------------[END SCRIPT]--------------------

REPRODUCIBILITY: 100%

INVESTIGATION:
As it was discovered, the issue takes place during segment
construction after executing such sequence of user-space operations:

open("_darcs/index", O_RDWR|O_CREAT|O_NOCTTY, 0666) = 7
fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
ftruncate(7, 60)

The error message "NILFS error (device dm-17): nilfs_bmap_assign:
broken bmap (inode number=28)" takes place because of trying to get
block number for third block of the file with logical offset #3072
bytes. As it is possible to see from above output, the file has 60
bytes of the whole size. So, it is enough one block (1 KB in size)
allocation for the whole file. Trying to operate with several blocks
instead of one takes place because of discovering several dirty
buffers for this file in nilfs_segctor_scan_file() method.

The root cause of this issue is in nilfs_set_page_dirty function which
is called just before writing to an mmapped page.

When nilfs_page_mkwrite function handles a page at EOF boundary, it
fills hole blocks only inside EOF through __block_page_mkwrite().

The __block_page_mkwrite() function calls set_page_dirty() after
filling hole blocks, thus nilfs_set_page_dirty function (=
a_ops->set_page_dirty) is called.  However, the current implementation
of nilfs_set_page_dirty() wrongly marks all buffers dirty even for
page at EOF boundary.

As a result, buffers outside EOF are inconsistently marked dirty and
queued for write even though they are not mapped with nilfs_get_block
function.

FIX:
This modifies nilfs_set_page_dirty() not to mark hole blocks dirty.

Thanks to Vyacheslav Dubeyko for his effort on analysis and proposals
for this issue.

Reported-by: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Reported-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/nilfs2/inode.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 689fb60..bccfec8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -219,13 +219,32 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
-	int ret = __set_page_dirty_buffers(page);
+	int ret = __set_page_dirty_nobuffers(page);
 
-	if (ret) {
+	if (page_has_buffers(page)) {
 		struct inode *inode = page->mapping->host;
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned nr_dirty = 0;
+		struct buffer_head *bh, *head;
 
-		nilfs_set_file_dirty(inode, nr_dirty);
+		/*
+		 * This page is locked by callers, and no other thread
+		 * concurrently marks its buffers dirty since they are
+		 * only dirtied through routines in fs/buffer.c in
+		 * which call sites of mark_buffer_dirty are protected
+		 * by page lock.
+		 */
+		bh = head = page_buffers(page);
+		do {
+			/* Do not mark hole blocks dirty */
+			if (buffer_dirty(bh) || !buffer_mapped(bh))
+				continue;
+
+			set_buffer_dirty(bh);
+			nr_dirty++;
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (nr_dirty)
+			nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
