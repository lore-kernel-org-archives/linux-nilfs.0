From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Sat, 22 Jun 2013 20:37:54 +0200
Message-ID: <CAFvQSYTZfiNQv4==v+m5W+SMCfrxm6WmV8gwKC_+yaW1MBfdOQ@mail.gmail.com>
References: <51C0A731.9060509@student.tuwien.ac.at>
	<1371626223.2221.25.camel@slavad-ubuntu>
	<51C177A4.3030204@student.tuwien.ac.at>
	<2F76977A-589B-47EB-8818-382477099600@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=qKmxJ1zx8R70ClP6/ztb1gVKEQYKpiSdn2FKWjzP1JU=;
        b=NTp397E8nZi1nA0od4ZQFKkistP4y7DXaBixLRxj0+Uvq1VVYvjcffeSLa9KdHm9eU
         TZMR0mo5B3HxXlLTNjGbLyE1zX2KkLYlLxs1axPemp1hzp6T62V9H+vUed7qEfmwUrzG
         NFF1t1dI6C2SzLuE2xRkYCR1A0Jczkw80F3IMff/nM702ql2JU4V9fQBa2FkmrSQK+dm
         qQFOcclOKu0aAf0EFuNlL8YT7M2cPip+NQ6V4v0iorpTx4uHW8x1RYBCQeJ/hqgWi7ld
         ePnKAdeBnAmV3wQ1Oo2zkBbyXEMqJUhP9WkruO050sHiMNvK1des8JESX2/2Dx2EFFd1
         VG0Q==
In-Reply-To: <2F76977A-589B-47EB-8818-382477099600-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

> First of all, I am thinking now and I will think that defragmentation should be
> a part of GC activity. Usually, from my point of view, users choose NILFS2
> because of using flash storage (SSD and so on). So, GC is a consequence of
> log-structured nature of NILFS2. But it needs to think about flash aging, anyway.
> Because activity of GC or other auxiliary subsystems should take into account
> NAND flash wear-leveling. If activity of auxiliary subsystems will be significant
> then NAND flash will fail soon without any clear reasons from an user's
> viewpoint.

I have no idea of the actual implementation or the code, so my comment
just represents the POV of a fs-user.
I've tried Nilfs2 and Btrfs (both cow) on traditional mechanical
harddisks to get cheap, efficient snapshoting.
However, due to cow, files with high random-write activity (like
firefox's internal sqlite database) fragmented so heavily those
filesystems were practiacally unuseable on HDDs.

Btrfs actually offers both, manual defragmentation as well as an
autodefrag mount option - which is useful even for SSDs when the
average continous segment size becomes as low as 4kb.
While autodefrag would be great for nilfs2, a manual tool at least
wouldn't hurt ;)

Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
