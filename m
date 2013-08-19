From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs2 crash debugging (was: Broken nilfs2 filesystem)
Date: Mon, 19 Aug 2013 23:55:35 +0400
Message-ID: <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>
References: <51F2A8A4.4020400@antoneliasson.se> <51F2A945.6050909@antoneliasson.se> <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com> <520CB032.2000602@antoneliasson.se>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=K0bIsnKQEsYeCCo70JhUCatklOpiPakRrgn6MfEv+lQ=;
	b=d05ES4YJfEfAPl4NGwCnjN8Llc6DtM9l1595HtybcSniw9SPe5Sjs2K38AHxw+2gM09YdQh/iWXtwk722Hkw1TS1NGNvStuDB9JNH1OZD1IKWXlXTpPm/FqHN2tuVpxh;
In-Reply-To: <520CB032.2000602-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Aug 15, 2013, at 2:40 PM, Anton Eliasson wrote:

[snip]
> Hi again. I was able to reproduce the crash on a fully updated system=
 by starting the two virtual machines simultaneously as described in my=
 e-mail from May 25. I made a new attempt to rebuild the kernel with yo=
ur patches. I selected these options in make menuconfig [1], which resu=
lted in this generated config.x86_64 [2] which has the following diff c=
ompared to the stock config.x86_64:
>=20

As I remember, you reported about remount file system in RO mode
and many "broken bnode" error messages issue, initially. Unfortunately,
as I can see, you can't reproduce this issue. I really had hope that yo=
u
can reproduce this important issue.

As I see, shared by you logs with crush contain details about the issue
that it was reported also by J=E9r=F4me Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
=2E
I mean this error message:

[  304.494448] BUG: unable to handle kernel paging request at 000000000=
00013f6    =20
[  304.494456] IP: [<ffffffffa1327232>] nilfs_end_page_io+0x12/0xc0 [ni=
lfs2]

I can reproduce this issue on my side and this issue is under investiga=
tion yet.

But anyway... Could you try to reproduce the issue with remounting
file system in RO mode? It is really important and annoying issue.

>    --- config.x86_64    2013-08-11 00:06:09.000000000 +0200
>    +++ config.x86_64.last    2013-08-11 12:48:44.094979947 +0200
>    @@ -1,6 +1,6 @@
>     #
>     # Automatically generated file; DO NOT EDIT.
>    -# Linux/x86 3.10.0-1 Kernel Configuration
>    +# Linux/x86 3.10.5-1 Kernel Configuration
>     #
>     CONFIG_64BIT=3Dy
>     CONFIG_X86_64=3Dy
>    @@ -5450,6 +5450,11 @@
>     # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
>     # CONFIG_BTRFS_DEBUG is not set
>     CONFIG_NILFS2_FS=3Dm
>    +CONFIG_NILFS2_DEBUG=3Dy
>    +# CONFIG_NILFS2_USE_PR_DEBUG is not set
>    +CONFIG_NILFS2_DEBUG_SHOW_ERRORS=3Dy
>    +CONFIG_NILFS2_DEBUG_DUMP_STACK=3Dy
>    +# CONFIG_NILFS2_DEBUG_SUBSYSTEMS is not set
>     CONFIG_FS_POSIX_ACL=3Dy
>     CONFIG_EXPORTFS=3Dy
>     CONFIG_FILE_LOCKING=3Dy
>=20

As I remember, I asked you about enabling more configuration options.
I mean such options:
CONFIG_NILFS2_DEBUG_BASE_OPERATIONS,
CONFIG_NILFS2_DEBUG_MDT_FILES,=20
CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM,
CONFIG_NILFS2_DEBUG_BLOCK_MAPPING.

I suppose that you don't enable these options because it has dependence
from "Enable output from subsystem" option. But, anyway, I am afraid
that you don't reproduce the issue in the case of these options enablin=
g.
But maybe you will be more lucky in such trying. :)=20

Anyway, thank you for your efforts. It will be really great if you will=
 be lucky
and will reproduce the issue with remount file system in RO mode
and many "broken bnode" error messages. Could you try again?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
