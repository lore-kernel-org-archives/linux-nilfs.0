From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is it possible to restore the state of a nilfs2 partition after
 deleting files?
Date: Sat, 27 May 2023 01:52:39 +0900
Message-ID: <CAKFNMok+C43Y1jCzyP-iUXB3rV_X60aui7J4aaa1rK6-ZtCcnw@mail.gmail.com>
References: <20230525151838.GA5174@debian64>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685119976; x=1687711976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzVX/dRsBr5sMa8u/NKVlw4EJ4PLR20vgYyRYRJxLiY=;
        b=q4MBFpATEPmly2PzO/jnwWBqvdtvMH0m3x4+NPSh0Te+PcGcswVLwChsupBVDJx6Ee
         HsIiVoLhpfb7CjSc23aobzZ1p5G0TR62JLokUv0bTuGUhFfjaClwpYv3MBhSPYWTmVw9
         9GKpnjmwxeUvTD2spTjR9c+CeYd0dwiUixy4NCC73EDl3mXjFBZ8WBGrf0lGWlxolO3U
         PhAXNzs/6Xa/FA2Ou1RRfsQSLm3TxNnPKhIJIDzhAclDdwFDr6cEJB9XMHrS4d+8IrFP
         Hq3WDy2dSRf2Z73yY5A7X6uVGbEKq9ttJnpCVMrdqnOSplk/w2j7RSsqBMmFoCQ8Qp/1
         kJxg==
In-Reply-To: <20230525151838.GA5174@debian64>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Frank Schwidom <schwidom-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 26, 2023 at 12:37=E2=80=AFAM Frank Schwidom wrote:
>
> Hi,
>
> is it anyhow possible to set the state of a nilfs2 partition to the lates=
t
> checkpoint or snapshot?

Unfortunately there is no special command to do that easily.

Instead, since NILFS can mount the current tree at the same time as
the snapshot, it is common to mount them on two directories at the
same time and write back part or all of the snapshot to the current
tree using rsync or so.

If you're expecting native filesystem functionality, sorry for the
inconvenience, but the answer is no.

Regards,
Ryusuke Konishi

>
> (I am using nilfs-tools 2.2.7-1 on
> Linux debian64 5.10.0-0.deb10.16-amd64 #1 SMP Debian 5.10.127-2~bpo10+1 (=
2022-07-28) x86_64 GNU/Linux)
>
> Thanks in advance,
> Frank
