From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [syzbot] [nilfs?] general protection fault in
 nilfs_clear_dirty_page
Date: Mon, 12 Jun 2023 05:30:23 +0200
Message-ID: <20230612033023.GA16241@lst.de>
References: <000000000000da4f6b05eb9bf593@google.com> <000000000000c0951105fde12435@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <000000000000c0951105fde12435-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, wqu-IBi9RG/b67k@public.gmane.org

On Sun, Jun 11, 2023 at 02:18:29PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 4a445b7b6178d88956192c0202463063f52e8667
> Author: Qu Wenruo <wqu-IBi9RG/b67k@public.gmane.org>
> Date:   Sat Aug 13 08:06:53 2022 +0000
> 
>     btrfs: don't merge pages into bio if their page offset is not contiguous

I can't see how that btrfs commit would affect nilfs2..

