From: Leszek Dubiel <leszek.dubiel-1wJNZh+36GH0W0O+zarrUQ@public.gmane.org>
Subject: user experience
Date: Tue, 10 Jan 2012 17:22:35 +0100
Message-ID: <4F0C65CB.9030203@dubielvitrum.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Dubiel Vitrum is using Linux Debian system extensively to manage all 
documents in electronic form. We have ten million of files sorted in 
directories. The biggest directories contain about 100.000 files.

Currently our system works effectively by using ReiserFs, which is 
especially fast for small files and directories containing lots of 
files. But ReiserFS is not supported any more, so we are looking for a 
new file system that would handle our job as good as ReiserFS.

I installed fresh Debian, created empty partitions, formated them as 
Reiserfs, Nilfs. Then run command on each partition:

     for A in $(seq 10); do for B in $(seq 100); do for C in $(seq 
1000); do mkdir -p $A/$B/$C; done; done; done

and then run:

     find >/dev/null.

On Reiserfs it (last command, find) took 19 seconds, while on Nilfs it 
took 170 seconds. Maybe this is because system lacks b-tree directory 
management. Another limitation is that I was unable to create more than 
thirty thousand directories in one directory.

Leszek Dubiel
www.dubielvitrum.pl

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
