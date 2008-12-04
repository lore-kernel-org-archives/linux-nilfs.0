From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 04 Dec 2008 17:06:54 +0900 (JST)
Message-ID: <20081204.170654.88475919.ryusuke@osrg.net>
References: <20081203064930.B64F0829D@blinkenlights.ch>
	<20081203.233940.10724508.ryusuke@osrg.net>
	<20081203162628.B82C3829D@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081203162628.B82C3829D-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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

Hi Adrian,

Thanks for dump logs.

 segment: segnum = 85092
   partial segment
     creation time = 2008-11-26 17:41:05
   partial segment
     creation time = 2008-11-26 17:41:06
 segment: segnum = 85093
   partial segment           -> pseg 174270464
     creation time = 2008-11-26 17:41:06
       ino = 3, cno = 0, nblocks = 86, ndatblk = 80
   partial segment           -> pseg 174271740
     creation time = 2008-11-26 17:41:11
       ino = 3, cno = 0, nblocks = 8, ndatblk = 3
   partial segment           -> pseg 174271758
     creation time = 2008-11-26 17:42:47
       ino = 3, cno = 0, nblocks = 735, ndatblk = 722
 segment: segnum = 85094
   partial segment           -> pseg 174272512    <-- pointed by superblock
     creation time = 2008-10-28 20:27:55
       ino = 3, cno = 0, nblocks = 61, ndatblk = 51
   partial segment
     creation time = 2008-10-28 20:29:14
 segment: segnum = 85095
   partial segment
     creation time = 2008-10-28 20:29:15


According to your logs, the segment pointed by
the superblock was not written as suspected.

This never occurs if the block device is
supporting 'write barrier' feature properly.

Could you tell me the kernel version that you are using?

I feel that an additional disk flush operation may be
needed for older kernels or such devices. (Of course,
first priority should be on making fsck.)


Regards,
Ryusuke Konishi
