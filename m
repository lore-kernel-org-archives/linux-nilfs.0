From: Tomas Hlavaty <tom-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8 in nilfs_segctor_do_construct
Date: Fri, 27 Mar 2020 07:26:51 +0100
Message-ID: <874kuapb2s.fsf@logand.com>
References: <8736emquds.fsf@logand.com> <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com> <87immckp07.fsf@logand.com> <87v9p2tkut.fsf@logand.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87v9p2tkut.fsf-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Tomas Hlavaty <tom-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org> writes:
>>> 2) Can you mount the corrupted(?) partition from a recent version of
>>> kernel ?

I tried the following Linux kernel versions:

- v4.19
- v5.4
- v5.5.11

and still get the crash
