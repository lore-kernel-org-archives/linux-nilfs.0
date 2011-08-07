From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 08:23:19 +0900 (JST)
Message-ID: <20110808.082319.114757823.ryusuke@osrg.net>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <28d103cbef1f8ebb3a7b458509e53c4d-tp2ajI7sM87MEvS+BUbURm2TqnkC6wfpXqFh9Ls21Oc@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 07 Aug 2011 20:09:04 +0100, Gordan Bobic wrote:
>  Hi,
> 
>  Is there a way to set default nice/ionice levels for nilfs-cleanerd?
> 
>  Gordan

At present, you have to manually invoke the cleanerd through the
nice/ionice commands or to run renice/ionice later specifying the
process ID of the cleanerd.

One way to make this convenient is introducing new directives in
/etc/nilfs_cleanerd.conf as follows:

 # Scheduling priority.
 nice 19    # niceness -20~19
 
 # IO scheduling class.
 # Supported classes are default, idle, best-effort, and realtime.
 ionice_class  idle

 # IO scheduling priority.
 # 0-7 is valid for best-effort and realtime classes.
 ionice_data   5

Do you think these extensions make sense ?


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
