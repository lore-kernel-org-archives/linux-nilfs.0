From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] fs, nilfs: convert nilfs_root.count from atomic_t to
 refcount_t
Date: Sat, 21 Oct 2017 03:46:24 +0900
Message-ID: <423eab28-f68d-b7e9-d330-1f49df8c974a@lab.ntt.co.jp>
References: <1508496684-4908-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508496684-4908-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On 2017/10/20 19:51, Elena Reshetova wrote:
> atomic_t variables are currently used to implement reference
> counters with the following properties:
>   - counter is initialized to 1 using atomic_set()
>   - a resource is freed upon counter reaching zero
>   - once counter reaches zero, its further
>     increments aren't allowed
>   - counter schema uses basic atomic operations
>     (set, inc, inc_not_zero, dec_and_test, etc.)
> 
> Such atomic variables should be converted to a newly provided
> refcount_t type and API that prevents accidental counter overflows
> and underflows. This is important since overflows and underflows
> can lead to use-after-free situation and be exploitable.
> 
> The variable nilfs_root.count is used as pure reference counter.
> Convert it to refcount_t and fix up the operations.
> 
> Suggested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Reviewed-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thank you.

Ryusuke Konishi

> ---
>   fs/nilfs2/the_nilfs.c | 8 ++++----
>   fs/nilfs2/the_nilfs.h | 5 +++--
>   2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 2dd75bf..afebb50 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -737,7 +737,7 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
>   		} else if (cno > root->cno) {
>   			n = n->rb_right;
>   		} else {
> -			atomic_inc(&root->count);
> +			refcount_inc(&root->count);
>   			spin_unlock(&nilfs->ns_cptree_lock);
>   			return root;
>   		}
> @@ -776,7 +776,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
>   		} else if (cno > root->cno) {
>   			p = &(*p)->rb_right;
>   		} else {
> -			atomic_inc(&root->count);
> +			refcount_inc(&root->count);
>   			spin_unlock(&nilfs->ns_cptree_lock);
>   			kfree(new);
>   			return root;
> @@ -786,7 +786,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
>   	new->cno = cno;
>   	new->ifile = NULL;
>   	new->nilfs = nilfs;
> -	atomic_set(&new->count, 1);
> +	refcount_set(&new->count, 1);
>   	atomic64_set(&new->inodes_count, 0);
>   	atomic64_set(&new->blocks_count, 0);
>   
> @@ -806,7 +806,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
>   
>   void nilfs_put_root(struct nilfs_root *root)
>   {
> -	if (atomic_dec_and_test(&root->count)) {
> +	if (refcount_dec_and_test(&root->count)) {
>   		struct the_nilfs *nilfs = root->nilfs;
>   
>   		nilfs_sysfs_delete_snapshot_group(root);
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index b305c6f..883d732 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -27,6 +27,7 @@
>   #include <linux/blkdev.h>
>   #include <linux/backing-dev.h>
>   #include <linux/slab.h>
> +#include <linux/refcount.h>
>   
>   struct nilfs_sc_info;
>   struct nilfs_sysfs_dev_subgroups;
> @@ -246,7 +247,7 @@ struct nilfs_root {
>   	__u64 cno;
>   	struct rb_node rb_node;
>   
> -	atomic_t count;
> +	refcount_t count;
>   	struct the_nilfs *nilfs;
>   	struct inode *ifile;
>   
> @@ -299,7 +300,7 @@ void nilfs_swap_super_block(struct the_nilfs *);
>   
>   static inline void nilfs_get_root(struct nilfs_root *root)
>   {
> -	atomic_inc(&root->count);
> +	refcount_inc(&root->count);
>   }
>   
>   static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
