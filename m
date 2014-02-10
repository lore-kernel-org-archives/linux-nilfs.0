From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 0/1] nilfs2: add mount option that reduces super block
 writes
Date: Mon, 10 Feb 2014 09:56:22 +0100
Message-ID: <52F89436.7000202@gmx.net>
References: <cover.1391359219.git.andreas.rohner@gmx.net> <CAFvQSYT0cdeETZX-qdq07t6T4jq9Z=wJxXwBzycyn9Ue_JV8FA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFvQSYT0cdeETZX-qdq07t6T4jq9Z=wJxXwBzycyn9Ue_JV8FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On 2014-02-09 16:36, Clemens Eisserer wrote:
> Hi Andreas, hi Ryusuke,
> 
>> Instead of periodically writing to the super block, this patch only
>> writes at mount and umount time and performs a linear scan for the
>> latest segment in case a recovery is necessary.
>> The SD-Cards and the USB-Stick are not particularly fast, but they are
>> small enough so that the recovery time is tolerable.
> 
> Finally I found some time to test your patch and also the new version
> works fine (and fast!) here:
> 
> [ 3.349464] NILFS warning: searching for latest log
> [ 4.747552] NILFS warning: mounting unchecked fs
> [ 5.214883] NILFS: recovery complete.
> 
> So your enhanced recovery code requires ~1.3s for a 12GB nilfs2
> partition on the higher-end 16GB SD card I use in the raspberry.
> Also, despite frequent power-cuts I haven't obsereved any issues -
> which made me switch to nilfs2+patch even for the rootfs (was ext4
> ro).

Thanks for testing it on your raspberry pi. I also own one, but I didn't
move the root fs to nilfs2 yet. Please be careful using the patch on a
production system. Although I am quite confident that it is safe, there
may still be some horrible bug in my code. More testing is definitely
necessary. It is not an "enhanced recovery" as you put it, but more like
a corner case experimental brute force recovery. Nevertheless I am
surprised how fast it is on the pi.

>> I see.  For further discussion on this approach, it looks like we need
>> some measurement data of the situation that this patch makes a
>> difference (for example, for an SD card or some device).  Anyway, I
>> agree that the patch has a value for experiment purpose.
> 
> What do you think about the results obtained by andreas and me?
> With SD cards (in the raspberry) I experience linear scan times as low
> as ~110ms/1GB, and for everything else avoiding superblock writes
> probably doesn't make sense anyway. And if some techie enables the
> option on his SSD, recovery is also blazingly fast.
> 
> Thanks a lot & best regards, Clemens

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
