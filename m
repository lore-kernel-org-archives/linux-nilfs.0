From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Tue, 17 Mar 2009 22:43:24 +0900 (JST)
Message-ID: <20090317.224324.58871500.ryusuke@osrg.net>
References: <20090317154529.1aeeecdc@natsu.i4>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090317154529.1aeeecdc-2Ve/5xEMxL0@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, roman-ohbefDXYbNo@public.gmane.org

Hi,
On Tue, 17 Mar 2009 15:45:29 +0500, Roman Mamedov wrote:
> Hello.
> 
> I am seeing strange behaviour of nilfs. Namely, a new checkpoint with
> significant NBLKINC value is created on every cleanerd step, even though
> the file system is not accessed or written to by any apps at the time.
> Also, lssu shows that new segments are being continuously appended to
> the tail, whereas segments at the top are disappearing.

The garbage collection of nilfs is ``copying GC'', and it creates
checkpoints (it's normal for nilfs).  In addition, if segments
selected for cleaning have few reclaimable blocks, most remaining
blocks are copied into new segments.

If you are using nilfs-2.0.10 or later, you can see ``i'' flag in FLG
field of lscp.  The ``i'' flag means the checkpoint is created only
for such internal operation including GC.

> I am not completely sure, but this might have begun after doing a
> bind mount, i.e. `mount --bind /mnt/nilfs/somedir /some/other/dir`.
> Timestamp of the first strange checkpoint roughly corresponds to the
> time when I did that mount. And when I was trying to unmount it, the
> mount point was "busy", and `fuser` reported that the process using it
> is nilfs_cleanerd.

Did you specify an fstype option?  The behavior seems different
between:

  $ mount --bind /nilfs2 /test

and

  $ mount --bind -t nilfs2 /nilfs2 /test

In the former case, the result was as follows:

  /dev/sdb1 on /nilfs2 type nilfs2 (rw,gcpid=12667)
  /nilfs2 on /test type none (rw,bind)

In the latter case, it became

  /dev/sdb1 on /nilfs2 type nilfs2 (rw,gcpid=12667)
  /nilfs2 on /test type nilfs2 (rw,bind,gcpid=12673)

and, the second cleanerd has gone:

  nilfs_cleanerd[12673]: start
  nilfs_cleanerd[12673]: cannot create cleanerd on /nilfs2
  nilfs_cleanerd[12673]: shutdown
  nilfs_cleanerd[12667]: wake up
  nilfs_cleanerd[12667]: wait 21.000000000

Either example is safe. (the latter is a mere lucky)

I couldn't confirm your case that the clearnerd grabs different
mount point and prevent unmount.

> Hmm, now I see that `/mnt/nilfs/somedir` also has a zero-sized ".nilfs"
> file, just like the root directory of that filesystem. Perhaps this is
> the cause of the problem?

``.nilfs'' is just a regular file used to allow locking between
cleanerd and other userland tools.  So it will appear both mount
points.

Maybe clearnerd mistook the mount point, but the background checkpoint
creation itself is normal behavior.

Regards,
Ryusuke Konishi
 
> My kernel is 2.6.28. Initially, nilfs module and tools were versions
> 2.0.6, but an upgrade to 2.0.11 did not help.
> 
> If it matters, nilfs is created over a LUKS encrypted partition
> (/dev/mapper/device).
> 
> -- 
> With respect,
> Roman
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
