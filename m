From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Getting involved
Date: Sun, 12 Apr 2009 20:30:29 +0900
Message-ID: <c4a7c9420904120430k29bf577era97c435b536e7469@mail.gmail.com>
References: <3D6C1CDC-0C3B-4CB3-95B1-F36AB3114033@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3D6C1CDC-0C3B-4CB3-95B1-F36AB3114033-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi!
2009/4/12 Matteo Latini <mtylty-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi all,
> I just discovered nilfs and I was wondering if there is some
> way of getting involved in developing some code...
>
> thx,
> Matteo Latini

Thanks.  Any contribution is welcome.

If you are interested in developing NILFS,
please toy the source code.

It's available from the following site with git:

  http://www.nilfs.org/git/

I'm also preparing for a repository of in-tree code in kernel.org.
Until it gets available, Linus' tree is a quick reference.

  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

I'm now concentrating on bug hunting toward release of kernel 2.6.30,
but I feel new feature development should be driven for later versions.

At least, we have following todo items
(these are listed in the current status page of our project),

> * Checkpoint based remote replication
> * Performance improvement (Better Block I/O submission)
> * atime support
> * Optimization for silicon disks (e.g. SSD)
> * fsck
> * Faster inode allocation
> * Online resizing
> * Online defrag
> * filesystem freeze support
> * Variety of Garbage Collection policies
> * Design document and better developer support
> * Better support of fsync, mmap, and direct I/O.
> * Filesystem label support
> * More backup copies of the super block
> * Time-machine like browser extension (or Time slider)

and we also need distro support;  for example, Ubuntu or Fedora
doesn't have good nilfs support though it's well supported in Debian.

Documentation is another important problem.
I'm not a native English writer, so all texts including comments,
manpages, readme file have much room for improvement.

If someone refine our manpages in util-package,  I will take it in
pretty certainly   ;)

Let's take it easy.

Regards,
Ryusuke Konishi
