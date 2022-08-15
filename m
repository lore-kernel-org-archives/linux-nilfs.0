From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [vs] KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 15 Aug 2022 22:54:12 +0900
Message-ID: <CAKFNMonPnmC+q3JUyNtL0dkMtTv2EOD4fy45SKfBoQo_J_-ySA@mail.gmail.com>
References: <34e8df4a.848e1.182a1264256.Coremail.stitch@zju.edu.cn> <Yvovz7FKlHLNpNaf@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=86Hytperb3E14EJa5HiVkGPyx/1oPSgRX5LsRpbwPDs=;
        b=IIAM/+vlwipei5CDmjCVcQsUoSF1bpzVXM/f84xCDhUylP+1vHQ4aI98LSLhvgZYjD
         eGSxhaBUUdI43CXcenwmjFGmAnbKiWverCYgRjfMw3JKyvf5DJvxLqqzcFkHG/0ZiU8H
         A3pejU8G0E0Xs71BLA8w8dvoB0vTYbMBEy8AOAp0eU/6vUxFwS5N17KmX0cbYRa6T1dJ
         ellsod+xWpwk+bLoDG96N0+3cO3Iam3//o8FNWqbU/q9aC9tBvdLXvF4IBZ+CPY4go/3
         ph+v5hWbaLmiiFnNW+eXZ+XxVn3nsMxcO4XEWot+2/pRNBVbpaTD3o0hCqhAMPCbrgoG
         Jvrw==
In-Reply-To: <Yvovz7FKlHLNpNaf-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?6K645ZiJ6K+a?= <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

> And again, as this is public, why notify us and not just work to solve
> this in public with the developers involved?
>
> thanks,

Thank you for reporting.

This looks like a nilfs2 specific bug rather than a vfs problem.
I'd like to send a patch that fixes this on the nilfs2 side.

Thanks,
Ryusuke Konishi

On Mon, Aug 15, 2022 at 8:36 PM Greg KH wrote:
>
> On Mon, Aug 15, 2022 at 06:56:55PM +0800, =E8=AE=B8=E5=98=89=E8=AF=9A wro=
te:
> > Hi developers,
> >
> > We may found a flaw in the fs module which can lead to UAF write or DoS=
.
> > We would appreciate a CVE ID if this is a security issue.
>
> As our documentation states, us at security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org do not assign
> CVEs or deal with them at all.
>
> >
> > HEAD commit: 3d7cb6b04c3f Linux-5.19
> > git tree: upstream
> > console output:https://drive.google.com/file/d/1PoH9PUdMilsrKtq1oGHu_sh=
M3dggNFAB/view?usp=3Dsharing
> > kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysST=
fWFpfXYkG/view?usp=3Dsharing
> > syz repro: https://drive.google.com/file/d/19N1Xh8TVoSUr_2J8j-bWXktL21S=
vRx_9/view?usp=3Dsharing
> > C reproducer: https://drive.google.com/file/d/1R1rYseY7JBDCSfLAP4pjSCoM=
Vgkr7l5b/view?usp=3Dsharing
> >
> > Description
> > In alloc_inode, inode_init_always could return -NOMEM if
> > security_inode_alloc fails. In its error handling, i_callback and
> > nilfs_free_inode will be called. However, because inode->i_private is
> > not initialized due to the failure of security_inode_alloc, the functio=
n
> > nilfs_is_metadata_file_inode can return true and nilfs_mdt_destroy will
> >
> >
> > be executed to lead to GPF bug.
> >
> >
> >
> >
> > Someone found the similar problem: https://groups.google.com/g/syzkalle=
r-bugs/c/z2WroC3_BSw.
>
> Great, can you work on this in public on that thread then?  Have you
> tested the proposed patch that is provided there to see if it solves it
> or not?
>
> > Fix this bug by moving the assignment of inode->i_private before securi=
ty_inode_alloc.
>
> That's what the existing patch looks to do, does that work?
>
> And again, as this is public, why notify us and not just work to solve
> this in public with the developers involved?
>
> thanks,
>
> greg k-h
