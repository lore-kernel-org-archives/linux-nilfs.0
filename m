From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Mon, 27 Jul 2009 14:02:02 +0900 (JST)
Message-ID: <20090727.140202.14993189.ryusuke@osrg.net>
References: <826723.64411.qm@web58808.mail.re1.yahoo.com>
	<874oszhsip.wl%jir@sekiba.com>
	<450036.15299.qm@web58805.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <450036.15299.qm-tDJBJ58iwLuB9c0Qi4KiSlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
On Sun, 26 Jul 2009 19:00:09 -0700 (PDT), Eric A wrote:
> Ok, thanks that makes sense.  Well now that nilfs_cleanerd has been
> running for about 9 hours, it is actually starting to free up some
> space!  It's freed up about 1GB so far of the 12GB that should be
> freed.  So, I suppose it is working correctly, just rather slowly.

Well, this should get fixed in the course of improvement of the
garbage collector.

> So, the only real problem is that it is not being started on mount,
> but for now I can just manually start it.
>
> Eric

Yes, I'd like to know why cleanerd fails or is not invoked in your
(gentoo?) boot environment.

> /proc/mounts:
> rootfs / rootfs rw 0 0
> /dev/root / nilfs2 rw,noatime 0 0

looks good to me.

> The only thing I see in syslog related to nilfs:
> Jul 26 12:23:50 gentoo klogd: VFS: Mounted root (nilfs2 filesystem) readonly on device 8:2.
> Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: start
> Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: override protection period to 0

After nilfs was mounted readonly as above, it must have been remounted
read-write, and normally cleanerd should be invoked at the time.

Could you see the following points to be checked ?

 * if the symbolic link /dev/root points to an existent device /dev/sdxx
   (or /dev/hdyy) or not.
 * if the root entry is written in /etc/fstab as below:

  /dev/sdxx     /    nilfs2   defaults            0    0       

 * if mount.nilfs2 is placed in /sbin near ``/sbin/mount''.
 * /proc was mounted before the root nilfs is remounted read-write.

Thanks,
Ryusuke Konishi

> ________________________________
> From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
> Sent: Sunday, July 26, 2009 8:35:42 PM
> Subject: Re: [NILFS users] df reports used space gradually growing.
> 
> Hi,
> 
> > Using lscp, I see no snapshots, but several thousand checkpoints.  I tried
> > deleting the checkpoints with rmcp, but that didn't free up any space.  The
> > disk is still slowly filling.
> 
> Unfortunately that's the way rmcp works for now.
> rmcp only tells the cleanerd the checkpoint is ready to remove even
> in the protection period and nilfs_cleanerd is the only process that
> collect garage from the storage and create free space for new logs.
> 
> thanks,
> 
> regards,
> -- 
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
