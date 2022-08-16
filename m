From: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [vs] KASAN: use-after-free in nilfs_mdt_destroy
Date: Tue, 16 Aug 2022 10:35:00 +0200
Message-ID: <CAKXUXMy94SkUA9jU69H9Mdkzo4gui+3kTc2YoqaeoXmCHYKzGA@mail.gmail.com>
References: <34e8df4a.848e1.182a1264256.Coremail.stitch@zju.edu.cn> <Yvovz7FKlHLNpNaf@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=FMUX1ca5qhsOzjLJCdGy9/aUl/PcngAKP1Q59U2m9jw=;
        b=n/tVJwbfPpK8pmRi/mUkTlRYcBg3snZ+3io5/uWNXWWIsGMarWtT4bwSp78kaRbEeO
         0PEuc1pZiXvOpJSDn5GzVdtKYn9GLS7OgNFuTBCIHkGO4BImoS6Pc78burXmiZFPjjaq
         /V4u5urQLJBJECSZnZP3kyksl7wAZliXNThFwtO85aUazaAN9TZP1KUPRLDOpO+oLdWG
         OW+MTPl+h3JiMT3MEzILafl0FK2HBVvwTR7RLkAzTFiTApjInCKKO6leEfBLsDKyBsN0
         6fX4R2buiWqkbcxKwvmMjv18D0ZXtn9c48AMiC5tSPqbR+NZNWd7x2BsWeNgxC6KMOlk
         MQow==
In-Reply-To: <Yvovz7FKlHLNpNaf-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: =?UTF-8?B?6K645ZiJ6K+a?= <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 15, 2022 at 1:36 PM Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
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

Hi all,

this email was sent to security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, where the emails are
supposed to remain undisclosed in a private email list with curated
participants, but it was also sent to the public mailing lists
syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org and linux-nilfs-u79uwXL29TaiAVqoAR/hOA@public.gmane.org So the
whole communication is already public and disclosed. I guess there are
really no measures needed now for anyone to keep anything further
"secret due to security" and all efforts can be simply put in
understanding the reported issue, the known patch and the next steps
in the usual public channels.

Just to add to Greg's advice, it was public from the beginning, so
there really was not the need to have security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org in the loop.

I would like to understand which statements in the kernel's patch
submission guidelines got you to report to security-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org Can
you point to those parts of the documentation? Then, we can think
about how to improve those and see if that improvement helps others
avoid such potential process issues in the future.


Best regards,

Lukas
