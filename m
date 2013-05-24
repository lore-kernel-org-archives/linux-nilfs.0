From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v5 0/2] nilfs2: implement calculation of free inodes count
Date: Fri, 24 May 2013 17:32:13 +0400
Message-ID: <1369402333.2235.21.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=sxgf5CessfD6NvuJJR0htSyvKZYfRrDP8t8frReusU4=;
	b=ijCjhwKLVRhPi92xJJ8+UDqMfCXE46ZmiUjskiMx8itEc83OhctGT2MCrJvaLXY/aoa5VAc/qSApmavNEmqew4+ECNMP58sQuzCCvnPVn4OrTtqklMZ+ZlwJTDwGI4lZ;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

Hi Ryusuke,

This is fifth version of the patch set. I hope that it is simply
enough now. Thank you for review and suggestions. Your comments
improved the code really.

v4->v5
 * Remove mi_desc_blocks_count field from nilfs_mdt_info struct.
 * Remove logic of using mi_desc_blocks_count from the code.
 * Simplify logic of nilfs_palloc_count_max_entries() method.
 * Add single patch with changing on atomic_long_t type
   representation of inodes_count and blocks_count fields in
   nilfs_root struct.

v3->v4
 * The desc_blocks value is represented by unsigned long type.
 * The nilfs_palloc_count_desc_blocks() method is simplified.
 * The mi_desc_blocks_count field of nilfs_mdt_info structure
   is represented as atomic64_t for the case of CONFIG_64BIT and
   as atomic_t for other cases.

v2->v3
 * Trivial BUG_ON checks were removed.
 * Whole calculation algorithm was moved into
   nilfs_palloc_count_max_entries() method.
 * Improve error processing in the code.
 * The nilfs_palloc_mdt_file_can_grow() method was simplified.
 * The nilfs_ifile_count_free_inodes() method was simplified.

v1->v2
 * Change __statfs_word on u64 type.
 * Rename nilfs_count_free_inodes() into nilfs_ifile_count_free_inodes()
   method.
 * Introduce auxiliary functions: nilfs_palloc_count_max_entries(),
   nilfs_palloc_count_desc_blocks(), nilfs_palloc_mdt_file_can_grow().
 * Rework processing of returned error from
   nilfs_ifile_count_free_inodes() in nilfs_statfs().

With the best regards,
Vyacheslav Dubeyko.
---
 fs/nilfs2/alloc.c     |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h     |    2 ++
 fs/nilfs2/ifile.c     |   22 +++++++++++++++++
 fs/nilfs2/ifile.h     |    2 ++
 fs/nilfs2/inode.c     |    8 +++---
 fs/nilfs2/segment.c   |    4 +--
 fs/nilfs2/super.c     |   31 ++++++++++++++++++++---
 fs/nilfs2/the_nilfs.c |    4 +--
 fs/nilfs2/the_nilfs.h |    4 +--
 9 files changed, 128 insertions(+), 14 deletions(-)
-- 
1.7.9.5


