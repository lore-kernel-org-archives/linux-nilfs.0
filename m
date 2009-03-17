From: Roman Mamedov <roman-ohbefDXYbNo@public.gmane.org>
Subject: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Tue, 17 Mar 2009 15:45:29 +0500
Message-ID: <20090317154529.1aeeecdc@natsu.i4>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hello.

I am seeing strange behaviour of nilfs. Namely, a new checkpoint with
significant NBLKINC value is created on every cleanerd step, even though
the file system is not accessed or written to by any apps at the time.
Also, lssu shows that new segments are being continuously appended to
the tail, whereas segments at the top are disappearing.

I am not completely sure, but this might have begun after doing a
bind mount, i.e. `mount --bind /mnt/nilfs/somedir /some/other/dir`.
Timestamp of the first strange checkpoint roughly corresponds to the
time when I did that mount. And when I was trying to unmount it, the
mount point was "busy", and `fuser` reported that the process using it
is nilfs_cleanerd.

Hmm, now I see that `/mnt/nilfs/somedir` also has a zero-sized ".nilfs"
file, just like the root directory of that filesystem. Perhaps this is
the cause of the problem?

My kernel is 2.6.28. Initially, nilfs module and tools were versions
2.0.6, but an upgrade to 2.0.11 did not help.

If it matters, nilfs is created over a LUKS encrypted partition
(/dev/mapper/device).

-- 
With respect,
Roman
