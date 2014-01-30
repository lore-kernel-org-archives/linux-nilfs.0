From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add mount option that reduces super block
 writes
Date: Thu, 30 Jan 2014 12:33:55 +0100
Message-ID: <52EA38A3.8060107@gmx.net>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <cover.1391048231.git.andreas.rohner@gmx.net> <75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner@gmx.net> <127C78C3-9D47-439C-9639-263BC453D98D@dubeyko.com> <52E9EB06.1000504@gmx.net> <8DBE8E18-F678-44B0-A6A6-5AFEC227AA86@dubeyko.com> <52EA2002.1030809@gmx.net> <A6830DB2-DC73-4ACC-BE73-7A6EC1AC7C18@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A6830DB2-DC73-4ACC-BE73-7A6EC1AC7C18-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-30 12:27, Vyacheslav Dubeyko wrote:
> 
> On Jan 30, 2014, at 12:48 PM, Andreas Rohner wrote:
> 
>>
>> I have just finished a test with my  100 GB HDD and SSD. I filled it
>> with dd until it was 100% full. Then I cut power to the machine and
>> timed the following mount operation:
>>
>> 100GB HDD:
>> time sudo mount -o bad_ftl /dev/sda1 /mnt/
>>
>> real	1m21.068s
>> user	0m0.020s
>> sys	0m0.770s
>>
>> 100GB SSD:
>> time sudo mount -o bad_ftl /dev/sdc1 /mnt/
>>
>> real	0m2.124s
>> user	0m0.010s
>> sys	0m0.243s
>>
>> So it looks quite bad for hard drives. To scan a 1 TB hard drive would
>> take 13 minutes.
>>
>> But a 1 TB SSD would only take 20 seconds!
>>
> 
> I think that it will be good to have comparable results for the same environment.
> I mean, for example, measurement in different situations for SSD (without your
> patch and this your patch). How much time do you need for scanning the whole SSD
> by your approach? I think that comparison of linear scanning results for the whole
> SSD drive and for sudden power-off situation can provide basis for consideration.
> But sudden power-off situation can be different, I suppose.

I will test it more thoroughly in the evening or tomorrow morning. The
whole SSD has 120 GB, but I only use a 100 GB partition to be able to
better compare it with my hard drive. The scan always scans the whole
partition, because you cannot predict where the latest segment will be.

It is a pretty worn out Samsung 840 SSD. I use it for all my tests.

br,
Andreas Rohner

> Thanks,
> Vyacheslav Dubeyko.
> 
>> I will test one of my SD cards next.
>>
>> Regards,
>> Andreas Rohner
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
