From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 4 Dec 2008 09:29:47 +0100
Message-ID: <20081204092947.c29d230d.adrian@blinkenlights.ch>
References: <20081203064930.B64F0829D@blinkenlights.ch>
	<20081203.233940.10724508.ryusuke@osrg.net>
	<20081203162628.B82C3829D@blinkenlights.ch>
	<20081204.170654.88475919.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081204.170654.88475919.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Hi,

> This never occurs if the block device is
> supporting 'write barrier' feature properly.
> Could you tell me the kernel version that you are using?

adrian@echelon:~$ uname -r
2.6.27.4

root@echelon:~# udevinfo -a -p /sys/block/sdb/|grep model
    ATTRS{model}=="10EAVS External "
root@echelon:~# lsusb |grep Wes
Bus 001 Device 003: ID 1058:1001 Western Digital Technologies, Inc. External Hard Disk


> (Of course, first priority should be on making fsck.)

Well: Is there any way to recover my data 'soon' or should
i re-format the partition? 

Regards,
 Adrian
