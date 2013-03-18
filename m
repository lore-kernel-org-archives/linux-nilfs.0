From: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Mon, 18 Mar 2013 18:23:52 +0400
Message-ID: <20130318142352.GA4148@black>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
 <1363328491.2078.21.camel@slavad-ubuntu>
 <20130315232157.GC1542@black>
 <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <70219EF1-8083-4DD5-BA18-84CD1914DC3E-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,


> Moreover, could you share output of "nilfs-tune -l" utility?

Here you are.

nilfs-tune 2.1.4
Filesystem volume name:	  ROOT
Filesystem UUID:	  0b4ff339-f246-41c6-9c4c-55064d9ffea9
Filesystem magic number:  0x3434
Filesystem revision #:	  2.0
Filesystem features:      (none)
Filesystem state:	  invalid or mounted
Filesystem OS type:	  Linux
Block size:		  4096
Filesystem created:	  Wed May  9 16:52:59 2012
Last mount time:	  Tue Mar 12 07:24:52 2013
Last write time:	  Thu Mar 14 23:39:36 2013
Mount count:		  81
Maximum mount count:	  50
Reserve blocks uid:	  0 (user root)
Reserve blocks gid:	  0 (group root)
First inode:		  11
Inode size:		  128
DAT entry size:		  32
Checkpoint size:	  192
Segment usage size:	  16
Number of segments:	  56432
Device size:		  473390895104
First data block:	  1
# of blocks per segment:  2048
Reserved segments %:	  5
Last checkpoint #:	  5439414
Last block address:	  48011326
Last sequence #:	  305301
Free blocks count:	  45154304
Commit interval:	  0
# of blks to create seg:  0
CRC seed:		  0xf8f795ab
CRC check sum:		  0xc4ea5e0d
CRC check data size:	  0x00000118

> > I am sorry, I didn't receive any archive.
> > 
> 
> It is strange.

[offtopic]: I observed and am still observing continous timeouts
after data coming from bluehost.com domain like this:

Mar 15 10:22:18 localhost postfix/smtpd[26071]: connect from oproxy5-pub.bluehost.com[67.222.38.55]
Mar 15 10:22:19 localhost postfix/smtpd[26071]: 53590D03:client=oproxy5-pub.bluehost.com[67.222.38.55]
Mar 15 10:24:01 localhost postfix/smtpd[26054]: disconnect from vger.kernel.org[209.132.180.67]
Mar 15 10:25:18 localhost postfix/smtpd[26037]: timeout after DATA (407 bytes) from unknown[144.76.18.105]
Mar 15 10:25:18 localhost postfix/smtpd[26037]: disconnect from unknown[144.76.18.105]
Mar 15 10:26:46 localhost postfix/smtpd[26052]: timeout after DATA (999 bytes) from oproxy1-pub.bluehost.com[66.147.249.253]
Mar 15 10:26:46 localhost postfix/smtpd[26052]: disconnect from oproxy1-pub.bluehost.com[66.147.249.253]
Mar 15 10:26:46 localhost postfix/cleanup[26053]: 39E48256: message-id=<1363328491.2078.21.camel@slavad-ubuntu>
Mar 15 10:27:19 localhost postfix/smtpd[26071]: timeout after DATA (1006 bytes) from oproxy5-pub.bluehost.com[67.222.38.55]
Mar 15 10:27:19 localhost postfix/smtpd[26071]: disconnect from oproxy5-pub.bluehost.com[67.222.38.55]
Mar 15 10:27:19 localhost postfix/cleanup[26060]: 53590D03: message-id=<1363328512.2078.23.camel@slavad-ubuntu>
Mar 15 10:28:23 localhost postfix/smtpd[26052]: connect from oproxy1-pub.bluehost.com[66.147.249.253]
Mar 15 10:28:24 localhost postfix/smtpd[26052]: 1995D256: client=oproxy1-pub.bluehost.com[66.147.249.253]

This may or may not be connected to delivery of your previous mail. What
makes me to suspect this may have relation is the hostname in the
message-id. [/offtopic]


> Now you can download nilfs-utils archive with last actual
> version of fsck.nilfs2 from
> http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz.

Thank you for the tool.

> Please, compile utilities set with fsck and run "fsck -v debug [device] 2> [output-file]".

I first tried with '-n' and discovered that this mode is not supported.
Then I ran the program as you suggested. I didn't study the program
source but is seems that this tool never writes. The report came out
really huge, please download in from
http://www.dragonworks.ru/nilfs2/fsck.nilfs2.debug.log.xz

I also prepared the '-v info' version which is considerably smaller:
http://www.dragonworks.ru/nilfs2/fsck.nilfs2.info.log.xz

Besides seemengly many problems in the filesystem's structures it
suggests that the primary and secondary superblocks are not identical
so I simply copied last 4kB of the volume to offset 1kB --- to no avail.
(Of course I experimented with a copy of the volume data)

What else can I do?

Thanks and regards.
Alexander.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
