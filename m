From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: correct logic of translation virtual blocks
 number into physical ones
Date: Tue, 02 Jul 2013 01:02:38 +0900 (JST)
Message-ID: <20130702.010238.65450534.konishi.ryusuke@lab.ntt.co.jp>
References: <1372674852.2198.23.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372674852.2198.23.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 01 Jul 2013 14:34:12 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> The issue report is contained description of mount failure:
> 
> [  822.390075] NILFS version 2 loaded
> [  822.436888] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [  822.437107] NILFS: corrupt root inode.
> 
> The first phase of investigation discovered that it tries to read
> really something wrong instead of root inode:
<snip>
> ---
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: correct logic of translation virtual blocks number into physical ones
> 
> The issue report is contained description of mount failure:
> 
> [  822.390075] NILFS version 2 loaded
> [  822.436888] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [  822.437107] NILFS: corrupt root inode.
> 
> Investigation of the issue discovered that it takes places
> reading of ifile's block from not proper placement because of
> successful ending of operation of virtual block number translation
> into physical one.
> 
> This patch adds checking of start checkpoint and end checkpoint by
> comparing with current checkpoint number during translation of
> virtual block number into physical block number. Because it makes
> sense to operate with blocks that are alive for current checkpoint.
> 
> As a result, mount fails with such error message:
> 
> [17348.793335] NILFS warning (device loop0): nilfs_ifile_get_inode_block: unable to read inode: 2
> [17348.793869] NILFS: get root inode failed
> 
> Reported-by: Bryce Gibson <bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Vyacheslav, this patch breaks snapshot mounts because past blocks
deleted from the current file system have an end checkpoint number
smaller than the current checkpoint number.

Also, the title of this patch looks wrong.  You are trying to insert a
sanity check in the translation logic.  It doesn't correct translation
logic itself, nor removes the cause of reported problem.

I think the title of this patch should be "nilfs2: insert sanity check
in translation logic of ..."  or so.

Regards,
Ryusuke Konishi

> ---
>  fs/nilfs2/dat.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index fa0f803..08d9268 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -396,9 +396,11 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
>   */
>  int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
>  {
> +	struct the_nilfs *nilfs = dat->i_sb->s_fs_info;
>  	struct buffer_head *entry_bh, *bh;
>  	struct nilfs_dat_entry *entry;
>  	sector_t blocknr;
> +	__u64 cur_cno, start_cno, end_cno;
>  	void *kaddr;
>  	int ret;
>  
> @@ -422,6 +424,13 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
>  		ret = -ENOENT;
>  		goto out;
>  	}
> +	cur_cno = nilfs->ns_cno;
> +	start_cno = le64_to_cpu(entry->de_start);
> +	end_cno = le64_to_cpu(entry->de_end);
> +	if (cur_cno < start_cno || cur_cno > end_cno) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
>  	*blocknrp = blocknr;
>  
>   out:
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
