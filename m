Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3BACDB47E
	for <linux-nilfs@archiver.kernel.org>; Sun, 15 Oct 2023 10:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjJOKTr (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Sun, 15 Oct 2023 06:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJOKTr (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>);
        Sun, 15 Oct 2023 06:19:47 -0400
X-Greylist: delayed 448 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 Oct 2023 03:19:44 PDT
Received: from mail-out9.elkdata.ee (mail-out9.elkdata.ee [185.7.252.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3477AD
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 03:19:44 -0700 (PDT)
Received: from mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123])
        by mail-out9.elkdata.ee (Postfix) with ESMTP id E2D68F4A7
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 13:12:14 +0300 (EEST)
Received: from mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123])
        by mail-relay4.elkdata.ee (Postfix) with ESMTP id E18FBF1819
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 13:12:14 +0300 (EEST)
X-Virus-Scanned: amavisd-new at elkdata.ee
Received: from mail-relay4.elkdata.ee ([185.7.252.123])
        by mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123]) (amavisd-new, port 10024)
        with ESMTP id sGcSgUbrZovC for <linux-nilfs@vger.kernel.org>;
        Sun, 15 Oct 2023 13:12:14 +0300 (EEST)
Received: from mail.elkdata.ee (unknown [185.7.252.121])
        by mail-relay4.elkdata.ee (Postfix) with ESMTP id 2A88CF1814
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 13:12:14 +0300 (EEST)
Received: from [192.168.30.41] (dhcp-160-101.cable.infonet.ee [82.147.160.101])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: martin.vahi@softf1.com)
        by mail.elkdata.ee (Postfix) with ESMTPSA id 1F72E866C3
        for <linux-nilfs@vger.kernel.org>; Sun, 15 Oct 2023 13:12:14 +0300 (EEST)
Message-ID: <4f12ac12-0cae-7959-6aea-9b2fc6e1e4f5@softf1.com>
Date:   Sun, 15 Oct 2023 13:12:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
From:   Martin Vahi <martin.vahi@softf1.com>
To:     linux-nilfs@vger.kernel.org
Subject: How to Elegantly Handle "error -22 while searching super root" with
 Multi-TiB USB-HDDs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org


The symptoms are that a NilFS2 partition at a multi-TiB-sized USB-HDD that
has only one huge primary partition, the NilFS2 partition,
fails to mount. The symptoms include:

     ----start--of--citation--of--dmesg--output--last--lines---
     [  382.418297] usb 2-2: new high-speed USB device number 5 using xhci_hcd
     [  382.611471] usb 2-2: New USB device found, idVendor=152d, idProduct=578e, bcdDevice=14.05
     [  382.611480] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
     [  382.611485] usb 2-2: Product: External USB 3.0
     [  382.611489] usb 2-2: Manufacturer: Intenso
     [  382.611493] usb 2-2: SerialNumber: 20171113252B4
     [  382.616077] scsi host7: uas
     [  382.617099] scsi 7:0:0:0: Direct-Access     Intenso  External USB 3.0 1405 PQ: 0 ANSI: 6
     [  382.617889] sd 7:0:0:0: Attached scsi generic sg3 type 0
     [  382.618920] sd 7:0:0:0: [sdc] 1220942646 4096-byte logical blocks: (5.00 TB/4.55 TiB)
     [  382.619085] sd 7:0:0:0: [sdc] Write Protect is off
     [  382.619086] sd 7:0:0:0: [sdc] Mode Sense: 5f 00 00 08
     [  382.619391] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     [  382.619619] sd 7:0:0:0: [sdc] Optimal transfer size 33550336 bytes
     [  382.673809]  sdc: sdc1
     [  382.675211] sd 7:0:0:0: [sdc] Attached SCSI disk
     [  486.063294] NILFS (sdc1): mounting unchecked fs
     [  486.099403] NILFS (sdc1): invalid segment: Magic number mismatch
     [  486.099413] NILFS (sdc1): trying rollback from an earlier position
     [  486.100080] NILFS (sdc1): invalid segment: Magic number mismatch
     [  486.100081] NILFS (sdc1): error -22 while searching super root
     [ 1034.270149] NILFS (sdc1): mounting unchecked fs
     [ 1034.313297] NILFS (sdc1): invalid segment: Magic number mismatch
     [ 1034.313308] NILFS (sdc1): trying rollback from an earlier position
     [ 1034.314722] NILFS (sdc1): invalid segment: Magic number mismatch
     [ 1034.314726] NILFS (sdc1): error -22 while searching super root
     ----end----of--citation--of--dmesg--output--last--lines---

 From an 2012_07_23 mailing list post at

     https://www.mail-archive.com/linux-nilfs@vger.kernel.org/msg01243.html

it seems that the way to may be the solution is to use
"ddrescue" for creating an image of the whole device and then
mount that HDD-image. As of 2023_10_15 I do not know, if that
"ddrescue" based solution works for me, because I do not have
big-enough empty HDD at and to try it, but the referenced
mailing list post is over 10 years old and it can be expected
that an USB-HDD that has its own power supply, can loose
power at any moment or its USB-cable can be detached
at any moment, so I suspect that there just has to be
some more elegant solution to this naturally occurring
problem than to create a HDD-image of a multi-TiB sized HDD.

My problem is that I fail to find that solution, despite
surfing the mailing list archive and reading the various
NilFS related documentation. Could anybody please provide some
links to related documentation, messages at the mailing list archive
or please provide some other hints or ideas, how I can mount
my USB-HDD without waiting a whole week or two for it to
get copied to some bigger HDD and then back again. Thank You.


Yours sincerely,
Martin.Vahi@softf1.com
