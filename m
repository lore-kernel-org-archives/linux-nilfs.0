From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: couldn't mount because of unsupported optional features (477e7ad1e859f753)
Date: Thu, 30 Dec 2021 12:00:33 +0000
Message-ID: <25037.40801.808565.662504@cyme.ty.sabi.co.uk>
References: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:References:In-Reply-To:Subject:To:
        Date:Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OqfxSnE34cCa6rzncHoYPxmUtQMKd5EINhfIEla3Z2U=; b=QoC+IaGsW0/Ae3LrXvPtYB4GQl
        967M1rRA3aA+pnidiKccRlsrtyMg+VhAZ9HXGeSxRXd8MTeKycasUbSqFNEq8oQgIkbHD7wmHtHjy
        MVNYRhHEteU4cHjSn3O384rZ6D/fSVQOU7gWWeOMmaZ9mY+9VawXGZB6EYcC6fTrsO/ONLhpFUP+h
        JYc/Ncok/EHIxolw1W6VxmfGxdWS4+4inHp4nYvEOzecS2lgp4Y/PlDhZl2juyrZGlichfN0gbCDv
        OahXzOoCOzM6fQFWQHcpa3M6SShgoeORXNkEw+ikjgoykD4Tmb3F3ccNYiKseaLi44N2zC6tdw7mU
In-Reply-To: <39575f5e-b47a-d971-6c15-35985a35c9d5-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> Trying to mount a NILFS partition

To be pedantic, but it matters, it is "block device" in UNIX-like
systems, and more "NILFS2 instance", as here could be multiple
NILFS2 instances even in a single block device (but that is a
very rare setup usually requiring 'losetup' mounts).

> fails with "couldn't mount because of unsupported optional
> features (477e7ad1e859f753)". [...]

That does not look a lucky situation. You can use 'lscp
/dev/...'  to list the checkpoints and try to mount an older
checkpoint with 'mount -t nilfs2 -o cp=... /dev/... ...' to
mount it and resume work from that. In theory older checkpoints
will be fully consistent even if the latest one is corrupted.

Unless that  message means that the NILFS2 instance is corrupted
because of "issues" (usually hardware, most common with block
devices on USB storage devices).
