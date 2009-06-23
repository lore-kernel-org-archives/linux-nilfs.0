From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd shutdown
Date: Tue, 23 Jun 2009 10:53:11 +0900 (JST)
Message-ID: <20090623.105311.117320231.ryusuke@osrg.net>
References: <917066.47147.qm@web43411.mail.sp1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <917066.47147.qm-klR48C3JjEDrNpU5RS+xBlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sh1v4_0h-/E1597aS9LQAvxtiuMwx3w@public.gmane.org

Hi,
On Mon, 22 Jun 2009 14:09:39 -0700 (PDT), shiva onassis wrote:
> =

> Hello and thank you for your answer
> =

> --- On Mon, 6/22/09, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> [...] =

> > The recent patch against nilfs-utils works find for me and
> > cleanerd now
> > automaticaly starats when mount the nilfs partition.=A0
> > It would be worth
> > for you to apply it.
> =

> If the patch is in the git I'll wait for the next version. I'm on archlin=
ux, switching to another version is easy for me, but I don't know how to ma=
ke a package with git-sources.
> =

> If the patch is already in 2.0.13, it still does not work for me.

The patch is already in 2.0.13.
 =

> Jun 22 22:47:57 localhost nilfs_cleanerd[4242]: start
> Jun 22 22:47:57 localhost nilfs_cleanerd[4242]: cannot open nilfs on /dev=
/mapper/system-root: Invalid argument

The partition was mounted with a read-write mount. Is this right?
Cleanerd cannot operates on the read-only mount.
 =

> But maybe it's just how I do things:
> At system start for some reason there is no /etc/mtab. So I do a remount =
of / after all the others init scripts as a workaround. Only after the remo=
unt I see the volume mounted.
> =

> mount -t nilfs2 -o remount,rw /dev/mapper/system-root /
> =

> kind regards.

Ah, it might be due to lack of /proc mount.

The clearner daemon does not see /etc/mtab, instead it scans
/proc/mounts.  The nilfs library function looks to fail if the
/proc/mounts is not there.


Cheers,
Ryusuke Konishi
