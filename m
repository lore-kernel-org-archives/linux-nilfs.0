From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Fri, 25 Oct 2013 10:54:19 +0900 (JST)
Message-ID: <20131025.105419.207535004.konishi.ryusuke@lab.ntt.co.jp>
References: <B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A@dubeyko.com>
	<52697C8B.3090407@intellitree.com>
	<20131025.103819.27810920.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131025.103819.27810920.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 25 Oct 2013 10:38:19 +0900 (JST), Ryusuke Konishi wrote:
> Nilfs-utils has two separate mount programs.  One is the version
> using libmount library (nilfs-utils/sbin/mount/mount_libmount.c)
> and another is prior mount program (nilfs-utils/sbin/mount/mount.c).

I suspect this is the reason why the issue isn't reproduced in
Vyacheslav's environment.
 
> Recent distros use the former program because the prior mount program
> does not work when /etc/mtab is a symbolic link to /proc/mounts.
> 
> How does /etc/mtab in your environment look like ?
> 
> If /etc/mtab is a symblink link or "gcpid" option doesn't appear in
> it, your mount program is the libmount version.

If this is true, the issue seems to be a bug of mount_libmount.c.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
