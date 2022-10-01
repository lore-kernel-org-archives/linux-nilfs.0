From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH] nilfs: check filetype/uid/gid at
 nilfs_read_inode_common()
Date: Sat, 1 Oct 2022 23:34:57 +0900
Message-ID: <7d6a80dc-940c-8a64-020d-4a524913512a@I-love.SAKURA.ne.jp>
References: <000000000000eb0ba805e9d6e30e@google.com>
 <f1438f46-a52d-707b-4ef9-ab29525f1c98@I-love.SAKURA.ne.jp>
 <4ac809f9-a414-e936-0da1-f943e0551ef2@I-love.SAKURA.ne.jp>
 <CAKFNMom4G5jzSZ_i-kKnykzkhDags+XKYbRZD-cu_FeTVrFMwg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <CAKFNMom4G5jzSZ_i-kKnykzkhDags+XKYbRZD-cu_FeTVrFMwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

On 2022/10/01 23:28, Ryusuke Konishi wrote:
> I think the former is fine because we don't have the idea to add
> metadata file inodes other
> than file type.   If you make a revised patch, I will approve or
> handle it.   Or if you are busy,
> I will take over the fix.

Please take over the fix. Thank you.

