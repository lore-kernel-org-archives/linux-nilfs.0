Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD5CDB47E
	for <linux-nilfs@archiver.kernel.org>; Sun, 15 Oct 2023 15:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjJOPbi (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Sun, 15 Oct 2023 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJOPbh (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>);
        Sun, 15 Oct 2023 11:31:37 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E136AB
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 08:31:35 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id ada2fe7eead31-457c6267818so749484137.2
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 08:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697383894; x=1697988694; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZobR5eJ2Y3ej4c89ElfXrdtlklHoYYPlZtply19rM0=;
        b=U4MSu+1oi86ti7vlK2x08w4cuBX2Ly++JOU2MtS2dG1N6qcXD2KCxjkkaWWfT4UZNb
         rXZapQCZPmu0WzTiTBN3URLNCeX3+kGxnEemQhXK4kIXmUMsnNK6LzmUsdq8M5e/VGcq
         e2Za22fgoBirX4i7kTe0uMcnGwNQTl8nCe3yoNWKJtqOY5cVf1cUlCAYywJdaAJEA5Jt
         hAtEY56e3MTFf1dwE1daZjnx0Eg1NKOgFetiXu7S84Y4Wr1/+J8jPHTETf8XWnAnJ9ff
         z22rvwqh6c3zSen18ep/LWVmT547WGcv+LgE7C33fGk2K5Cx40f1FKXc6LnpQ9R6jBzt
         qFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697383894; x=1697988694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZobR5eJ2Y3ej4c89ElfXrdtlklHoYYPlZtply19rM0=;
        b=CTncjjxRwpIRa8lKkg6O5zGXz+6FeL3o0vvaIxwewJiyEEKfxQmgGBq4JWCWK0AZmW
         FQS8V4fyzKswwiOiv5f100o49zshOYSMReHSvntg3cdn4CC8egartCKA4vpQ2HC57+wO
         8ptGBxiEIyl1wBFP3riruM3Z+r8KHLALjXG5sk5ngab0p4fjXuwJg335kl8lTj0Fv58I
         kr2pXITwAulQwqPPGu1FvNUo7+3Hdk8gQj41Fkpz3NCjkgCnWvv8CXBC5eQZGH/3Ar/E
         d7m8MdnergAhWVrb8C1zZlJOKOzhClo5GIfW3ui12xiD7twPqEsVRzfcm6w2fOruXC9j
         C9bg==
X-Gm-Message-State: AOJu0YzY3RcDsdVmtfG009HabtHbdqR0DnQSgSzWTl78RapOuXYey/4t
        jSRip+DO+iCva/jnsxeeQpPWwoqz+ArpQ4QUFK2UuhvbVAY=
X-Google-Smtp-Source: AGHT+IHy6lpBV5XE0hh4Dz3jRix65bQKG+ju/MdJhyj3BGMrVdpvR9SnO2xEvovsH5DX2HHAmWWiGQSeENGzFRpNW64=
X-Received: by 2002:a05:6102:534:b0:44e:a18a:2507 with SMTP id
 m20-20020a056102053400b0044ea18a2507mr25997626vsa.0.1697383894123; Sun, 15
 Oct 2023 08:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <4f12ac12-0cae-7959-6aea-9b2fc6e1e4f5@softf1.com>
In-Reply-To: <4f12ac12-0cae-7959-6aea-9b2fc6e1e4f5@softf1.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Mon, 16 Oct 2023 00:31:17 +0900
Message-ID: <CAKFNMokcGOJ9B3J1iDf+z_6imRO9-FUCPCXf1v44pLnSh4i-7g@mail.gmail.com>
Subject: Re: How to Elegantly Handle "error -22 while searching super root"
 with Multi-TiB USB-HDDs
To:     Martin Vahi <martin.vahi@softf1.com>
Cc:     linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

On Sun, Oct 15, 2023 at 7:55=E2=80=AFPM Martin Vahi wrote:
>
>
> The symptoms are that a NilFS2 partition at a multi-TiB-sized USB-HDD tha=
t
> has only one huge primary partition, the NilFS2 partition,
> fails to mount. The symptoms include:
>
>      ----start--of--citation--of--dmesg--output--last--lines---
>      [  382.418297] usb 2-2: new high-speed USB device number 5 using xhc=
i_hcd
>      [  382.611471] usb 2-2: New USB device found, idVendor=3D152d, idPro=
duct=3D578e, bcdDevice=3D14.05
>      [  382.611480] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2=
, SerialNumber=3D3
>      [  382.611485] usb 2-2: Product: External USB 3.0
>      [  382.611489] usb 2-2: Manufacturer: Intenso
>      [  382.611493] usb 2-2: SerialNumber: 20171113252B4
>      [  382.616077] scsi host7: uas
>      [  382.617099] scsi 7:0:0:0: Direct-Access     Intenso  External USB=
 3.0 1405 PQ: 0 ANSI: 6
>      [  382.617889] sd 7:0:0:0: Attached scsi generic sg3 type 0
>      [  382.618920] sd 7:0:0:0: [sdc] 1220942646 4096-byte logical blocks=
: (5.00 TB/4.55 TiB)
>      [  382.619085] sd 7:0:0:0: [sdc] Write Protect is off
>      [  382.619086] sd 7:0:0:0: [sdc] Mode Sense: 5f 00 00 08
>      [  382.619391] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: e=
nabled, doesn't support DPO or FUA
>      [  382.619619] sd 7:0:0:0: [sdc] Optimal transfer size 33550336 byte=
s
>      [  382.673809]  sdc: sdc1
>      [  382.675211] sd 7:0:0:0: [sdc] Attached SCSI disk
>      [  486.063294] NILFS (sdc1): mounting unchecked fs
>      [  486.099403] NILFS (sdc1): invalid segment: Magic number mismatch
>      [  486.099413] NILFS (sdc1): trying rollback from an earlier positio=
n
>      [  486.100080] NILFS (sdc1): invalid segment: Magic number mismatch
>      [  486.100081] NILFS (sdc1): error -22 while searching super root
>      [ 1034.270149] NILFS (sdc1): mounting unchecked fs
>      [ 1034.313297] NILFS (sdc1): invalid segment: Magic number mismatch
>      [ 1034.313308] NILFS (sdc1): trying rollback from an earlier positio=
n
>      [ 1034.314722] NILFS (sdc1): invalid segment: Magic number mismatch
>      [ 1034.314726] NILFS (sdc1): error -22 while searching super root
>      ----end----of--citation--of--dmesg--output--last--lines---
>
>  From an 2012_07_23 mailing list post at
>
>      https://www.mail-archive.com/linux-nilfs@vger.kernel.org/msg01243.ht=
ml
>
> it seems that the way to may be the solution is to use
> "ddrescue" for creating an image of the whole device and then
> mount that HDD-image. As of 2023_10_15 I do not know, if that
> "ddrescue" based solution works for me, because I do not have
> big-enough empty HDD at and to try it, but the referenced
> mailing list post is over 10 years old and it can be expected
> that an USB-HDD that has its own power supply, can loose
> power at any moment or its USB-cable can be detached
> at any moment, so I suspect that there just has to be
> some more elegant solution to this naturally occurring
> problem than to create a HDD-image of a multi-TiB sized HDD.
>
> My problem is that I fail to find that solution, despite
> surfing the mailing list archive and reading the various
> NilFS related documentation. Could anybody please provide some
> links to related documentation, messages at the mailing list archive
> or please provide some other hints or ideas, how I can mount
> my USB-HDD without waiting a whole week or two for it to
> get copied to some bigger HDD and then back again. Thank You.
>
>
> Yours sincerely,
> Martin.Vahi@softf1.com

The log messages indicate that the situation is quite severe.

>      [  486.099403] NILFS (sdc1): invalid segment: Magic number mismatch

This message indicates that the magic number in the header of the log
pointed to by a superblock is abnormal, that is, the log data is
corrupted on disk.

>      [  486.099413] NILFS (sdc1): trying rollback from an earlier positio=
n
>      [  486.100080] NILFS (sdc1): invalid segment: Magic number mismatch
>      [  486.100081] NILFS (sdc1): error -22 while searching super root

And this message indicates that although recovery was attempted using
a spare superblock, the previous log pointed to by that pointer was
also corrupted.

Therefore, the data immediately before the problem probably has not
been written to the disk, and cannot be salvaged.

NILFS2 is designed to write log data  to media and then update the
superblock pointer, and to be safe, the superblock is duplicated so
that you can retroactively mount logs from a while ago.   It's rare
that either of these remedies doesn't work, and this usually doesn't
happen even with a sudden power cut.

Normally, even with a disk cache, this will not happen if the minimum
guaranteed write ordering and flushing semantics are properly
guaranteed.  There may be probably a bug in the device driver or the
disk firmware, or the disk may not be reliable to begin with.
Or perhaps the data that was supposed to have been written to the
media was unfortunately corrupted retroactively.

If there is no backup, the only way to rescue old data is to manually
rewrite the number of the last segment number (and associated
checkpoint and sequence numbers) in superblocks and successfully mount
it with read-only and norecovery mount options.  Unfortunately, there
is no easy way to recover from this level of destruction.

Since it cannot be mounted, the lssu command cannot be used to
determine the state of segments.  Instead, try checking the status
with the nilfs-tune and dumpseg commands:

$ sudo nilfs-tune -l /dev/sdc1

will list information written in a superblock.  And,

$ i=3D0; while [ $i -lt 511 ]; do sudo dumpseg /dev/sdc1 $i | head -4;
let i=3Di+1; done

writes out information (such as sequence number and creation date and
time) for segments with valid logs.
Here, 511 is the number of segments, so use the value in the "Number
of segments:" field in the nilfs-tune output for your device.

This will give you an overview of the logs (segments) written to disk.

Try dumping the information of the segment that appears to be the
newest using  dumpseg without the head command, and look for the
segment containing "ino =3D 3" (the inode number of that DAT metadata
file written at the end of the checkpointed log).
For instance, if the 100th segment appears to be the newest, try the follow=
ing:

$ sudo dumpseg /dev/sdc1 100

Since manually rewriting the segment pointer in a superblock is a
dangerous operation, I will omit it here.
I think it is important to first understand the current situation.

Regards,
Ryusuke Konishi
