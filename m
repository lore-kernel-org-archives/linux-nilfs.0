From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd
Date: Sun, 11 Oct 2009 12:29:11 +0900 (JST)
Message-ID: <20091011.122911.131278678.ryusuke@osrg.net>
References: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Sun, 11 Oct 2009 00:18:10 +0200, Jan de Kruyf wrote:
> Hallo,
> Here is an interesting disaster with nilfs2. Lightening went down the
> chimney on the other side of the wall. Computer was off, but plugged in.
> Motherboard died.
> 
> So I now try to fix partitions. at the moment it is /var. /home will come
> later.
> 
> Here is the problem:
> /var data is readable but the cleanerd has become confused after the
> disaster and has filled up the partition
> 
> partition size 5.8 Gig, data size 2.56 Gig, but usage is now 100%
> Normal mounting:
> cleanerd cannot be stopped anymore, neither with TERM or KILL signals.

Seems like it went into an infinite loop.

Can you change ``log priority'' written in /etc/nilfs_cleanerd.conf ?

Cleanerd may log additional messages if you change it ``debug'' level:

  log_priority         debug

The syslog is written out to the /var directory, so you should
mount the /var data on /mnt or other.

> lscp shows only cleaner checkpoints now.
> 
> When mounting without the cleanerd running there are no dmesg's of interest
> on mounting or on execution of any command
> 
> To rescue the partition do I copy the data to another disk and reformat? Or
> is there a simpler solution?

Well, I recommend you to upgrade the module to the latest version
'v2.0.17' because former versions may cause file system corruption or
kernel oopses if things turn out bad.  Two maintenance releases were
made after you pulled nilfs2-module.git.

nilfs-utils also has new version (v2.0.14).

If you will see the same problem for these new versions, maybe you
should make a backup copy and reformat the partition.

But, I would appreciate it if you could help me to find the cause of
the busy loop in cleanerd before the reformat.

> Best Regard,
> 
> Jan de Kruyf.
> ------------------

Thank you for reporting the issue.

With regards,
Ryusuke Konishi
 
> ps.
>  running debian lenny, kernel 2.6.26-1-686
> 
> branch 'master' of http://git.nilfs.org/nilfs2-utils  dd. 11 july 2009
> branch 'master' of http://git.nilfs.org/nilfs2-module  dd. 11 july 2009
> tag 'v2.0.15'
> 
> and here is the superblock of the partition:
> 
> 
> 00000000: 0200 0000 0000 3434 0001 0000 8422 95d1  ......44....."..
> 00000010: 80b7 90e7 0200 0000 ca02 0000 0000 0000  ................
> 00000020: 00b4 6665 0100 0000 0100 0000 0000 0000  ..fe............
> 00000030: 0008 0000 0500 0000 e1e6 1400 0000 0000  ................
> 00000040: d69f 0d00 0000 0000 c181 0900 0000 0000  ................
> 00000050: 0000 0000 0000 0000 4815 5a4a 0000 0000  ........H.ZJ....
> 00000060: 3713 d04a 0000 0000 3713 d04a 0000 0000  7..J....7..J....
> 00000070: 4000 3200 0000 0100 4815 5a4a 0000 0000  @.2.....H.ZJ....
> 00000080: 004e ed00 0000 0000 0000 0000 0b00 0000  .N..............
> 00000090: 8000 2000 c000 1000 470b 1351 09a6 4016  .. .....G..Q..@.
> 000000a0: 9397 70f2 82f5 d61b 7661 7200 0000 0000  ..p.....var.....
> 000000b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> 000000c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> 000000d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> 000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> 000000f0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
