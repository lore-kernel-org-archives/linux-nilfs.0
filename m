From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS2 on an Intel X25-M SSD
Date: Sun, 03 Jan 2010 21:39:20 +0900 (JST)
Message-ID: <20100103.213920.62349314.ryusuke@osrg.net>
References: <4B3C7326.4010002@gmail.com>
	<20100103.022425.52166650.ryusuke@osrg.net>
	<20100102204417.GA6877@Pilar.aei.mpg.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20100102204417.GA6877-8NNKxJcwqxqHjx4iBuKRcg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: crmafra2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Sat, 2 Jan 2010 21:44:17 +0100, "Carlos R. Mafra" wrote:
> The partition has 150 GB, so perhaps NILFS2 thinks that there 
> is "enough free space" and did not care too much about 
> deleting the old data. But I thought that what would matter
> most is the protection_period from /etc/nilfs_cleanerd.conf (3600)...

No, no, I meant the current GC of NILFS2 does not see how much free
space is left.  It just monotonically works unless user changes GC
parameters with a HUP signal.
 
> I must have understood it incorrectly, because I thought that after
> 3600 secs after deleting those 10 GB the partition would shrink to 90 GB
> "quickly" (like in 1-2 hours). Than after those 1-2 hours my old
> data would be forever gone.
> 
> So that was my odd feeling about NILFS2. I would not necessarily
> say that it is a "problem" because if one is not using an external
> hard disk then eventually there will be enough time to clean things
> up, but it feels like it could be better. I have even read some
> emails from the archives where people had problems with a full
> partition even though they knew they had free space.
> 
> To test it a bit more, I increased nsegments_per_clean to 12, 
> decreased protection_period to 60 and cleaning_interval to 2,
> but now the cleanerd was using like 15% of CPU and it was not
> cleaning the data much faster (I don't remember the numbers).
> 
> So what is more important to NILFS2, the notion of "free space
> left" or the protection_period setting?

"free space left" should be cared, but the current GC does not as I
mentioned above.

So, the protection_period setting is the most important.  The next is
GC speed given by cleaning_interval and nsegments_per_clean (tweaking
cleaning_interval seems preferable because increasing
nsegments_per_clean causes a burst of memory allocation).

Cheers,
Ryusuke Konishi
