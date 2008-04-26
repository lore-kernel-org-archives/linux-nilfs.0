From: Daniel Baumann <daniel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: FYI: nilfs2 in Debian
Date: Sat, 26 Apr 2008 15:15:20 +0200
Message-ID: <48132AE8.7060305@debian.org>
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
Content-Type: text/plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I've uploaded nilfs2 and nilfs2-tools to Debian. They are present in
unstable, and soon migrate to testing, which means that nilfs2 will be
present in the upcoming new stable release of Debian, called 5.0 "lenny".

Later, I'll add it to linux-modules-extra-2.6, so that pre-build module
packages for all Debian default kernel images are available (see [0] for
more information about kernel modules packaging in Debian).

Regards,
Daniel

[0]
http://blog.daniel-baumann.ch/2006/12/10#20061210_kernel-modules-packaging

-- 
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann-uDfGT2BMUjhJc61us3aD9uTW4wlIGRCZ@public.gmane.org
Internet:       http://people.panthera-systems.net/~daniel-baumann/
