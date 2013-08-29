From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Thu, 29 Aug 2013 19:37:32 -0400
Message-ID: <CALJXSJpbHN2SQWz0e2gC_hrRKG8EcnV2bWf068GWsuoa8AX5Dw@mail.gmail.com>
References: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
	<1376054125.2272.84.camel@slavad-ubuntu>
	<20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp>
	<20130816.134934.27810145.konishi.ryusuke@lab.ntt.co.jp>
	<1376636610.2301.28.camel@slavad-ubuntu>
	<72C60256-983E-43D0-9DA1-D4A446B578BB@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=KoLdq7ptRvc4mpKUBWk9wnavpcHTAGS5UhVTnodqiHY=;
        b=PbFSvqegdoflO+ma8QJJCavFyCMcI8wFujJia4+qy+L1g89WZ8Vzf+OXfddqbqUAet
         VhKSCiSJiEcyaJ6YT7tJdcYehEZQxAyGhbwxu0dP/tK7F2OrKpu4SAO2WnD/WK1kXZ+r
         +4RHwDim/SkhIapR6MF0MThPxJPlW+h51++8315p5WEyWkOb8XxeTNWBzOGn1DkwgYM4
         yUbxZfoKwwZJu4ogKp5hDSR/AuiC0Wq8B3n7prsuAcAbQBqGBNwUq+QAVgQjnIUpbl9S
         eFwjtVqusLMRBWbZ4nHSO02bRydfApIOpW9i7flYP0hx5gXwu7yk8w7VUodj1XsPFt1C
         Lqqw==
In-Reply-To: <72C60256-983E-43D0-9DA1-D4A446B578BB-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Aug 29, 2013 at 3:10 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> I need to check independently some my suspicions about the issue. So, I need in additional details.
>
> Did you have any mounted ext4/ext3 partitions in the background of the reproduced issue?

I had /boot as ext3 mounted all that time but completely unused until
we started diagnosing the logs.

>
> Could you check that you can reproduce the issue in the case of absence any mounted
> ext4/ext3 partitions?
>

Would you like me to try with /boot umounted?

> Could you check also that you can reproduce the issue for 3.2 or earlier kernel version?

That would be harder to test but possible.


I have a bigger issue though. Right now I'm running in the problem
that the cleaner won't work anymore and partition is full. I migrated
to ext4 until I decide making a new nilfs2 partition, I'm not sure
I'll be able to reproduce the problem on a full FS, I could resize it
a bit though.

Link to this problem:
http://permalink.gmane.org/gmane.comp.file-systems.nilfs.user/3072
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
