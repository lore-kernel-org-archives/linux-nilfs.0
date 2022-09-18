From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 kernfs_put_active
Date: Sun, 18 Sep 2022 19:43:15 +0900
Message-ID: <29200a14-e722-2d1e-66a2-c07b105036e8@I-love.SAKURA.ne.jp>
References: <00000000000095339805e8d6958e@google.com>
 <de81bf82-3ddf-4875-381d-e52949046b25@I-love.SAKURA.ne.jp>
 <f3b88739-148c-323c-2458-4b9d6bf9c592@I-love.SAKURA.ne.jp>
 <CAKFNMo=XjvQjoSo+N-MJGv5h4FPnjVm6bGaJm0QkO8GxjMNtTg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <CAKFNMo=XjvQjoSo+N-MJGv5h4FPnjVm6bGaJm0QkO8GxjMNtTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: syzbot <syzbot+258ad6d2cb6685e145bc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/09/18 19:19, Ryusuke Konishi wrote:
> I'm not sure if the patch [2] fixes the originally reported problem,
> but it will be fixed if it's the same.

Will be fixed. Thank you.

#syz fix: fs: fix UAF/GPF bug in nilfs_mdt_destroy

