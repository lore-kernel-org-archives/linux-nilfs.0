From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Strange issue on disk usage with nilfs2 and df command
Date: Fri, 22 Jan 2021 00:02:14 +0900
Message-ID: <CAKFNMokm-Ciz+---m+sqG10e+JERSH8mhHdnOJppZPgk=T2d+w@mail.gmail.com>
References: <ab9c4da7-428d-1ed4-c3a6-07d6d90815ba@eurek.it>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mA1JBPDD0fnbcYxnsbbdLiImCHIJu79VjpXqSMkQprU=;
        b=VasqO5UVWpmqNkQEbfT/O+dA5bIvvtRFp3CK9+oKUQlQr0vU5dCesoY9C4zK76cQv+
         PKqyzxn5j0oHSNbO3TyYiBYlZ/hDSyt7VdlmDA/XXWYsoJYg9OVuOKWSvcBJHX3BT/A/
         E45dz3sZQnVz4bdtSfqzcUB1VaLfB37a4j8ECtuBj5OaDl2ouddWr5wRLmwjNUMspwdQ
         DvtLfIGjYqsit7sme5OG+9ZiLTs0J6QXU0ewV9MlmP7UDV4amHJrf2c4GPblufgC/0wD
         OhPSI/n8B4+zV3X0bdNnRLBY3HdIc3kiaVTS5GMwxYNLS2U1FMIRx8f0+0FFezIPm05J
         Gp2Q==
In-Reply-To: <ab9c4da7-428d-1ed4-c3a6-07d6d90815ba-nshbqAY+RnA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gianluca <gianlucarenzi-nshbqAY+RnA@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

Can you try "sudo lssu -l -p 60" ?

This shows the percentage of live blocks for every in-use segment
at the time.
("Live block" here means in-use block, which is not reclaimable
 with GC.  If you are using snapshots of NILFS, this pushes up the
 number of live blocks)

"df" command reports disk usage based on the percentage of in-use
segments instead of actual live blocks.  "lssu -l" may give more hints
about disk usage.

Regards,
Ryusuke Konishi

On Sat, Jan 16, 2021 at 12:13 AM gianluca <gianlucarenzi-nshbqAY+RnA@public.gmane.org> wrote:
>
> Hello,
> I am facing a little annoying issue in a Debian Stretch 9.13 (armel)
> board with rootfilesystem with nilfs2 type.
>
> The system has a iMX28 CPU with 256MB DDR2 Ram and 4GB emmC flash storage.
>
> The system has /var /run /tmp in tempfs ramdisk.
>
> In the beginning the filesystem is full at 50% so about 2Gb.
> All the remaining space is technically empty.
>
> The application is writing the same sqlite3 database every 30s or 60s
> dipending on the configuration (it writes few kilobytes every time, so
> the database size increase very little each time).
>
> The rootfs is mounted with: noatime,nodiratime,rw in the /etc/fstab
> configuration file.
>
> The nilfs tools are 2.2.6 as per Debian Stretch version.
>
> The Linux Kernel is 4.9.78 vanilla.
>
> The cleaner configuration file is the standard vanilla Debian version
> with some changes:
>
> protection_period is 60 (original has 3600)
>
> The min_clean_segments is 10% (90% of usage of the disk triggers the
> start of garbage collector)
>
> The max_clean_segments is 20% (80% of usage of the disk triggers the
> stop of the garbage collector)
>
> But in my board it seems something goes partially wrong.
>
> After some days/week of usage:
>
> 1- the garbage collector is a running state (nilfs-clean -l)
>
> 2- The usage is 90% (df command)
>
> After some time the gc goes in idle but the disk space still at 90%.
>
> If I create a big file to increase the usage of the storage up to 95% of
> real disk space, the gc starts after a while, and it remains running
> forever.
>
> If I delete this big file, it runs for a while, then the space returns
> to 90%. But using lsblk it gives me the 80% or less of filesystem usage.
>
> What the heck is happening?
>
> The GC is working as expected, but it gives me wrong status or wrong
> disk usage (df)...
>
> Weird
>
> Anybody has issued this problem yet?
>
> Regards
> --
> Eurek s.r.l.                          |
> Electronic Engineering                | http://www.eurek.it
> via Celletta 8/B, 40026 Imola, Italy  | Phone: +39-(0)542-609120
> p.iva 00690621206 - c.f. 04020030377  | Fax:   +39-(0)542-609212
