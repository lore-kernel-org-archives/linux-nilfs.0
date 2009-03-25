From: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: continuous backup solution with nilfs
Date: Wed, 25 Mar 2009 02:07:52 +0100
Message-ID: <4577.84.133.242.204.1237943266.squirrel@ssl.its-beck.de>
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

Hi,

I'd like to post some semi-useful setup I installed a week ago for you to
enjoy. Maybe someone has some comments on it ...

The plan is to create an "indestructible" block device which does
real-time backup to a remote iSCSI LUN. This can be done with Linux
Software RAID alone already, but using nilfs, one can add point-in-time
recovery to said block device.

The intention is to run virtual machines of any kind on the indestructible
block device, and have backup of any past state, up to certain limits of
course.

This is the setup:

 * The remote iSCSI LUN is formatted with nilfs2. It is mounted without
cleanerd, to avoid performance loss on the host.

 * A loop file is created on the nilfs2. The size of this file will limit
the size of the indestructible block device.

 * Another loop file identical in size is created on a local filesystem
(eventually this may also be a real partition or disk).

 * Using mdadm, both loop devices are welded together as a RAID-0
(mirrored) device. The remote loop device is marked "write-mostly" so
reads on the iSCSI LUN are kept at minimum. "write-behind" is activated
to allow the remote device to lag behind. Also, internal bitmapping is
activated, so in case of a connection loss only changed blocks are
written to the remote loop file.

 * The resulting md-device can be formatted with any filesystem or
connected to a virtual machine.

So how does it perform?

Quite well I'd say. I am running two slave databases on two indestructible
block devices (formatted with XFS actually), backed by a single iSCSI LUN
with nilfs2. One 100 GB, another 50 GB. The nilfs partition (1000 GB) is
filling at a rate of about 30 GB a day. They keep up with their masters.
Of course nothing is optimized for anything here: Small changes in the
database are likely to produce rather big block copies in the nilfs.

I plan to swap the nilfs device and resync on a blank loop file once it is
full. Far more efficient than using cleanerd, sorry :-)

Recovery is "okay".

I can use any checkpoint and load the loop file from that point in time.
There are some things to note, though:

 * The file is read-only. So is the loop device. mdadm doesn't really like
assembling with a read-only loop device (I couldn't stop it without a
kernel "oops" message). The safe workaround is to mount the loop device
directly, without any RAID. That works for XFS, but not necessarily for
other filesystems, as the end of the device contains the mdadm
superblock.

 * The filesystem is in an unclean state. It will try to repair and fail
to do so because it is read-only. In case of XFS, that can be turned off
with mount option.

 * Also, the filesystem UUID is the same as the active one. Same again, a
mount option forces ignoring the UUID.

The backup can be restored, which was the point.

The remote loop device can be removed with mdadm. Write performance should
increase a lot then, though it will never be native because the bitmap
file has to be written. Upon re-add, it resynced quickly (the /proc/mdstat
indicator isn't accurate on this, the sync just skips unwritten portions).

I will now watch the nilfs2 device fill up to see what happens and will
report back soon. My guess is something will explode: mdadm, loop and / or
nilfs. This can be avoided, of course, by swapping the loop file before
that happens. But I'm curious.

All done with an unmodified Debian Lenny, nilfs is version 2.04 (tools
2.06) and kernel is 2.6.26.

Comments welcome!

Regards,

Pierre Beck
