From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v6 0/2] nilfs2: introduce free inodes count calculation
 implementation
Date: Thu, 30 May 2013 00:47:42 +0900 (JST)
Message-ID: <20130530.004742.511734781.konishi.ryusuke@lab.ntt.co.jp>
References: <1369819553.2224.20.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1369819553.2224.20.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>, =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>

Hi Andrew,

Could you queue this patch set for the next merge window?

Thanks,
Ryusuke Konishi

On Wed, 29 May 2013 13:25:53 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> This is sixth version of the patch set.
> 
> v5->v6
>  * Minor corrections in logic of free inodes calculation
>    (remove obsolete increment, align indentations).
>  * Rework patch on using atomic64_t instead of using
>    atomic_long_t (Joern Engel suggestion).
> 
> v4->v5
>  * Remove mi_desc_blocks_count field from nilfs_mdt_info struct.
>  * Remove logic of using mi_desc_blocks_count from the code.
>  * Simplify logic of nilfs_palloc_count_max_entries() method.
>  * Add single patch with changing on atomic_long_t type
>    representation of inodes_count and blocks_count fields in
>    nilfs_root struct.
> 
> v3->v4
>  * The desc_blocks value is represented by unsigned long type.
>  * The nilfs_palloc_count_desc_blocks() method is simplified.
>  * The mi_desc_blocks_count field of nilfs_mdt_info structure
>    is represented as atomic64_t for the case of CONFIG_64BIT and
>    as atomic_t for other cases.
> 
> v2->v3
>  * Trivial BUG_ON checks were removed.
>  * Whole calculation algorithm was moved into
>    nilfs_palloc_count_max_entries() method.
>  * Improve error processing in the code.
>  * The nilfs_palloc_mdt_file_can_grow() method was simplified.
>  * The nilfs_ifile_count_free_inodes() method was simplified.
> 
> v1->v2
>  * Change __statfs_word on u64 type.
>  * Rename nilfs_count_free_inodes() into nilfs_ifile_count_free_inodes()
>    method.
>  * Introduce auxiliary functions: nilfs_palloc_count_max_entries(),
>    nilfs_palloc_count_desc_blocks(), nilfs_palloc_mdt_file_can_grow().
>  * Rework processing of returned error from
>    nilfs_ifile_count_free_inodes() in nilfs_statfs().
> 
> With the best regards,
> Vyacheslav Dubeyko.
> ---
>  fs/nilfs2/alloc.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/alloc.h     |    2 ++
>  fs/nilfs2/ifile.c     |   22 +++++++++++++++++
>  fs/nilfs2/ifile.h     |    2 ++
>  fs/nilfs2/inode.c     |    8 +++----
>  fs/nilfs2/segment.c   |    4 ++--
>  fs/nilfs2/super.c     |   31 ++++++++++++++++++++----
>  fs/nilfs2/the_nilfs.c |    4 ++--
>  fs/nilfs2/the_nilfs.h |    4 ++--
>  9 files changed, 126 insertions(+), 14 deletions(-)
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
