From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sat, 22 Aug 2009 13:36:13 +0300
Message-ID: <200908221336.13326.yuri@itinteg.net>
References: <200908211918.34720.yuri@itinteg.net>
	<200908221146.28241.yuri@itinteg.net>
	<20090822.185013.23110170.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090822.185013.23110170.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Disposition: inline
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

On Saturday 22 August 2009 12:50:13 Ryusuke Konishi wrote:
> The first message is just information I added in the patch.
> But, uum, the root inode of checkpoint 27252 seems to be broken, too.
>  
> Can you go back to much older checkpoints ?

I try to use older snapshot, that was successfully used before:

Aug 16 07:10:32 filer filer: Running: /sbin/mount.nilfs2 -r -o cp=5063 
/dev/cciss/c0d1p1 /snaps/2009-08-16_07_10_07
Aug 16 07:10:32 filer filer: Status: [OK]  Ouput:

But currently I get the same error.

The stored data is not critical for me so, as I have full backups, but I
prefer to check possibility of the fs recovery, if possible.

I have update utils to 2.0.14 and kernel to 2.6.30.5 + your patch.
Is it possible to add some printk to get additional information?

Thank you.
Yuri.
