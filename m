From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 4 Dec 2008 14:04:31 +0100
Message-ID: <20081204140431.ec72f1ec.adrian@blinkenlights.ch>
References: <20081203162628.B82C3829D@blinkenlights.ch>
	<20081204.170654.88475919.ryusuke@osrg.net>
	<20081204092947.c29d230d.adrian@blinkenlights.ch>
	<20081204.215805.88483726.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081204.215805.88483726.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

> [...]  where x:x:x:x is the address displayed by lsscsi command.

bash-3.1# lsscsi | grep 10EAVS
[4:0:0:0]    disk    WD       10EAVS External  1.05  /dev/wdigital    
bash-3.1# cat /sys/class/scsi_disk/4\:0\:0\:0/cache_type 
write through
bash-3.1# cat /sys/class/scsi_disk/4\:0\:0\:0/FUA        
0


> Wait for a moment.  I'm now writing an impromptu tool
> to correct this kind of problem.

Oh, great. I'll be glad to test it ;-)

Regards,
 Adrian
