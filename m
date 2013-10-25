From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Fri, 25 Oct 2013 12:26:10 -0400
Message-ID: <526A9BA2.7010202@intellitree.com>
References: <52696F86.70203@intellitree.com>	<B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A@dubeyko.com>	<52697C8B.3090407@intellitree.com> <20131025.103819.27810920.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131025.103819.27810920.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/24/2013 9:38 PM, Ryusuke Konishi wrote:
>> The double-mount should be prevented at the kernel level, right?  I
>> could try a linux version direct from kernel.org, next.
>>
>> If the double-mount should be prevented in user-space, then I could
>> check things like the libc, compiler, strace, etc.
> The double-mount check is done in user-space to avoid that two garbage
> collectors run on the same device.  Actually, nilfs kernel module
> itself can have two writable mounts.
>
> Nilfs-utils has two separate mount programs.  One is the version
> using libmount library (nilfs-utils/sbin/mount/mount_libmount.c)
> and another is prior mount program (nilfs-utils/sbin/mount/mount.c).
>
> Recent distros use the former program because the prior mount program
> does not work when /etc/mtab is a symbolic link to /proc/mounts.

Ah-ha!  Both systems use a symlink.  On System 1, I compiled nilfs-tools 
in a chroot so I could link them statically with recent library 
versions, then installed the static binaries.  Your configure script 
would not have been able to see the /etc/mtab symlink.

However, System 2 had recent libraries and I was able to "emerge 
nilfs-tools" normally.  However, that Gentoo ebuild was marked 
experimental, so maybe they know of the problem.  I'll investigate which 
source file was used for mount.nilfs2

Thanks for the information!

-Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
