From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 00:34:54 +0100
Message-ID: <4E3F211E.4060806@bobich.net>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net> <20110808.082319.114757823.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110808.082319.114757823.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08/08/2011 12:23 AM, Ryusuke Konishi wrote:
>>
>>   Is there a way to set default nice/ionice levels for nilfs-cleanerd?
>
> At present, you have to manually invoke the cleanerd through the
> nice/ionice commands or to run renice/ionice later specifying the
> process ID of the cleanerd.
>
> One way to make this convenient is introducing new directives in
> /etc/nilfs_cleanerd.conf as follows:
>
>   # Scheduling priority.
>   nice 19    # niceness -20~19
>
>   # IO scheduling class.
>   # Supported classes are default, idle, best-effort, and realtime.
>   ionice_class  idle
>
>   # IO scheduling priority.
>   # 0-7 is valid for best-effort and realtime classes.
>   ionice_data   5
>
> Do you think these extensions make sense ?

Yes, I think those would be really handy. It would also mean that the 
cleanerd could be scheduled to run more aggressively but at lower 
priority, so the clean-up would be potentially more up to date while 
having less impact on the system performance.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
