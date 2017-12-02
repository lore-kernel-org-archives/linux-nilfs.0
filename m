From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: error mounting, input/output error
Date: Sat, 2 Dec 2017 20:00:16 +0900
Message-ID: <CAKFNMokvRJUy_+kfhHqFGudFPZv8cLr_i8Gz-UpWW330d_JOCQ@mail.gmail.com>
References: <20171202072129.Horde.hTiH1buA85eVlzWo5n2UQ-5@rapidbsure.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=47uItyjvWGReDkqsXKaocwGFCGhuWeABo1VIx94bIts=;
        b=U92lndtRHE25PMCPwsHQ9xXlEA98uSTDOcWtVelv8D17QHCUviFun+jjjMlu7smBuJ
         /MqFXeNMITId/emSNTzmbBcnlSiHJJdl73tTfZQgIjV84URWnqxEDZCjeT4OMfEI9RBh
         IkQk9MY7dDBBk6JDXeKNbyx8i8Kyy8VGUwbhZoe8Nq7jFFhByWTz6Mx/GuCtTZHNTywG
         lL7ZT0HPv3Eaugb2JbV0toTgHnQhl4Qre33dtkq2Xb76pA6HY9iycZX54dR2YX1luiNw
         NO/gj7M99pnPxnGCcq+ywIxWC0nvMMOcItFS3emfejwFTuK6nQw7qN+0jFHgtlqf0z5m
         DbcA==
In-Reply-To: <20171202072129.Horde.hTiH1buA85eVlzWo5n2UQ-5-F+CjGebjtwRZroRs9YW3xA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-12-02 16:21 GMT+09:00  <customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org>:
>
>
>
> I have a working hard drive that stopped being able to read the nilfs2
> partition after a low battery laptop shutdown
>
> There is no fsck function available, and I failed to copy the image and
> reinstall to a reformated partition- as explained below.
>
> Can someone please suggest how to recover the data?
>
> When mounting the partition with
>
> mount -t "nilfs2" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdb2"
> "/media/user/Unallocated"
> or
> mount -t "nilfs2" -o "errors=continue,uhelper=udisks2,nodev,nosuid"
> "/dev/sdb2" "/media/user/Unallocated"
>
> I get an I/O error "Error while mounting... Input/output error"
>
> output of dmesg
>
>
> [ 3521.639526] NILFS (sdb2): mounting unchecked fs
> [ 3524.672660] ata2.00: exception Emask 0x0 SAct 0x3e000 SErr 0x0 action 0x0
> [ 3524.672668] ata2.00: irq_stat 0x40000008
> [ 3524.672673] ata2.00: failed command: READ FPDMA QUEUED
> [ 3524.672681] ata2.00: cmd 60/40:68:c0:5d:ba/05:00:e3:00:00/40 tag 13
> ncq dma 688128 in
>                         res 41/40:00:e0:60:ba/00:00:e3:00:00/40 Emask
> 0x409 (media error) <F>
> [ 3524.672684] ata2.00: status: { DRDY ERR }
> [ 3524.672687] ata2.00: error: { UNC }
> [ 3524.686112] ata2.00: configured for UDMA/133
> [ 3524.686206] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [ 3524.686210] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current]
> [ 3524.686213] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read
> error - auto reallocate failed
> [ 3524.686218] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 e3 ba 5d c0
> 00 05 40 00
> [ 3524.686221] print_req_error: I/O error, dev sdb, sector 3820642528
> [ 3524.686272] ata2: EH complete
> [ 3527.523500] ata2.00: exception Emask 0x0 SAct 0x4000000 SErr 0x0
> action 0x0
> [ 3527.523507] ata2.00: irq_stat 0x40000008
> [ 3527.523510] ata2.00: failed command: READ FPDMA QUEUED
> [ 3527.523514] ata2.00: cmd 60/08:d0:e0:60:ba/00:00:e3:00:00/40 tag 26
> ncq dma 4096 in
>                         res 41/40:00:e0:60:ba/00:00:e3:00:00/40 Emask
> 0x409 (media error) <F>
> [ 3527.523516] ata2.00: status: { DRDY ERR }
> [ 3527.523517] ata2.00: error: { UNC }
> [ 3527.536847] ata2.00: configured for UDMA/133
> [ 3527.536869] sd 1:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [ 3527.536874] sd 1:0:0:0: [sdb] tag#26 Sense Key : Medium Error [current]
> [ 3527.536878] sd 1:0:0:0: [sdb] tag#26 Add. Sense: Unrecovered read
> error - auto reallocate failed
> [ 3527.536885] sd 1:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 e3 ba 60 e0
> 00 00 08 00
> [ 3527.536887] print_req_error: I/O error, dev sdb, sector 3820642528
> [ 3527.536927] ata2: EH complete
> [ 3527.536930] NILFS (sdb2): I/O error reading segment
> [ 3527.536932] NILFS (sdb2): error -5 while searching super root
> --------------------------------------

Look like nilfs aborted to mount due to an I/O error of underlying block device.

Make sure whether you can directly read the device or not with dd command.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
