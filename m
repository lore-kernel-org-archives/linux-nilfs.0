From: "Tomas Vondra" <tv-iJ9qWsyttzc@public.gmane.org>
Subject: nilfs2 benchmark / write barriers
Date: Fri, 9 Sep 2011 23:46:13 +0200
Message-ID: <670047e76e7eb22f4edc3904cbf26658.squirrel@sq.gransy.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've run a series of benchmarks to compare PostgreSQL performance with
various file systems and block sizes (file system as well as database).
Nilfs2 was included in the benchmark and I was surprised how well it
performed.

I do have a few questions, though. All the following charts are with 4kB
fs blocks and 4kB db blocks and a blue area means a checkpoint (i.e. a
write activity).

I've used kernel 2.6.39-gentoo-r3 and nilfs-utils-2.0.21.

1) write barriers

With all the other file systems, the performance is significantly
influenced by the write barriers, but this is not true for nilfs2. This is
the tps I get with write barriers enabled:

http://www.fuzzy.cz/tmp/nilfs2-barrier-4096-4-tps-rw.png

and this is with write barriers disabled:

http://www.fuzzy.cz/tmp/nilfs2-nobarrier-4096-4-tps-rw.png

Both charts look exactly the same - that's a bit suspicious.

For example with btrfs, the results are these

http://www.fuzzy.cz/tmp/btrfs-datacow-barrier-4096-4-tps-rw.png
http://www.fuzzy.cz/tmp/btrfs-datacow-nobarrier-4096-4-tps-rw.png

so there's a significant difference.

2) continuous decrease of peformance

One thing I don't like is that the performance continuously decreases -
this is visible on the charts above. I do understand that the performance
decreases during the checkpoint, but I'd expect it to grow after the
checkpoint (and that does not happen).

So I'm wondering - isn't there a mount option that could improve this?

Tomas

PS: The complete benchmark results are here http://www.fuzzy.cz/bench/.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
