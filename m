From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Mon, 27 Jul 2009 03:57:44 +0900 (JST)
Message-ID: <20090727.035744.118657598.ryusuke@osrg.net>
References: <675178.67834.qm@web58804.mail.re1.yahoo.com>
	<debc30fc0907260905w76ccec51g421ab08ecf3f67bd@mail.gmail.com>
	<288232.83823.qm@web58801.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <288232.83823.qm-GoVOXiws8HGB9c0Qi4KiSlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org

Hi,
On Sun, 26 Jul 2009 10:40:08 -0700 (PDT), Eric A wrote:
> You're right; nilfs_cleanered wasn't running.  I've tried rebooting
> and it still isn't automatically starting.  I'm running 2.6.31-rc4
> and nilfs-utils-2.0.14.  The following is the relevant fstab line:
> =

> /dev/sda2               /               nilfs2          rw,noatime       =
       0 0

Oh, I thought the problem would be fixed with nilfs-utils-2.0.14.

How does the relevant line in /proc/mounts look like?

I think you can find the error which terminated cleanerd in
/var/log/syslog or /var/log/messages.

> I manually started nilfs_cleanered and have been running it for
>about an hour.  Conky shows disk read/writes of 1MiB every 2 seconds
>or so, but I don't see any space being freed up.  In fact, df still
>reports a gradual filling of the disk.  Eric

Is is the same thing if you shorten the protection period or release
snapshots ?

Thanks,
Ryusuke Konishi

> ________________________________
> From: J=E9r=F4me Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
> Cc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
> Sent: Sunday, July 26, 2009 12:05:56 PM
> Subject: Re: [NILFS users] df reports used space gradually growing.
> =

> On Sun, Jul 26, 2009 at 11:18 AM, Eric A<eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> > I installed nilfs2 on my 32GB SSD for my rootfs about a week ago and ha=
ve
> > been very impressed with the improvements in write speed..  However, I =
just
> > noticed that df reports I am using 25GB when there is only about 13GB of
> > data on the disk.  The 13GB size agrees with du and the size of my daily
> > ext2 backup.  I monitored the situation over night, and the size report=
ed by
> > df appears to be growing by about 1-2GB a day.
> >
> This sounds like the nilfs_cleanerd is not running, could you check if
> it appears in ps output?
> =

> > Is the size reported by df incorrect?  What will happen when it reports=
 that
> > the entire disk is full?
> >
> Depending on the version of NILFS you're using, you may be in trouble,
> else, just starting nilfs_cleanerd manually should be able to free up
> all the space.
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
