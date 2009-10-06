From: "Barham, David" <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS hanging SLES 11 - advise on diagnosis needed
Date: Tue, 6 Oct 2009 16:24:20 +0200
Message-ID: <80225669DEC80D488C4A0B5150466E1802F184D0@dekomplm002.net.plm.eds.com>
References: <4ABE2E86.5010708@att.net><C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com><80225669DEC80D488C4A0B5150466E1802F17EC3@dekomplm002.net.plm.eds.com>
	<20091002.204207.26501663.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Class: urn:content-classes:message
In-Reply-To: <20091002.204207.26501663.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

I checked the hardware today as the machine keeps falling over, but only as=
 I'm doing data copies into the nilfs2 filesystem via NFS. The last few tim=
es I've not had any errors in the logs at all except those the clearerd whi=
ch is in debug mode and the startup after I power cycle the machine.

I tried to build a debug version of 2.0.17 but I'm getting =


/usr/local/sources/nilfs-2.0.17 # make
make -C fs
make[1]: Entering directory `/usr/local/sources/nilfs-2.0.17/fs'
make -C /lib/modules/2.6.27.19-5-default/build SUBDIRS=3D/usr/local/sources=
/nilfs-2.0.17/fs BUILD_DIR=3D/usr/local/sources/nilfs-2.0.17/fs modules
make[2]: Entering directory `/usr/src/linux-2.6.27.19-5-obj/x86_64/default'
make -C ../../../linux-2.6.27.19-5 O=3D/usr/src/linux-2.6.27.19-5-obj/x86_6=
4/default/. modules
  CC [M]  /usr/local/sources/nilfs-2.0.17/fs/debug.o
/usr/local/sources/nilfs-2.0.17/fs/debug.c: In function =E2snprint_page_fla=
gs=E2:
/usr/local/sources/nilfs-2.0.17/fs/debug.c:408: error: implicit declaration=
 of function =E2PagePinned=E2
make[5]: *** [/usr/local/sources/nilfs-2.0.17/fs/debug.o] Error 1
make[4]: *** [_module_/usr/local/sources/nilfs-2.0.17/fs] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.27.19-5-obj/x86_64/default'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/sources/nilfs-2.0.17/fs'
make: *** [fs] Error 2

I get the same error trying to make 2.0.16.

I've had a look at the C but I'm out of my depth.

Any help would be great.

Thanks
David Barham
Siemens PLM Software


-----Original Message-----
From: Ryusuke Konishi [mailto:ryusuke-sG5X7nlA6pw@public.gmane.org] =

Sent: 02 October 2009 12:42
To:; Barham, David
Subject: Re: [NILFS users] NILFS hanging SLES 11 - advise on diagnosis need=
ed

Hi,
On Fri, 2 Oct 2009 12:11:14 +0200, "Barham, David" wrote:
> Hi
> I'm running SLES 11, 2.6.27.19-5-default with NILFS2 nilfs-2.0.16. I have=
 a 1.5Tb NILFS2 partition which I am setting up with the intention of using=
 Robocopy from various PCs via samba. The robocopy scripts run nightly and =
a checkpoint is taken once night. A script stops samba, unmounts the previo=
us weeks checkpoint, deletes the checkpoint, creates a new one and then mou=
nts it and restarts samba. This should mean that at any time the user can g=
o back to 'snapshot_{DAY}' to get their files back.
> =

> So far so good.
> =

> However as I copy the previously backed up files from the previous linux =
machine where I was doing this (only giving a 'current' copy with reiserfs)=
. I'm finding that the new machine is occasionally hanging. The OS just loc=
ks up, screen on console frozen but host still responds to ping. =

> =

> I'm trying to work out what is causing the hang, I'm getting various mess=
ages in the log from smartd relating to the disk which houses the NILFS alo=
ng the lines of:
> =

>  Oct  2 09:56:59 cpli6008 syslog-ng[1933]: Log statistics; dropped=3D'pip=
e(/dev/xconsole)=3D0', dropped=3D'pipe(/dev/tty10)=3D0', processed=3D'cente=
r(queued)=3D947', processed=3D'center(received)=3D478', processed=3D'destin=
ation(newsnotice)=3D0', processed=3D'destination(acpid)=3D0', processed=3D'=
destination(firewall)=3D0', processed=3D'destination(mail)=3D12', processed=
=3D'destination(mailinfo)=3D12', processed=3D'destination(console)=3D151', =
processed=3D'destination(newserr)=3D0', processed=3D'destination(newscrit)=
=3D0', processed=3D'destination(messages)=3D466', processed=3D'destination(=
mailwarn)=3D0', processed=3D'destination(localmessages)=3D0', processed=3D'=
destination(netmgm)=3D0', processed=3D'destination(mailerr)=3D0', processed=
=3D'destination(xconsole)=3D151', processed=3D'destination(warn)=3D155', pr=
ocessed=3D'source(src)=3D478'
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sda [SAT], SMART Usag=
e Attribute: 194 Temperature_Celsius changed from 110 to 112
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Pref=
ailure Attribute: 1 Raw_Read_Error_Rate changed from 115 to 117
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usag=
e Attribute: 189 High_Fly_Writes changed from 88 to 87
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usag=
e Attribute: 190 Airflow_Temperature_Cel changed from 60 to 61
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usag=
e Attribute: 194 Temperature_Celsius changed from 40 to 39
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usag=
e Attribute: 195 Hardware_ECC_Recovered changed from 50 to 51
> =

> {machine stops responding and gets power cycled}
>
> Oct  2 10:10:58 cpli6008 syslog-ng[1948]: syslog-ng starting up; version=
=3D'2.0.9'
> =

> Do folks think that the hang is NILFS or dodgy hardware/reporting
> from smartd? Is there any advise on getting some debug or status
> information from NILFS to help show it isn't the cause of the
> problem. I would have expected that if it went bang I'd have seen
> something 'worrying' in the log.

The nilfs2 standalone module has a debug mode.  You can enable it by
commenting out the following line (i.e. CONFIG_NILFS_DEBUG=3Dy) in
nilfs2-module/fs/Makefile before compiling:

ifndef CONFIG_NILFS
  EXTERNAL_BUILD=3Dy
  CONFIG_NILFS=3Dm
  # Uncomment below to do debug build.
  CONFIG_NILFS_DEBUG=3Dy
  # Uncomment below to enable bmap validity check.
  #CONFIG_NILFS_BMAP_DEBUG=3Dy
endif

By the way, I'm planning to release nilfs-2.0.17 tomorrow in order to
solve file system corruption problems which infrequently happen and
were reported on this list.

The bugfix was already merged in the mainline and also sent to -stable
trees for 3.6.30 and 3.6.31, but not yet done.

Your problem looks hardware problem to me, but I think the new version
is worth a try.

Cheers,
Ryusuke Konishi
