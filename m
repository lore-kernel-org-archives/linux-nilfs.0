From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: cleaner: run one cleaning pass based on minimum free space
Date: Sat, 13 Mar 2010 21:49:43 +0100
Message-ID: <4B9BFA67.1010501@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

In order to reduce cleaner io, I am thinking it could be usefull to
implement a parameter where you can specify the minimum free space. If
this parameter is set, instead of normal cleaning operation, the cleaner
would wait until there is less than minimum free space available and
then run one cleaning pass (from first to last segment). If after that,
there is again more than minimum free space available, continue waiting,
otherwise run cleaning passes until there is more than minimum free
space available.

What would you think about this idea ?

Bye,
David Arendt
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
