From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS hanging SLES 11 - advise on diagnosis needed
Date: Fri, 02 Oct 2009 20:42:07 +0900 (JST)
Message-ID: <20091002.204207.26501663.ryusuke@osrg.net>
References: <4ABE2E86.5010708@att.net>
	<C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com>
	<80225669DEC80D488C4A0B5150466E1802F17EC3@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <80225669DEC80D488C4A0B5150466E1802F17EC3-q6sIb7dcTNEDs3eufgyKiYGWD8NUZu9dQQ4Iyu8u01E@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org

Hi,
On Fri, 2 Oct 2009 12:11:14 +0200, "Barham, David" wrote:
> Hi
> I'm running SLES 11, 2.6.27.19-5-default with NILFS2 nilfs-2.0.16. I have a 1.5Tb NILFS2 partition which I am setting up with the intention of using Robocopy from various PCs via samba. The robocopy scripts run nightly and a checkpoint is taken once night. A script stops samba, unmounts the previous weeks checkpoint, deletes the checkpoint, creates a new one and then mounts it and restarts samba. This should mean that at any time the user can go back to 'snapshot_{DAY}' to get their files back.
> 
> So far so good.
> 
> However as I copy the previously backed up files from the previous linux machine where I was doing this (only giving a 'current' copy with reiserfs). I'm finding that the new machine is occasionally hanging. The OS just locks up, screen on console frozen but host still responds to ping. 
> 
> I'm trying to work out what is causing the hang, I'm getting various messages in the log from smartd relating to the disk which houses the NILFS along the lines of:
> 
>  Oct  2 09:56:59 cpli6008 syslog-ng[1933]: Log statistics; dropped='pipe(/dev/xconsole)=0', dropped='pipe(/dev/tty10)=0', processed='center(queued)=947', processed='center(received)=478', processed='destination(newsnotice)=0', processed='destination(acpid)=0', processed='destination(firewall)=0', processed='destination(mail)=12', processed='destination(mailinfo)=12', processed='destination(console)=151', processed='destination(newserr)=0', processed='destination(newscrit)=0', processed='destination(messages)=466', processed='destination(mailwarn)=0', processed='destination(localmessages)=0', processed='destination(netmgm)=0', processed='destination(mailerr)=0', processed='destination(xconsole)=151', processed='destination(warn)=155', processed='source(src)=478'
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 110 to 112
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 115 to 117
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 189 High_Fly_Writes changed from 88 to 87
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 60 to 61
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 40 to 39
> Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 50 to 51
> 
> {machine stops responding and gets power cycled}
>
> Oct  2 10:10:58 cpli6008 syslog-ng[1948]: syslog-ng starting up; version='2.0.9'
> 
> Do folks think that the hang is NILFS or dodgy hardware/reporting
> from smartd? Is there any advise on getting some debug or status
> information from NILFS to help show it isn't the cause of the
> problem. I would have expected that if it went bang I'd have seen
> something 'worrying' in the log.

The nilfs2 standalone module has a debug mode.  You can enable it by
commenting out the following line (i.e. CONFIG_NILFS_DEBUG=y) in
nilfs2-module/fs/Makefile before compiling:

ifndef CONFIG_NILFS
  EXTERNAL_BUILD=y
  CONFIG_NILFS=m
  # Uncomment below to do debug build.
  CONFIG_NILFS_DEBUG=y
  # Uncomment below to enable bmap validity check.
  #CONFIG_NILFS_BMAP_DEBUG=y
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
