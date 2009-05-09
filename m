From: "Ian R. Justman" <ianj-/yW00HUYfHJ7SG6B9HmcNQ@public.gmane.org>
Subject: Recent Ubuntu releases?
Date: Sat, 09 May 2009 15:03:05 -0700
Message-ID: <4A05FD99.6050406@ian-justman.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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


Hi, all.

Was just wondering, has anyone built NILFS2 packages against recent 
Ubuntu releases, e.g. Intrepid Ibis and Jaunty Jackalope?  The packages 
available via the site are only available for Hardy.  The packages in 
Jaunty are older versions (2.0.6).

However, I can report that the latest module and utility source trees 
build just fine under Jaunty which uses the 2.6.28 kernel (using x86 
32-bit in a VM here).  You just need to make sure that the 
linux-headers-(x) package appropriate to the kernel you're running and 
the uuid-dev package is also installed so that the kernel module and 
userland utilities respectively will build.

--Ian.

-- 
Ian R. Justman
UNIX hacker.  Anime fan.  Any questions?
ianj (at) ian-justman.com
