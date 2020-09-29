From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: Fix some kernel-doc warnings for nilfs2
Date: Tue, 29 Sep 2020 22:41:38 +0900
Message-ID: <CAKFNMonTkN8E4q+ZJdzFauwWo3tx5gB1rDKq=-fGs0XMV5cTbQ@mail.gmail.com>
References: <1601386269-2423-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+STyH5O53die4jdqqjMtAFsl2MxlZkezojrgZ2z1daA=;
        b=gQR6esvWA5VB8c+pFxu5ZUVTEmuzFU8jTLvmpvuhzYpF+hnUmrX88oRIoj6JPliLKO
         pYM7X8qOYmYiHgVBXppKpLcUDPqcjEG743lkeRX+guaNLrWxYtX0SWFUvGVMaUsLSdgc
         60osieHexS768K34EqAj0SE0Vd6GatjP154kA0Qo5+cBcKJ5q56Lyco6pmu9KwJlx43q
         Zl26FXmOB2xEF86ENkJiPY02QehREDNfcgmGo06uJWVcpYCjSYdvsjcHzTkY/eUd93Bu
         gmarNZGerNQMxtXFUqgYk8Ot1cQcdpNdUWiYDDw0tgPl2kqLY8n9CgAQBmg7/kTE61HB
         AHdA==
In-Reply-To: <1601386269-2423-1-git-send-email-konishi.ryusuke@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Andrew,

Please queue this, kernel-doc warnings fix, for the next merge window.

Thanks,
Ryusuke Konishi

On Tue, Sep 29, 2020 at 10:31 PM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> From: Wang Hai <wanghai38@huawei.com>
>
> Fixes the following W=1 kernel build warning(s):
>
> fs/nilfs2/bmap.c:378: warning: Excess function parameter 'bhp' description in 'nilfs_bmap_assign'
> fs/nilfs2/cpfile.c:907: warning: Excess function parameter 'status' description in 'nilfs_cpfile_change_cpmode'
> fs/nilfs2/cpfile.c:946: warning: Excess function parameter 'stat' description in 'nilfs_cpfile_get_stat'
> fs/nilfs2/page.c:76: warning: Excess function parameter 'inode' description in 'nilfs_forget_buffer'
> fs/nilfs2/sufile.c:563: warning: Excess function parameter 'stat' description in 'nilfs_sufile_get_stat'
>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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
> 1.8.3.1
>
