From: "Barham, David" <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: NILFS hanging SLES 11 - advise on diagnosis needed
Date: Fri, 2 Oct 2009 12:11:14 +0200
Message-ID: <80225669DEC80D488C4A0B5150466E1802F17EC3@dekomplm002.net.plm.eds.com>
References: <4ABE0553.3090502@att.net><debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com><4ABE0AD7.7000904@att.net><debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com><4ABE13D3.2080809@att.net><debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com><4ABE2704.6030607@att.net><debc30fc0909260815s412ee145xa90e02d9ce4c942f@mail.gmail.com><4ABE2E86.5010708@att.net>
	<C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Class: urn:content-classes:message
In-Reply-To: <C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9-BUHhN+a2lJ4@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi
I'm running SLES 11, 2.6.27.19-5-default with NILFS2 nilfs-2.0.16. I have a 1.5Tb NILFS2 partition which I am setting up with the intention of using Robocopy from various PCs via samba. The robocopy scripts run nightly and a checkpoint is taken once night. A script stops samba, unmounts the previous weeks checkpoint, deletes the checkpoint, creates a new one and then mounts it and restarts samba. This should mean that at any time the user can go back to 'snapshot_{DAY}' to get their files back.

So far so good.

However as I copy the previously backed up files from the previous linux machine where I was doing this (only giving a 'current' copy with reiserfs). I'm finding that the new machine is occasionally hanging. The OS just locks up, screen on console frozen but host still responds to ping. 

I'm trying to work out what is causing the hang, I'm getting various messages in the log from smartd relating to the disk which houses the NILFS along the lines of:

 Oct  2 09:56:59 cpli6008 syslog-ng[1933]: Log statistics; dropped='pipe(/dev/xconsole)=0', dropped='pipe(/dev/tty10)=0', processed='center(queued)=947', processed='center(received)=478', processed='destination(newsnotice)=0', processed='destination(acpid)=0', processed='destination(firewall)=0', processed='destination(mail)=12', processed='destination(mailinfo)=12', processed='destination(console)=151', processed='destination(newserr)=0', processed='destination(newscrit)=0', processed='destination(messages)=466', processed='destination(mailwarn)=0', processed='destination(localmessages)=0', processed='destination(netmgm)=0', processed='destination(mailerr)=0', processed='destination(xconsole)=151', processed='destination(warn)=155', processed='source(src)=478'
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 110 to 112
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 115 to 117
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 189 High_Fly_Writes changed from 88 to 87
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 60 to 61
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 40 to 39
Oct  2 09:57:25 cpli6008 smartd[3473]: Device: /dev/sdb [SAT], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 50 to 51

{machine stops responding and gets power cycled}

Oct  2 10:10:58 cpli6008 syslog-ng[1948]: syslog-ng starting up; version='2.0.9'

Do folks think that the hang is NILFS or dodgy hardware/reporting from smartd? Is there any advise on getting some debug or status information from NILFS to help show it isn't the cause of the problem. I would have expected that if it went bang I'd have seen something 'worrying' in the log. 

For information the hardware is a Dell Precision 380.

Many thanks
David Barham
Siemens PLM Software
