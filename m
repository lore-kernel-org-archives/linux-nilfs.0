From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH] nilfs: check filetype/uid/gid at
 nilfs_read_inode_common()
Date: Sat, 1 Oct 2022 21:41:05 +0900
Message-ID: <4ac809f9-a414-e936-0da1-f943e0551ef2@I-love.SAKURA.ne.jp>
References: <000000000000eb0ba805e9d6e30e@google.com>
 <f1438f46-a52d-707b-4ef9-ab29525f1c98@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <f1438f46-a52d-707b-4ef9-ab29525f1c98-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

On 2022/10/01 20:24, Tetsuo Handa wrote:
> syzbot is reporting lockdep warning followed by NULL pointer dereference
> at nilfs_bmap_lookup_at_level() [1], for a crafted filesystem which
> contains raw_inode->i_mode == 0 is poisoning checkpoint inode at
> nilfs_read_inode_common() from nilfs_ifile_read() from
> nilfs_attach_checkpoint() from nilfs_fill_super() from nilfs_mount().
> Check that filetype/uid/gid are valid as well as i_nlink is valid.
> 
> Link: https://syzkaller.appspot.com/bug?extid=2b32eb36c1a825b7a74c [1]
> Reported-by: syzot <syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> ---
> This patch solves crash but I don't know whether this patch is correct.

Hmm, since bmap->b_sem and bmap->b_ops are initialized by nilfs_bmap_read(),
and nilfs_bmap_read() is called from nilfs_read_inode_common() only if
S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)
is true, I guess that the caller needs to verify that the returned inode is
a regular file? But where to add that check?

