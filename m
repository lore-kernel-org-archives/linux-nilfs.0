From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sun, 19 Jan 2014 00:08:58 +0100
Message-ID: <52DB098A.4010300@gmx.net>
References: <W9375626839227141389894521@atl4webmail02>	<1389940315.2731.16.camel@slavad-ubuntu> <20140118.104703.356941870.konishi.ryusuke@lab.ntt.co.jp> <52DA696D.6010206@gmx.net> <04877EE1-F5BF-41CE-AC92-CD9C3ED0B8A4@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <04877EE1-F5BF-41CE-AC92-CD9C3ED0B8A4-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-01-19 00:08, Vyacheslav Dubeyko wrote:
> I think that it is very desirable to share patches for the review on early
> stages because it is possible to achieve a valuable results by means of
> open and continuos discussion. So, you are welcome to share your
> vision and your patches.

Good I will prepare my patches.

> As I remember, I had made many remarks about your approach and about
> your code last time. So, I hope that you rework your approach significantly.

Yes it is basically a complete rewrite.

>> [1] https://www.dropbox.com/s/3ued8g5xaktnpbq/replay_parallel_ssd_line.pdf
> 
> To be honest, I completely misunderstand this diagram. It is hard to understand
> it without additional description, from my point of view.

Yes you are probably right about that. It is generated from a GC log
file. For every GC operation I print out the number of live blocks. For
example if the GC cleans a segment and 90% of the blocks in it are live,
then 90% of the blocks need to be moved to a new segment. Moving blocks
is undesirable and therefore I call that "inefficient". In this example
the efficiency would be 10%. So 10% would then become one point in the
graph at time 0. The goal of every cleaning policy is to find segments
with as few live blocks as possible. So efficiency is basically the
percentage of dead blocks. Maybe I should label it differently...

The vertical dashed lines mark the time, when the benchmark finished.
The GC still runs on for some time after that until it reaches the
max_clean_segments threshold.

The graph shows, that the cost-benefit and greedy policies are better at
finding segments with a lot of dead blocks. So less blocks need to be
moved to new segments and the benchmark finishes in less than half the time.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
