From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/1] nilfs2: add mount option that reduces super block writes
Date: Sun, 9 Feb 2014 16:36:02 +0100
Message-ID: <CAFvQSYT0cdeETZX-qdq07t6T4jq9Z=wJxXwBzycyn9Ue_JV8FA@mail.gmail.com>
References: <cover.1391359219.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=DFw4EY7GhdMme8unHsvOS/yBc6HSX4Gv+k1NYaYaWbo=;
        b=p/Y5yipZ1UWOHE5jr5OubYSW4ozxhO/o1cZiYvLx0DmoF5FBss/3Irq9YpIvt+eq+M
         Pa2bCEbSG1u0r9OEL+pXo25i9Mxapdy1Y5E8I/vzwk5X6rhSEf6pzAm1LsG7478EwX7c
         M8dYzX/CILyfNImXLCiaKF5fAhgcvL/Xtan3nAmy+IaAiQVQ8L54Q8a8oTpmUaddA8x8
         zsqh491ZT/mOCO4Z1yqT1xvxixGLN2q6PGYKYNaZA9fnmuB+PLX0NDXOycpFCCI3ewpA
         NrXIWmErdr+T41ErJPXG5D/DbZcnajHtzeQDOS9ohQnAgn51NtecYB/sHA4eLLOc6e8O
         m5Lw==
In-Reply-To: <cover.1391359219.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas, hi Ryusuke,

> Instead of periodically writing to the super block, this patch only
> writes at mount and umount time and performs a linear scan for the
> latest segment in case a recovery is necessary.
> The SD-Cards and the USB-Stick are not particularly fast, but they are
> small enough so that the recovery time is tolerable.

Finally I found some time to test your patch and also the new version
works fine (and fast!) here:

[ 3.349464] NILFS warning: searching for latest log
[ 4.747552] NILFS warning: mounting unchecked fs
[ 5.214883] NILFS: recovery complete.

So your enhanced recovery code requires ~1.3s for a 12GB nilfs2
partition on the higher-end 16GB SD card I use in the raspberry.
Also, despite frequent power-cuts I haven't obsereved any issues -
which made me switch to nilfs2+patch even for the rootfs (was ext4
ro).

> I see.  For further discussion on this approach, it looks like we need
> some measurement data of the situation that this patch makes a
> difference (for example, for an SD card or some device).  Anyway, I
> agree that the patch has a value for experiment purpose.

What do you think about the results obtained by andreas and me?
With SD cards (in the raspberry) I experience linear scan times as low
as ~110ms/1GB, and for everything else avoiding superblock writes
probably doesn't make sense anyway. And if some techie enables the
option on his SSD, recovery is also blazingly fast.

Thanks a lot & best regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
