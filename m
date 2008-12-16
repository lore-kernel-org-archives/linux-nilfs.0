From: "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: lockups?
Date: Mon, 15 Dec 2008 22:51:50 -0500
Message-ID: <856033f20812151951t2411ec88g8075616cf9e3e96f@mail.gmail.com>
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

After using nilfs for both my root and home partition for about a
week, I had perhaps 4 or 5 lockups, which never occurred before when I
was using ext2 or reiserfs. At one instance, it locked up immediately
after the laptop wakes up from the suspend-to-ram mode. At other
times, it just happened with no apparent reason. Everytime when it did
hang, the CapLock light from my laptop would keep flashing, screen got
frozen with no more update, and keyboard/mouse got locked up. Because
I'm using ramdisk for /var/log to save SSD life, so I didn't have any
log. Also, I didn't seem to have lost any file, and the recovery at
next boot was rather quick.

I wonder if it's due to nilfs2, and what's the best way to help
debugging this situation. Would it help to turn on some logging?
Thanks!

-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
