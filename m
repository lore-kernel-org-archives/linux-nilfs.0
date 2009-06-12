From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug Report
Date: Fri, 12 Jun 2009 15:44:11 +0900 (JST)
Message-ID: <20090612.154411.85670752.ryusuke@osrg.net>
References: <mailman.1.1244602801.14549.users@nilfs.org>
	<20090611195123.46d7a684@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090611195123.46d7a684@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org

Hi,
On Thu, 11 Jun 2009 19:51:23 +0200, "Dipl.-Ing. Michael Niederle" wrote:
> Hi!
> 
> Today I installed SIMPLUX on a freshly formatted 30GB partition on a
> pen drive.  I updated the whole system, compiled and installed the
> final version of the 2.6.30 kernel. I did not apply any further
> nilfs-patches. Everything worked fine. Then (using the new kernel) I
> deleted several GB of old data. The garbage collection worked really
> slow, so I changed the settings in nilfs_cleanerd.conf as follows:
> 
> protection_period	900
> selection_policy	timestamp
> nsegments_per_clean	10
> cleaning_interval	5
> use_mmap
> log_priority		info
> 
> Then I restarted the cleaner daemon and was happy to see now much
> more activity on the pen-drive. The garbage collection claimed back
> MB after MB. I thought it would take some time for the garbage
> collection to complete and left the room.
>
> When I returned the machine was completely crashed (black screen - maybe due
> to the screen saver). I could only reboot it via "ctrl-alt-sysrqst USB".
> 
> There was no background job during the time of the crash - just an idling
> X-desktop (iceWM - so only very few running daemons).
> 
> The next reboot took half an hour! Here an excerpt from the kernel
> log:
> 
> [    2.407501] usb-storage: device scan complete
> [    2.456443] sd 2:0:0:1: [sdd] Attached SCSI removable disk
> [ 1759.409004] segctord starting. Construction interval = 5 seconds, CP frequenc
> [ 1759.421950] NILFS warning: mounting unchecked fs
> [ 1759.456071] NILFS: recovery complete.
> 
> It seems nilfs read the whole partition - byte for byte. This would take
> approximately the time spent. Wouldn't it suffice to read all segment headers
> to recover? The pen drive can handle more than 2000 reads per second.

It's obviously abnormal.  Nilfs stores a pointer to the latest log in
superblocks.  If power failure occurs, nilfs tries to recover newer
logs by scanning them from the pointed log.

So, your problem seems that neither superblock has been written back
to your pendrive for very long period.

I think the heavy GC load prevented the writeback.

In general, decreasing cleaning_interval is safer than increasing the
nsegments_per_clean to accelerate garbage collection.

Okay, I'll consider enforcing writeback of superblocks to avoid long
duration recovery on mount.

Thank you for reporting this issue.

> Before it (presumably) crashed the system the cleaner daemon had done a
> nice job - freeing several GB of unused space (but not yet completed the
> garbage collection).
> 
> Greetings, Michael

Regards,
Ryusuke Konishi
