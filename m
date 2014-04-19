From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: few patches from Debian
Date: Sat, 19 Apr 2014 21:00:14 +0900 (JST)
Message-ID: <20140419.210014.85398266.konishi.ryusuke@lab.ntt.co.jp>
References: <4645877.yriC0M9ozk@debstor>
	<20140419.202620.220041591.konishi.ryusuke@lab.ntt.co.jp>
	<7826590.1PyduIE8uy@debstor>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7826590.1PyduIE8uy@debstor>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 19 Apr 2014 21:46:37 +1000, Dmitry Smirnov wrote:
> On Sat, 19 Apr 2014 20:26:20 Ryusuke Konishi wrote:
>> Yes, I agree.  nilfs_cleanerd should statically link libnilfs and
>> libnilfsgc.  I am searching the way to do that.
> 
> So far I was able to do it with corrected patch (attached).
> I hope this time I got it right... Apologies for inconvenience...

Don't mind.  I will fix the issue a bit differently (as follows) and
then apply your revised patch.

Regards,
Ryusuke Konishi

diff --git a/sbin/cleanerd/Makefile.am b/sbin/cleanerd/Makefile.am
index 0f68670..0af4104 100644
--- a/sbin/cleanerd/Makefile.am
+++ b/sbin/cleanerd/Makefile.am
@@ -9,6 +9,7 @@ nilfs_cleanerd_SOURCES = cleanerd.c cldconfig.c \
 nilfs_cleanerd_CFLAGS = -Wall
 nilfs_cleanerd_CPPFLAGS = -I$(top_srcdir)/include \
 	-DSYSCONFDIR=\"$(sysconfdir)\"
+nilfs_cleanerd_LDFLAGS = -static
 
 dist_sysconf_DATA = nilfs_cleanerd.conf
 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
