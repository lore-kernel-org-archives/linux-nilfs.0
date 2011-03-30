From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
Date: Wed, 30 Mar 2011 13:17:18 +0200
Message-ID: <4D93113E.2070805@fusionio.com>
References: <20110330.132555.158630340.ryusuke@osrg.net> <4D930F02.4070409@fusionio.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D930F02.4070409@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 2011-03-30 13:07, Jens Axboe wrote:
> On 2011-03-30 06:25, Ryusuke Konishi wrote:
>> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
>> index 4d2a1ee..9d2dc6b 100644
>> --- a/fs/nilfs2/page.c
>> +++ b/fs/nilfs2/page.c
>> @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
>>  void nilfs_mapping_init(struct address_space *mapping,
>>  			struct backing_dev_info *bdi)
>>  {
>> +	static const struct address_space_operations empty_aops;
>> +
>>  	mapping->host = NULL;
>>  	mapping->flags = 0;
>>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>>  	mapping->assoc_mapping = NULL;
>>  	mapping->backing_dev_info = bdi;
>> -	mapping->a_ops = NULL;
>> +	mapping->a_ops = &empty_aops;
>>  }
> 
> Hmm wait, inode init should set the mapping aops to an empty type
> already. Does the OOPS go away if you just remove the mapping->a_ops =
> NULL assignment?

In any case, I think this is a better fix.

diff --git a/fs/inode.c b/fs/inode.c
index 5f4e11a..b818730 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -125,6 +125,13 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 static DECLARE_RWSEM(iprune_sem);
 
 /*
+ * Empty aops. Can be used for the cases where the user does not
+ * define any of the address_space operations.
+ */
+const struct address_space_operations empty_aops = {
+};
+
+/*
  * Statistics gathering..
  */
 struct inodes_stat_t inodes_stat;
@@ -176,7 +183,6 @@ int proc_nr_inodes(ctl_table *table, int write,
  */
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
-	static const struct address_space_operations empty_aops;
 	static const struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
 	struct address_space *const mapping = &inode->i_data;
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4d2a1ee..1168059 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -500,7 +500,7 @@ void nilfs_mapping_init(struct address_space *mapping,
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = bdi;
-	mapping->a_ops = NULL;
+	mapping->a_ops = &empty_aops;
 }
 
 /*
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index c74400f..403c192 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -80,7 +80,6 @@ enum {
 };
 
 static const struct inode_operations none_inode_operations;
-static const struct address_space_operations none_address_operations;
 static const struct file_operations none_file_operations;
 
 /**
@@ -130,7 +129,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	}
 
 	/* Re-define all operations to be "nothing" */
-	inode->i_mapping->a_ops = &none_address_operations;
+	inode->i_mapping->a_ops = &empty_aops;
 	inode->i_op = &none_inode_operations;
 	inode->i_fop = &none_file_operations;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 52f283c..1b95af3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -613,6 +613,8 @@ struct address_space_operations {
 	int (*error_remove_page)(struct address_space *, struct page *);
 };
 
+extern const struct address_space_operations empty_aops;
+
 /*
  * pagecache_write_begin/pagecache_write_end must be used by general code
  * to write into the pagecache.

-- 
Jens Axboe
