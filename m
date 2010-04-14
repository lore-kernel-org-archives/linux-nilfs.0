From: ales-76-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org
Subject: =?us-ascii?Q?Re=3A=20NILFS=20information=20request?=
Date: Thu, 15 Apr 2010 01:19:49 +0200 (CEST)
Message-ID: <4283.1025.1852-28777-1386800339-1271287189@seznam.cz>
References: <F4AFB004-B0AF-40AE-8100-7B41D9E0DC78@xs4all.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F4AFB004-B0AF-40AE-8100-7B41D9E0DC78-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: =?us-ascii?Q?Vincent=20Diepeveen?= <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I'm not sure if I understand your requirements correctly, but I have my doubts about NILFS being a silver bullet for latency constrained workloads. First, the idea behind log-structured file systems is to optimize for writes - batching several unrelated write requests into a single continuous write. Your workload seems to be read-mostly (BTW, ReiserFS is noted for very good small file performance and it worked stable for me). Second, performace of any file system depends on performance of the underlying hardware and magnetic disks simply cannot deliver enough IOPs, especially for random reads/writes. So if you want really low latency and high IO rate you probably need to either go for SSDs (and NILFS for that matter), or keep the whole working set in memory (which is usually prohibitive in
  terms of price). Third, there are other things than file systems that are probably more suited to the task. I mean, you can put several machines together to form a cluster and than run a distribited key-value store on it. Key-value stores are something in between a file system and relational database. These are optimized for retrieving/storing small objects with low latency. Most known key-value store is probably Amazon's Dynamo (http://www.allthingsdistributed.com/2007/10/amazons_dynamo.html), but there are others. You can find a decent introduction here: http://www.metabrew.com/article/anti-rdbms-a-list-of-distributed-key-value-stores/ I understand that my answers are probably not what you expected, but that's what I think. And I'm sure others will have come up with something more sub
 stantial and more related to NILFS performace for your workload.

Cheers

Ales Blaha

> hi all,
> 
> Read an interesting article online on NILFS suggesting it would be ok  
> for fast latency.
> 
> Very interesting.
> 
> Now my use case is rather simple. It is for read-only of EGTBs.   
> (chess endgametablebases).
> 
> During a game tree search of (for example) a chessprogram if reaching  
> far endgame,
> it will go into the file system and do a lot of random reads.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
