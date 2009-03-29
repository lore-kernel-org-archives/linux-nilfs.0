From: Oleg Volkov <volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org>
Subject: optimized nilfs
Date: Sun, 29 Mar 2009 11:21:47 +0400
Message-ID: <1238311307.28013.4.camel@flot.hovrino.net>
References: <mailman.1.1238295601.27184.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1238295601.27184.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

	
1. I recommend to choose the block size when formatting the partition.
For this test the speed of reading and writing.

Example:
> I use 2x32G usb flash (raid0, 64k chunks). Nilfs with "-B 512".
> I use one 32G usb flash. Nilfs with "-B 256".

2. If possible, turn off the logs. If this is not possible to make
separate partition for logs, but is not small.

3. Try not to fill the section of more than 30% and reduce the speed
cleanerd.

--
Oleg Volkov
