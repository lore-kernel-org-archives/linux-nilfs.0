From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] nilfs2: Fix some kernel-doc warnings for nilfs2
Date: Fri, 18 Sep 2020 22:06:32 +0900
Message-ID: <CAKFNMokCqSL+bn+Ak9c0-z9OeC3Wabf_US0hgnXjUfgbnJ07ZQ@mail.gmail.com>
References: <20200918123640.72014-1-wanghai38@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZUoctTKvMEX46atc5bG0ZTqxvB+PI1w0uFEi2bv4h1M=;
        b=SPq1lp3uxcES/OcfFU/VY4a5pAoYxXmdkgWMEXgqHYZ4a1/HI2WnMX80OQXtrO/wQW
         mivf3ef6ELDDUsrAMYSnSAh8eo6f0h7+12vr4cD9rdT703QwMZIA675bOFpOTnOQgtZ1
         lxaNUwgOfVzOGeYVgg37TxUaY5tA+ntAqUgUg3P9DxZW/CTTynNPJclPX0UAUiMAviNB
         b5VC2kEh17T+08s+sL5sOtFVgtGaduzEn935hyXcsrRJZwg7UfdFh10bzEA2+biXODZj
         wnnwju6xuUYup3sLXyecTS69YRUIvc6dyEts7aXYsRfBPvBHR7cngfiabd1XI5wD8mih
         UUpg==
In-Reply-To: <20200918123640.72014-1-wanghai38-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Hai <wanghai38-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Wang,

The patch looks correct.  Will apply, thank you.

Ryusuke Konishi

On Fri, Sep 18, 2020 at 9:40 PM Wang Hai <wanghai38-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
> fs/nilfs2/bmap.c:378: warning: Excess function parameter 'bhp' description in 'nilfs_bmap_assign'
> fs/nilfs2/cpfile.c:907: warning: Excess function parameter 'status' description in 'nilfs_cpfile_change_cpmode'
> fs/nilfs2/cpfile.c:946: warning: Excess function parameter 'stat' description in 'nilfs_cpfile_get_stat'
> fs/nilfs2/page.c:76: warning: Excess function parameter 'inode' description in 'nilfs_forget_buffer'
> fs/nilfs2/sufile.c:563: warning: Excess function parameter 'stat' description in 'nilfs_sufile_get_stat'
>
> Signed-off-by: Wang Hai <wanghai38-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nilfs2/bmap.c   | 2 +-
>  fs/nilfs2/cpfile.c | 6 +++---
>  fs/nilfs2/page.c   | 1 -
>  fs/nilfs2/sufile.c | 4 ++--
>  4 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index e516ae389ca5..5900879d5693 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -355,7 +355,7 @@ void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *bmap,
>  /**
>   * nilfs_bmap_assign - assign a new block number to a block
>   * @bmap: bmap
> - * @bhp: pointer to buffer head
> + * @bh: pointer to buffer head
>   * @blocknr: block number
>   * @binfo: block information
>   *
> diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
> index 86d4d850d130..025fb082575a 100644
> --- a/fs/nilfs2/cpfile.c
> +++ b/fs/nilfs2/cpfile.c
> @@ -889,7 +889,7 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
>   * nilfs_cpfile_change_cpmode - change checkpoint mode
>   * @cpfile: inode of checkpoint file
>   * @cno: checkpoint number
> - * @status: mode of checkpoint
> + * @mode: mode of checkpoint
>   *
>   * Description: nilfs_change_cpmode() changes the mode of the checkpoint
>   * specified by @cno. The mode @mode is NILFS_CHECKPOINT or NILFS_SNAPSHOT.
> @@ -930,12 +930,12 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
>  /**
>   * nilfs_cpfile_get_stat - get checkpoint statistics
>   * @cpfile: inode of checkpoint file
> - * @stat: pointer to a structure of checkpoint statistics
> + * @cpstat: pointer to a structure of checkpoint statistics
>   *
>   * Description: nilfs_cpfile_get_stat() returns information about checkpoints.
>   *
>   * Return Value: On success, 0 is returned, and checkpoints information is
> - * stored in the place pointed by @stat. On error, one of the following
> + * stored in the place pointed by @cpstat. On error, one of the following
>   * negative error codes is returned.
>   *
>   * %-EIO - I/O error.
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index b175f1330408..171fb5cd427f 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -69,7 +69,6 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
>
>  /**
>   * nilfs_forget_buffer - discard dirty state
> - * @inode: owner inode of the buffer
>   * @bh: buffer head of the buffer to be discarded
>   */
>  void nilfs_forget_buffer(struct buffer_head *bh)
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 42ff67c0c14f..63722475e17e 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -546,13 +546,13 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>  /**
>   * nilfs_sufile_get_stat - get segment usage statistics
>   * @sufile: inode of segment usage file
> - * @stat: pointer to a structure of segment usage statistics
> + * @sustat: pointer to a structure of segment usage statistics
>   *
>   * Description: nilfs_sufile_get_stat() returns information about segment
>   * usage.
>   *
>   * Return Value: On success, 0 is returned, and segment usage information is
> - * stored in the place pointed by @stat. On error, one of the following
> + * stored in the place pointed by @sustat. On error, one of the following
>   * negative error codes is returned.
>   *
>   * %-EIO - I/O error.
> --
> 2.17.1
>
