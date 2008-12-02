From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Tue, 2 Dec 2008 07:44:09 +0100
Message-ID: <20081202064345.31DB4802A@blinkenlights.ch>
References: <20081128153732.be4f5cf8.adrian@blinkenlights.ch>
	<20081202.015029.88482681.ryusuke@osrg.net>
	<20081201171411.99215829D@blinkenlights.ch>
	<20081202.142225.78011419.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081202.142225.78011419.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Debug output:

NILFS nilfs_fill_super: start(silent=0)
NILFS: INFO: recovery required for readonly filesystem.
NILFS: write access will be enabled during recovery.
NILFS(recovery) nilfs_search_super_root: looking segment (seg_start=174272512, seg_end=174274559, segnum=85094, seg_seq=181656)
NILFS(recovery) load_segment_summary: checking segment (pseg_start=174272512, full_check=1)
NILFS(recovery) load_segment_summary: done (ret=4)
NILFS(recovery) nilfs_search_super_root: strayed: scan_newer=0, ret=4
NILFS warning: Sequence number mismatch
NILFS: error searching super root.
NILFS nilfs_fill_super: aborted
NILFS put_nilfs: the_nilfs on bdev sdb5 was freed



Do you also need the output with your first patch applied?

Regards,
 Adrian
