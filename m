From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Wed, 3 Dec 2008 07:49:56 +0100
Message-ID: <20081203064930.B64F0829D@blinkenlights.ch>
References: <20081201171411.99215829D@blinkenlights.ch>
	<20081202.142225.78011419.ryusuke@osrg.net>
	<20081202064345.31DB4802A@blinkenlights.ch>
	<20081203.120021.27010822.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081203.120021.27010822.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Still fails to mount :

# insmod fs/nilfs2.ko 
# echo "-vvv recovery" > /proc/fs/nilfs2/debug_option
# mount -t nilfs2 -r /dev/wdigital5 /scratch/

Dec  3 06:47:50 echelon kernel: NILFS nilfs_fill_super: start(silent=0)
Dec  3 06:47:50 echelon kernel: NILFS(recovery) nilfs_search_super_root: looking segment (seg_start=174272512, seg_end=174274559, segnum=85094, seg_seq=181656)
Dec  3 06:47:50 echelon kernel: NILFS(recovery) load_segment_summary: checking segment (pseg_start=174272512, full_check=1)
Dec  3 06:47:51 echelon kernel: NILFS(recovery) load_segment_summary: done (ret=0)
Dec  3 06:47:51 echelon kernel: NILFS(recovery) nilfs_search_super_root: found super root: segnum=85094, seq=181656, pseg_start=174272512, pseg_offset=295
Dec  3 06:47:51 echelon kernel: NILFS nilfs_attach_checkpoint: failed to attach ifile (checkpoint number=93986, err=-22)
Dec  3 06:47:51 echelon kernel: NILFS nilfs_fill_super: aborted
Dec  3 06:47:51 echelon kernel: NILFS put_nilfs: the_nilfs on bdev sdb5 was freed
