From: "Ethy H. Brito" <ethy.brito-INItM/9t2qJfJ/NunPodnw@public.gmane.org>
Subject: cleanerd taking too long to complete
Date: Sat, 16 Dec 2017 22:13:26 -0200
Message-ID: <20171216221326.39ce57f1@babalu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi All

I've been struggling with this fellow for a few days now.

Here is the deal: I recently discovered that a nilfs partition has been
used for a few weeks without cleanerd running.

Well, since monday I started it (mount -o remount) it and noticed it uses
almost 100% of my CPUs.
To avoid this behavior I suspend (-s) it during labor hours and resume
(-r) it at night.

Now lies the "problem". The partition (512G) was not cleared throughout the week.
Yesterday I resumed cleanerd by 6PM and it is still "running" (-l) up to this
moment, more than 24 hours later.

Is it normal to take this long (and more) to clear??
How can I be informed about how much of the job has cleanerd already completed?

Regards

Ethy
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
