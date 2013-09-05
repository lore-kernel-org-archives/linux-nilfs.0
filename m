From: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Obtaining kernel patches
Date: Thu, 05 Sep 2013 07:54:22 -0700
Message-ID: <CE4DE92E.8DF9%markt@netqa.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello nilfs'ers:

I've been actively using nilfs in my project for a couple years now,
and follow closely the development via this mailing list.

In my environment nilfs has been very stable; however, the way I'm
using it does not stress any existing race conditions (fairly quiet
activity).

Recently however I have a case where a snapshot disappeared, and a
message in the syslog from the nilfs cleaner "..snapshot count mismatch..".

I'm using Debian and the 3.3.1 kernel, and am wondering how to best obtain
all important patches to date.

Thanks and best regards,
Mark Trumpold


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
