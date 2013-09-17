From: Benixon Dhas <Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: Problems in GC when using NilFS2 with large segment size
Date: Tue, 17 Sep 2013 18:39:01 +0000
Message-ID: <3764420FCC841C4DAE85E3B76FC61A772A5A77E9@wdscexmb03.sc.wdc.com>
References: <3764420FCC841C4DAE85E3B76FC61A772A5A74F6@wdscexmb03.sc.wdc.com>
 <201309161617.AA05682@capsicum.lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201309161617.AA05682-ZdTO5nnmHvkOizVVqyxoihMFgDP4sedm@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: 'Ryusuke Konishi' <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks for your comments Ryusuke Konishi.

We have tried the second suggestion of reducing the number of segments cleaned in a single pass in the configuration file. Even after this we are seeing the memory issue.
Due to limitations of ShIngled Disks the smallest segment size that we can go with is 128MB. In our case a larger segment size is desirable.

We would like a feature which can limit the amount of kernel memory  that is used for garbage collection. This might make the garbage collector inefficient. But it would make it stable on systems with limited resources.
 We are just beginning to look through the source to understand NilFS2 better. We can experiment by modifying the NilFS2 source. We would welcome any suggestions or pointers that would help us in modifying the source. 

Thanks,
Benixon

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Monday, September 16, 2013 9:18 AM
To: Benixon Dhas
Subject: Re: Problems in GC when using NilFS2 with large segment size

Hi Benixon,

>Hello Ryusuke Konishi,
>
> I am a senior engineer at Western Digital working on Shingled Disks. 
> Shingled Magnetic Recording(SMR) is a new technology that increase HDD 
> capacity. The capacity increase comes at a cost that the drive must 
> physically write sequentially. We have learned about NilFS and have successfully prototyped our technology with your file system.
>
> We are now looking into some slight modifications with NilFS to fit a 
> new use case. Specifically we're looking into memory usage and cleaner algorithms.
> We tried to use NilFS2 on HDD with large segment size (say 128 MB or greater) and 4kB block size.
> Under light loads everything is working fine. Then we  tried running  
> a workload that writes four files in parallel generating data at the 
> rate of 2MB/second per file and a normal CPU load around 60% on a i5 
> core processor. This is fine as long as the garbage collector (GC) is 
> idle. But when Garbage collector starts on this 750GB NilFS partition we see some warnings due to memory allocations failing in the kernel and after a while the OOM killer is triggered.
>
> We see that the only about 150 MB out of the available 8GB main memory free under loaded conditions.
> The problem stills occurs even when the main memory is freed by dropping caches every 10 seconds.
> We are writing  1 to /proc/sys/vm/drop_caches for dropping the data 
> cache. Also we observe that when GC is running the disk activity is increased about five times the normal.
>
> Is there anything that we can do to solve this problem in your opinion?

The cleaner of NILFS reclaims disk space by repeating one-shot GC.
Every one-shot GC is performed per (nsegments_per_clean) segments, or
(mc_nsegments_per_clean) segments if the ratio of free disk space is less than (min_clean_segments).

The cleaner moves data of in-use blocks to new segments with kernel page cache, so it allocates, for the former case, (segment size) * (nsegments_per_clean) kernel memory bytes at worst, and (segment size) * (mc_nsegments_per_clean) bytes for the latter case.

By default, (nsegments_per_clean) is set to two and (mc_nsegments_per_clean) is set to four.  These parameters are defined in /etc/nilfs_cleanerd.conf.

To minimize memory pressure, I recommend you to tweak GC parameters with taking the above memory allocation model into consideration.
The following workaround may make a difference:

1. Decrease segment size
2. Decrease mc_nsegments_per_clean and nsegments_per_clean 3. Decrease cleaning_interval and mc_cleaning_interval instead of increasing
   segment size or {mc_,}nsegments_per_clean.

In general, using large segment size is not recommended because it consumes large kernel memory at least temporarily.

> Also is linux-nilfs kernel mailing list a better place for such 
> questions or is there any other person who might be able to help?

linux-nilfs mailing list is the best place to discuss such topic.

> Please provide us your suggestions and do let us know if you need any more details.
>
> Thanks,
> Benixon

With regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
