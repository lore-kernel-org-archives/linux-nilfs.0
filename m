From: "Barham, David" <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS space usage
Date: Fri, 2 Oct 2009 18:20:41 +0200
Message-ID: <80225669DEC80D488C4A0B5150466E1802F18005@dekomplm002.net.plm.eds.com>
References: <4ABE0553.3090502@att.net><debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com><4ABE0AD7.7000904@att.net><debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com><4ABE13D3.2080809@att.net><debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com><4ABE2704.6030607@att.net><debc30fc0909260815s412ee145xa90e02d9ce4c942f@mail.gmail.com><4ABE2E86.5010708@att.net><C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com>
	<80225669DEC80D488C4A0B5150466E1802F17EC3@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Class: urn:content-classes:message
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

As per my previous question...

I'm running SLES 11, 2.6.27.19-5-default with NILFS2 nilfs-2.0.16. I
have a 1.5Tb NILFS2 partition which I am setting up with the intention
of using Robocopy from various PCs via samba. The robocopy scripts run
nightly and a checkpoint is taken once night. A script stops samba,
unmounts the previous weeks checkpoint, deletes the checkpoint, creates
a new one and then mounts it and restarts samba. This should mean that
at any time the user can go back to 'snapshot_{DAY}' to get their files
back.

So far so good.

I'm really confused by the space utilisation I'm seeing and what
cleanerd actually does.

The drive is now up to 98% full but should only have about 500Gb on it.
I have removed the few checkpoint I made so no all there is are the
snapshots. Turning the option in nilfs_cleanerd.conf to debug shows.

Oct  2 16:37:44 cpli6008 nilfs_cleanerd[3611]: start
Oct  2 16:37:44 cpli6008 nilfs_cleanerd[3611]: ncleansegs = 13850
Oct  2 16:38:50 cpli6008 nilfs_cleanerd[3611]: 2 segments selected to be
cleaned

I just used the default options on the mkfs and haven't changed any
setting (other than debug) in nilfs_cleanerd.conf.

I'm guessing that my cpio -pdumv from a different machine into the nilfs
file system has resulted masses of snapshots and these are taking the
space.

Is there a way to clean up or change the preferences to create fewer
snapshots?



Many thanks
David Barham
Siemens PLM Software


_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users
