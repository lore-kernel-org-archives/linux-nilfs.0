From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Harddisk not going to standby when using NILFS
Date: Sun, 03 Jan 2010 20:35:32 +0900 (JST)
Message-ID: <20100103.203532.220048154.ryusuke@osrg.net>
References: <deafb1571001021054n284bb268x58f2764afd32a65c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <deafb1571001021054n284bb268x58f2764afd32a65c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: markus.r.lindgren-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Sat, 2 Jan 2010 19:54:29 +0100, Markus Lindgren wrote:
> Hi,
> 
> I just started using NILFS on two of my "backup" disks just to give
> NILFS a try. Initially I plan to test having daily backups on these
> disks (I know this is not a typical use scenario for NILFS, but anyhow
> it is a way of starting with NILFS).
> 
> To my problem... I discovered that when using NILFS the hard disk
> never seems to enter the 'standby' power-saving state; it remains in
> the 'active/idle' state, which causes extra noise and power usage.
> (Which is bad since I like things when they are quiet :-)
> I then tried mounting one of the disks without the cleanerd, but still
> both disks remain in the 'active/idle' state. And yes, I waited
> sufficiently long for the drives to enter the standby state.
> 
> Does anyone know of a workaround to get the disks to enter the
> 'standby' power state when using NILFS? (And not by forcing disks to
> that state by using hdparm.)
>
> In case it is the cleanerd causing the disks not to spin down, is
> there perhaps a way to trigger running the "cleanerd" only a few times
> per day? In my usage scenario there is no point in constantly checking
> for garbage on the disks.

On my laptop, the standby state worked after doing 'hdparm -B 1'.
But, as you pointed out, cleanerd prevented the device from entering
the standby state.  After killing cleanerd by hand, this issue seems
to get settled.

If you won't kill cleanerd manually, another possible solution is to
set protection_period a large value in /etc/nilfs_cleanerd.conf.  I
think the essential solution is to improve cleanerd to suppress
needless operation as repeatedly discussed in this list.

> On a secondary note, when I tried to remount the second disk to not
> use cleanerd I got the following message:
>   umount.nilfs2: cleanerd (pid=2160) still exists on /dev/sdb1.
> waiting.....failed
>   umount.nilfs2: /mnt/sdb1: device is busy
>   umount.nilfs2: cleanerd (pid=2160) still exists on /dev/sdb1.
> waiting.....failed
>   umount.nilfs2: /mnt/sdb1: device is busy
> Which is a bit strange, since as far as I know, no files where in use
> from that disk and no bash/shell running from directories on that
> disk. I did not help to try forcing the umount either.

Ahh, there seems no way to shutdown cleanerd directly by remount.

How about this?

  # mount -t nilfs2 -o remount,ro /dev/xxx /dir &&
    mount -t nilfs2 -i -o remount,rw /dev/xxx /dir

> Thanks in advance,
>   Markus Lindgren

Cheers,
Ryusuke Konishi
