From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Sun, 25 Aug 2013 17:02:32 +0200
Message-ID: <521A1C88.9080100@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se> <51F2A945.6050909@antoneliasson.se> <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com> <520CB032.2000602@antoneliasson.se> <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-08-19 21:55:
> On Aug 15, 2013, at 2:40 PM, Anton Eliasson wrote:
>
> [snip]
>> Hi again. I was able to reproduce the crash on a fully updated syste=
m by starting the two virtual machines simultaneously as described in m=
y e-mail from May 25. I made a new attempt to rebuild the kernel with y=
our patches. I selected these options in make menuconfig [1], which res=
ulted in this generated config.x86_64 [2] which has the following diff =
compared to the stock config.x86_64:
>>
> As I remember, you reported about remount file system in RO mode
> and many "broken bnode" error messages issue, initially. Unfortunatel=
y,
> as I can see, you can't reproduce this issue. I really had hope that =
you
> can reproduce this important issue.
>
> As I see, shared by you logs with crush contain details about the iss=
ue
> that it was reported also by J=E9r=F4me Poulin <jeromepoulin-Re5JQEeQqe8@public.gmane.org=
m>.
> I mean this error message:
>
> [  304.494448] BUG: unable to handle kernel paging request at 0000000=
0000013f6
> [  304.494456] IP: [<ffffffffa1327232>] nilfs_end_page_io+0x12/0xc0 [=
nilfs2]
>
> I can reproduce this issue on my side and this issue is under investi=
gation yet.
>
> But anyway... Could you try to reproduce the issue with remounting
> file system in RO mode? It is really important and annoying issue.
Yes, that one is much easier to reproduce. I simply try to read one of=20
the corrupted files in /home. See below. I have no idea how the actual=20
corruption happened, however.

> [...]
> As I remember, I asked you about enabling more configuration options.
> I mean such options:
> CONFIG_NILFS2_DEBUG_BASE_OPERATIONS,
> CONFIG_NILFS2_DEBUG_MDT_FILES,
> CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM,
> CONFIG_NILFS2_DEBUG_BLOCK_MAPPING.
>
> I suppose that you don't enable these options because it has dependen=
ce
> from "Enable output from subsystem" option. But, anyway, I am afraid
> that you don't reproduce the issue in the case of these options enabl=
ing.
> But maybe you will be more lucky in such trying. :)
I think I got it right this time. The missing options appeared after I=20
enabled CONFIG_NILFS2_DEBUG_SUBSYSTEMS. The config I used is here [1],=20
which has the following diff compared to the upstream config:

     --- config.x86_64    2013-08-25 06:53:05.000000000 +0200
     +++ config.x86_64.last    2013-08-25 15:24:51.118711529 +0200
     @@ -1,6 +1,6 @@
      #
      # Automatically generated file; DO NOT EDIT.
     -# Linux/x86 3.10.5-1 Kernel Configuration
     +# Linux/x86 3.10.9-1 Kernel Configuration
      #
      CONFIG_64BIT=3Dy
      CONFIG_X86_64=3Dy
     @@ -5452,6 +5452,20 @@
      # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
      # CONFIG_BTRFS_DEBUG is not set
      CONFIG_NILFS2_FS=3Dm
     +CONFIG_NILFS2_DEBUG=3Dy
     +# CONFIG_NILFS2_USE_PR_DEBUG is not set
     +CONFIG_NILFS2_DEBUG_SHOW_ERRORS=3Dy
     +CONFIG_NILFS2_DEBUG_DUMP_STACK=3Dy
     +CONFIG_NILFS2_DEBUG_SUBSYSTEMS=3Dy
     +CONFIG_NILFS2_DEBUG_BASE_OPERATIONS=3Dy
     +CONFIG_NILFS2_DEBUG_MDT_FILES=3Dy
     +CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM=3Dy
     +# CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM is not set
     +# CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM is not set
     +CONFIG_NILFS2_DEBUG_BLOCK_MAPPING=3Dy
     +# CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT is not set
     +# CONFIG_NILFS2_DEBUG_SHOW_SPAM is not set
     +# CONFIG_NILFS2_DEBUG_HEXDUMP is not set
      CONFIG_FS_POSIX_ACL=3Dy
      CONFIG_EXPORTFS=3Dy
      CONFIG_FILE_LOCKING=3Dy

> Anyway, thank you for your efforts. It will be really great if you wi=
ll be lucky
> and will reproduce the issue with remount file system in RO mode
> and many "broken bnode" error messages. Could you try again?
>
> Thanks,
> Vyacheslav Dubeyko.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Yes. Here's another huge kernel.log for you [2]. It's 19 MB compressed=20
and 282 MB uncompressed. I blanked the log while running the stock=20
kernel and then rebooted to the custom debugging kernel. X wouldn't=20
start so I just logged in to a virtual terminal, changed directory to=20
"~/Bilder/20130321-28 Jakobs bilder fr=E5n Nederl=E4nderna" and then=20
executed `cat 179.JPG >/dev/null`.

This caused a read-only remount and a bunch of "broken bmap" messages t=
o=20
show, followed by an "Input/Output error". I saved a copy of=20
/var/log/kernel.log as soon as I could after that, before reinstalling=20
the stock kernel and rebooting.

[1]: http://antoneliasson.se/publicdump/config.x86_64.last.20130825
[2]: http://antoneliasson.se/publicdump/kernel.log.20130825.gz

--=20
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
