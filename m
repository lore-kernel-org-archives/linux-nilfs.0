From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v5 11/12] nilfs2: replace direct access of d_count with
 the d_count() helper
Date: Sat, 06 Jul 2013 19:45:21 +0900 (JST)
Message-ID: <20130706.194521.326433844.konishi.ryusuke@lab.ntt.co.jp>
References: <1373035709-40875-1-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1373035709-40875-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <andi@firstfloor.org>, "Chandramouleeswaran, Aswin" <aswin@hp.com>, "Norton, Scott J" <scott.norton@hp.com>

On Fri,  5 Jul 2013 10:48:29 -0400, Waiman Long <Waiman.Long@hp.com> wrote:
> Because of the d_count change made in dcache.h, all readonly references
> to d_count have to be changed to use the new d_count() helper as they
> shouldn't access its value directly.  There is no change in logic
> and everything should just work.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index c7d1f9f..bd9d1f2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -973,7 +973,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
>  
>  static int nilfs_tree_was_touched(struct dentry *root_dentry)
>  {
> -	return root_dentry->d_count > 1;
> +	return d_count(root_dentry) > 1;
>  }
>  
>  /**
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
