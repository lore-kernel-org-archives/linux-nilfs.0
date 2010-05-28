From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 14:39:27 +0100
Message-ID: <4BFFC78F.10900@bobich.net>
References: <4BFCF55A.80205@bobich.net>	<927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl>	<4BFF8BD6.7080802@bobich.net>	<72C0FCE6-CE1A-4262-B89F-A1C3CBA99EAD@xs4all.nl>	<4BFF9E74.6040900@bobich.net> <A3BB0C84-D2BD-4119-9296-0A4D9FC02F19@xs4all.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A3BB0C84-D2BD-4119-9296-0A4D9FC02F19-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vincent Diepeveen wrote:

>>>>>> 1) Modern SSDs (e.g. Intel) do this logical/physical mapping 
>>>>>> internally, so that the writes happen sequentially anyway.
>>>>> Could you explain that, as far as i know modern SSD's have 8 
>>>>> independant channels to do read and writes, which is why they are 
>>>>> having that big read and write speed and can in theory therefore 
>>>>> support 8 threads doing reads and writes. Each channel say using 
>>>>> blocks of 4KB, so it's 64KB in total.
>>>>
>>>> I'm talking about something else. I'm talking about the fact that 
>>>> you can turn logical random writes into physical sequential writes 
>>>> by re-mapping logical blocks to sequential physical blocks.
>>> That's doing 2 steps back in history isn't it?
>>
>> Sorry, I don't see what you mean. Can you elaborate?
> 
> I didn't investigate NILFS, but under all conditions what you want to 
> avoid is some sort of central locking of the file system,
> because if you're proposing all sorts of fancy stuff to the file system 
> whereas you can already do your thing using full bandwidth of the SSD.

Are you actually claiming that you can achieve full write throughput on 
random writes that you can achieve on sequential writes on an SSD? Try 
that with write caches on the drive disabled.

> It really is interesting to have a file system where you do a minimum 
> number of actions to the file system
> so that other threads can do there work there. Any complicated 
> datastructure manipulation that requires central locking
> or other forms of complicated locking will limit other i/o actions.

I agree.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
