From: Volkov Oleg <volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org>
Subject: [SPAM]  Using NILFS on usb flash drive
Date: Thu, 26 Jun 2008 13:34:00 +0400
Message-ID: <200806261334.00233.volkov@teratelecom.ru>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

I installed Linux system on nilfs root partition
I use 2x32G usb flash (raid0, 64k chunks).
Nilfs with "-B 512."

I use gentoo linux.
I had to remove the script / etc / init.d / checkroot.

mount.nilfs2 does not understand the command:
mount -o remount, ro /
mount -o remount, rw /
mount -f ...

Fixed please.

-- 
Oleg Volkov
