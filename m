From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs compilation errors
Date: Mon, 30 Apr 2012 22:37:28 +0900 (JST)
Message-ID: <20120430.223728.112841635.konishi.ryusuke@lab.ntt.co.jp>
References: <CAGS5fSyvGmPexvi92oaTjXeATOSaxj9XRA+Liih7uWGUjFKODg@mail.gmail.com>
	<CAGS5fSzREKF5QGKMUWwZ9RXhY==STpDkm-aDF9_0L8oNoJ7VPg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGS5fSzREKF5QGKMUWwZ9RXhY==STpDkm-aDF9_0L8oNoJ7VPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: shubham20006-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 30 Apr 2012 16:49:12 +0530, shubham sharma wrote:
> Hi,
> 
> I am trying to compile the nilfs sources on Ubuntu but it is giving
> compilation errors.
> 
> My kernel version is
> 
> ----8<----
> shubham@shubham-VirtualBox:~/work/nilfs/git_repo/nilfs2-module$ uname -r
> 3.0.0-12-generic
> ----8<----
> 
> I got the nilfs sources from the git repository:
> 
> ----8<----
> shubham@shubham-VirtualBox:~/work/nilfs$ git clone
> git://github.com/nilfs-dev/nilfs2-module.git
> ----8<----
> 
> After getting the sources, i tried to compile the sources but i am
> getting the following compilation errors:
> 
> ----8<----
<snip>
> ----8<----
> 
> Is there any step that I am missing before compiling the code?

The nilfs2-module.git is the source tree of old module for kernels between
2.6.18~2.6.29.

This tree is maintained for CentOS5 and other RHEL5 clone users, and
lacks support of new features such as online-resizing.

You have no reason to use it for other newer Linux ditros.

Try in-kernel nilfs2 module.  The nilfs2 module in 3.0 kernel is
nearly the latest, and its latest successor version (i.e. 3.0.x)
includes important bugfixes backported from newer kernels.

Regards,
Ryusuke Konishi
 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
