From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs: check filetype/uid/gid at nilfs_read_inode_common()
Date: Sat, 1 Oct 2022 23:28:22 +0900
Message-ID: <CAKFNMom4G5jzSZ_i-kKnykzkhDags+XKYbRZD-cu_FeTVrFMwg@mail.gmail.com>
References: <000000000000eb0ba805e9d6e30e@google.com> <f1438f46-a52d-707b-4ef9-ab29525f1c98@I-love.SAKURA.ne.jp>
 <4ac809f9-a414-e936-0da1-f943e0551ef2@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5SOqjTYxrPX3UKSRLL1nV1n1rZEuBHFtZb+M/+rfmWU=;
        b=AGd+clWmm36L7dQlU00uRrlhU9GjQwXmYL1f6rVF6JlwTpf3m+JIZ694Ulv7hM4Qea
         Tscs6ZLGdjWiEokTuInG1qfyGe59YNuKLDRyyYZLC+tji6tm01Le+PLolXs1nAobvyQ/
         IfvDSXZYkJJHCx/iiTjBPTbXz7/tXhdjxaNDufuBfCily18Zx0i2rmLmT/v5zfWK/57Q
         w//+PgoByAiDfJ6F+oxKznhm/8qp1lj1NhETBGH5RgHR1t0pCUyyh60QTkqHNABCRDuq
         puJeB/+KG2hfJpVhio7nsA+M4kBE8eYuXuvrwbmAVpS3l+iHFYNJ1BNj0EDQCs7g6gVr
         oL1g==
In-Reply-To: <4ac809f9-a414-e936-0da1-f943e0551ef2-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

On Sat, Oct 1, 2022 at 9:41 PM Tetsuo Handa wrote:
>
> On 2022/10/01 20:24, Tetsuo Handa wrote:
> > syzbot is reporting lockdep warning followed by NULL pointer dereference
> > at nilfs_bmap_lookup_at_level() [1], for a crafted filesystem which
> > contains raw_inode->i_mode == 0 is poisoning checkpoint inode at
> > nilfs_read_inode_common() from nilfs_ifile_read() from
> > nilfs_attach_checkpoint() from nilfs_fill_super() from nilfs_mount().
> > Check that filetype/uid/gid are valid as well as i_nlink is valid.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=2b32eb36c1a825b7a74c [1]
> > Reported-by: syzot <syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
> > Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> > ---
> > This patch solves crash but I don't know whether this patch is correct.
>
> Hmm, since bmap->b_sem and bmap->b_ops are initialized by nilfs_bmap_read(),
> and nilfs_bmap_read() is called from nilfs_read_inode_common() only if
> S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)
> is true, I guess that the caller needs to verify that the returned inode is
> a regular file? But where to add that check?

Exactly, this looks like the root cause of the issue.

For metadata files, which are internal persistent files of nilfs2 and
used to store metadata
on disk, must have a file type and must call nilfs_bmap_read(), but
that sanity check
is missing.

As you pointed out, we need to add a sanity check for i_mode of metadata files.

The simple way is to insert a conditional sanity check in
nilfs_read_inode_common()
using nilfs_is_metadata_file_inode() and S_ISREG(), for instance:

    if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
             return -EIO;   /* On-disk inode of the metadata file is
corrupted. */
    if (inode->i_nlink == 0)
             return -ESTALE;   /* ... */

Or, we can add the i_mode sanity checks separately in
nilfs_dat_read(), nilfs_ifile_read(), nilfs_sufile_read(), and
nilfs_cpfile_read() before they call nilfs_read_inode_common().

I think the former is fine because we don't have the idea to add
metadata file inodes other
than file type.   If you make a revised patch, I will approve or
handle it.   Or if you are busy,
I will take over the fix.

Thank you,
Ryusuke Konishi
