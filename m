From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd
Date: Sun, 11 Oct 2009 15:49:16 +0900 (JST)
Message-ID: <20091011.154916.07997858.ryusuke@osrg.net>
References: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
	<20091011.122911.131278678.ryusuke@osrg.net>
	<ee5afd760910102232o5f17c50cxb5024f6f76ecbcf5@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ee5afd760910102232o5f17c50cxb5024f6f76ecbcf5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Sun, 11 Oct 2009 07:32:50 +0200, Jan de Kruyf wrote:
> Hallo,
> Sorry the detail was a little bit scant last night.
> The nilfs versions running on the machine at the time of the disaster were
> the latest versions.
> This is the maintenance hard-drive running, I will update today.
> 
> The loop is (as far as I can see now from the logs)
> -
> -------kern.log-------------------------------------------
> Oct 10 06:53:11 debianLenny kernel: [44514.982086] segctord starting.
> Construction interval = 5 seconds, CP frequency < 30 seconds
> Oct 10 06:53:11 debianLenny kernel: [44515.115227] NILFS warning: mounting
> unchecked fs
> Oct 10 06:53:11 debianLenny kernel: [44515.398152] NILFS: recovery complete.
> Oct 10 06:53:28 debianLenny kernel: [44535.631729] NILFS warning (device
> hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> Oct 10 06:53:33 debianLenny kernel: [44542.849960] NILFS warning (device
> hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> Oct 10 06:53:38 debianLenny kernel: [44550.592403] NILFS warning (device
> hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> ---------------------------------------------------------------
> 
> this is from the maintenance versions on /dev/hda (still to be updated),
> with /dev/hdb not functional.
> It will fill up the log until the partition is full.

According to the log, the error was repeatedly detected in a retry
loop in the nilfs_clean_segments kernel function which cleanerd calls
via ioctl.  The err=-28 means ENOSPC (no space left on the device).

Yeah, if cleanerd falls into this state, it cannot handle any signals.
And, it doesn't return to userspace until the error is removed.

As you are pointing out, I wonder why this error is generated on the
device having enough free space.

I'll attach a patch to identify which function returns ENOSPC.  Could
you try the patch ?

Thanks,
Ryusuke Konishi

> I will dd the partion into a loop-mountable file once I have updated, so
> diagnostics
> may continue.
> 
> I was aware of this problem before: when you overfill a partition cleanerd
> goes into this loop.
> 
> The interesting part is: how did cleanerd get confused this time. since the
> partition was only half full
> and cleanerd was running more or less regularly. I am only aware that I
> stopped cleanerd a few times that day with TERM
> since it was in the way of other work. It made the /home partition so slow
> that I could not write a dvd anymore.
> But this is a separate issue.
> 
> So I will do a low-level check on the sick disc to check for media format
> failures
> and I will try to do some log reading over the next few days to see if I can
> find
> the log of the first mount after the accident.
> 
> Regards
> Jan de Kruyf.
> 
> "Let us sing, the Lord is on his Throne and the earth is full of his Glory."
> enjoy the rest of your day.


diff --git a/fs/alloc.c b/fs/alloc.c
index 1c76c38..fdec249 100644
--- a/fs/alloc.c
+++ b/fs/alloc.c
@@ -235,6 +235,8 @@ static int nilfs_palloc_find_available_slot(struct inode *inode,
 				return pos;
 		}
 	}
+	printk(KERN_ERR "%s: disk full\n", __func__);
+	dump_stack();
 	return -ENOSPC;
 }
 
@@ -320,6 +322,8 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	}
 
 	/* no entries left */
+	printk(KERN_ERR "%s: disk full\n", __func__);
+	dump_stack();
 	return -ENOSPC;
 
  out_desc:
diff --git a/fs/sufile.c b/fs/sufile.c
index 47ad9a4..e109a7e 100644
--- a/fs/sufile.c
+++ b/fs/sufile.c
@@ -322,6 +322,8 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	}
 
 	/* no segments left */
+	printk(KERN_ERR "%s: disk full\n", __func__);
+	dump_stack();
 	ret = -ENOSPC;
 
  out_header:
