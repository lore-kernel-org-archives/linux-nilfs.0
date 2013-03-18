From: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Tue, 19 Mar 2013 02:31:45 +0400
Message-ID: <20130318223145.GA17965@black>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
 <1363328491.2078.21.camel@slavad-ubuntu>
 <20130315232157.GC1542@black>
 <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
 <20130318142352.GA4148@black>
 <4E5BDA60-7615-4F82-AC0F-4459DD9EF544@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E5BDA60-7615-4F82-AC0F-4459DD9EF544-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

thank you for your analysis and support!

> As I can see from the debug output last write was on Friday
> March 15, 2013 at 00:02:24.

This write (unless something has happened to system clock) must have
occured during the mount attempt after the reboot. The time you
mention (which timezone, btw?) is approximately the time when I
discovered that my laptop has hung and when I rebooted it. My
impression (which may be wrong) is that there passed quite a while
after the hang before I had noticed this.

> So, I need in raw dump of three segments #23443 (ss_seq = 305301,
> first block #48011264), #23444 (ss_seq = 305302, first block
> #48013312), #23445 (ss_seq = 305303, first block #48015360).
> Please, make raw dump from #48011264 till #48017408 (namely,
> 6144 blocks)

A small note: 48017408-48011264+1 = 6145

> and share with me. Moreover, please, share dumpseg output
> for this segments.

I prepared the dumpseg output for these segments. Please find it
at http://www.dragonworks.ru/nilfs2/dumpseg.log .

As to the raw data, these blocks happened to contain some quite
sensitive information. I won't share this information
publicitly and would avoid leaking it as much as it seems
reasonable. If this data is of real and great help, please
let me know, I will prepare and send a link privately.
Sorry about that.

> Tomorrow, I prepare patch with additional debug output for
> deeper investigation of the issue on your side.

Is there any chance to register a different fs aside with
"official" nilfs2? Would such a simple change be sufficient?

diff -ur org/super.c new/super.c
--- org/super.c	2013-03-19 02:17:23.922469000 +0400
+++ new/super.c	2013-03-19 02:16:20.440634698 +0400
@@ -1356,7 +1356,7 @@
 
 struct file_system_type nilfs_fs_type = {
 	.owner    = THIS_MODULE,
-	.name     = "nilfs2",
+	.name     = "nilfs2-dbg",
 	.mount    = nilfs_mount,
 	.kill_sb  = kill_block_super,
 	.fs_flags = FS_REQUIRES_DEV,

What I want is to whenever possible avoid rebooting a machine
I am using for experimentation. It has /home on a nilfs2
partition and there're usually open user files on it.

Thanks and regards.
Alexander Bezrukov.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
