From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Tue, 31 Mar 2009 23:44:37 +0900 (JST)
Message-ID: <20090331.234437.112904649.ryusuke@osrg.net>
References: <20090317154529.1aeeecdc@natsu.i4>
	<20090317.224324.58871500.ryusuke@osrg.net>
	<20090317191924.1924576b@natsu.i4>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090317191924.1924576b-2Ve/5xEMxL0@public.gmane.org>
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
To: roman-ohbefDXYbNo@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Tue, 17 Mar 2009 19:19:24 +0500, Roman Mamedov <roman-ohbefDXYbNo@public.gmane.org> wrote:
> What is really strange, is that it looks like I can unmount the main
> NILFS, but the bind mount will continue to be accessible and writable.
> And when I remount the main mount point back, cleanerd grabs the bind
> mount. See below:
> 
> # mount -t nilfs2 /dev/mapper/hi320data /mnt/hi320data
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
> time.
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS
> filesystem.
> 
> # mount --bind /mnt/hi320data/test/ /mnt/bind-test/
> 
> # ls /mnt/bind-test/
> 
> # touch /mnt/bind-test/abc
> 
> # umount /mnt/hi320data
> 
> # umount /mnt/hi320data
> umount: /mnt/hi320data: not mounted
> 
> # touch /mnt/bind-test/def
> 
> # ls /mnt/bind-test/
> abc  def
> 
> # mount -t nilfs2 /dev/mapper/hi320data /mnt/hi320data
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
> time.
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS
> filesystem.
> 
> # ls /mnt/hi320data/test/
> abc  def
> 
> # umount /mnt/bind-test 
> umount: /mnt/bind-test: device is busy
> umount: /mnt/bind-test: device is busy
> 
> # fuser -c /mnt/bind-test/
> /mnt/bind-test/:     23203
> 
> # ps -Af | grep 23203
> root 23203  1  1 19:06 ? 00:00:00 /sbin/nilfs_cleanerd
>    -n /dev/mapper/hi320data /mnt/hi320data
> 
> -----------------------
> Maybe it misdetects the bind mount as another mount of the same
> filesystem (e.g. like when mounting a snapshot)?

Now, I'm considering not to invoke cleanerd for bind-mounts.  It is
too complex to switch over the base directory of cleanerd along with
mount/umount events as above.  (It is possible but I'd rather avoid
complicating life management of cleanerd any further.)

In addition, the bind mount can attach only part of a single
filesystem, and therefore the .nilfs file, which is required for
proper cleaner operation, is not assured to exist on the top of mount
point for bind mounts.

Do you have any inconvenience if I disable GC for bind mounts?

Usually bind mount has an original rw-mount though Linux can
detach original mount prior to the bind-mount.

Regards,
Ryusuke Konishi
