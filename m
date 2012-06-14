From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: off-line resizing?
Date: Thu, 14 Jun 2012 11:22:17 +0700
Message-ID: <86lijqv7ye.fsf@gray.siamics.net>
References: <86fw9zw601.fsf@gray.siamics.net>
	<20120614.110607.87804359.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>>>> Ryusuke Konishi writes:
>>>>> On Wed, 13 Jun 2012 23:06:54 +0700, Ivan Shmakov wrote:

[=E2=80=A6]

 >> Unfortunately, I don't plan to switch my =E2=80=9Cproduction=E2=80=9D=
 hosts to Linux
 >> 3 yet.  However, for the purposes I want to give NILFS a try I can
 >> assume that I can easily umount the volume whenever I need to resiz=
e
 >> it, to run whatever user-space code necessary.

 >> Thus, I'm curious, are there any plans to implement =E2=80=9Coff-li=
ne=E2=80=9D NILFS
 >> resizing?

 > Implementing Off-line resizing is a bit tough task because it
 > requires a user space library to read internal meta data of the nilf=
s
 > file system and append updated blocks to it.  This is almost
 > equivalent to implementing kernel functions of nilfs in user land.

 > So, we have no concrete schedule now.

	ACK, thanks.

	I wonder, how complicated this task would be?  In particular, do
	I need to alter all the segments to resize filesystem, or only
	specific ones?  Also, are these internal metadata records just
	=E2=80=9Ca bunch of C structs=E2=80=9D, or something more complex?

[=E2=80=A6]

 > For other Linux distros, the standalone kmod may be applicable with
 > or without customizing the source code.  it has a glue code to
 > support multiple kernel versions.  For reference, the source code of
 > the standalone kmod is available at:

 > git://github.com/nilfs-dev/nilfs2-kmod-centos6.git

	ACK, thanks.

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
