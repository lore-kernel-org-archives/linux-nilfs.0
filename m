From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: {WHAT?} read checksum verification
Date: Wed, 12 Jul 2023 23:29:09 +0100
Message-ID: <25775.10549.41499.886957@petal.ty.sabi.co.uk>
References: <174f995c-e794-74c4-24d6-52451f3f3f28@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:References:In-Reply-To:Subject:To:
        Date:Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3noleI4cFJm1LhhKIDY7EYrlpTYYecpFopAnL7reDec=; b=Wr5Lh5dDSPSewi+jnNBwrxp8NR
        hszAHG1P4RgGlfm59tnhhw/xYvAbd6TTHzymDXIoauncZD2dFWSxkyAdh8RpxVJES5BGhpgvveLtc
        Z2EnWWwdt1yPHfuXr/np6MrXKOv8LP6HQvrIPEXX6eusOR28Y02w7FFdSNu5DUnbm9L5cFESInhAI
        GHLUAGbwmwKOcSgayuFf/5Sy3ZcnWH5PW+xNhgi6fvstBFw4D1HPjJ2u/1Yi8WHjd3qAgrTAG+Rm4
        wBCF+kEUIJERAjaXudG6ozMPnmOdN6WM0tB1mBjJl67SyXAd4D4GrGc9CTLmbrC6ydFL24CK5VkRB
In-Reply-To: <174f995c-e794-74c4-24d6-52451f3f3f28-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> I used NILFS over ISCSI. I had random block corruption during
> one week, silently destroying data until NILFS finally
> crashed. First of all, I thought about a NILFS bug, so I
> created a BTRFS volume

I use both for main filesystem and backup for "diversity", and I
value NILFS2 because it is very robust (I don't really use
either filesystems snapshotting features).

> and restored the backup from one week earlier to it. After
> minutes, the BTRFS volume gave checksum errors, so the
> culrprit was found, the ISCSI server.

There used to be a good argument that checksumming (or
compressing) data should be end-to-end and checksumming (or
compressing) in the filesystem is a bit too much, but when LOGFS
and NILFS/nILFS2 were designed I guess CPUs were too slow to
checksum everything. Even excellent recent filesystems like F2FS
don't do data integrity checking for various reasons though.

In theory your iSCSI or its host-adapter should have told you
about errors... Many can enable after-write verification (even
if its quite expensive). Alternatively some people run regularly
silent-corruption detecting daemons if their hardware does not
report corruption or it escapes the relevant checks for various
reasons:

https://indico.desy.de/event/257/contributions/58082/attachments/37574/46878/kelemen-2007-HEPiX-Silent_Corruptions.pdf
https://storagemojo.com/2007/09/19/cerns-data-corruption-research/

> [...] NILFS creates checksums on block writes. It would really
> be a good addition to verify these checksums on read [...]

It would be interesting to have data integrity checking or
compression in NILFS2, and log-structured filesystem makes that
easier (Btrfs code is rather complex instead), but modifying
mature and stable filesystems is a risky thing...

My understanding is that these checksums are not quite suitable
for data integrity checks but are designed for log-sequence
recovery, a bit like journal checksums for journal-based
filesystems.

https://www.spinics.net/lists/linux-nilfs/msg01063.html
"nilfs2 store checksums for all data. However, at least the
current implementation does not verify it when reading.
Actually, the main purpose of the checksums is recovery after
unexpected reboot; it does not suit for per-file data
verification because the checksums are given per ``log''."
