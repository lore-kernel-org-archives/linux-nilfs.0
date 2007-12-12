From: Pierre Etchemaite <petchema-5XhUwtNo+r9Wk0Htik3J/w@public.gmane.org>
Subject: Unknown symbol __umoddi3 / ... __udivdi3
Date: Wed, 12 Dec 2007 11:45:14 +0100
Message-ID: <475FBBBA.10602@agematis.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

    Hello all,

First, I believe log based filesystems are the future; Not only for 
snapshot feature, but also because they can give superior performance 
(vs. standard filesystems) on modern disks, cf

http://citeseer.ist.psu.edu/694627.html

for a very interesting performance analysis.


Now, back to more down-to-earth considerations :)
I'd like to give the nilfs 2.0.0-testing7 release a try with linux 
kernel 2.6.23, but I can't load the kernel module; dmesg says

nilfs2: Unknown symbol __umoddi3
nilfs2: Unknown symbol __udivdi3
nilfs2: Unknown symbol __umoddi3
nilfs2: Unknown symbol __udivdi3
nilfs2: Unknown symbol __umoddi3
nilfs2: Unknown symbol __udivdi3

CPU is an AMD64 but used in 32 bit mode, and it seems that 64 bit 
divisions are a problem for 32 bit kernels :/
Any idea how to get around that? (using asm/div64.h?)

Best regards,
Pierre.
