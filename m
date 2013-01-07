From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs causes the server crashed
Date: Mon, 7 Jan 2013 16:03:55 +0800
Message-ID: <A804603B-A921-4618-9BA3-8FE3F6A37316@gmail.com>
References: <0E29E2A8-658D-4911-A1B9-7080BAFDE020@gmail.com> <9EF47262-0248-4F4C-9C60-BEA95BD87BBF@dubeyko.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=GOkpKQYlrTjyk1DoTULKxItzgoX2WOvzKq0TEuVLU/0=;
        b=AelX3NLNNZ/7/pW+PLOEy5J58r0iIlTvSiTWGH2fgAE08aaQ8IzJ3m6BpwSnaG0kaK
         ekS60CQRsZuejk28+AQDppaeH2hJtmn3Tz/XTDtSL7DASZ/p5X0QgSXzP0CvyyfOotiM
         65HDlBM7rBNh3WsBou/fQDz6eLzhsJPA0WvQuxXEdNQTtdCvRvyArjx/ZwCydw1oJ0Jx
         p4Zg3cFtSvCkSMpdBna5r6qQjH1zNeaplBsSKOdoCeqQU1kx5ORwuJ9ao0AkZuQMOpTH
         UcJV7X5CKRMiIhz19pXiuBb6piEa9aTH/x2R+Pth+xBfQp+Twgfb/fHmvgoo/IYLUFW3
         iFTw==
In-Reply-To: <9EF47262-0248-4F4C-9C60-BEA95BD87BBF-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


=D4=DA 2013-1-7=A3=AC02:59=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> =
=D0=B4=B5=C0=A3=BA

>=20
> On Jan 6, 2013, at 10:44 AM, Elmer Zhang wrote:
>=20
>> Hi,
>> My server always crash and reboot when I start MySQLs which stores t=
he data on NILFS2 filesystem.
>>=20
>> I found some vmcore, but they are so big and I don't know how to ext=
ract useful information from them.
>> ~]# ll -h /var/crash/*/*
>> -rw------- 1 root root 141M Dec 20 16:14 /var/crash/127.0.0.1-2012-1=
2-20-16:14:03/vmcore
>> -rw------- 1 root root 512M Jan  4 16:00 /var/crash/127.0.0.1-2013-0=
1-04-15:59:20/vmcore
>> -rw------- 1 root root  92M Jan  4 16:25 /var/crash/127.0.0.1-2013-0=
1-04-16:25:35/vmcore
>> -rw------- 1 root root  62M Jan  4 16:50 /var/crash/127.0.0.1-2013-0=
1-04-16:50:02/vmcore
>> -rw------- 1 root root  63M Jan  4 18:55 /var/crash/127.0.0.1-2013-0=
1-04-18:55:43/vmcore
>> -rw------- 1 root root  80M Jan  5 14:55 /var/crash/127.0.0.1-2013-0=
1-05-14:55:15/vmcore
>> -rw------- 1 root root  65M Jan  5 15:30 /var/crash/127.0.0.1-2013-0=
1-05-15:30:35/vmcore
>> -rw------- 1 root root 199M Jan  6 15:06 /var/crash/127.0.0.1-2013-0=
1-06-15:06:19/vmcore
>>=20
>=20
> Crashdumps can be useful, I think. As I can see, you can use crash ut=
ility for analyzing it (http://magazine.redhat.com/2007/08/15/a-quick-o=
verview-of-linux-kernel-crash-dump-analysis/). I think that bt, log and=
 ps internal commands of crash utility can be very interesting. Could y=
ou share details of its output?
The output of crash: http://d.pr/n/V9ay
bt: http://d.pr/n/fyAs
log: http://d.pr/n/dYI0
ps: http://d.pr/n/KguM

>=20
>> And below is some snapshot of the screen, hope it's useful:
>> http://d.pr/i/4OZR
>> http://d.pr/i/10M3
>> http://d.pr/i/HnJn
>> http://d.pr/i/HW6t
>>=20
>=20
> I hope that these screenshots are a consequence of the initial issue.=
 But maybe it is a some new issue.
>=20
>> My environment:
>> kernel: 2.6.32-220.13.1.el6.x86_64
>> kmod-nilfs2-0.4.3-1.el6.x86_64
>> nilfs-utils-2.1.4-7.x86_64
>> Raid: raid10 with SEAGATE ST32000444SS(2TB) * 12
>> mount: /dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=3D9047)
>>=20
>> ~]# nilfs-tune -l /dev/sdb2=20
>> nilfs-tune 2.1.4
>> Filesystem volume name:	  (none)
>> Filesystem UUID:	  dcfb7152-a342-48d0-a712-212a3062395e
>> Filesystem magic number:  0x3434
>> Filesystem revision #:	  2.0
>> Filesystem features:      (none)
>> Filesystem state:	  invalid or mounted,error
>> Filesystem OS type:	  Linux
>> Block size:		  4096
>> Filesystem created:	  Mon Dec  3 13:56:51 2012
>> Last mount time:	  Sun Jan  6 15:41:34 2013
>> Last write time:	  Sun Jan  6 15:41:34 2013
>> Mount count:		  25
>> Maximum mount count:	  50
>> Reserve blocks uid:	  0 (user root)
>> Reserve blocks gid:	  0 (group root)
>> First inode:		  11
>> Inode size:		  128
>> DAT entry size:		  32
>> Checkpoint size:	  192
>> Segment usage size:	  16
>> Number of segments:	  1246464
>> Device size:		  10456104173568
>> First data block:	  1
>> # of blocks per segment:  2048
>> Reserved segments %:	  5
>> Last checkpoint #:	  6327388
>> Last block address:	  256856089
>> Last sequence #:	  3862375
>> Free blocks count:	  598300672
>> Commit interval:	  60
>> # of blks to create seg:  0
>> CRC seed:		  0x3adfb6c3
>> CRC check sum:		  0xca2168f3
>> CRC check data size:	  0x00000118
>>=20
>=20
> Thank you for details.
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
>>=20
>> Thanks
>> ---
>> Elmer Zhang
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

---
Elmer Zhang

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
