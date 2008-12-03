From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Wed, 03 Dec 2008 23:39:40 +0900 (JST)
Message-ID: <20081203.233940.10724508.ryusuke@osrg.net>
References: <20081202064345.31DB4802A@blinkenlights.ch>
	<20081203.120021.27010822.ryusuke@osrg.net>
	<20081203064930.B64F0829D@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081203064930.B64F0829D-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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
To: adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Wed, 3 Dec 2008 07:49:56 +0100, Adrian Ulrich wrote:
> Still fails to mount :
> 
> # insmod fs/nilfs2.ko 
> # echo "-vvv recovery" > /proc/fs/nilfs2/debug_option
> # mount -t nilfs2 -r /dev/wdigital5 /scratch/
> 
> Dec  3 06:47:50 echelon kernel: NILFS nilfs_fill_super: start(silent=0)
> Dec  3 06:47:50 echelon kernel: NILFS(recovery) nilfs_search_super_root: looking segment (seg_start=174272512, seg_end=174274559, segnum=85094, seg_seq=181656)
> Dec  3 06:47:50 echelon kernel: NILFS(recovery) load_segment_summary: checking segment (pseg_start=174272512, full_check=1)
> Dec  3 06:47:51 echelon kernel: NILFS(recovery) load_segment_summary: done (ret=0)
> Dec  3 06:47:51 echelon kernel: NILFS(recovery) nilfs_search_super_root: found super root: segnum=85094, seq=181656, pseg_start=174272512, pseg_offset=295
> Dec  3 06:47:51 echelon kernel: NILFS nilfs_attach_checkpoint: failed to attach ifile (checkpoint number=93986, err=-22)
> Dec  3 06:47:51 echelon kernel: NILFS nilfs_fill_super: aborted
> Dec  3 06:47:51 echelon kernel: NILFS put_nilfs: the_nilfs on bdev sdb5 was freed

The segment pointed by the superblock was likely not the latest one.


Could you get a summary of segments as follows, and send it to me
off-line?

 bash# for (( i = 0; i <= 85096; i++ )); do dumpseg /dev/wdigital5 $i | grep -e creation -e segment -e "ino = 3,"; done > segdump.txt
 bash# bzip2 segdump.txt


This will generate the summary as follows, and it helps
to identify the the last segment actually written.

segment: segnum = 0
  partial segment
    creation time = 2008-10-10 15:30:36
      ino = 3, cno = 1, nblocks = 3, ndatblk = 3
  partial segment
    creation time = 2008-10-10 15:30:48
      ino = 3, cno = 0, nblocks = 39, ndatblk = 38
  partial segment
    creation time = 2008-10-10 15:30:51
segment: segnum = 1
  partial segment
    creation time = 2008-10-10 15:30:52
segment: segnum = 2
  partial segment
    creation time = 2008-10-10 15:30:52
  partial segment
    creation time = 2008-10-10 15:30:54
...


If you can find the latest segment from 'creation time' fields,
then get a full dump, too.

 # dumpseg /dev/wdigital5 [the number of the newest segment] > latest-seg.txt


Regards,
Ryusuke Konishi
