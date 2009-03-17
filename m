From: Roman Mamedov <roman-ohbefDXYbNo@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Tue, 17 Mar 2009 19:19:24 +0500
Message-ID: <20090317191924.1924576b@natsu.i4>
References: <20090317154529.1aeeecdc@natsu.i4>
	<20090317.224324.58871500.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090317.224324.58871500.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Tue, 17 Mar 2009 22:43:24 +0900 (JST)
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> The garbage collection of nilfs is ``copying GC'', and it creates
> checkpoints (it's normal for nilfs).  In addition, if segments
> selected for cleaning have few reclaimable blocks, most remaining
> blocks are copied into new segments.

I thought the NBLKINC count should not increase much when there are
no user writes to the filesystem. But it was increasing by several
thousands on every step.

This filesystem has size of about 300 gigabytes, and all I did, is
copied about 150 gigabytes of data to it, with no deletions, no
modifications or rewrites. But even about 6-8 hours after that, the
cleanerd process still has work to do, so much, that it interferes with
normal usage of the filesystem (i.e. playing a FLAC audio file from it
was skipping at times, even counting a bit increased load from going
through kcryptd, this shouldn't happen).

> If you are using nilfs-2.0.10 or later, you can see ``i'' flag in FLG
> field of lscp.  The ``i'' flag means the checkpoint is created only
> for such internal operation including GC.

Yes, after the upgrade to 2.0.11 I see "i" marks on these checkpoints.

> Did you specify an fstype option?

I had the fstype specified as "none" (in fstab).

>   /nilfs2 on /test type none (rw,bind)

Yes, this is what I have.

> and, the second cleanerd has gone:

I have only one cleanderd in process list.

What is really strange, is that it looks like I can unmount the main
NILFS, but the bind mount will continue to be accessible and writable.
And when I remount the main mount point back, cleanerd grabs the bind
mount. See below:

# mount -t nilfs2 /dev/mapper/hi320data /mnt/hi320data
mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
time.
mount.nilfs2: WARNING! - Do not place critical data on a NILFS
filesystem.

# mount --bind /mnt/hi320data/test/ /mnt/bind-test/

# ls /mnt/bind-test/

# touch /mnt/bind-test/abc

# umount /mnt/hi320data

# umount /mnt/hi320data
umount: /mnt/hi320data: not mounted

# touch /mnt/bind-test/def

# ls /mnt/bind-test/
abc  def

# mount -t nilfs2 /dev/mapper/hi320data /mnt/hi320data
mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
time.
mount.nilfs2: WARNING! - Do not place critical data on a NILFS
filesystem.

# ls /mnt/hi320data/test/
abc  def

# umount /mnt/bind-test 
umount: /mnt/bind-test: device is busy
umount: /mnt/bind-test: device is busy

# fuser -c /mnt/bind-test/
/mnt/bind-test/:     23203

# ps -Af | grep 23203
root 23203  1  1 19:06 ? 00:00:00 /sbin/nilfs_cleanerd
   -n /dev/mapper/hi320data /mnt/hi320data

-----------------------
Maybe it misdetects the bind mount as another mount of the same
filesystem (e.g. like when mounting a snapshot)?

-- 
With respect,
Roman
