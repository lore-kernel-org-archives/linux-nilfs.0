From: Daniel Baumann <daniel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: proper name for userspace package?
Date: Mon, 03 Aug 2009 22:04:38 +0200
Message-ID: <4A7742D6.9050405@debian.org>
References: <4A71CA72.8080106@redhat.com>	<20090731.023234.56054455.ryusuke@osrg.net>	<4A71E82C.1040208@debian.org>
	<20090804.041006.12536354.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090804.041006.12536354.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:
> "nilfs-tools" sounds simpler. Umm, actually it would be better in the
> long term because the nilfs package already has versions related to
> the filesystem version (e.g. -2.x.y).  At least I don't have any
> reason to object to the rename.

ok, i think so too. i just renamed in debian (well, i've uploaded it..
it will not wait for 0 to \infty for ftp-masters re-approval in the NEW
queue :/).

> I just realized that ocfs2-tools package has versions 1.x.y.

i heard, that ocfs2 is called ocfs2 because ocfs1 was oracle intern
only. not sure if that's true though.

-- 
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann-uDfGT2BMUjhJc61us3aD9uTW4wlIGRCZ@public.gmane.org
Internet:       http://people.panthera-systems.net/~daniel-baumann/
