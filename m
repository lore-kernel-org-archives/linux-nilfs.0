From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: an irritating problem and possible source of quiet data loss
Date: Tue, 23 Aug 2011 13:29:15 +0900 (JST)
Message-ID: <20110823.132915.20107862.ryusuke@osrg.net>
References: <201108171207.22032.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108171207.22032.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 17 Aug 2011 12:07:21 +0000, dexen deVries wrote:
> Hi,
> 
> theres' that irritating problem that two files on the same device
> and with same pathname -- but different content -- can have same
> inode number on NILFS2. It really can screw automated and manual
> backup/restore. Best of all, it seems to be against POSIX. Actually,
> two `versions' of the same file.
> 
> Today I wanted to revert a config file to certain older version:
> 
> (/dev/sda3 is the current root filesystem)
> 
> # chcp ss /dev/sda3 7591068
> # mount /dev/sda3 /mnt/x -o ro,cp=7591068
> # diff -burN /etc/adjtime  /mnt/x/etc/adjtime | diffstat
>  adjtime |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> so far so good. However!
> 
> # cp etc/adjtime /etc
> cp: `etc/adjtime' and `/etc/adjtime' are the same file
> 
> and it did /not/ copy the original version over the new file.
> 
> 
> The thing is, till recently the `diff' would also (errorously!) not
> report difference between those two files, because it relied on
> comparing device and inode numbers. If those matched, the files must
> be the same file. Just like pointer equality in C programming
> language: if two objects are located at the same address (pointer
> equality), they are the same object.

Yes, this is a known and essential problem of the snapshot mounts in nilfs.

> MVFS (a ClearCase thingie) and NILFS2 break that; diff now contains special 
> workaround because of MVFS. But some other utilities do not.
> 
> From diff's sources:
> > POSIX says that two files are identical if st_ino and st_dev are
> > the same, but many file systems incorrectly assign the same (device,
> > inode) pair to two distinct files, including:
> > 
> > ((short list: Linux NFS, Network Appliance NFS, MVFS)) 
> 
> Please consider fixing that: either report different inode numbers on mounted 
> snapshots, or use different device numbers for mounted snapshots. The later 
> could make more sense -- a snapshot of filesystem is a much different entity 
> than the current state -- and also could be way easier to implement in kernel 
> without changing filesystem format.

Some filesystem uses anonymous block device to avoid this issue, but
the number of anonymous devices is limited to 127 per system.

We often make concurrent snapshot mounts whose total number is larger
than this.  A compromise for this issue is adding mount option which
switches reusing the original block ID or assigning a new block ID for
snapshot mounts.

-- I don't know if we can actually do this, but I agree that it is a
problem to be handled in some way.

> Before any fix is ready, a manual workaround is possible, by using loop device:
> 
> coil!root!/mnt # losetup -f -v /dev/sda3
> Loop device is /dev/loop0
> coil!root!/mnt # mount /dev/loop0 /mnt/x -o cp=7591068,ro
> (now /dev/loop0 mounted at /mnt/x has different device ID than the root 
> filesystem at /dev/sda3)
> coil!root!~ # cp /mnt/x/etc/adjtime /etc/adjtime 
> 
> (worked!)

Thanks for reporting the workaround.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
