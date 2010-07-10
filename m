From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Limits for checkpoints
Date: Sat, 10 Jul 2010 16:14:17 +0900
Message-ID: <AANLkTin6HLWr1vDIpkE2_wL5Hen7BBhod0SMMu7jQi5u@mail.gmail.com>
References: <1278652414.8104.3.camel@Stanowisko-25>
	<87eifd9q88.wl%jir@sekiba.com>
	<1278653914.8104.7.camel@Stanowisko-25>
	<20100709.200552.176154048.ryusuke@osrg.net>
	<1278692181.7532.1.camel@Stanowisko-25>
	<AANLkTikPhJGn45cLRcndvki4GSfpAzrdo8V7fbkmfo3o@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:sender:received
         :in-reply-to:references:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=ILxnkfTUnvzdwHu3wrwjL3WRr4qpramU363nnIWQd+8=;
        b=NS9SIRv5ORkFPGKuV+kVzJeLRGanHAGUftzUIJdp1yiAiP5JzNWkGm0cG6u+HdTpTv
         n+26NhBBzCP1W1FSl5j+tCIDu61qFXxy84owIbFP2K29cK0cVILCOQyIe6xzphVTuIix
         0lLIXwLsehVmZ/ncCMJFntP8sYs5XB4D1JhtI=
In-Reply-To: <AANLkTikPhJGn45cLRcndvki4GSfpAzrdo8V7fbkmfo3o-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?xYF1a2FzeiBXw7NqY2lja2k=?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2010/7/10 =C5=81ukasz W=C3=B3jcicki wrote:
>
>> If you worry about the disk usage of df output, one of the way is
>> adjusting min_clean_segments and max_clean_segments in
>> /etc/nilfs_cleanerd.conf.
>>
>> In the latest version of nilfs, nilfs_cleanerd tries to store past
>> data until free space gets less than 10% of the disk capacity.
>>
>> By decreasing those parameters, or by setting min_clean_segments to
>> zero this behavior is adjustable.
>
> Are these parameters will work with the version of kernel module
> 2-0-18 ?

Yes.   The main part of cleaner function is implemented in
nilfs_cleanerd and it is a userland program.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
