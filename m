From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH] nilfs2: Fix reference count leak in
 nilfs_sysfs_create_snapshot_group()
Date: Thu, 28 May 2020 21:48:57 +0200
Message-ID: <30cf7534-b62e-84b1-571a-945aaffac5b0@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590695339;
        bh=+B7LBaGX99S3uPjCcCLsxs3BCct//Xlvs6N9ytdHIBk=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=NIVjeoGVrMq0EaifFBo73HopbicIFYFK692s4AY2G+YxiNBiGaAER4Y16xPF2eIxe
         iDrA5V5kwYEpwmG3UPxERXfnb9vd8FbpkyUHh1JHlWijuJlT0pUEhXgbjaCkbmBcuV
         qO7CFafeAk1SDOS6G+pExj10OrPTWS0GAJiixa5k=
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Qiushi Wu <wu000273@umn.edu>, linux-nilfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kangjie Lu <kjlu@umn.edu>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>

> kobject_init_and_add() takes reference even when it fails.

It will be helpful to mention which object is referenced here, won't it?


> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object.

I guess that an imperative wording is preferred also for this change descr=
iption.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3Db0c3ba31be3e45a130e13b278c=
f3b90f69bda6f6#n151

How do you think about to combine this update step together with
=E2=80=9Cnilfs2: Fix reference count leak in nilfs_sysfs_create_device_gro=
up=E2=80=9D
into a small patch series?
https://lore.kernel.org/patchwork/patch/1248696/
https://lore.kernel.org/lkml/20200527200933.31135-1-wu000273@umn.edu/

Regards,
Markus
