From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Sun, 26 Jul 2009 12:05:56 -0400
Message-ID: <debc30fc0907260905w76ccec51g421ab08ecf3f67bd@mail.gmail.com>
References: <675178.67834.qm@web58804.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <675178.67834.qm-MMAiOCDKa4SB9c0Qi4KiSlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
To: eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Cc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Sun, Jul 26, 2009 at 11:18 AM, Eric A<eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> I installed nilfs2 on my 32GB SSD for my rootfs about a week ago and have
> been very impressed with the improvements in write speed.=A0 However, I j=
ust
> noticed that df reports I am using 25GB when there is only about 13GB of
> data on the disk.=A0 The 13GB size agrees with du and the size of my daily
> ext2 backup.=A0 I monitored the situation over night, and the size report=
ed by
> df appears to be growing by about 1-2GB a day.
>
This sounds like the nilfs_cleanerd is not running, could you check if
it appears in ps output?

> Is the size reported by df incorrect?=A0 What will happen when it reports=
 that
> the entire disk is full?
>
Depending on the version of NILFS you're using, you may be in trouble,
else, just starting nilfs_cleanerd manually should be able to free up
all the space.
