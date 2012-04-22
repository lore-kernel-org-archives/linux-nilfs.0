From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS development contribution
Date: Sun, 22 Apr 2012 18:15:04 +0900 (JST)
Message-ID: <20120422.181504.62372140.konishi.ryusuke@lab.ntt.co.jp>
References: <CABECqUEGCxizjgZPWUazTJBZYWTUTCQnbieDSaSUMj8oGeMnEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABECqUEGCxizjgZPWUazTJBZYWTUTCQnbieDSaSUMj8oGeMnEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 18 Apr 2012 16:35:28 +0530, santhosh kumars wrote:
> Hi,
> I have gone through the documents of NILFS mentioned on the home page
> of NILFS. I have interest in file system development and have some
> background knowledge about the linux VFS layer and have also created a
> sample memory based file system which resides only in the memory. In
> one of the slides "Development of a New Logstructured File System for
> Linux", there is a mention to involve outside developers in the
> project as well. I too want to contribute in the development of nilfs
> so I wanted to know where can I start from to get involved in the
> project.can any one help me for  to get start please.
> 
> Thanks,
> karuanakar.

Sorry for my late reply. I was quite busy this week.


Contribution to our project is of course welcome.

NILFS is now a part of the Linux kernel, and is developed using public
git trees and the linux-nilfs mailing list.  I am taking in function
enhancement as well as bug fixes which outside developers sent to me,
simlilarly with usual Linux/OSS development.

My recommendation for starting to get involved in the project is to
utilize github; both userland utilities and nilfs branch of kernel
tree are maintained there.

This project has many todo items, which is listed in lower part of
http://www.nilfs.org/en/current_status.html

My recent concern is improving garbage collection algorithm and I/O
performance of in-kernel filesystem module.

What is necessary is just to do your favorite or possible thing,
however, if you can provide help to these priorities, I would
appreciate it :)


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
