From: Tomas Hlavaty <tom-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8 in nilfs_segctor_do_construct
Date: Thu, 23 Jan 2020 13:31:38 +0100
Message-ID: <87v9p2tkut.fsf@logand.com>
References: <8736emquds.fsf@logand.com> <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com> <87immckp07.fsf@logand.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87immckp07.fsf-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ryusuke,

>> 2) Can you mount the corrupted(?) partition from a recent version of
>> kernel ?

this will take me some time to figure out

>> 3) Does read-only mount option (-r) work to avoid the crash ?

ro mount doesn't seem to crash

at least after mounting the partition read-only
- running lscp
- running sudo find . -type f inside the mounted partition
- cat <some random file on the nilfs partition>
does not crash

the crash i was seeing was during rsync (writing i guess)

Other info that might be relevant:

- the nilfs partition was on top of luks
- the corruption happened probably during shutdown
  the shutdown hanged for a long time waiting for nilfs
  disk (iirc it waits for 1m30s) and even after that it did
  not finish so i turned the computer off without waiting
  further.  after new start, i got the crash
- i got the same problem on another disk recently

Regards,

Tomas
