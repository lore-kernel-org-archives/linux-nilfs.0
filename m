From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Sun, 15 Mar 2009 22:58:35 +0900 (JST)
Message-ID: <20090315.225835.27463578.ryusuke@osrg.net>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
	<20090313162609.GD7494@zaphod.leonweber.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090313162609.GD7494-Tv691C15nu5348sJH/KcYBvVK+yQ3ZXh@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, leon-UvuJAy62EvlM7kwft8N7nw@public.gmane.org

Hi,
On Fri, 13 Mar 2009 17:26:09 +0100, Leon Weber wrote:
> On 08.03.2009 14:39:16, Ryusuke Konishi wrote:
> > I've moved the replication feature to the top of todo list in our web
> > site ;)
> 
> Is replication really a feature that a file system should implement? I
> think it should be implemented one layer below the fs. If one needs a
> replicated file system, there are things like drbd (distributed
> replicated block device).

Yes, DRBD is another solution. I'm actually thinking it a possible
measure though we haven't yet evaluate for nilfs.  But as you know the
granularity differs from that of the checkpoint based solution.

Unless the checkpoint based solution doesn't have any merit, I think
the solution to be chosen depends on customer's (users') demand and
so-called service level.

Anyway you have a good point.  I should care not only rsync but also
drbd and other block layer solutions, and must find merits definitely.

> Of course, the file system should support being
> on a replicated device, though I don't really see a need to implement
> this on the fs layer, or am I missing anything?
> 
> Leon

In general, filesystems are said to have better opportunity to utilize
the knowledge for their metadata structures and consistency especially
for copy-on-write filesystems.

Those can efficiently extract delta by nature, and can drop
intermediate changes depending on required granularity.

Will it true with nilfs? - I don't know yet, but I think it's one of
the feature being worth of consideration.

Thanks,
Ryusuke Konishi
