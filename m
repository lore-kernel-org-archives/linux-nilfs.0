From: butt3rflyh4ck <butterflyhuangxx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [vs-plain] KASAN: use-after-free in nilfs_mdt_destroy
Date: Tue, 16 Aug 2022 15:46:04 +0800
Message-ID: <CAFcO6XN-m2VvV0FCLGBSiTLKZ0mj_WESqz=ZVPWdpmECJuv-+w@mail.gmail.com>
References: <34e8df4a.848e1.182a1264256.Coremail.stitch@zju.edu.cn> <8C0C088A-11A4-4D0E-93B9-CA70F0040341@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=8Yukm6IoZYfpPJpaCKSecWUw9Ym3RfYDxea1L/nbqQA=;
        b=foDsXYEoPlUb/3s0pJVmWr41mvJxNdCtFj7cxcOA7+TD/0UNLGuSQIV1pNK8wlnMln
         qzpvPrU9YFagd52yAdTnFRvLQuRY9JesFOixMtNJcVs38Y5U2urxcG9E0OszpJEt+4lY
         83b9MuU1dOq/9s5t5kATCmD2vSTvoNyjWof+fRLmJLO6KzB+C5qN2e1hENirub8KcRun
         ZVFDMtOnqrAczuor6FCsyzsb6cgNiLwjYB++BJZvp3xizVGiDzjNWJl52J8PlSb1wleg
         ahH/AU+U2a1qKMJJQQRmZI9SZkVV3arUNWzZDJfDijiIaRwKFjusRiufV6ZLMzOxPIHr
         VTMw==
In-Reply-To: <8C0C088A-11A4-4D0E-93B9-CA70F0040341-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?B?6K645ZiJ6K+a?= <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, "security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org" <linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org>, "konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi, there is a patch for this issue.
https://lore.kernel.org/linux-fsdevel/20220816040859.659129-1-dzm91-m1nqm0VisMk@public.gmane.org=
u.cn/T/#u


On Tue, Aug 16, 2022 at 3:36 PM John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>
>
> > On 15 Aug 2022, at 11:56, =E8=AE=B8=E5=98=89=E8=AF=9A <stitch-Y5EWUtBUdg7F11Dp+j+f1g@public.gmane.org=
n> wrote:
> >
> > Hi developers,
> >
> > We may found a flaw in the fs module which can lead to UAF write or DoS=
.
> > We would appreciate a CVE ID if this is a security issue.
> >
>
> Confirming that your message made it through to linux-distros, but you ha=
ven't mentioned a date when this would be made public.  However,
>
> > Someone found the similar problem: https://groups.google.com/g/syzkalle=
r-bugs/c/z2WroC3_BSw.
> >
> > Fix this bug by moving the assignment of inode->i_private before securi=
ty_inode_alloc.
>
> There's already a public discussion about that and if, indeed, that's the=
 same bug then you should take this to oss-security as simply a rediscovery=
 of an existing bug.
>
> I'll leave it to Red Hat to decide whether to allocate a CVE number for t=
his issue. It needs significant privileges to exploit it; the only real que=
stion is whether you could use those privileges to crash the machine anyway=
.
>
> jch
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller/8C0C088A-11A4-4D0E-93B9-CA70F0040341%40oracle.com.



--=20
Active Defense Lab of Venustech
