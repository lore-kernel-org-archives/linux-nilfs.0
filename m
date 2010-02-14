From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: crash
Date: Sun, 14 Feb 2010 16:34:01 +0900
Message-ID: <c4a7c9421002132334j3275ed0ched3b3502877182e6@mail.gmail.com>
References: <20100210.130700.55835591.ryusuke@osrg.net>
	 <ee5afd761002092314i1ba1ec66ie6fe7d0f22d6927e@mail.gmail.com>
	 <ee5afd761002092326k3bb3a74fq7145cdb9925d88d5@mail.gmail.com>
	 <20100211.143001.184824921.ryusuke@osrg.net>
	 <ee5afd761002110943y1ca061bdi610de2f1a5df3c32@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:received:in-reply-to
         :references:date:x-google-sender-auth:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        bh=pGIKumLf6Kkat0hCY4a3HbKI7fefZa+25YfhB+28WSc=;
        b=IKt8xKHmrKQRL1wOSBsMR7vOQVC2bjZMUawpJnzgNTR8JaacRpWcv1JI6fDlvoIOw/
         SyaKuv14EFvnFnOJeJ3ooUhdRRcKJQOlbTo09y2RCASGd9RnEmkNpdRGTbPXbogAgwFZ
         B2WTlXSZbXf8YP4bC2O+aXKSc+GaJYi9GeKBE=
In-Reply-To: <ee5afd761002110943y1ca061bdi610de2f1a5df3c32-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
2010/2/12 Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pliny the Elder (ad 23=9679): =91Semper aliquid novi Africam adferre
> [Africa always brings [us] something new]=92
>
> Hallo,
> something is not quite right between the git repository and my git ma=
ster copy
> somehow the patches dont update the local copy with git am
> I have to extract the patch and apply with 'patch -l' (Match =A0patte=
rns
> =A0loosely, in case tabs or spaces have been munged in your files.)
> Which then has other complications like finding the wrong spot in
> super.c for one patch, so that hunk was then rejected and had to be
> done by hand.
>
>
> On the crash:
> My initial idea was quite wrong. Something went amiss somewhere in th=
e
> middle of nowhere.
> It might be cleanerd connected, but I cannot say for sure.
>
> See the attached .tgz for details of my post mortem effort. If more
> data is needed please say so.
>
> Regards,
>
> Jan de Kruyf.

Thank you for the detail report.

According to your log, many tiny checkpoints were created
around 2010-02-09 20:30:01 ~ 2010-02-09 20:31:00.

I saw the dump data of the segment 343 to see the logs having checkpoin=
ts
on "20:30:01", but they looked normal to me.

The series of checkpoints after 1844624 seems to need care as you say.

             1844624  2010-02-09 20:30:59   cp    -         55      166=
21
             1844625  2010-02-09 20:30:59   cp    -         33      166=
21
             1844626  2010-02-09 20:30:59   cp    -         33      166=
21
             1844627  2010-02-09 20:30:59   cp    -         34      166=
21
             1844628  2010-02-09 20:30:59   cp    -         33      166=
21
             1844629  2010-02-09 20:30:59   cp    -         33      166=
21
             1844630  2010-02-09 20:30:59   cp    -         33      166=
21

But, it was not included in the segment 343 but in the segment 344.

Checkpoints can be created when application performs synchronous writes
(e.g. fsync or OSYNC writes).

So, we needs an additional dumpseg data to confirm if it's normal or no=
t.

Can you still take out the dump ?

In addition, I think "ls -laiR" for the var directory would be helpful =
because
it prints inode numbers along with file names.

Thanks in advance,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
