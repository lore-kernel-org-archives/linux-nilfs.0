From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Fri, 28 Nov 2008 16:43:00 +0900 (JST)
Message-ID: <20081128.164300.47236105.ryusuke@osrg.net>
References: <20081126182158.20FD28306@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081126182158.20FD28306-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org

Hi,

On Wed, 26 Nov 2008 19:22:12 +0100, Adrian Ulrich wrote:
> Hi,
> 
> I just had an usb-harddrive (with nilfs2 and ext3 mounted) throw some IO-Errors (Most likely due to a crappy usb controller)
> and now nilfs2 refuses to mount the partition:
> 
> NILFS warning: Sequence number mismatch
> NILFS: error searching super root.
> 
> (ext3 still works fine)
> 
> Any idea?

Hmm, this error seems to be caused by some kind of bug in NILFS2
write routines.  I'll verify their error handlings.

In the meantime, please try the contained patch as follows:

$ tar jxf nilfs-2.0.5.tar.bz2
$ cd nilfs-2.0.5
$ patch -p1 < this-mail.patch
$ make
$ sudo make install

It disables the check of sequence numbers and would allow you to
mount the partition.

With regards,
Ryusuke Konishi

--
diff --git a/fs/recovery.c b/fs/recovery.c
index bd8e175..1144609 100644
--- a/fs/recovery.c
+++ b/fs/recovery.c
@@ -240,10 +240,12 @@ load_segment_summary(struct nilfs_sb_info *sbi, sector_t pseg_start,
 		goto failed;
 	}
 	store_segsum_info(ssi, sum, sbi->s_super->s_blocksize);
+#if 0
 	if (seg_seq != ssi->seg_seq) {
 		ret = NILFS_SEG_FAIL_SEQ;
 		goto failed;
 	}
+#endif
 	if (full_check) {
 		offset = sizeof(sum->ss_datasum);
 		check_bytes =
