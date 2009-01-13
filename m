From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs crashes on 2.6.18 and 2.6.26 kernel
Date: Tue, 13 Jan 2009 17:30:36 +0900 (JST)
Message-ID: <20090113.173036.74135964.ryusuke@osrg.net>
References: <62ae1fa40901121422u477654bbjf8174dbb8491e0ef@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <62ae1fa40901121422u477654bbjf8174dbb8491e0ef-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, amrita.nayal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Mon, 12 Jan 2009 14:22:45 -0800, "amrita nayal" wrote:
> Hi,
> 
> I have been trying to gauge file systems performance on flash device
> for one of my projects.
> 
> I already have numbers for ext2 and ext4 , both of them doing pretty
> good for sequential IOs, but horrible when it comes to random ones.
> Now I am trying to look into NILFS to figure out what performance they
> can give for random IOs.
> 
> I downloaded open source software from nilfs.org. Once I start
> running my fio tests the kernel crashes. And presumably this happens
> when cleaner demon tries to clean the snapshots, to make space in the
> device.
> 
> Has anybody seen similar problems ?

Actully a few other people have reported crashes which seem to be
caused by some sort of cleaner problem.

Is your fio test program available publicly?

I'd like to fix the cleaner related problems, but I haven't succeeded
to reproduce this so far.

If we can get the way to reproduce this easily, it would be a great
help.

> I am able to get some numbers for sequential IOs, keeping device size
> as small as 12g.
> (though device spans 240g) .But w/ similar device size of 12g for
> randowm write, kernel crashes almost when the test is ~20% complete.

How was the free space on the paratition?

> I have also tried to update cleanerd.conf so that snapshots cleaning
> is held longer, but am not able to avert it for the duration of random
> write is preety long.

That's interesting.

So, you did shorten protection_period or increase the number of
nsegments_per_clean ?

> I would highly appreciate inputs.
> 
> Thanks
> Amrita

Thanks for reporting the problem.

Regards,
Ryusuke
