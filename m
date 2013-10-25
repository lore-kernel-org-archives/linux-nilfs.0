From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Fri, 25 Oct 2013 10:38:19 +0900 (JST)
Message-ID: <20131025.103819.27810920.konishi.ryusuke@lab.ntt.co.jp>
References: <52696F86.70203@intellitree.com>
	<B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A@dubeyko.com>
	<52697C8B.3090407@intellitree.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52697C8B.3090407-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> The double-mount should be prevented at the kernel level, right?  I
> could try a linux version direct from kernel.org, next.
> 
> If the double-mount should be prevented in user-space, then I could
> check things like the libc, compiler, strace, etc.

The double-mount check is done in user-space to avoid that two garbage
collectors run on the same device.  Actually, nilfs kernel module
itself can have two writable mounts.

Nilfs-utils has two separate mount programs.  One is the version
using libmount library (nilfs-utils/sbin/mount/mount_libmount.c)
and another is prior mount program (nilfs-utils/sbin/mount/mount.c).

Recent distros use the former program because the prior mount program
does not work when /etc/mtab is a symbolic link to /proc/mounts.

How does /etc/mtab in your environment look like ?

If /etc/mtab is a symblink link or "gcpid" option doesn't appear in
it, your mount program is the libmount version.


Regards,
Ryusuke Konishi


On Thu, 24 Oct 2013 16:01:15 -0400, Michael Conrad wrote:
> On 10/24/2013 3:57 PM, Vyacheslav Dubeyko wrote:
>> What do you mean when you are talking about two systems?
>> Do you have two systems are working in parallel with one NILFS2
>> partition?
>> What is your configuration?
> 
> Separate systems.  Each has 2 SATA disks (a main drive, and a second
> for backups).  These are test/development servers I use, and running
> regular consumer hardware.  I added a second drive to each just to
> experiment with NILFS.  (BTW, I had problems when running NILFS on a
> loopback device on System 1.  I can investigate that further later.)
> 
> I tried NILFS on System 1 a few days ago, and ran into the problem. I
> decided to try a newer kernel, but tried from scratch on System 2
> instead of upgrading System 1.  The only thing they have in common is
> that they are gentoo-based and 32-bit.  They have very different
> hardware and very different kernel configs.
> 
> The double-mount should be prevented at the kernel level, right?  I
> could try a linux version direct from kernel.org, next.
> 
> If the double-mount should be prevented in user-space, then I could
> check things like the libc, compiler, strace, etc.
> 
> Which would you like next?
> 
> -Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
