From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: {WHAT?} read checksum verification
Date: Fri, 14 Jul 2023 05:29:47 +0900
Message-ID: <CAKFNMomYVt34VObp136j=nA5s=_ee6-5ashHw46UyXZ_Y0MgfQ@mail.gmail.com>
References: <174f995c-e794-74c4-24d6-52451f3f3f28@prnet.org>
 <25775.10549.41499.886957@petal.ty.sabi.co.uk> <b99d2029-9b96-a016-875e-09b208c0ab9c@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689280204; x=1691872204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uILOvcD4g/H7l9GNqFkLN+OVpWOB8/EBOSJwIV3sV/c=;
        b=gesAs1IwhvCCTogct0Ln8kKNv2fBdXd29q9m/ep+PEvcoeRr+YaemQILQIU81NMXQm
         cQnWHk6s0bDBYB9DfRebT+zXV5TWzhmkWYF+/m0AYO69OGOwqvbMbg/tOw2ORnHB1GXh
         BQlfwl4ZddzqHYX+LZyKaIqMOvtlZv6ZJn5ibzTO9N2KOSLiYhjznAh8WD8huKUhSY32
         kJNskuHKy0wCvHxCStY+Yv5LedMIj1ZqUZvBLQ9sQCDnoKmMNVv3RSydIzRDn0Kdbw9p
         /zTKRSRobSO+okJRlNFL0aDHdw55Z3B8jt6rI/89U6Efsfo3flZYl/gVjGEvOixq5w8m
         G82Q==
In-Reply-To: <b99d2029-9b96-a016-875e-09b208c0ab9c-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Cc: Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Iip2UmYkHbXO@public.gmane.org>, list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 13, 2023 at 1:44=E2=80=AFPM David Arendt wrote:
>
> On 7/13/23 00:29, Peter Grandi wrote:
> >> I used NILFS over ISCSI. I had random block corruption during
> >> one week, silently destroying data until NILFS finally
> >> crashed. First of all, I thought about a NILFS bug, so I
> >> created a BTRFS volume
> > I use both for main filesystem and backup for "diversity", and I
> > value NILFS2 because it is very robust (I don't really use
> > either filesystems snapshotting features).
> So do I, therefor I said it was not NILFS fault.
> >> and restored the backup from one week earlier to it. After
> >> minutes, the BTRFS volume gave checksum errors, so the
> >> culrprit was found, the ISCSI server.
> > There used to be a good argument that checksumming (or
> > compressing) data should be end-to-end and checksumming (or
> > compressing) in the filesystem is a bit too much, but when LOGFS
> > and NILFS/nILFS2 were designed I guess CPUs were too slow to
> > checksum everything. Even excellent recent filesystems like F2FS
> > don't do data integrity checking for various reasons though.
> >
> > In theory your iSCSI or its host-adapter should have told you
> > about errors... Many can enable after-write verification (even
> > if its quite expensive). Alternatively some people run regularly
> > silent-corruption detecting daemons if their hardware does not
> > report corruption or it escapes the relevant checks for various
> > reasons:
>
> The host adapter can return errors if underlying the disk itself returns
> them. If bits randomly flip on disk after being written, the host
> adapter can't know (at least not in non raid scenarios).
>

I recommend replacing unreliable block layers first.
The reliability of the filesystem depends heavily on that of the block
layer, and the block device must be sufficiently reliable.

In general, the various checks and reliability measures that
filesystems and operating systems have are insufficient to compensate
for defective or unreliable block devices.  Problem-prone devices are
difficult to use regularly, even if errors can be detected.

Putting that premise aside for a moment, if you want to take advantage
of both properties of retroactive snapshotting (or robustness) that
nilfs2 provides and data integrity checking, a short-term solution
might be to try dm-integrity[1] and nilfs2 together.

[1]  https://docs.kernel.org/admin-guide/device-mapper/dm-integrity.html

The block device provided by dm-integrity will return an I/O error
when there is a problem with integrity, so nilfs2 should be able to
detect it.

For example, how to use dm-integrity and nilfs2 together is as follows:

$ sudo integritysetup format /dev/<your-device>
$ sudo integritysetup open /dev/<your-device> mydata
$ sudo mkfs -t nilfs2 /dev/mapper/mydata
$ sudo mount -t nilfs2 /dev/mapper/mydata /mnt/mydata

(It might be worth mentioning this in the FAQ on the NILFS project web site=
.)

Since dm-integrity is a dedicated function, you can specify detailed
options according to the integrity requirements you want to achieve.
It seems to work stably even when combined with nilfs2.

I don't know of a convenient way to periodically check for device bit
rot or sector data corruption, but I think that a somewhat forcible
method is to read the block device with the dd command:

$ sudo dd if=3D/dev/mapper/mydata of=3D/dev/null bs=3D8M

> > https://indico.desy.de/event/257/contributions/58082/attachments/37574/=
46878/kelemen-2007-HEPiX-Silent_Corruptions.pdf
> > https://storagemojo.com/2007/09/19/cerns-data-corruption-research/
> >
> >> [...] NILFS creates checksums on block writes. It would really
> >> be a good addition to verify these checksums on read [...]
> > It would be interesting to have data integrity checking or
> > compression in NILFS2, and log-structured filesystem makes that
> > easier (Btrfs code is rather complex instead), but modifying
> > mature and stable filesystems is a risky thing...
> >
> > My understanding is that these checksums are not quite suitable
> > for data integrity checks but are designed for log-sequence
> > recovery, a bit like journal checksums for journal-based
> > filesystems.
> >
> > https://www.spinics.net/lists/linux-nilfs/msg01063.html
> > "nilfs2 store checksums for all data. However, at least the
> > current implementation does not verify it when reading.
> > Actually, the main purpose of the checksums is recovery after
> > unexpected reboot; it does not suit for per-file data
> > verification because the checksums are given per ``log''."
>
> It think exactly this would be interesting, if checksum per log already
> exist, it would be good to verify these on read. As already said, I am
> not expecting to know on which file corruption occurred, but it would be
> nice to know that something nasty is going on.
>

It's tricky to use crc in logs for integrity checking on file data
read, so I think we should think of other ways if we implement it.

On the one hand, this might be useful for background checks.
I mean block device data anomaly detection can be implemented as a
background or one-shot running, user space or kernel module function.

In any case, features that are not suitable for everyday use may end
up being turned off on a regular basis, resulting in unused features
that only add patterns for regression testing.  I would like to avoid
this.

Also, I don't know about the future, but I'm still focused on solving
the problems reported by syzbot, and even after that is over, I'd like
to review and fix various implementations that have become obsolete
for the latest Linux kernel, so honestly I don't have much energy to
start such a function right now.   However, I think it's good to have
discussions like this from time to time as it will be a good
confirmation of the current situation.

Thank you.

Ryusuke Konishi
