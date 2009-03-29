From: =?ISO-8859-1?Q?Ingo_Gl=F6ckner?= <iglockner-S0/GAf8tV78@public.gmane.org>
Subject: Re: Questions regarding use of nilfs2 on SSDs
Date: Sun, 29 Mar 2009 15:30:13 +0200
Message-ID: <49CF77E5.1080209@web.de>
References: <49CE8EDA.8070304@web.de>
	<20090329.151750.64733928.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090329.151750.64733928.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, iglockner-S0/GAf8tV78@public.gmane.org

Dear Ryusuke Konishi,

thanks for your immediate reply!

>> - I have read somewhere
>>> http://www.ocztechnologyforum.com/forum/showpost.php?p=361424&postcount=10
>>   that using nilfs2 as the rootfs generates enormous I/O traffic
>>   (up to 45 GB write in 1-2 days!) If this is true, then it will
>>   eventually translate into reduced lifetime for SSDs.
>>   Can you confirm that the segment management of nilfs2
>>   is so write-heavy on the drive?
>>   If so, are there ways to avoid this?
> 
> Yes, this is true.  This is mainly because garbage collection creep
> around the partition until no old updates are found.

I have made a small test in order to reproduce this
phenomenon. I report the results here just to
demonstrate how drastic the effect is, knowing that
an improved cleanerd will likely behave differently.

- First I copied 4 GB of data to a fresh nilfs2 partition.
  Once the protection period expired, the cleanerd obviously
  reorganized the segments, which resulted in another
  4 GB of writes. After reorganization, no further writes
  due to cleanerd were observed.

- Then I created a snapshot with chcp ss and changed it
  back to a checkpoint using chcp cp.
  This caused the cleanerd to become active after the
  protection period and write another 4 GB once again!

- Finally I created an empty file on the nilfs2 partition
  using touch emptyfile.
  This too resulted in the cleanerd generating 4 GB write
  traffic after the protection period, effectively
  reorganizing the complete content of the partition.

Considering the limited lifetime of SSDs with respect to
writes, reorganizing the data *once* (in order to fill
segments more densely) is okay for me, but reorganizing
the whole data every time there is the tiniest change to the
file system (setting/unsetting a snapshot, creating an
empty file...) troubles me when it comes to SSDs.
It would be better if the GC would create stable segments.
At the moment even those segments that are already
completely filled with data are copied again and again.

But as you write, your colleague is currently improving
the GC, so I am confident that he will solve this problem!

In the meantime I will stick to your advice and avoid
the use of the GC if possible.

Thanks again for your help,
- Ingo
