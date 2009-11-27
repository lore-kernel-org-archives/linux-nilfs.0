From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 8/9] nilfs2: delete mark_inode_dirty in
 nilfs_delete_entry
Date: Fri, 27 Nov 2009 18:38:48 +0900 (JST)
Message-ID: <20091127.183848.33215894.ryusuke@osrg.net>
References: <1259305324-28050-1-git-send-email-jir@unicus.jp>
	<1259305324-28050-9-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259305324-28050-9-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 27 Nov 2009 16:02:03 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Delete mark_inode_dirty() in nilfs_delete_entry() to reduce duplicate
> mark_inode_dirty() calls both in nilfs_rename() and nilfs_delete_entry().
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/dir.c   |    1 -
>  fs/nilfs2/namei.c |    4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 693539b..1d9a4e4 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -595,7 +595,6 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
>  	nilfs_commit_chunk(page, mapping, from, to);
>  	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
>  /*	NILFS_I(inode)->i_flags &= ~NILFS_BTREE_FL; */
> -	mark_inode_dirty(inode);
>  out:
>  	nilfs_put_page(page);
>  	return err;
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index c662f8e..166a261 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -316,6 +316,8 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
>  	if (err)
>  		goto out;
>  
> +	mark_inode_dirty(dir);
> +

I think this mark_inode_dirty(dir) should be moved to nilfs_unlink()
because nilfs_rmdir() already has one mark_inode_dirty(dir) call.

>  	inode->i_ctime = dir->i_ctime;
>  	drop_nlink(inode);
>  	err = 0;
> @@ -451,8 +453,8 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	if (dir_de) {
>  		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
>  		drop_nlink(old_dir);
> -		mark_inode_dirty(old_dir);
>  	}
> +	mark_inode_dirty(old_dir);
>  	mark_inode_dirty(old_inode);
>  
>  	err = nilfs_transaction_commit(old_dir->i_sb);
> -- 
> 1.5.6.5
> 
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
