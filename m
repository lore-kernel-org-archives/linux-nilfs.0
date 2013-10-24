From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Thu, 24 Oct 2013 23:57:27 +0400
Message-ID: <B40AD6B8-5EB1-4F64-9224-2F684AE3DF8A@dubeyko.com>
References: <52695704.3010507@intellitree.com> <76524A8B-8063-4335-9B26-615417123CDE@dubeyko.com> <52696F86.70203@intellitree.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=xyP445cLMP6yJGPUhZiJKCB5D8JZw4l3uVyAjISlMTw=;
	b=QjSucBKZEWsi0LX+PnBIF1zGP2PWr0P47eSf0lXkg1pHh05lFraXtKCQoHGM5GAXeSf7WYCwuCajl30y+o/TeACQsB4ni5d9nPhxc0feDCVh7Htfpe8Rf7POUgs8AaAw;
In-Reply-To: <52696F86.70203-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Oct 24, 2013, at 11:05 PM, Michael Conrad wrote:

> 
> System 1:
> 
> 
> uname -a
>  Linux mlcdev 3.2.12-gentoo #10 SMP Fri Oct 18 22:00:41 UTC 2013 i686 Intel(R) Xeon(R) CPU           X3220  @ 2.40GHz GenuineIntel GNU/Linux
> 
> mount.nilfs2 -V
>  mount.nilfs2 (nilfs-utils 2.1.5)
> 
> System 2:
> 
> uname -a
>  Linux conserv 3.10.7-gentoo-r1 #1 SMP Wed Oct 23 18:50:52 EDT 2013 i686 Intel(R) Core(TM)2 Quad CPU Q8300 @ 2.50GHz GenuineIntel GNU/Linux
> 

What do you mean when you are talking about two systems?
Do you have two systems are working in parallel with one NILFS2 partition?
What is your configuration?

> mount.nilfs2 -V
>  mount.nilfs2 (nilfs-utils 2.1.5)
> 
> These are both 32-bit systems, running kernels from "gentoo-sources" (which are mostly vanilla).
> 
> My steps were very simple:
> 
>  mkfs -t nilfs2 -L SNAPSHOT /dev/sdb4
>  mount /dev/sdb4 /mnt/a
>  mount /dev/sdb4 /mnt/b
> 
> Mount.nilfs2 reports the error, but the filesystem gets mounted twice in rw mode.
> 

All works fine on my side with one system. I think that I misunderstand your environment, currently.

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
