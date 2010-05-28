From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Fri, 28 May 2010 10:17:54 +0200
Message-ID: <927E6E4B-B072-42EE-915A-FD34A88D478A@xs4all.nl>
References: <4BFCF55A.80205@bobich.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFCF55A.80205-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On May 26, 2010, at 12:18 PM, Gordan Bobic wrote:

> I've got a somewhat broad question on the suitability of nilfs for  
> various workloads and different backing storage devices. From what  
> I understand from the documentation available, the idea is to  
> always write sequentially, and thus avoid slow random writes on old/ 
> naive SSDs. Hence I have a few questions.
>
> 1) Modern SSDs (e.g. Intel) do this logical/physical mapping  
> internally, so that the writes happen sequentially anyway.

Could you explain that, as far as i know modern SSD's have 8  
independant channels to do read and writes, which is why they are  
having that big read and write speed and can in theory therefore  
support 8 threads doing reads and writes. Each channel say using  
blocks of 4KB, so it's 64KB in total.

> Does nilfs demonstrably provide additional benefits on such modern  
> SSDs with sensible firmware?
>
> 2) Mechanical disks suffer from slow random writes (or any random  
> operation for that matter), too. Do the benefits of nilfs show in  
> random write performance on mechanical disks?
>
> 3) How does this affect real-world read performance if nilfs is  
> used on a mechanical disk? How much additional file fragmentation  
> in absolute terms does nilfs cause?
>

Basically the main difference between SSD's and traditional disks is  
that SSD's have a faster latency, have more than 1 channel and write  
small blocks of 4KB, whereas 64KB read/writes are already real small  
for a traditional disk.

So a file system should benefit from the special properties of a SSD  
to be suited for this modern hardware.

> 4) As the data gets expired, and snapshots get deleted, this will  
> inevitably lead to fragmentation, which will de-linearize writes as  
> they have to go into whatever holes are available in the data. How  
> does this affect nilfs write performance?
>
> 5) How does the specific writing amount measure against other file  
> systems (I'm specifically interested in comparisons vs. ext2). What  
> I mean by specific writing amount is for writing, say, 100,000  
> random sized files, how many write operations and MBs (or sectors)  
> of writes are required for the exact same operation being performed  
> on nilfs and ext2 (e.g. as measured by vmstat -d).

Isn't ext2 a bit old?

Of course i understand you skip ext4 as that obviously still has to  
get bugfixed.

>
> Many thanks.
>
> Gordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
