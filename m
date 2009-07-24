From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Regarding NILFS performance
Date: Fri, 24 Jul 2009 19:18:31 +0900 (JST)
Message-ID: <20090724.191831.99280875.ryusuke@osrg.net>
References: <447f427d0907230205r2913fef4l8d912c0b093a4904@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <447f427d0907230205r2913fef4l8d912c0b093a4904-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dutdurudut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Thu, 23 Jul 2009 12:05:18 +0300, havuz goz wrote:
> Hello there,
> I apologize in advance if this e-mail is redundant. I'm not a
> developer, but log-based filesystems intrigue me. I have seen some
> benchmarks (I think on a linux-mag.com article), which didn't
> reflect the performance I had been expecting.

Thank you for your interest in nilfs.
 
> My basic understanding of how NILFS operates is that it appends a
> file which is to be committed to disk to the head of the log,
> eliminating, theoretically, the need to carry out random
> writes. From this I extrapolate , writes should be incredibly fast,
> since even budget ssds are capable of burst-write speeds of 200
> mb/s. What real-life factor exactly holds back NILFS's speed?

Theoretically, yes, LFS is said to be suited for random writes.  In
reality, the performance is highly dependent on the machine
environment.

For example, it depends on whether the disk cache mode is set to write
through/write-back, whether the device is sensitive to continuity of
access, or the I/O path is latency sensitive or not, etc.

As a matter of a fact, nilfs is not yet tuned well especially for
writes.  We have placed priority on mainline merge and bug fixes.

I did some peformance tuning for reads in the updates merged in
2.6.31-rc1, but it was left untouched until very recently.
 
> What happens with huge files? Is it possible to commit the
> modifications applied to a file as separate differential file,

Nilfs writes delta of files per block.  If you overwrites 1KB region
in a 1GB file, nilfs will append only a 4KB data block along with some
meta data blocks.

> leaving the original file intact?

Yes sure, that is what nilfs stards for.

> What about defragging? Does the garbage collection system move
> rarely modified files out of the way?

Not yet touched.  I think nilfs needs defragging to mitigate aging
effect, but the current GC is not intelligent, far inferior to such
level. :(

> I presume read performance is not the primary consideration in the
> development of NILFS, since reads are cached and modern ssds are
> incredibly fast at random reads anyway.  Since the burst read
> performance of both hdds and ssds is blazing fast, does it make
> sense to burst-read an entire cluster of adjacent small files and
> pick the desired files in system memory? I wouldn't mind if the
> unnecessary files were left in ram either, since modern computers
> have vast unused ram space.

Yeah, it's true by some perspective. One of the character of Linux is
that it applies memory for caches as much as possible.  Theoretically,
this nature would favor write oriented filesystems like LFS.

But, the capacity of storage devices is several orders of magnitude
larger than memory and it even grows faster.  Besides, we may want to
apply it to systems with different requirement, for example, a huge
scale mail system or the system holding many VM images.

As you say, background on storage was dramatically changed from the
past.  And, it may provide a tailwind to nilfs.  But, I think we still
needs more effort to improve raw I/O performance, at least to the
extent that NILFS does not lose its appeal.

> Thanks in advance.

Cheers,
Ryusuke Konishi
