From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Thu, 24 Oct 2013 16:01:15 -0400
Message-ID: <52697C8B.3090407@intellitree.com>
References: <52695704.3010507@intellitree.com> <76524A8B-8063-4335-9B26-615417123CDE@dubeyko.com> <52696F86.70203@intellitree.com> <B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/24/2013 3:57 PM, Vyacheslav Dubeyko wrote:
> What do you mean when you are talking about two systems?
> Do you have two systems are working in parallel with one NILFS2 partition?
> What is your configuration?

Separate systems.  Each has 2 SATA disks (a main drive, and a second for 
backups).  These are test/development servers I use, and running regular 
consumer hardware.  I added a second drive to each just to experiment 
with NILFS.  (BTW, I had problems when running NILFS on a loopback 
device on System 1.  I can investigate that further later.)

I tried NILFS on System 1 a few days ago, and ran into the problem. I 
decided to try a newer kernel, but tried from scratch on System 2 
instead of upgrading System 1.  The only thing they have in common is 
that they are gentoo-based and 32-bit.  They have very different 
hardware and very different kernel configs.

The double-mount should be prevented at the kernel level, right?  I 
could try a linux version direct from kernel.org, next.

If the double-mount should be prevented in user-space, then I could 
check things like the libc, compiler, strace, etc.

Which would you like next?

-Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
