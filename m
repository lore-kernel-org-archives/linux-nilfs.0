From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Database performance is worse with (DIRECT
 IO)O_DIRECT
Date: Thu, 06 Aug 2009 03:16:45 +0900 (JST)
Message-ID: <20090806.031645.99368317.ryusuke@osrg.net>
References: <00c301ca15d4$fbac8d00$f305a700$@iis.u-tokyo.ac.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <00c301ca15d4$fbac8d00$f305a700$@iis.u-tokyo.ac.jp>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org

Hi!
On Wed, 5 Aug 2009 22:59:43 +0900, "Yongkun Wang" wrote:
> hi, guys
> 
> I have been using this awesome file system for a while.
>
> I built a database server on it. The transaction throughput on
> NILFS2 is about several times faster than that on EXT2.
>
> However, when I set the flush method to DIRECT IO (O_DIRECT), the
> database performance on NILFS2 is even worse than that on EXT2 with
> DIRECT IO.

Interesting results.

Nilfs2 is actually not yet supporting O_DIRECT write because the core
routine of direct IO is not available for copy-on-write filesystems.
It is fallen back to a buffered write for nilfs.

O_DIRECT read is OK, but I took O_DIRECT write is implied in your
case.  Do you use postgresql ?

> My conjecture is that probably the log-structured file system need a
> lot of buffer to apply changes and group the writes.

Likely reason.  You can see what's happing on the partition by using
``dumpseg'' command; it will show summary of logs for a specified
segment.  ( You can track recently written segments with ``lssu''
command )

If your conjecture is right, you will see many files and meta data
files with inode number 4, 5, and 3, are written very frequently.

> Is it also possible that the implementation of NILFS2 on DIRECT IO
> is not very efficient?
>
> Before I read the code, could you give me some hints why the
> performance is not good with DIRECT IO?

Yes, as I mentioned above.

I think we can add native support of O_DIRECT to nilfs, but I suspect
there is a influential difference in how to flush out data between the
native direct-io and the fall-backed buffered write & sync; we may be
able to improve performance without the native o-direct support.


> Or could you please introduce the implementation relevant to the
> DIRECT IO?

Roughly speaking, I think the current nilfs implementation of O_DIRECT
leads to the same action as O_DSYNC.  To be exact, we need to analyze
the disk with the dumpseg or trace internal functions because the
behavior depends on the environment.

Cheers,
Ryusuke Konishi
