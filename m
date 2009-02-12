From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.7 released
Date: Thu, 12 Feb 2009 13:51:48 +0900 (JST)
Message-ID: <20090212.135148.04636085.ryusuke@osrg.net>
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

Dear NILFS users,

We have released nilfs-2.0.7 and nilfs-utils-2.0.7, which fixed
several GC problems and buggy behavior of lscp command seen in
enumerating checkpoints.

We have decided to change ioctl interface in the next release in order
to clean up compatibility issues between kernel module and userland
tools.  It won't lose disk format compatibility, but old userland
tools will become unsupported for later modules.  (I mean the next
release would require simultaneous updating of both packages.)

The updated package can be found at:
http://www.nilfs.org/en/download.html

Thanks,
--
Ryusuke Konishi
NILFS team NTT
