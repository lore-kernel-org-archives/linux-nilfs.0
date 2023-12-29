Received: from mail-out9.elkdata.ee (mail-out9.elkdata.ee [185.7.252.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D6125B5
	for <linux-nilfs@vger.kernel.org>; Fri, 29 Dec 2023 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=softf1.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=softf1.com
Received: from mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123])
	by mail-out9.elkdata.ee (Postfix) with ESMTP id 1AFC872A0E
	for <linux-nilfs@vger.kernel.org>; Fri, 29 Dec 2023 17:51:39 +0200 (EET)
Received: from mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123])
	by mail-relay4.elkdata.ee (Postfix) with ESMTP id 199B5EF349
	for <linux-nilfs@vger.kernel.org>; Fri, 29 Dec 2023 17:51:39 +0200 (EET)
X-Virus-Scanned: amavisd-new at elkdata.ee
Received: from mail-relay4.elkdata.ee ([185.7.252.123])
	by mail-relay4.elkdata.ee (mail-relay4.elkdata.ee [185.7.252.123]) (amavisd-new, port 10024)
	with ESMTP id BvDcVctPMQOh for <linux-nilfs@vger.kernel.org>;
	Fri, 29 Dec 2023 17:51:37 +0200 (EET)
Received: from mail.elkdata.ee (unknown [185.7.252.121])
	by mail-relay4.elkdata.ee (Postfix) with ESMTP id 95F76EF345
	for <linux-nilfs@vger.kernel.org>; Fri, 29 Dec 2023 17:51:37 +0200 (EET)
Received: from [192.168.30.41] (89-235-223-80.saturn.infonet.ee [89.235.223.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: martin.vahi@softf1.com)
	by mail.elkdata.ee (Postfix) with ESMTPSA id 901E1864FD
	for <linux-nilfs@vger.kernel.org>; Fri, 29 Dec 2023 17:51:37 +0200 (EET)
Message-ID: <853218a8-507e-18de-d745-4e6e51b43025@softf1.com>
Date: Fri, 29 Dec 2023 17:51:37 +0200
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Continuation of the topic "error Foo(now -5, once -22) while
 searching super root"
From: Martin Vahi <martin.vahi@softf1.com>
To: linux-nilfs@vger.kernel.org
References: <4f12ac12-0cae-7959-6aea-9b2fc6e1e4f5@softf1.com>
Content-Language: en-US
In-Reply-To: <4f12ac12-0cae-7959-6aea-9b2fc6e1e4f5@softf1.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This letter is a continuation of the thread that I started at 2023_10_15

https://marc.info/?l=linux-nilfs&m=169738371518323&w=2
archival copy: https://archive.is/Fbw5e

The purpose of my current letter is to document, write down,
information that might contain hints to the flaw.

This time the computer was the same,

     (Two 2-threaded cores, 12GiB RAM minus the video memory. A line from /var/cpuinfo)
     Intel(R) Core(TM) i5-4200M CPU @ 2.50GHz

Linux distribution on the computer was different,
a live-DVD with KNOPPIX version 9.1
freshly written on a MDisc DVD(As of 2023_12 still totally buyable
from original manufacturer, ritek-europe dot com, redirects to conrexx dot com,
in small quantities like a pack of 100 discs for about 200€, including all shipping and handling.
They order them from Taiwan to Netherlands and then use FedEx to send from
Netherlands to the rest of the EU. No, I do NOT sell them myself, NOR do I earn from that business in any way,
I just had hard time getting MDisc DVDs and that's where I got those,
but the delivery time was about 2 months.) and the USB-HDD was a
~465GiB < 500GiB sized magnetic disc, which was mounted
with mount options "noatime,nodiratime". The error occurred
during a long "git commit -a". The repository resided
on the USB-HDD. There was plenty of CPU-time free, because
only the window manager with a "few" "standard" KNOPPIX
programs were running and there was no shortage of RAM, because
multiple GiB was free. The "git commit -a" was given over
an SSH session, id est the USB cable stayed put, no movement
of the USB cable due to the use of a laptop keyboard.
The laptop booted from the MDisc DVD about 2 days before
the error occurred and the rest of the programs at the laptop
seem to work fine after the error without rebooting the laptop, id est
the kernel did not totally crash.

The laptop with the ~465GiB USB-HDD was not on the same table with the
keyboard that was in use, id est keyboard vibrations did not
reach the USB-HDD or the laptop in any significant amount.


     ----start--of--citation--of--dmesg--output--last--lines---
     [  150.848200] usb 3-4: new high-speed USB device number 5 using xhci_hcd
     [  150.989381] usb 3-4: New USB device found, idVendor=152d, idProduct=2329, bcdDevice= 1.00
     [  150.989390] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
     [  150.989394] usb 3-4: Product: USB to ATA/ATAPI bridge
     [  150.989397] usb 3-4: Manufacturer: JMicron
     [  150.989401] usb 3-4: SerialNumber: 801130168383
     [  150.990928] usb-storage 3-4:1.0: USB Mass Storage device detected
     [  150.991138] usb-storage 3-4:1.0: Quirks match for vid 152d pid 2329: 8020
     [  150.991193] scsi host7: usb-storage 3-4:1.0
     [  154.102691] scsi 7:0:0:0: Direct-Access     WDC WD50 00LPLX-60ZNTT1   02.0 PQ: 0 ANSI: 2 CCS
     [  154.103140] sd 7:0:0:0: Attached scsi generic sg2 type 0
     [  154.103556] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/466 GiB)
     [  154.103931] sd 7:0:0:0: [sdc] Write Protect is off
     [  154.103940] sd 7:0:0:0: [sdc] Mode Sense: 28 00 00 00
     [  154.104321] sd 7:0:0:0: [sdc] No Caching mode page found
     [  154.104328] sd 7:0:0:0: [sdc] Assuming drive cache: write through
     [  154.187547]  sdc: sdc1 sdc2 sdc3 sdc4 sdc5 sdc6 sdc7 sdc8
     [  154.188768] sd 7:0:0:0: [sdc] Attached SCSI disk
     [  222.853951] NILFS version 2 loaded
     [  222.855302] NILFS (sdc7): mounting unchecked fs
     [  226.181683] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=2s
     [  226.181687] sd 7:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current]
     [  226.181689] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
     [  226.181692] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 28 13 20 28 00 00 08 00
     [  226.181694] blk_update_request: critical medium error, dev sdc, sector 672342056 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 0
     [  226.181726] NILFS (sdc7): I/O error reading segment
     [  226.181729] NILFS (sdc7): error -5 while searching super root
     root@Microknoppix:/home/knoppix/haakimiskataloogid# mount -t nilfs2 /dev/sdc7 ./h1
     mount.nilfs2: Error while mounting /dev/sdc7 on /home/knoppix/haakimiskataloogid/h1: Input/output error
     root@Microknoppix:/home/knoppix/haakimiskataloogid#
     ----end----of--citation--of--dmesg--output--last--lines---

I find it scary that a file system can get so unusable
during ordinary use while the hardware seems to be just fine
and there is no standard tool to recover even a fraction
of the files at the NilFS2 partition. As of 2023_12_29
I have most of my files on NilFS2 partitions with the hope
that it helps to preserve them, but it turns out that
when ext4 fails, looses files, at power failures, then NilFS2 fails
at plain usage scenarios, where there is no power
failure or any other relevant event. As things stand now (2023_12_29),
my strategy is to mirror my files at different file systems:
NilFS2 to not loose files during power failures or resets and
ext4 to not loose files during plain, calm, low-intensity, HDD usage.

Another line of thought is that RAIDs are useless, if the
kernel of the computer that the RAID is connected to,
corrupts in RAM. Therefore the HDDs with different file system types
should be connected to different computers, preferably running
different operating systems. As my main operating system is some
Linux distribution (varies over time and between machines), then
FreeBSD, OpenBSD and Solaris derivatives (illumos and alike
come to mind) as hopefully sufficiently varying options.

I mentioned MDisc DVD-s, because if an operating system
boots from a DVD, then there CAN NOT BE ANY KERNEL
FILE SYSTEM CORRUPTION RELATED BOOT BINARY CORRUPTION
and unlike plain DVD-s, MDisc DVDs last longer than 10 years.
MDisc DVDs can be reliably written only with a special DVD writer that has
slightly more powerful laser than other, "ordinary", DVD-writers,
but the prices of such USB-DVD-writers are roughly the same as
with other USB-DVD-writers, only the specs differ and one
must make a slightly greater effort to find the USB-DVD-writers
that have "MDisc support". Supposedly other DVD-writers
also write MDisc DVDs, but with a great error rate. MDisc DVDs
are designed to be readable with plain DVD-writers/readers
and even old DVD-readers that lack DVD writing capability.
I mention that aspect, because with Raspberry_Pi-like computers
the Flash memory card wear related errors also appear
at the Linux kernel binary and other installed binaries and
that makes the Raspberry_Pi-like computers unstable over time.
As of 2023 the newest Raspberry_Pi official Linux, the "RaspberryOS"
has the option to use a "readonly-write-only-to-RAM filesystem", a lot like
live Linux DVDs use to reduce the wear of the memory card,
but the various scientific papers (You can search them Yourself,
there are plenty on the net, easy to find, semanticscholar dot org )
basically, depending on how one interprets the graphs and
temperature conditions of memory cards and memory sticks,
state the "sufficiently reliable" data retention rate to
about one year, 2 years tops. Again, depending on interpretation.
My interpretation is that if I touch a memory card or
a USB memory stick than I feel that it's hot and therefore
the Flash memory die in the device must be even hotter.
My personal intuitive observation matches with the
roughly 1 year retention time, after which the data should
be rewritten, including file system formatting information.

That is to say, for reliability, Flash memory card should be taken out of
a Raspberry_Pi-like computer roughly once per year and
the Linux program dd should/might be used to rewrite the
original image to the memory card, even if the memory card
is used in "readonly-write-only-to-RAM mode".

The F-RAM, used for storing program code in
car-industry microcontrollers (MCUs) does not
seem to be any better than Flash, despite initial hype,
except that may be MCUs are "stored"/used in cooler conditions.
I do not know. Car engines do get hot. That is to say,
some old-fashioned ROM can be pretty nice thing to have
and for laptops and desktops a MDisc DVD or BluRay
can be that "ROM", except that according to
some sources on the wild-wild-web the BluRay's,
including the proper MDisc BluRays that have
the inorganic die, not the
Verbatim (yes, that famous brand) fakes that only
use the MDisc as a trade-mark, supposedly have
a higher error rate than MDisc DVDs. But, even
plain DVDs can be a lot of help, for at least 5 year period,
possibly for a 10 year period. Again, if DVD
is like ROM, then any driver binary, including NilFS2 driver,
binary does not corrupt due to storage bitrot,
filesystem information corruption.

And the bad news is that the so hyped up "cloud storage",
where the storage providers advertise that they store
their clients' data at some really fancy and fast
solid state storage devices (essentially Flash memory)
has exactly the same bitrotting issue, which is why
at least one person that I know of (not me, yet)
keeps an off-cloud list of file hashes (MD5, SHA256, ...)
of files that a his clients' web application
at a server consists of. I mean, if banking information
or other critical information is stored at modern Flash-memory
based fast storage devices at the greatest and fanciest
servers and that information were to corrode due to
some file system driver issue that no RAID can compensate...


Summary of my compromise-semi-workaround:

     x) Boot from a live-DVD and use a Bash script to
        customize the running instance, id est copy
        the /etc/passwd and /etc/shadow files and
        /etc/ssh folder. Plain DVDs will do, but
        MDisc DVDs are better and with some long-term planning
        it is still (as of 2023_12) possible to get them, not as "new-old-stock", but
        as brand new products that are still being produced in relatively small volumes.
        Once their patents expire, there might be even multiple MDisc DVD producers,
        if there is enough demand for MDisc DVDs. If people still
        buy plain DVDs, then there might be also some market for MDisc DVDs.

        (I like to think of DVDs like I think of paper: relatively low data capacity,
        we don't produce them at home, id est it takes a factory to
        produce them, yet we use the old-fashioned paper still for
        data storage in many situations, like labels on apple-jam jars,
        packaging of many products contain text and image information, etc.
        In that sense DVD format as such might last for a long time,
        specially if it overcomes storage reliability issues like
        the MDisc DVDs have overcome, and if there are
        multiple producers like there are multiple paper producing
        factories.)

     x) Mirror files on different HDDs/SSDs that have
        different file system types,
        one HDD/SSD per computer to counter a situation, where
        a kernel/file_system_driver running instance corrupts
        due to some typical C/C++ related memory corruption.

     x) With Raspberry_Pi-like computers, overwrite the
        memory card once per year (with "dd", id est
        including filesystem formatting information)
        and try to avoid wearing the memory card by switching off
        the swap ("swapoff --all").

     x) With various Linux file systems use the
        "noatime,nodiratime" mount options
        ("mount -o noatime,nodiratime /dev/foodevice /bar/folder")

Thank You for reading my letter.
I hope that it helps to somehow get by
till the core of the NilFS2
corruption issue gets solved.

Yours sincerely,
Martin.Vahi@softf1.com


