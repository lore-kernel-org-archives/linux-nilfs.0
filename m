From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd some questions
Date: Fri, 30 Jan 2009 18:40:34 +0900 (JST)
Message-ID: <20090130.184034.91816318.ryusuke@osrg.net>
References: <497B59C2.80709@blueyonder.co.uk>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <497B59C2.80709-QgLWrMLu8clzjhtm8Ag3mw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, tombrough-QgLWrMLu8clzjhtm8Ag3mw@public.gmane.org

Hi,
On Sat, 24 Jan 2009 18:11:14 +0000, tom wrote:
> I'm using nilfs2 on a debian (lenny machine) using kernel 2.6.26-1-686
> and nilfs version 2.0.6. Currently I have a 250 Gb single partition
> drive connected via USB2, which I have formatted for nilfs2. I have
> noticed that when extracting a large archive onto the the file system
> that it seems to "burst", that is, it will extract for 5 seconds then
> halt for 1 and then repeat this cycle faithfully for the duration.
> 
> If I switch (kill) off the GC then the "bursting" effect disappears. I
> can remove checkpoints more efficiently using rmcp, however am I right
> in thinking that the GC does more than just remove checkpoints ?

Yes, only GC can reclaim disk space; rmcp does not make free space.
 
> Is the behaviour that I am witnessing typical of the nilfs GC or is
> being highlighted because I am using usb instead of directly attached
> ide / sata ?

I don't know why that happens, but a likely cause is bulky reads of
blocks during GC.

In that case, the following workarounds may make a difference.

1) Decrease value of `nsegments_per_clean' in /etc/nilfs_cleanerd.conf
  e.g.
  #nsegments_per_clean   2
  nsegments_per_clean   1

2) Re-create the partition using mkfs.nilfs2 with a smaller segment size.
  e.g.
  # mkfs -t nilfs2 -B 1024 /dev/sdxx
  (This halves the number of blocks per segment)

> I'm hoping to apply nilfs in production environment for our print unit
> at work because they would like self service recovery and because they
> have large amounts of graphical data that is updated daily but could
> only be safely backed up using a snaphot technology.
> 
> However I am concerned that any large file / archive extracts onto a
> nilfs file system with the GC switched on would impede efficiency.
>
> It is safe to say that I wont be using USB attached storage in the
> production environment, but I thought it might be worth mentioning my
> findings as the behaviour may still be present in a very muted form on
> IDE / SATA based storage devices.

Thanks for reporting.

I feel, the current GC is indeed immature and needs more love
especially for production use.
 
> I guess I could run GC at off peak times as a workaround, but would it
> ever catch up ?

Not guaranteed.  The speed of the GC is static unless you change
nilfs_cleanerd.conf and send a HUP signal to the GC daemon.
At least the speed should be adjusted adaptively, but not done yet.

Regards,
Ryusuke Konishi
