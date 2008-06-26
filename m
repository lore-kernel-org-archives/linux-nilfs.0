From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Using NILFS on usb flash drive
Date: Thu, 26 Jun 2008 21:33:28 +0900 (JST)
Message-ID: <20080626.213328.34749155.ryusuke@osrg.net>
References: <200806261334.00233.volkov@teratelecom.ru>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200806261334.00233.volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

On Thu, 26 Jun 2008 13:34:00 +0400, Volkov Oleg wrote:
> I installed Linux system on nilfs root partition
> I use 2x32G usb flash (raid0, 64k chunks).
> Nilfs with "-B 512."
> 
> I use gentoo linux.
> I had to remove the script / etc / init.d / checkroot.
> 
> mount.nilfs2 does not understand the command:
> mount -o remount, ro /
> mount -o remount, rw /
> mount -f ...
> 
> Fixed please.

Please let me know some details.

How did you load the NILFS2 module (nilfs2.ko)
before mounting the root partition created by NILFS2 ?
Are you using an initrd image with nilfs2.ko ?

What kind of message was printed in the problem,
or did it hang up ?

Regards,
Ryusuke Konishi
