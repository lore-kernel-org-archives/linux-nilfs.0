From: Jan Misiak <fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kernel panic (2.6.36) after file system corruption (?)
Date: Sat, 18 Dec 2010 15:08:45 +0100
Message-ID: <AANLkTim3dU2mZMr-BVP0JmSoD9y-UtGT=NTTLmSgiYsU@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:mime-version:received:from:date
         :message-id:subject:to:content-type;
        bh=9v16p2Q9HR0C6vhhc57Uj2auc/7Efi0JWKIiPhYLzJw=;
        b=rur90Dkrqly7U6J2kA7hyE0cUMJJe6oAfdsrrliZjB+4x7R/7vlEKATvAd/tsa7x/F
         HYf3CTJytNy2nh9RS2J38/+mqrPlDPMiA3vwTrujJyDknMvksaGll4zoCFnVCLYoQdnb
         xrk32XtPN2Xf3/OKF6yitXOsQBYPcEuXiDx4c=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I am just a simple end-user but as nobody in my distribution has had
the same problem I was forced to turn to the upstream. Please bear
with me.

I have been using nilfs2 on a 16GB usb-stick on a x86 thin client
running Arch Linux. The box had been running 24/7 and had an uptime of
about two weeks with kernel 2.6.36/nilfs-utils 2.0.20 when it
panicked. Unfortunately nothing was to be seen in the logs (system
partition was ext3). Now it panics every time I attempt to mount the
volume.

I tried to use netconsole to capture the panic message but it gets
truncated so I had to resort to taking pictures.

box #1 kernel 2.6.36.2/nilfs-utlis 2.0.20
    http://fijam.eu.org/other/netconsole.log
    http://fijam.eu.org/other/0000.jpg

I tried to mount the usb-stick on a laptop with the same kernel
(2.6.36.2) to capture more of the panic messages:

box #2 kernel 2.6.36.2/nilfs-utlis 2.0.20
    http://fijam.eu.org/other/0001.jpeg
    http://fijam.eu.org/other/0002.jpeg

It crashes when I try to mount with kernel 2.6.32.27 as well:

box #2 kernel 2.6.32.27/nilfs-utlis 2.0.20
    http://fijam.eu.org/other/0003.jpeg
    http://fijam.eu.org/other/0004.jpeg

I would be grateful for advice on how can I help with getting to the
bottom of this.

Regards,
Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
